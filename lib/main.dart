import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _fabSlideAnimation;
  late Animation<Offset> _screenSlideAnimation;

  bool _isBlueScreenVisible = false;

  @override
  void initState() {
    super.initState();

    // Animation controller for FAB and blue screen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // FAB slide animation (from bottom-center to upward)
    _fabSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2.0), // Moves FAB upward
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Blue screen sliding animation
    _screenSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleBlueScreen() {
    setState(() {
      _isBlueScreenVisible = !_isBlueScreenVisible;
      if (_isBlueScreenVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main screen content
          const Center(
            child: Text(
              'Events',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),

          // Blue Screen with categories
          SlideTransition(
            position: _screenSlideAnimation,
            child: Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // "X" Button
                    GestureDetector(
                      onTap: _toggleBlueScreen,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Categories
                    _buildCategory('Reminder'),
                    _buildCategory('Camera'),
                    _buildCategory('Attachment'),
                    _buildCategory('Text Note'),
                  ],
                ),
              ),
            ),
          ),

          if (!_isBlueScreenVisible)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionalTranslation(
                    translation: _fabSlideAnimation.value,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.primaryDelta! < -10) {
                          _toggleBlueScreen();
                        }
                      },
                      child: AnimatedScale(
                        scale: _isBlueScreenVisible ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FloatingActionButton(
                            onPressed: _toggleBlueScreen,
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategory(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
