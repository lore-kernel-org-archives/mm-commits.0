From: akpm@linux-foundation.org
Subject: + ati_remote2-autorepeat-and-loadable-keymap-support.patch added to -mm tree
Date: Mon, 03 Mar 2008 14:03:37 -0800
Message-ID: <200803032203.m23M3bvZ008962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYCCWGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 17:06:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@dadeos.co.uk, dtor@mail.ru, jkosina@suse.cz


The patch titled
     ati_remote2: autorepeat and loadable keymap support
has been added to the -mm tree.  Its filename is
     ati_remote2-autorepeat-and-loadable-keymap-support.patch

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
Subject: ati_remote2: autorepeat and loadable keymap support
From: Peter Stokes <linux@dadeos.co.uk>

Reconfigure the ati_remote2 driver to use soft-autorepeat functionality and
add support for loadable key maps.

I have reconfigure the driver to use the input system's built-in autorepeat
functionality as the device only appears to be able to produce key repeat
notifications at a fixed period.  Switching to the software autorepeat
functionality provides more precise configuration of the timings requested for
repeat-delay and repeat-rate.

As this device is exposed as a combined keyboard and mouse, this change
somewhat depends upon the suggested modification to the core soft-autorepeat
functionality as outlined in my previous post to the linux-input mailing list
(on 12th Feb 2008 entitled "Soft-autorepeat functionality"), without that
modification, the mouse buttons are autorepeated :-(

The loadable keymap support exposes the ability to map 5 separate keycodes to
each key (depending on which "mode" the remote control is currently in). 
Additionally, I have attempted to ensure that the scancodes used to map
keycodes to the keys lie outside of the range normally covered by regular
keyboards so as to avoid requests to remap the keys on the remote from being
intercepted by a normal keyboard.

Signed-off-by: Peter Stokes <linux@dadeos.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/ati_remote2.c |  265 +++++++++++++++++------------
 1 file changed, 162 insertions(+), 103 deletions(-)

diff -puN drivers/input/misc/ati_remote2.c~ati_remote2-autorepeat-and-loadable-keymap-support drivers/input/misc/ati_remote2.c
--- a/drivers/input/misc/ati_remote2.c~ati_remote2-autorepeat-and-loadable-keymap-support
+++ a/drivers/input/misc/ati_remote2.c
@@ -2,7 +2,7 @@
  * ati_remote2 - ATI/Philips USB RF remote driver
  *
  * Copyright (C) 2005 Ville Syrjala <syrjala@sci.fi>
- * Copyright (C) 2007 Peter Stokes <linux@dadeos.freeserve.co.uk>
+ * Copyright (C) 2007 Peter Stokes <linux@dadeos.co.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2
@@ -12,7 +12,7 @@
 #include <linux/usb/input.h>
 
 #define DRIVER_DESC    "ATI/Philips USB RF remote driver"
-#define DRIVER_VERSION "0.2"
+#define DRIVER_VERSION "0.3"
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_VERSION(DRIVER_VERSION);
@@ -27,7 +27,7 @@ MODULE_LICENSE("GPL");
  * A remote's "channel" may be altered by pressing and holding the "PC" button for
  * approximately 3 seconds, after which the button will slowly flash the count of the
  * currently configured "channel", using the numeric keypad enter a number between 1 and
- * 16 and then the "PC" button again, the button will slowly flash the count of the
+ * 16 and then press the "PC" button again, the button will slowly flash the count of the
  * newly configured "channel".
  */
 
@@ -45,61 +45,66 @@ static struct usb_device_id ati_remote2_
 };
 MODULE_DEVICE_TABLE(usb, ati_remote2_id_table);
 
