From: akpm@linux-foundation.org
Subject: - console-keyboard-events-and-accessibility.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:03 -0700
Message-ID: <200710192249.l9JMn3Zf023937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbXJSWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Console keyboard events and accessibility
has been removed from the -mm tree.  Its filename was
     console-keyboard-events-and-accessibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Console keyboard events and accessibility
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Some blind people use a kernel engine called Speakup which uses hardware
synthesis to speak what gets displayed on the screen.  They use the
PC keyboard to control this engine (start/stop, accelerate, ...) and
also need to get keyboard feedback (to make sure to know what they are
typing, the caps lock status, etc.)

Up to now, the way it was done was very ugly.  Below is a patch to add a
notifier list for permitting a far better implementation, see ChangeLog
above for details.

You may wonder why this can't be done at the input layer.  The problem
is that what people want to monitor is the console keyboard, i.e. all
input keyboards that got attached to the console, and with the currently
active keymap (i.e. keysyms, not only keycodes).

This adds a keyboard notifier that such modules can use to get the keyboard
events and possibly eat them, at several stages:

- keycodes: even before translation into keysym.
- unbound keycodes: when no keysym is bound.
- unicode: when the keycode would get translated into a unicode character.
- keysym: when the keycode would get translated into a keysym.
- post_keysym: after the keysym got interpreted, so as to see the result
  (caps lock, etc.)

This also provides access to k_handler so as to permit simulation of
keypresses.

[akpm@linux-foundation.org: various fixes]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c  |   42 +++++++++++++++++++++++++++++++------
 include/linux/keyboard.h |   11 +++++++++
 include/linux/notifier.h |    9 +++++++
 3 files changed, 56 insertions(+), 6 deletions(-)

diff -puN drivers/char/keyboard.c~console-keyboard-events-and-accessibility drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~console-keyboard-events-and-accessibility
+++ a/drivers/char/keyboard.c
@@ -42,6 +42,7 @@
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
+#include <linux/notifier.h>
 
 extern void ctrl_alt_del(void);
 
@@ -81,7 +82,8 @@ void compute_shiftstate(void);
 typedef void (k_handler_fn)(struct vc_data *vc, unsigned char value,
 			    char up_flag);
 static k_handler_fn K_HANDLERS;
-static k_handler_fn *k_handler[16] = { K_HANDLERS };
+k_handler_fn *k_handler[16] = { K_HANDLERS };
+EXPORT_SYMBOL_GPL(k_handler);
 
 #define FN_HANDLERS\
 	fn_null,	fn_enter,	fn_show_ptregs,	fn_show_mem,\
@@ -160,6 +162,23 @@ static int sysrq_alt_use;
 static int sysrq_alt;
 
 /*
+ * Notifier list for console keyboard events
+ */
+static ATOMIC_NOTIFIER_HEAD(keyboard_notifier_list);
+
+int register_keyboard_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&keyboard_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_keyboard_notifier);
+
+int unregister_keyboard_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&keyboard_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_keyboard_notifier);
+
+/*
  * Translation of scancodes to keycodes. We set them on only the first
  * keyboard in the list that accepts the scancode and keycode.
  * Explanation for not choosing the first attached keyboard anymore:
@@ -1130,6 +1149,7 @@ static void kbd_keycode(unsigned int key
 	unsigned char type, raw_mode;
 	struct tty_struct *tty;
 	int shift_final;
+	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 
 	tty = vc->vc_tty;
 
@@ -1217,10 +1237,11 @@ static void kbd_keycode(unsigned int key
 		return;
 	}
 
-	shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
+	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
 	key_map = key_maps[shift_final];
 
-	if (!key_map) {
+	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
+		atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNBOUND_KEYCODE, &param);
 		compute_shiftstate();
 		kbd->slockstate = 0;
 		return;
@@ -1237,6 +1258,9 @@ static void kbd_keycode(unsigned int key
 	type = KTYP(keysym);
 
 	if (type < 0xf0) {
+		param.value = keysym;
+		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
+			return;
 		if (down && !raw_mode)
 			to_utf8(vc, keysym);
 		return;
@@ -1244,9 +1268,6 @@ static void kbd_keycode(unsigned int key
 
 	type -= 0xf0;
 
-	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
-		return;
-
 	if (type == KT_LETTER) {
 		type = KT_LATIN;
 		if (vc_kbd_led(kbd, VC_CAPSLOCK)) {
@@ -1255,9 +1276,18 @@ static void kbd_keycode(unsigned int key
 				keysym = key_map[keycode];
 		}
 	}
+	param.value = keysym;
+
+	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYSYM, &param) == NOTIFY_STOP)
+		return;
+
+	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
+		return;
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
+	atomic_notifier_call_chain(&keyboard_notifier_list, KBD_POST_KEYSYM, &param);
+
 	if (type != KT_SLOCK)
 		kbd->slockstate = 0;
 }
diff -puN include/linux/keyboard.h~console-keyboard-events-and-accessibility include/linux/keyboard.h
--- a/include/linux/keyboard.h~console-keyboard-events-and-accessibility
+++ a/include/linux/keyboard.h
@@ -23,10 +23,21 @@
 #define MAX_NR_OF_USER_KEYMAPS 256 	/* should be at least 7 */
 
 #ifdef __KERNEL__
+struct notifier_block;
 extern const int NR_TYPES;
 extern const int max_vals[];
 extern unsigned short *key_maps[MAX_NR_KEYMAPS];
 extern unsigned short plain_map[NR_KEYS];
+
+struct keyboard_notifier_param {
+	struct vc_data *vc;	/* VC on which the keyboard press was done */
+	int down;		/* Pressure of the key? */
+	int shift;		/* Current shift mask */
+	unsigned int value;	/* keycode, unicode value or keysym */
+};
+
+extern int register_keyboard_notifier(struct notifier_block *nb);
+extern int unregister_keyboard_notifier(struct notifier_block *nb);
 #endif
 
 #define MAX_NR_FUNC	256	/* max nr of strings assigned to keys */
diff -puN include/linux/notifier.h~console-keyboard-events-and-accessibility include/linux/notifier.h
--- a/include/linux/notifier.h~console-keyboard-events-and-accessibility
+++ a/include/linux/notifier.h
@@ -231,5 +231,14 @@ static inline int notifier_to_errno(int 
 #define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
 
+/* Console keyboard events.
+ * Note: KBD_KEYCODE is always sent before KBD_UNBOUND_KEYCODE, KBD_UNICODE and
+ * KBD_KEYSYM. */
+#define KBD_KEYCODE		0x0001 /* Keyboard keycode, called before any other */
+#define KBD_UNBOUND_KEYCODE	0x0002 /* Keyboard keycode which is not bound to any other */
+#define KBD_UNICODE		0x0003 /* Keyboard unicode */
+#define KBD_KEYSYM		0x0004 /* Keyboard keysym */
+#define KBD_POST_KEYSYM		0x0005 /* Called after keyboard keysym interpretation */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
