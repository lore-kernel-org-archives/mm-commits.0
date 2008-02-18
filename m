From: akpm@linux-foundation.org
Subject: + maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:58:35 -0800
Message-ID: <200802180959.m1I9xWwW018849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbYBRKAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian@newgolddream.dyndns.info, adrian@mcmen.demon.co.uk, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     maple: allow removal and reinsertion of keyboard driver module
has been added to the -mm tree.  Its filename is
     maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maple: allow removal and reinsertion of keyboard driver module
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>

Allow the removal (and subsequent reinsertion) of the maple_keyb (maple
keyboard) driver by adding a working removal function.

Also tidy long lines.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/maple_keyb.c |  124 ++++++++++++++++----------
 1 file changed, 81 insertions(+), 43 deletions(-)

diff -puN drivers/input/keyboard/maple_keyb.c~maple-allow-removal-and-reinsertion-of-keyboard-driver-module drivers/input/keyboard/maple_keyb.c
--- a/drivers/input/keyboard/maple_keyb.c~maple-allow-removal-and-reinsertion-of-keyboard-driver-module
+++ a/drivers/input/keyboard/maple_keyb.c
@@ -2,7 +2,7 @@
  * SEGA Dreamcast keyboard driver
  * Based on drivers/usb/usbkbd.c
  * Copyright YAEGASHI Takeshi, 2001