+
+static u8 ati_remote2_modes[] = {
+	0x01, /* AUX1 */
+	0x02, /* AUX2 */
+	0x04, /* AUX3 */
+	0x08, /* AUX4 */
+	0x10, /* PC   */
+};
+
 static struct {
-	int hw_code;
-	int key_code;
-} ati_remote2_key_table[] = {
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-	{ 0x0c, KEY_POWER },
-	{ 0x0d, KEY_MUTE },
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x20, KEY_CHANNELUP },
-	{ 0x21, KEY_CHANNELDOWN },
-	{ 0x28, KEY_FORWARD },
-	{ 0x29, KEY_REWIND },
-	{ 0x2c, KEY_PLAY },
-	{ 0x30, KEY_PAUSE },
-	{ 0x31, KEY_STOP },
-	{ 0x37, KEY_RECORD },
-	{ 0x38, KEY_DVD },
-	{ 0x39, KEY_TV },
-	{ 0x54, KEY_MENU },
-	{ 0x58, KEY_UP },
-	{ 0x59, KEY_DOWN },
-	{ 0x5a, KEY_LEFT },
-	{ 0x5b, KEY_RIGHT },
-	{ 0x5c, KEY_OK },
-	{ 0x78, KEY_A },
-	{ 0x79, KEY_B },
-	{ 0x7a, KEY_C },
-	{ 0x7b, KEY_D },
-	{ 0x7c, KEY_E },
-	{ 0x7d, KEY_F },
-	{ 0x82, KEY_ENTER },
-	{ 0x8e, KEY_VENDOR },
-	{ 0x96, KEY_COFFEE },
-	{ 0xa9, BTN_LEFT },
-	{ 0xaa, BTN_RIGHT },
-	{ 0xbe, KEY_QUESTION },
-	{ 0xd5, KEY_FRONT },
-	{ 0xd0, KEY_EDIT },
-	{ 0xf9, KEY_INFO },
-	{ (0x00 << 8) | 0x3f, KEY_PROG1 },
-	{ (0x01 << 8) | 0x3f, KEY_PROG2 },
-	{ (0x02 << 8) | 0x3f, KEY_PROG3 },
-	{ (0x03 << 8) | 0x3f, KEY_PROG4 },
-	{ (0x04 << 8) | 0x3f, KEY_PC },
-	{ 0, KEY_RESERVED }
+	u8  hwcode;
+	u16 keycode[ARRAY_SIZE(ati_remote2_modes)];
+} ati_remote2_keycodes[] = {
+/*	 hwcode   AUX1             AUX2             AUX3             AUX4             PC                */
+	{ 0x00, { KEY_0,           KEY_0,           KEY_0,           KEY_0,           KEY_0           } },
+	{ 0x01, { KEY_1,           KEY_1,           KEY_1,           KEY_1,           KEY_1           } },
+	{ 0x02, { KEY_2,           KEY_2,           KEY_2,           KEY_2,           KEY_2           } },
+	{ 0x03, { KEY_3,           KEY_3,           KEY_3,           KEY_3,           KEY_3           } },
+	{ 0x04, { KEY_4,           KEY_4,           KEY_4,           KEY_4,           KEY_4           } },
+	{ 0x05, { KEY_5,           KEY_5,           KEY_5,           KEY_5,           KEY_5           } },
+	{ 0x06, { KEY_6,           KEY_6,           KEY_6,           KEY_6,           KEY_6           } },
+	{ 0x07, { KEY_7,           KEY_7,           KEY_7,           KEY_7,           KEY_7           } },
+	{ 0x08, { KEY_8,           KEY_8,           KEY_8,           KEY_8,           KEY_8           } },
+	{ 0x09, { KEY_9,           KEY_9,           KEY_9,           KEY_9,           KEY_9           } },
+	{ 0x0c, { KEY_POWER,       KEY_POWER,       KEY_POWER,       KEY_POWER,       KEY_POWER       } },
+	{ 0x0d, { KEY_MUTE,        KEY_MUTE,        KEY_MUTE,        KEY_MUTE,        KEY_MUTE        } },
+	{ 0x10, { KEY_VOLUMEUP,    KEY_VOLUMEUP,    KEY_VOLUMEUP,    KEY_VOLUMEUP,    KEY_VOLUMEUP    } },
+	{ 0x11, { KEY_VOLUMEDOWN,  KEY_VOLUMEDOWN,  KEY_VOLUMEDOWN,  KEY_VOLUMEDOWN,  KEY_VOLUMEDOWN  } },
+	{ 0x20, { KEY_CHANNELUP,   KEY_CHANNELUP,   KEY_CHANNELUP,   KEY_CHANNELUP,   KEY_CHANNELUP   } },
+	{ 0x21, { KEY_CHANNELDOWN, KEY_CHANNELDOWN, KEY_CHANNELDOWN, KEY_CHANNELDOWN, KEY_CHANNELDOWN } },
+	{ 0x28, { KEY_FORWARD,     KEY_FORWARD,     KEY_FORWARD,     KEY_FORWARD,     KEY_FORWARD     } },
+	{ 0x29, { KEY_REWIND,      KEY_REWIND,      KEY_REWIND,      KEY_REWIND,      KEY_REWIND      } },
+	{ 0x2c, { KEY_PLAY,        KEY_PLAY,        KEY_PLAY,        KEY_PLAY,        KEY_PLAY        } },
+	{ 0x30, { KEY_PAUSE,       KEY_PAUSE,       KEY_PAUSE,       KEY_PAUSE,       KEY_PAUSE       } },
+	{ 0x31, { KEY_STOP,        KEY_STOP,        KEY_STOP,        KEY_STOP,        KEY_STOP        } },
+	{ 0x37, { KEY_RECORD,      KEY_RECORD,      KEY_RECORD,      KEY_RECORD,      KEY_RECORD      } },
+	{ 0x38, { KEY_DVD,         KEY_DVD,         KEY_DVD,         KEY_DVD,         KEY_DVD         } },
+	{ 0x39, { KEY_TV,          KEY_TV,          KEY_TV,          KEY_TV,          KEY_TV          } },
+	{ 0x3F, { KEY_PROG1,       KEY_PROG2,       KEY_PROG3,       KEY_PROG4,       KEY_PC          } },
+	{ 0x54, { KEY_MENU,        KEY_MENU,        KEY_MENU,        KEY_MENU,        KEY_MENU        } },
+	{ 0x58, { KEY_UP,          KEY_UP,          KEY_UP,          KEY_UP,          KEY_UP          } },
+	{ 0x59, { KEY_DOWN,        KEY_DOWN,        KEY_DOWN,        KEY_DOWN,        KEY_DOWN        } },
+	{ 0x5a, { KEY_LEFT,        KEY_LEFT,        KEY_LEFT,        KEY_LEFT,        KEY_LEFT        } },
+	{ 0x5b, { KEY_RIGHT,       KEY_RIGHT,       KEY_RIGHT,       KEY_RIGHT,       KEY_RIGHT       } },
+	{ 0x5c, { KEY_OK,          KEY_OK,          KEY_OK,          KEY_OK,          KEY_OK          } },
+	{ 0x78, { KEY_A,           KEY_A,           KEY_A,           KEY_A,           KEY_A           } },
+	{ 0x79, { KEY_B,           KEY_B,           KEY_B,           KEY_B,           KEY_B           } },
+	{ 0x7a, { KEY_C,           KEY_C,           KEY_C,           KEY_C,           KEY_C           } },
+	{ 0x7b, { KEY_D,           KEY_D,           KEY_D,           KEY_D,           KEY_D           } },
+	{ 0x7c, { KEY_E,           KEY_E,           KEY_E,           KEY_E,           KEY_E           } },
+	{ 0x7d, { KEY_F,           KEY_F,           KEY_F,           KEY_F,           KEY_F           } },
+	{ 0x82, { KEY_ENTER,       KEY_ENTER,       KEY_ENTER,       KEY_ENTER,       KEY_ENTER       } },
+	{ 0x8e, { KEY_VENDOR,      KEY_VENDOR,      KEY_VENDOR,      KEY_VENDOR,      KEY_VENDOR      } },
+	{ 0x96, { KEY_COFFEE,      KEY_COFFEE,      KEY_COFFEE,      KEY_COFFEE,      KEY_COFFEE      } },
+	{ 0xa9, { BTN_LEFT,        BTN_LEFT,        BTN_LEFT,        BTN_LEFT,        BTN_LEFT        } },
+	{ 0xaa, { BTN_RIGHT,       BTN_RIGHT,       BTN_RIGHT,       BTN_RIGHT,       BTN_RIGHT,      } },
+	{ 0xbe, { KEY_QUESTION,    KEY_QUESTION,    KEY_QUESTION,    KEY_QUESTION,    KEY_QUESTION,   } },
+	{ 0xd0, { KEY_EDIT,        KEY_EDIT,        KEY_EDIT,        KEY_EDIT,        KEY_EDIT        } },
+	{ 0xd5, { KEY_FRONT,       KEY_FRONT,       KEY_FRONT,       KEY_FRONT,       KEY_FRONT       } },
+	{ 0xf9, { KEY_INFO,        KEY_INFO,        KEY_INFO,        KEY_INFO,        KEY_INFO        } }
 };
 
 struct ati_remote2 {
@@ -112,11 +117,12 @@ struct ati_remote2 {
 	void *buf[2];
 	dma_addr_t buf_dma[2];
 
-	unsigned long jiffies;
 	int mode;
 
 	char name[64];
 	char phys[64];
+
+	u32 keycode[ARRAY_SIZE(ati_remote2_keycodes)][ARRAY_SIZE(ati_remote2_modes)];
 };
 
 static int ati_remote2_probe(struct usb_interface *interface, const struct usb_device_id *id);
@@ -159,11 +165,84 @@ static void ati_remote2_close(struct inp
 	usb_kill_urb(ar2->urb[1]);
 }
 
+static int ati_remote2_lookup(u8 hwcode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ati_remote2_keycodes); i++)
+		if (ati_remote2_keycodes[i].hwcode == hwcode)
+			return i;
+
+	return -1;
+}
+
+static int ati_remote2_getkeycode(struct input_dev *idev,
+				  int scancode, int *keycode)
+{
+	struct ati_remote2 *ar2 = input_get_drvdata(idev);
+	int index, mode;
+
+	if (((scancode >> 8) & mode_mask) != (scancode >> 8))
+		return -EINVAL;
+
+	index = ati_remote2_lookup(scancode & 0xFF);
+	if (index == -1)
+		return -EINVAL;
+
+	for (mode = 0; mode < ARRAY_SIZE(ati_remote2_modes); mode++) {
+		if ((1 << mode) & (scancode >> 8)) {
+			*keycode = ar2->keycode[index][mode];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int ati_remote2_setkeycode(struct input_dev *idev,
+				  int scancode, int keycode)
+{
+	struct ati_remote2 *ar2 = input_get_drvdata(idev);
+	int old_keycode = -1;
+	int index, mode;
+
+	if (((scancode >> 8) & mode_mask) != (scancode >> 8))
+		return -EINVAL;
+
+	index = ati_remote2_lookup(scancode & 0xFF);
+	if (index == -1)
+		return -EINVAL;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	for (mode = 0; mode < ARRAY_SIZE(ati_remote2_modes); mode++) {
+		if ((1 << mode) & (scancode >> 8)) {
+			old_keycode = ar2->keycode[index][mode];
+			ar2->keycode[index][mode] = keycode;
+		}
+	}
+
+	set_bit(keycode, idev->keybit);
+
+	for (index = 0; index < ARRAY_SIZE(ati_remote2_keycodes); index++) {
+		for (mode = 0; mode < ARRAY_SIZE(ati_remote2_modes); mode++) {
+			if (ar2->keycode[index][mode] == old_keycode)
+				return 0;
+		}
+	}
+
+	clear_bit(old_keycode, idev->keybit);
+
+	return 0;
+}
+
+
 static void ati_remote2_input_mouse(struct ati_remote2 *ar2)
 {
 	struct input_dev *idev = ar2->idev;
 	u8 *data = ar2->buf[0];
-	int channel, mode;
+	u8 channel, mode;
 
 	channel = data[0] >> 4;
 
@@ -187,22 +266,12 @@ static void ati_remote2_input_mouse(stru
 	input_sync(idev);
 }
 
-static int ati_remote2_lookup(unsigned int hw_code)
-{
-	int i;
-
-	for (i = 0; ati_remote2_key_table[i].key_code != KEY_RESERVED; i++)
-		if (ati_remote2_key_table[i].hw_code == hw_code)
-			return i;
-
-	return -1;
-}
-
 static void ati_remote2_input_key(struct ati_remote2 *ar2)
 {
 	struct input_dev *idev = ar2->idev;
 	u8 *data = ar2->buf[1];
-	int channel, mode, hw_code, index;
+	u8 channel, mode;
+	int index;
 
 	channel = data[0] >> 4;
 
@@ -218,12 +287,10 @@ static void ati_remote2_input_key(struct
 		return;
 	}
 
-	hw_code = data[2];
-	/*
-	 * Mode keys (AUX1-AUX4, PC) all generate the same code byte.
-	 * Use the mode byte to figure out which one was pressed.
-	 */
-	if (hw_code == 0x3f) {
+	if (!((1 << mode) & mode_mask))
+		return;
+
+	if (data[2] == 0x3f) {
 		/*
 		 * For some incomprehensible reason the mouse pad generates
 		 * events which look identical to the events from the last
@@ -236,14 +303,9 @@ static void ati_remote2_input_key(struct
 
 		if (data[1] == 0)
 			ar2->mode = mode;
-
-		hw_code |= mode << 8;
 	}
 
-	if (!((1 << mode) & mode_mask))
-		return;
-
-	index = ati_remote2_lookup(hw_code);
+	index = ati_remote2_lookup(data[2]);
 	if (index < 0) {
 		dev_err(&ar2->intf[1]->dev,
 			"Unknown code byte (%02x %02x %02x %02x)\n",
@@ -255,20 +317,9 @@ static void ati_remote2_input_key(struct
 	case 0:	/* release */
 		break;
 	case 1:	/* press */
-		ar2->jiffies = jiffies + msecs_to_jiffies(idev->rep[REP_DELAY]);
 		break;
 	case 2:	/* repeat */
-
-		/* No repeat for mouse buttons. */
-		if (ati_remote2_key_table[index].key_code == BTN_LEFT ||
-		    ati_remote2_key_table[index].key_code == BTN_RIGHT)
-			return;
-
-		if (!time_after_eq(jiffies, ar2->jiffies))
-			return;
-
-		ar2->jiffies = jiffies + msecs_to_jiffies(idev->rep[REP_PERIOD]);
-		break;
+		return; /* Autorepeat handled by input module */
 	default:
 		dev_err(&ar2->intf[1]->dev,
 			"Unknown state byte (%02x %02x %02x %02x)\n",
@@ -276,7 +327,7 @@ static void ati_remote2_input_key(struct
 		return;
 	}
 
-	input_event(idev, EV_KEY, ati_remote2_key_table[index].key_code, data[1]);
+	input_event(idev, EV_KEY, ar2->keycode[index][mode], data[1]);
 	input_sync(idev);
 }
 
@@ -334,10 +385,11 @@ static void ati_remote2_complete_key(str
 			"%s(): usb_submit_urb() = %d\n", __FUNCTION__, r);
 }
 
+
 static int ati_remote2_input_init(struct ati_remote2 *ar2)
 {
 	struct input_dev *idev;
-	int i, retval;
+	int index, mode, retval;
 
 	idev = input_allocate_device();
 	if (!idev)
@@ -347,18 +399,22 @@ static int ati_remote2_input_init(struct
 	input_set_drvdata(idev, ar2);
 
 	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) | BIT_MASK(EV_REL);
-	idev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
-		BIT_MASK(BTN_RIGHT);
+	idev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
 	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
-	for (i = 0; ati_remote2_key_table[i].key_code != KEY_RESERVED; i++)
-		set_bit(ati_remote2_key_table[i].key_code, idev->keybit);
 
-	idev->rep[REP_DELAY]  = 250;
-	idev->rep[REP_PERIOD] = 33;
+	for (index = 0; index < ARRAY_SIZE(ati_remote2_keycodes); index++) {
+		for (mode = 0; mode < ARRAY_SIZE(ati_remote2_modes); mode++) {
+			ar2->keycode[index][mode] = ati_remote2_keycodes[index].keycode[mode];
+			set_bit(ar2->keycode[index][mode], idev->keybit);
+		}
+	}
 
 	idev->open = ati_remote2_open;
 	idev->close = ati_remote2_close;
 
+	idev->getkeycode = ati_remote2_getkeycode;
+	idev->setkeycode = ati_remote2_setkeycode;
+
 	idev->name = ar2->name;
 	idev->phys = ar2->phys;
 
@@ -532,6 +588,9 @@ static int __init ati_remote2_init(void)
 	else
 		printk(KERN_INFO "ati_remote2: " DRIVER_DESC " " DRIVER_VERSION "\n");
 
+	mode_mask &= 0x1F;
+	channel_mask &= 0xFFFF;
+
 	return r;
 }
 
_

Patches currently in -mm which might be from linux@dadeos.co.uk are

ati_remote2-autorepeat-and-loadable-keymap-support.patch

