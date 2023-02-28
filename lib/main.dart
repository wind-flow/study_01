import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ProviderScope(child: CustomKeyboardScreen()));
}

// class KeyBoard {
//   KeyBoard._privateConstructor();
//   static final KeyBoard _instance = KeyBoard._privateConstructor();

//   factory KeyBoard() {
//     return _instance;
//   }
// }

class CustomKeyboardScreen extends StatefulWidget {
  const CustomKeyboardScreen({super.key});

  @override
  State<CustomKeyboardScreen> createState() => _CustomKeyboardScreenState();
}

class _CustomKeyboardScreenState extends State<CustomKeyboardScreen> {
  String amount = '';

  @override
  void initState() {
    super.initState();
  }

  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', const Icon(Icons.keyboard_backspace)],
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                renderText(),
                ...renderKeyboard(),
                const SizedBox(height: 16.0),
                renderConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
            children: x.map((y) {
              return Expanded(
                child: KeyboardKey(
                  label: y,
                  onTap: (val) {
                    if (val == '0' && amount.isEmpty) {
                      return;
                    }
                    if (amount.isNotEmpty && val! is Widget) {
                      setState(() {
                        amount = amount.substring(0, amount.length - 1);
                      });
                      return;
                    }

                    setState(() {
                      amount = amount + val;
                    });
                  },
                  value: y,
                ),
              );
            }).toList(),
          ),
        )
        .toList();
  }

  renderConfirmButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            // style: const ButtonStyle(backgroundColor: Colors.orange),
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  renderText() {
    String display = '변환할 금액';
    TextStyle style = const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
    );

    if (amount.isNotEmpty) {
      NumberFormat f = NumberFormat('#,###');

      display = '${f.format(int.parse(amount))}원';
      style = style.copyWith(
        color: Colors.black,
      );
    }

    return Expanded(
      child: Center(
        child: Text(
          display,
          style: style,
        ),
      ),
    );
  }
}

class KeyboardKey extends StatefulWidget {
  const KeyboardKey({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: InkWell(
        onTap: () => widget.onTap(widget.value),
        child: Center(
          child: renderLabel(),
        ),
      ),
    );
  }

  renderLabel() {
    if (widget.label is String) {
      return Text(
        widget.label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    } else {
      return widget.label;
    }
  }
}