- * Porting to 2.6 Copyright Adrian McMenamin, 2007
+ * Porting to 2.6 Copyright Adrian McMenamin, 2007, 2008
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -46,39 +46,51 @@ struct dc_kbd {
 };
 
 static const unsigned short dc_kbd_keycode[NR_SCANCODES] = {
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_A, KEY_B, KEY_C, KEY_D,
-	KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L,
-	KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T,
-	KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, KEY_1, KEY_2,
-	KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0,
-	KEY_ENTER, KEY_ESC, KEY_BACKSPACE, KEY_TAB, KEY_SPACE, KEY_MINUS, KEY_EQUAL, KEY_LEFTBRACE,
-	KEY_RIGHTBRACE, KEY_BACKSLASH, KEY_BACKSLASH, KEY_SEMICOLON, KEY_APOSTROPHE, KEY_GRAVE, KEY_COMMA,
-	KEY_DOT, KEY_SLASH, KEY_CAPSLOCK, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_A, KEY_B,
+	KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L,
+	KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V,
+	KEY_W, KEY_X, KEY_Y, KEY_Z, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6,
+	KEY_7, KEY_8, KEY_9, KEY_0, KEY_ENTER, KEY_ESC, KEY_BACKSPACE,
+	KEY_TAB, KEY_SPACE, KEY_MINUS, KEY_EQUAL, KEY_LEFTBRACE,
+	KEY_RIGHTBRACE, KEY_BACKSLASH, KEY_BACKSLASH, KEY_SEMICOLON,
+	KEY_APOSTROPHE, KEY_GRAVE, KEY_COMMA, KEY_DOT, KEY_SLASH,
+	KEY_CAPSLOCK, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6,
 	KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12, KEY_SYSRQ,
-	KEY_SCROLLLOCK, KEY_PAUSE, KEY_INSERT, KEY_HOME, KEY_PAGEUP, KEY_DELETE,
-	KEY_END, KEY_PAGEDOWN, KEY_RIGHT, KEY_LEFT, KEY_DOWN, KEY_UP,
-	KEY_NUMLOCK, KEY_KPSLASH, KEY_KPASTERISK, KEY_KPMINUS, KEY_KPPLUS, KEY_KPENTER, KEY_KP1, KEY_KP2,
-	KEY_KP3, KEY_KP4, KEY_KP5, KEY_KP6, KEY_KP7, KEY_KP8, KEY_KP9, KEY_KP0, KEY_KPDOT,
-	KEY_102ND, KEY_COMPOSE, KEY_POWER, KEY_KPEQUAL, KEY_F13, KEY_F14, KEY_F15,
-	KEY_F16, KEY_F17, KEY_F18, KEY_F19, KEY_F20,
-	KEY_F21, KEY_F22, KEY_F23, KEY_F24, KEY_OPEN, KEY_HELP, KEY_PROPS, KEY_FRONT,
-	KEY_STOP, KEY_AGAIN, KEY_UNDO, KEY_CUT, KEY_COPY, KEY_PASTE, KEY_FIND, KEY_MUTE,
-	KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_KPCOMMA, KEY_RESERVED, KEY_RO, KEY_KATAKANAHIRAGANA , KEY_YEN,
-	KEY_HENKAN, KEY_MUHENKAN, KEY_KPJPCOMMA, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_HANGEUL, KEY_HANJA, KEY_KATAKANA, KEY_HIRAGANA, KEY_ZENKAKUHANKAKU, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
-	KEY_LEFTCTRL, KEY_LEFTSHIFT, KEY_LEFTALT, KEY_LEFTMETA, KEY_RIGHTCTRL, KEY_RIGHTSHIFT, KEY_RIGHTALT, KEY_RIGHTMETA,
-	KEY_PLAYPAUSE, KEY_STOPCD, KEY_PREVIOUSSONG, KEY_NEXTSONG, KEY_EJECTCD, KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_MUTE,
-	KEY_WWW, KEY_BACK, KEY_FORWARD, KEY_STOP, KEY_FIND, KEY_SCROLLUP, KEY_SCROLLDOWN, KEY_EDIT, KEY_SLEEP,
-	KEY_SCREENLOCK, KEY_REFRESH, KEY_CALC, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED
+	KEY_SCROLLLOCK, KEY_PAUSE, KEY_INSERT, KEY_HOME, KEY_PAGEUP,
+	KEY_DELETE, KEY_END, KEY_PAGEDOWN, KEY_RIGHT, KEY_LEFT, KEY_DOWN,
+	KEY_UP, KEY_NUMLOCK, KEY_KPSLASH, KEY_KPASTERISK, KEY_KPMINUS,
+	KEY_KPPLUS, KEY_KPENTER, KEY_KP1, KEY_KP2, KEY_KP3, KEY_KP4, KEY_KP5,
+	KEY_KP6, KEY_KP7, KEY_KP8, KEY_KP9, KEY_KP0, KEY_KPDOT, KEY_102ND,
+	KEY_COMPOSE, KEY_POWER, KEY_KPEQUAL, KEY_F13, KEY_F14, KEY_F15,
+	KEY_F16, KEY_F17, KEY_F18, KEY_F19, KEY_F20, KEY_F21, KEY_F22,
+	KEY_F23, KEY_F24, KEY_OPEN, KEY_HELP, KEY_PROPS, KEY_FRONT, KEY_STOP,
+	KEY_AGAIN, KEY_UNDO, KEY_CUT, KEY_COPY, KEY_PASTE, KEY_FIND, KEY_MUTE,
+	KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_KPCOMMA, KEY_RESERVED, KEY_RO, KEY_KATAKANAHIRAGANA , KEY_YEN,
+	KEY_HENKAN, KEY_MUHENKAN, KEY_KPJPCOMMA, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_HANGEUL, KEY_HANJA, KEY_KATAKANA, KEY_HIRAGANA,
+	KEY_ZENKAKUHANKAKU, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_LEFTCTRL, KEY_LEFTSHIFT, KEY_LEFTALT,
+	KEY_LEFTMETA, KEY_RIGHTCTRL, KEY_RIGHTSHIFT, KEY_RIGHTALT,
+	KEY_RIGHTMETA, KEY_PLAYPAUSE, KEY_STOPCD, KEY_PREVIOUSSONG,
+	KEY_NEXTSONG, KEY_EJECTCD, KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_MUTE,
+	KEY_WWW, KEY_BACK, KEY_FORWARD, KEY_STOP, KEY_FIND, KEY_SCROLLUP,
+	KEY_SCROLLDOWN, KEY_EDIT, KEY_SLEEP, KEY_SCREENLOCK, KEY_REFRESH,
+	KEY_CALC, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED
 };
 
 static void dc_scan_kbd(struct dc_kbd *kbd)
@@ -152,14 +164,15 @@ static int dc_kbd_connect(struct maple_d
 	struct dc_kbd *kbd;
 	struct input_dev *dev;
 
-	if (!(mdev->function & MAPLE_FUNC_KEYBOARD))
-		return -EINVAL;
-
 	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
+	if (!kbd) {
+		error = -ENOMEM;
+		goto fail_kbd;
+	}
 	dev = input_allocate_device();
-	if (!kbd || !dev) {
+	if (!dev) {
 		error = -ENOMEM;
-		goto fail;
+		goto fail_dev;
 	}
 
 	mdev->private_data = kbd;
@@ -170,7 +183,7 @@ static int dc_kbd_connect(struct maple_d
 	dev->name = mdev->product_name;
 	dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	dev->keycode = kbd->keycode;
-	dev->keycodesize = sizeof (unsigned short);
+	dev->keycodesize = sizeof(unsigned short);
 	dev->keycodemax = ARRAY_SIZE(kbd->keycode);
 	dev->id.bustype = BUS_HOST;
 	dev->dev.parent = &mdev->dev;
@@ -187,12 +200,15 @@ static int dc_kbd_connect(struct maple_d
 		goto fail;
 
 	/* Maple polling is locked to VBLANK - which may be just 50/s */
-	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50, MAPLE_FUNC_KEYBOARD);
+	maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
+		MAPLE_FUNC_KEYBOARD);
 	return 0;
 
- fail:
+fail:
 	input_free_device(dev);
+fail_dev:
 	kfree(kbd);
+fail_kbd:
 	mdev->private_data = NULL;
 	return error;
 }
@@ -202,7 +218,7 @@ static void dc_kbd_disconnect(struct map
 	struct dc_kbd *kbd;
 
 	mutex_lock(&maple_keyb_mutex);
-
+	mdev->callback = NULL;
 	kbd = mdev->private_data;
 	mdev->private_data = NULL;
 	input_unregister_device(kbd->dev);
@@ -223,11 +239,18 @@ static int probe_maple_kbd(struct device
 		return error;
 
 	mdev->driver = mdrv;
-	mdev->registered = 1;
 
 	return 0;
 }
 
+static int remove_maple_kbd(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	dc_kbd_disconnect(mdev);
+	return 0;
+}
+
 static struct maple_driver dc_kbd_driver = {
 	.function = MAPLE_FUNC_KEYBOARD,
 	.connect = dc_kbd_connect,
@@ -235,9 +258,23 @@ static struct maple_driver dc_kbd_driver
 	.drv = {
 		.name = "Dreamcast_keyboard",
 		.probe = probe_maple_kbd,
+		.remove = remove_maple_kbd,
        },
 };
 
+static int unplug_maple_keyb(struct device *dev, void *ignored)
+{
+	/* Please DO NOT really unplug your keyboard */
+	struct maple_device *mdev;
+
+	mdev = to_maple_dev(dev);
+	if ((mdev->function & MAPLE_FUNC_KEYBOARD)
+		&& (mdev->driver == &dc_kbd_driver))
+		remove_maple_kbd(dev);
+
+	return 0;
+}
+
 static int __init dc_kbd_init(void)
 {
 	return maple_driver_register(&dc_kbd_driver.drv);
@@ -245,6 +282,7 @@ static int __init dc_kbd_init(void)
 
 static void __exit dc_kbd_exit(void)
 {
+	bus_for_each_dev(&maple_bus_type, NULL, NULL, unplug_maple_keyb);
 	driver_unregister(&dc_kbd_driver.drv);
 }
 
_

Patches currently in -mm which might be from adrian@newgolddream.dyndns.info are

maple-remove-unused-variable.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch
