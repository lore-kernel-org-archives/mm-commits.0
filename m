From: akpm@linux-foundation.org
Subject: - get-rid-of-input-bit-duplicate-defines.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:50 -0700
Message-ID: <200710192252.l9JMqoVT024308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966929AbXJSXIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dtor@mail.ru, jkosina@suse.cz, lenb@kernel.org, malattia@linux.it, marcel@holtmann.org, mchehab@infradead.org, perex@suse.cz, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     get rid of input BIT* duplicate defines
has been removed from the -mm tree.  Its filename was
     get-rid-of-input-bit-duplicate-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get rid of input BIT* duplicate defines
From: Jiri Slaby <jirislaby@gmail.com>

get rid of input BIT* duplicate defines

use newly global defined macros for input layer. Also remove includes of
input.h from non-input sources only for BIT macro definiton. Define the
macro temporarily in local manner, all those local definitons will be
removed further in this patchset (to not break bisecting).
BIT macro will be globally defined (1<<x)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <dtor@mail.ru>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: <lenb@kernel.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Cc: <perex@suse.cz>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <vernux@us.ibm.com>
Cc: <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/input-programming.txt         |   15 +--
 drivers/acpi/button.c                             |    6 -
 drivers/char/keyboard.c                           |    6 -
 drivers/char/sonypi.c                             |    8 -
 drivers/firmware/dcdbas.h                         |    3 
 drivers/hid/usbhid/usbkbd.c                       |    7 +
 drivers/hid/usbhid/usbmouse.c                     |   12 +-
 drivers/hwmon/applesmc.c                          |    2 
 drivers/hwmon/hdaps.c                             |    2 
 drivers/input/evdev.c                             |   12 +-
 drivers/input/input.c                             |   10 +-
 drivers/input/joydev.c                            |   16 +--
 drivers/input/joystick/a3d.c                      |   28 +++--
 drivers/input/joystick/adi.c                      |    2 
 drivers/input/joystick/amijoy.c                   |    7 -
 drivers/input/joystick/analog.c                   |    2 
 drivers/input/joystick/cobra.c                    |    2 
 drivers/input/joystick/db9.c                      |    2 
 drivers/input/joystick/gamecon.c                  |    4 
 drivers/input/joystick/gf2k.c                     |    2 
 drivers/input/joystick/grip.c                     |    2 
 drivers/input/joystick/grip_mp.c                  |    2 
 drivers/input/joystick/guillemot.c                |    2 
 drivers/input/joystick/iforce/iforce-main.c       |    3 
 drivers/input/joystick/iforce/iforce.h            |    4 
 drivers/input/joystick/interact.c                 |    2 
 drivers/input/joystick/magellan.c                 |    2 
 drivers/input/joystick/sidewinder.c               |    2 
 drivers/input/joystick/spaceball.c                |   17 ++-
 drivers/input/joystick/spaceorb.c                 |    2 
 drivers/input/joystick/stinger.c                  |    9 +
 drivers/input/joystick/tmdc.c                     |    2 
 drivers/input/joystick/turbografx.c               |    2 
 drivers/input/joystick/twidjoy.c                  |    2 
 drivers/input/joystick/warrior.c                  |    8 +
 drivers/input/joystick/xpad.c                     |    2 
 drivers/input/keyboard/aaed2000_kbd.c             |    2 
 drivers/input/keyboard/amikbd.c                   |    2 
 drivers/input/keyboard/atakbd.c                   |    2 
 drivers/input/keyboard/atkbd.c                    |   21 ++--
 drivers/input/keyboard/corgikbd.c                 |    3 
 drivers/input/keyboard/gpio_keys.c                |    2 
 drivers/input/keyboard/hil_kbd.c                  |    5 -
 drivers/input/keyboard/hilkbd.c                   |    5 -
 drivers/input/keyboard/locomokbd.c                |    2 
 drivers/input/keyboard/newtonkbd.c                |    2 
 drivers/input/keyboard/pxa27x_keyboard.c          |    5 -
 drivers/input/keyboard/spitzkbd.c                 |    3 
 drivers/input/keyboard/stowaway.c                 |    2 
 drivers/input/keyboard/sunkbd.c                   |    8 +
 drivers/input/keyboard/xtkbd.c                    |    2 
 drivers/input/misc/ati_remote.c                   |    8 -
 drivers/input/misc/ati_remote2.c                  |    7 -
 drivers/input/misc/atlas_btns.c                   |    2 
 drivers/input/misc/cobalt_btns.c                  |    2 
 drivers/input/misc/ixp4xx-beeper.c                |    4 
 drivers/input/misc/keyspan_remote.c               |    2 
 drivers/input/misc/m68kspkr.c                     |    4 
 drivers/input/misc/pcspkr.c                       |    4 
 drivers/input/misc/powermate.c                    |    9 +
 drivers/input/misc/sparcspkr.c                    |    4 
 drivers/input/misc/yealink.c                      |    2 
 drivers/input/mouse/alps.c                        |   26 ++---
 drivers/input/mouse/amimouse.c                    |    7 -
 drivers/input/mouse/atarimouse.c                  |    7 -
 drivers/input/mouse/hil_ptr.c                     |    6 -
 drivers/input/mouse/inport.c                      |    7 -
 drivers/input/mouse/lifebook.c                    |   11 +-
 drivers/input/mouse/logibm.c                      |    7 -
 drivers/input/mouse/pc110pad.c                    |    6 -
 drivers/input/mouse/psmouse-base.c                |    7 -
 drivers/input/mouse/rpcmouse.c                    |    7 -
 drivers/input/mouse/sermouse.c                    |    7 -
 drivers/input/mouse/touchkit_ps2.c                |    2 
 drivers/input/mousedev.c                          |   26 ++---
 drivers/input/serio/maceps2.c                     |    2 
 drivers/input/tablet/acecad.c                     |   12 +-
 drivers/input/tablet/gtco.c                       |    6 -
 drivers/input/tablet/kbtab.c                      |   11 +-
 drivers/input/tablet/wacom_sys.c                  |   58 +++++++-----
 drivers/input/touchscreen/ads7846.c               |    4 
 drivers/input/touchscreen/corgi_ts.c              |    4 
 drivers/input/touchscreen/elo.c                   |    4 
 drivers/input/touchscreen/fujitsu_ts.c            |    4 
 drivers/input/touchscreen/gunze.c                 |    4 
 drivers/input/touchscreen/h3600_ts_input.c        |    5 -
 drivers/input/touchscreen/hp680_ts_input.c        |    4 
 drivers/input/touchscreen/mk712.c                 |    4 
 drivers/input/touchscreen/mtouch.c                |    4 
 drivers/input/touchscreen/penmount.c              |    4 
 drivers/input/touchscreen/touchright.c            |    4 
 drivers/input/touchscreen/touchwin.c              |    4 
 drivers/input/touchscreen/ucb1400_ts.c            |    2 
 drivers/input/touchscreen/usbtouchscreen.c        |    4 
 drivers/macintosh/adbhid.c                        |   19 ++-
 drivers/macintosh/mac_hid.c                       |    7 -
 drivers/media/dvb/cinergyT2/cinergyT2.c           |    2 
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c        |    2 
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    2 
 drivers/media/video/usbvideo/konicawc.c           |    4 
 drivers/media/video/usbvideo/quickcam_messenger.c |    4 
 drivers/misc/ibmasm/remote.c                      |    8 -
 drivers/misc/sony-laptop.c                        |    6 -
 include/linux/hid.h                               |    4 
 include/linux/input.h                             |   43 ++++----
 include/linux/uinput.h                            |    4 
 net/bluetooth/hidp/core.c                         |   12 +-
 net/rfkill/rfkill-input.c                         |   12 +-
 sound/ppc/beep.c                                  |    4 
 sound/usb/caiaq/caiaq-input.c                     |    9 +
 110 files changed, 410 insertions(+), 327 deletions(-)

diff -puN Documentation/input/input-programming.txt~get-rid-of-input-bit-duplicate-defines Documentation/input/input-programming.txt
--- a/Documentation/input/input-programming.txt~get-rid-of-input-bit-duplicate-defines
+++ a/Documentation/input/input-programming.txt
@@ -42,8 +42,8 @@ static int __init button_init(void)
 		goto err_free_irq;
 	}
 
-	button_dev->evbit[0] = BIT(EV_KEY);
-	button_dev->keybit[LONG(BTN_0)] = BIT(BTN_0);
+	button_dev->evbit[0] = BIT_MASK(EV_KEY);
+	button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
 
 	error = input_register_device(button_dev);
 	if (error) {
@@ -217,14 +217,15 @@ If you don't need absfuzz and absflat, y
 that the thing is precise and always returns to exactly the center position
 (if it has any).
 
-1.4 NBITS(), LONG(), BIT()
+1.4 BITS_TO_LONGS(), BIT_WORD(), BIT_MASK()
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-These three macros from input.h help some bitfield computations:
+These three macros from bitops.h help some bitfield computations:
 
-	NBITS(x) - returns the length of a bitfield array in longs for x bits
-	LONG(x)  - returns the index in the array in longs for bit x
-	BIT(x)   - returns the index in a long for bit x
+	BITS_TO_LONGS(x) - returns the length of a bitfield array in longs for
+			   x bits
+	BIT_WORD(x)	 - returns the index in the array in longs for bit x
+	BIT_MASK(x)	 - returns the index in a long for bit x
 
 1.5 The id* and name fields
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff -puN drivers/acpi/button.c~get-rid-of-input-bit-duplicate-defines drivers/acpi/button.c
--- a/drivers/acpi/button.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/acpi/button.c
@@ -434,18 +434,18 @@ static int acpi_button_add(struct acpi_d
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
 	case ACPI_BUTTON_TYPE_POWERF:
-		input->evbit[0] = BIT(EV_KEY);
+		input->evbit[0] = BIT_MASK(EV_KEY);
 		set_bit(KEY_POWER, input->keybit);
 		break;
 
 	case ACPI_BUTTON_TYPE_SLEEP:
 	case ACPI_BUTTON_TYPE_SLEEPF:
-		input->evbit[0] = BIT(EV_KEY);
+		input->evbit[0] = BIT_MASK(EV_KEY);
 		set_bit(KEY_SLEEP, input->keybit);
 		break;
 
 	case ACPI_BUTTON_TYPE_LID:
-		input->evbit[0] = BIT(EV_SW);
+		input->evbit[0] = BIT_MASK(EV_SW);
 		set_bit(SW_LID, input->swbit);
 		break;
 	}
diff -puN drivers/char/keyboard.c~get-rid-of-input-bit-duplicate-defines drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/char/keyboard.c
@@ -129,7 +129,7 @@ int shift_state = 0;
  */
 
 static struct input_handler kbd_handler;
-static unsigned long key_down[NBITS(KEY_MAX)];		/* keyboard key bitmap */
+static unsigned long key_down[BITS_TO_LONGS(KEY_CNT)];	/* keyboard key bitmap */
 static unsigned char shift_down[NR_SHIFT];		/* shift state counters.. */
 static int dead_key_next;
 static int npadch = -1;					/* -1 or number assembled on pad */
@@ -1377,12 +1377,12 @@ static void kbd_start(struct input_handl
 static const struct input_device_id kbd_ids[] = {
 	{
                 .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
-                .evbit = { BIT(EV_KEY) },
+                .evbit = { BIT_MASK(EV_KEY) },
         },
 
 	{
                 .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
-                .evbit = { BIT(EV_SND) },
+                .evbit = { BIT_MASK(EV_SND) },
         },
 
 	{ },    /* Terminating entry */
diff -puN drivers/char/sonypi.c~get-rid-of-input-bit-duplicate-defines drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/char/sonypi.c
@@ -1178,9 +1178,9 @@ static int __devinit sonypi_create_input
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
 
-	jog_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	jog_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_MIDDLE);
-	jog_dev->relbit[0] = BIT(REL_WHEEL);
+	jog_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	jog_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_MIDDLE);
+	jog_dev->relbit[0] = BIT_MASK(REL_WHEEL);
 
 	sonypi_device.input_key_dev = key_dev = input_allocate_device();
 	if (!key_dev) {
@@ -1193,7 +1193,7 @@ static int __devinit sonypi_create_input
 	key_dev->id.vendor = PCI_VENDOR_ID_SONY;
 
 	/* Initialize the Input Drivers: special keys */
-	key_dev->evbit[0] = BIT(EV_KEY);
+	key_dev->evbit[0] = BIT_MASK(EV_KEY);
 	for (i = 0; sonypi_inputkeys[i].sonypiev; i++)
 		if (sonypi_inputkeys[i].inputev)
 			set_bit(sonypi_inputkeys[i].inputev, key_dev->keybit);
diff -puN drivers/firmware/dcdbas.h~get-rid-of-input-bit-duplicate-defines drivers/firmware/dcdbas.h
--- a/drivers/firmware/dcdbas.h~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/firmware/dcdbas.h
@@ -17,10 +17,11 @@
 #define _DCDBAS_H_
 
 #include <linux/device.h>
-#include <linux/input.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 
+#define BIT(x)					(1UL << x)
+
 #define MAX_SMI_DATA_BUF_SIZE			(256 * 1024)
 
 #define HC_ACTION_NONE				(0)
diff -puN drivers/hid/usbhid/usbkbd.c~get-rid-of-input-bit-duplicate-defines drivers/hid/usbhid/usbkbd.c
--- a/drivers/hid/usbhid/usbkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/hid/usbhid/usbkbd.c
@@ -274,8 +274,11 @@ static int usb_kbd_probe(struct usb_inte
 
 	input_set_drvdata(input_dev, kbd);
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_LED) | BIT(EV_REP);
-	input_dev->ledbit[0] = BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL) | BIT(LED_COMPOSE) | BIT(LED_KANA);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_LED) |
+		BIT_MASK(EV_REP);
+	input_dev->ledbit[0] = BIT_MASK(LED_NUML) | BIT_MASK(LED_CAPSL) |
+		BIT_MASK(LED_SCROLLL) | BIT_MASK(LED_COMPOSE) |
+		BIT_MASK(LED_KANA);
 
 	for (i = 0; i < 255; i++)
 		set_bit(usb_kbd_keycode[i], input_dev->keybit);
diff -puN drivers/hid/usbhid/usbmouse.c~get-rid-of-input-bit-duplicate-defines drivers/hid/usbhid/usbmouse.c
--- a/drivers/hid/usbhid/usbmouse.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/hid/usbhid/usbmouse.c
@@ -173,11 +173,13 @@ static int usb_mouse_probe(struct usb_in
 	usb_to_input_id(dev, &input_dev->id);
 	input_dev->dev.parent = &intf->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	input_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
-	input_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
-	input_dev->keybit[LONG(BTN_MOUSE)] |= BIT(BTN_SIDE) | BIT(BTN_EXTRA);
-	input_dev->relbit[0] |= BIT(REL_WHEEL);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] |= BIT_MASK(BTN_SIDE) |
+		BIT_MASK(BTN_EXTRA);
+	input_dev->relbit[0] |= BIT_MASK(REL_WHEEL);
 
 	input_set_drvdata(input_dev, mouse);
 
diff -puN drivers/hwmon/applesmc.c~get-rid-of-input-bit-duplicate-defines drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/hwmon/applesmc.c
@@ -1099,7 +1099,7 @@ static int applesmc_create_accelerometer
 	idev->name = "applesmc";
 	idev->id.bustype = BUS_HOST;
 	idev->dev.parent = &pdev->dev;
-	idev->evbit[0] = BIT(EV_ABS);
+	idev->evbit[0] = BIT_MASK(EV_ABS);
 	input_set_abs_params(idev, ABS_X,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 	input_set_abs_params(idev, ABS_Y,
diff -puN drivers/hwmon/hdaps.c~get-rid-of-input-bit-duplicate-defines drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/hwmon/hdaps.c
@@ -574,7 +574,7 @@ static int __init hdaps_init(void)
 	idev = hdaps_idev->input;
 	idev->name = "hdaps";
 	idev->dev.parent = &pdev->dev;
-	idev->evbit[0] = BIT(EV_ABS);
+	idev->evbit[0] = BIT_MASK(EV_ABS);
 	input_set_abs_params(idev, ABS_X,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
 	input_set_abs_params(idev, ABS_Y,
diff -puN drivers/input/evdev.c~get-rid-of-input-bit-duplicate-defines drivers/input/evdev.c
--- a/drivers/input/evdev.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/evdev.c
@@ -495,7 +495,7 @@ static unsigned int evdev_poll(struct fi
 #ifdef CONFIG_COMPAT
 
 #define BITS_PER_LONG_COMPAT (sizeof(compat_long_t) * 8)
-#define NBITS_COMPAT(x) ((((x) - 1) / BITS_PER_LONG_COMPAT) + 1)
+#define BITS_TO_LONGS_COMPAT(x) ((((x) - 1) / BITS_PER_LONG_COMPAT) + 1)
 
 #ifdef __BIG_ENDIAN
 static int bits_to_user(unsigned long *bits, unsigned int maxbit,
@@ -504,7 +504,7 @@ static int bits_to_user(unsigned long *b
 	int len, i;
 
 	if (compat) {
-		len = NBITS_COMPAT(maxbit) * sizeof(compat_long_t);
+		len = BITS_TO_LONGS_COMPAT(maxbit) * sizeof(compat_long_t);
 		if (len > maxlen)
 			len = maxlen;
 
@@ -515,7 +515,7 @@ static int bits_to_user(unsigned long *b
 					 sizeof(compat_long_t)))
 				return -EFAULT;
 	} else {
-		len = NBITS(maxbit) * sizeof(long);
+		len = BITS_TO_LONGS(maxbit) * sizeof(long);
 		if (len > maxlen)
 			len = maxlen;
 
@@ -530,8 +530,8 @@ static int bits_to_user(unsigned long *b
 			unsigned int maxlen, void __user *p, int compat)
 {
 	int len = compat ?
-			NBITS_COMPAT(maxbit) * sizeof(compat_long_t) :
-			NBITS(maxbit) * sizeof(long);
+			BITS_TO_LONGS_COMPAT(maxbit) * sizeof(compat_long_t) :
+			BITS_TO_LONGS(maxbit) * sizeof(long);
 
 	if (len > maxlen)
 		len = maxlen;
@@ -545,7 +545,7 @@ static int bits_to_user(unsigned long *b
 static int bits_to_user(unsigned long *bits, unsigned int maxbit,
 			unsigned int maxlen, void __user *p, int compat)
 {
-	int len = NBITS(maxbit) * sizeof(long);
+	int len = BITS_TO_LONGS(maxbit) * sizeof(long);
 
 	if (len > maxlen)
 		len = maxlen;
diff -puN drivers/input/input.c~get-rid-of-input-bit-duplicate-defines drivers/input/input.c
--- a/drivers/input/input.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/input.c
@@ -584,10 +584,10 @@ static int input_default_setkeycode(stru
 
 
 #define MATCH_BIT(bit, max) \
-		for (i = 0; i < NBITS(max); i++) \
+		for (i = 0; i < BITS_TO_LONGS(max); i++) \
 			if ((id->bit[i] & dev->bit[i]) != id->bit[i]) \
 				break; \
-		if (i != NBITS(max)) \
+		if (i != BITS_TO_LONGS(max)) \
 			continue;
 
 static const struct input_device_id *input_match_device(const struct input_device_id *id,
@@ -698,7 +698,7 @@ static void input_seq_print_bitmap(struc
 {
 	int i;
 
-	for (i = NBITS(max) - 1; i > 0; i--)
+	for (i = BITS_TO_LONGS(max) - 1; i > 0; i--)
 		if (bitmap[i])
 			break;
 
@@ -892,7 +892,7 @@ static int input_print_modalias_bits(cha
 
 	len += snprintf(buf, max(size, 0), "%c", name);
 	for (i = min_bit; i < max_bit; i++)
-		if (bm[LONG(i)] & BIT(i))
+		if (bm[BIT_WORD(i)] & BIT_MASK(i))
 			len += snprintf(buf + len, max(size - len, 0), "%X,", i);
 	return len;
 }
@@ -991,7 +991,7 @@ static int input_print_bitmap(char *buf,
 	int i;
 	int len = 0;
 
-	for (i = NBITS(max) - 1; i > 0; i--)
+	for (i = BITS_TO_LONGS(max) - 1; i > 0; i--)
 		if (bitmap[i])
 			break;
 
diff -puN drivers/input/joydev.c~get-rid-of-input-bit-duplicate-defines drivers/input/joydev.c
--- a/drivers/input/joydev.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joydev.c
@@ -844,8 +844,8 @@ static const struct input_device_id joyd
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(BTN_TOUCH)] = BIT(BTN_TOUCH) },
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH) },
 	},	/* Avoid itouchpads, touchscreens and tablets */
 	{ }	/* Terminating entry */
 };
@@ -854,20 +854,20 @@ static const struct input_device_id joyd
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_ABSBIT,
-		.evbit = { BIT(EV_ABS) },
-		.absbit = { BIT(ABS_X) },
+		.evbit = { BIT_MASK(EV_ABS) },
+		.absbit = { BIT_MASK(ABS_X) },
 	},
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_ABSBIT,
-		.evbit = { BIT(EV_ABS) },
-		.absbit = { BIT(ABS_WHEEL) },
+		.evbit = { BIT_MASK(EV_ABS) },
+		.absbit = { BIT_MASK(ABS_WHEEL) },
 	},
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_ABSBIT,
-		.evbit = { BIT(EV_ABS) },
-		.absbit = { BIT(ABS_THROTTLE) },
+		.evbit = { BIT_MASK(EV_ABS) },
+		.absbit = { BIT_MASK(ABS_THROTTLE) },
 	},
 	{ }	/* Terminating entry */
 };
diff -puN drivers/input/joystick/a3d.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/a3d.c
--- a/drivers/input/joystick/a3d.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/a3d.c
@@ -326,14 +326,19 @@ static int a3d_connect(struct gameport *
 
 		a3d->length = 33;
 
-		input_dev->evbit[0] |= BIT(EV_ABS) | BIT(EV_KEY) | BIT(EV_REL);
-		input_dev->relbit[0] |= BIT(REL_X) | BIT(REL_Y);
-		input_dev->absbit[0] |= BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_THROTTLE) | BIT(ABS_RUDDER)
-					| BIT(ABS_HAT0X) | BIT(ABS_HAT0Y) | BIT(ABS_HAT1X) | BIT(ABS_HAT1Y);
-		input_dev->keybit[LONG(BTN_MOUSE)] |= BIT(BTN_RIGHT) | BIT(BTN_LEFT) | BIT(BTN_MIDDLE)
-							| BIT(BTN_SIDE) | BIT(BTN_EXTRA);
-		input_dev->keybit[LONG(BTN_JOYSTICK)] |= BIT(BTN_TRIGGER) | BIT(BTN_THUMB) | BIT(BTN_TOP)
-							| BIT(BTN_PINKIE);
+		input_dev->evbit[0] |= BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY) |
+			BIT_MASK(EV_REL);
+		input_dev->relbit[0] |= BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+		input_dev->absbit[0] |= BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) |
+			BIT_MASK(ABS_THROTTLE) | BIT_MASK(ABS_RUDDER) |
+			BIT_MASK(ABS_HAT0X) | BIT_MASK(ABS_HAT0Y) |
+			BIT_MASK(ABS_HAT1X) | BIT_MASK(ABS_HAT1Y);
+		input_dev->keybit[BIT_WORD(BTN_MOUSE)] |= BIT_MASK(BTN_RIGHT) |
+			BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) |
+			BIT_MASK(BTN_SIDE) | BIT_MASK(BTN_EXTRA);
+		input_dev->keybit[BIT_WORD(BTN_JOYSTICK)] |=
+			BIT_MASK(BTN_TRIGGER) | BIT_MASK(BTN_THUMB) |
+			BIT_MASK(BTN_TOP) | BIT_MASK(BTN_PINKIE);
 
 		a3d_read(a3d, data);
 
@@ -348,9 +353,10 @@ static int a3d_connect(struct gameport *
 	} else {
 		a3d->length = 29;
 
-		input_dev->evbit[0] |= BIT(EV_KEY) | BIT(EV_REL);
-		input_dev->relbit[0] |= BIT(REL_X) | BIT(REL_Y);
-		input_dev->keybit[LONG(BTN_MOUSE)] |= BIT(BTN_RIGHT) | BIT(BTN_LEFT) | BIT(BTN_MIDDLE);
+		input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+		input_dev->relbit[0] |= BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+		input_dev->keybit[BIT_WORD(BTN_MOUSE)] |= BIT_MASK(BTN_RIGHT) |
+			BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE);
 
 		a3d_read(a3d, data);
 
diff -puN drivers/input/joystick/adi.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/adi.c
--- a/drivers/input/joystick/adi.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/adi.c
@@ -431,7 +431,7 @@ static int adi_init_input(struct adi *ad
 	input_dev->open = adi_open;
 	input_dev->close = adi_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; i < adi->axes10 + adi->axes8 + (adi->hats + (adi->pad != -1)) * 2; i++)
 		set_bit(adi->abs[i], input_dev->absbit);
diff -puN drivers/input/joystick/amijoy.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/amijoy.c
--- a/drivers/input/joystick/amijoy.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/amijoy.c
@@ -137,9 +137,10 @@ static int __init amijoy_init(void)
 		amijoy_dev[i]->open = amijoy_open;
 		amijoy_dev[i]->close = amijoy_close;
 
-		amijoy_dev[i]->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-		amijoy_dev[i]->absbit[0] = BIT(ABS_X) | BIT(ABS_Y);
-		amijoy_dev[i]->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
+		amijoy_dev[i]->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+		amijoy_dev[i]->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
+		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 		for (j = 0; j < 2; j++) {
 			amijoy_dev[i]->absmin[ABS_X + j] = -1;
 			amijoy_dev[i]->absmax[ABS_X + j] = 1;
diff -puN drivers/input/joystick/analog.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/analog.c
--- a/drivers/input/joystick/analog.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/analog.c
@@ -456,7 +456,7 @@ static int analog_init_device(struct ana
 	input_dev->open = analog_open;
 	input_dev->close = analog_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = j = 0; i < 4; i++)
 		if (analog->mask & (1 << i)) {
diff -puN drivers/input/joystick/cobra.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/cobra.c
--- a/drivers/input/joystick/cobra.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/cobra.c
@@ -218,7 +218,7 @@ static int cobra_connect(struct gameport
 		input_dev->open = cobra_open;
 		input_dev->close = cobra_close;
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 		input_set_abs_params(input_dev, ABS_X, -1, 1, 0, 0);
 		input_set_abs_params(input_dev, ABS_Y, -1, 1, 0, 0);
 		for (j = 0; cobra_btn[j]; j++)
diff -puN drivers/input/joystick/db9.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/db9.c
--- a/drivers/input/joystick/db9.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/db9.c
@@ -631,7 +631,7 @@ static struct db9 __init *db9_probe(int 
 		input_dev->open = db9_open;
 		input_dev->close = db9_close;
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 		for (j = 0; j < db9_mode->n_buttons; j++)
 			set_bit(db9_mode->buttons[j], input_dev->keybit);
 		for (j = 0; j < db9_mode->n_axis; j++) {
diff -puN drivers/input/joystick/gamecon.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/gamecon.c
--- a/drivers/input/joystick/gamecon.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/gamecon.c
@@ -653,12 +653,12 @@ static int __init gc_setup_pad(struct gc
 	input_dev->close = gc_close;
 
 	if (pad_type != GC_SNESMOUSE) {
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 		for (i = 0; i < 2; i++)
 			input_set_abs_params(input_dev, ABS_X + i, -1, 1, 0, 0);
 	} else
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
 
 	gc->pads[0] |= gc_status_bit[idx];
 	gc->pads[pad_type] |= gc_status_bit[idx];
diff -puN drivers/input/joystick/gf2k.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/gf2k.c
--- a/drivers/input/joystick/gf2k.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/gf2k.c
@@ -315,7 +315,7 @@ static int gf2k_connect(struct gameport 
 	input_dev->open = gf2k_open;
 	input_dev->close = gf2k_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; i < gf2k_axes[gf2k->id]; i++)
 		set_bit(gf2k_abs[i], input_dev->absbit);
diff -puN drivers/input/joystick/grip.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/grip.c
--- a/drivers/input/joystick/grip.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/grip.c
@@ -370,7 +370,7 @@ static int grip_connect(struct gameport 
 		input_dev->open = grip_open;
 		input_dev->close = grip_close;
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 		for (j = 0; (t = grip_abs[grip->mode[i]][j]) >= 0; j++) {
 
diff -puN drivers/input/joystick/grip_mp.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/grip_mp.c
--- a/drivers/input/joystick/grip_mp.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/grip_mp.c
@@ -606,7 +606,7 @@ static int register_slot(int slot, struc
 	input_dev->open = grip_open;
 	input_dev->close = grip_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (j = 0; (t = grip_abs[port->mode][j]) >= 0; j++)
 		input_set_abs_params(input_dev, t, -1, 1, 0, 0);
diff -puN drivers/input/joystick/guillemot.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/guillemot.c
--- a/drivers/input/joystick/guillemot.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/guillemot.c
@@ -238,7 +238,7 @@ static int guillemot_connect(struct game
 	input_dev->open = guillemot_open;
 	input_dev->close = guillemot_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; (t = guillemot->type->abs[i]) >= 0; i++)
 		input_set_abs_params(input_dev, t, 0, 255, 0, 0);
diff -puN drivers/input/joystick/iforce/iforce-main.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/iforce/iforce-main.c
--- a/drivers/input/joystick/iforce/iforce-main.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/iforce/iforce-main.c
@@ -389,7 +389,8 @@ int iforce_init_device(struct iforce *if
  * Set input device bitfields and ranges.
  */
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_FF_STATUS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) |
+		BIT_MASK(EV_FF_STATUS);
 
 	for (i = 0; iforce->type->btn[i] >= 0; i++)
 		set_bit(iforce->type->btn[i], input_dev->keybit);
diff -puN drivers/input/joystick/iforce/iforce.h~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/iforce/iforce.h
--- a/drivers/input/joystick/iforce/iforce.h~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/iforce/iforce.h
@@ -62,13 +62,13 @@
 #define FF_CORE_IS_PLAYED	3	/* Effect is currently being played */
 #define FF_CORE_SHOULD_PLAY	4	/* User wants the effect to be played */
 #define FF_CORE_UPDATE		5	/* Effect is being updated */
-#define FF_MODCORE_MAX		5
+#define FF_MODCORE_CNT		6
 
 struct iforce_core_effect {
 	/* Information about where modifiers are stored in the device's memory */
 	struct resource mod1_chunk;
 	struct resource mod2_chunk;
-	unsigned long flags[NBITS(FF_MODCORE_MAX)];
+	unsigned long flags[BITS_TO_LONGS(FF_MODCORE_CNT)];
 };
 
 #define FF_CMD_EFFECT		0x010e
diff -puN drivers/input/joystick/interact.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/interact.c
--- a/drivers/input/joystick/interact.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/interact.c
@@ -269,7 +269,7 @@ static int interact_connect(struct gamep
 	input_dev->open = interact_open;
 	input_dev->close = interact_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; (t = interact_type[interact->type].abs[i]) >= 0; i++) {
 		set_bit(t, input_dev->absbit);
diff -puN drivers/input/joystick/magellan.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/magellan.c
--- a/drivers/input/joystick/magellan.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/magellan.c
@@ -170,7 +170,7 @@ static int magellan_connect(struct serio
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; i < 9; i++)
 		set_bit(magellan_buttons[i], input_dev->keybit);
diff -puN drivers/input/joystick/sidewinder.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/sidewinder.c
--- a/drivers/input/joystick/sidewinder.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/sidewinder.c
@@ -758,7 +758,7 @@ static int sw_connect(struct gameport *g
 		input_dev->open = sw_open;
 		input_dev->close = sw_close;
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 		for (j = 0; (bits = sw_bit[sw->type][j]); j++) {
 			code = sw_abs[sw->type][j];
diff -puN drivers/input/joystick/spaceball.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/spaceball.c
--- a/drivers/input/joystick/spaceball.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/spaceball.c
@@ -228,18 +228,23 @@ static int spaceball_connect(struct seri
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	switch (id) {
 		case SPACEBALL_4000FLX:
 		case SPACEBALL_4000FLX_L:
-			input_dev->keybit[LONG(BTN_0)] |= BIT(BTN_9);
-			input_dev->keybit[LONG(BTN_A)] |= BIT(BTN_A) | BIT(BTN_B) | BIT(BTN_C) | BIT(BTN_MODE);
+			input_dev->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_9);
+			input_dev->keybit[BIT_WORD(BTN_A)] |= BIT_MASK(BTN_A) |
+				BIT_MASK(BTN_B) | BIT_MASK(BTN_C) |
+				BIT_MASK(BTN_MODE);
 		default:
-			input_dev->keybit[LONG(BTN_0)] |= BIT(BTN_2) | BIT(BTN_3) | BIT(BTN_4)
-				| BIT(BTN_5) | BIT(BTN_6) | BIT(BTN_7) | BIT(BTN_8);
+			input_dev->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_2) |
+				BIT_MASK(BTN_3) | BIT_MASK(BTN_4) |
+				BIT_MASK(BTN_5) | BIT_MASK(BTN_6) |
+				BIT_MASK(BTN_7) | BIT_MASK(BTN_8);
 		case SPACEBALL_3003C:
-			input_dev->keybit[LONG(BTN_0)] |= BIT(BTN_1) | BIT(BTN_8);
+			input_dev->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_1) |
+				BIT_MASK(BTN_8);
 	}
 
 	for (i = 0; i < 3; i++) {
diff -puN drivers/input/joystick/spaceorb.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/spaceorb.c
--- a/drivers/input/joystick/spaceorb.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/spaceorb.c
@@ -185,7 +185,7 @@ static int spaceorb_connect(struct serio
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; i < 6; i++)
 		set_bit(spaceorb_buttons[i], input_dev->keybit);
diff -puN drivers/input/joystick/stinger.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/stinger.c
--- a/drivers/input/joystick/stinger.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/stinger.c
@@ -156,10 +156,11 @@ static int stinger_connect(struct serio 
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_A)] = BIT(BTN_A) | BIT(BTN_B) | BIT(BTN_C) | BIT(BTN_X) |
-					 BIT(BTN_Y) | BIT(BTN_Z) | BIT(BTN_TL) | BIT(BTN_TR) |
-					 BIT(BTN_START) | BIT(BTN_SELECT);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_A)] = BIT_MASK(BTN_A) | BIT_MASK(BTN_B) |
+		BIT_MASK(BTN_C) | BIT_MASK(BTN_X) | BIT_MASK(BTN_Y) |
+		BIT_MASK(BTN_Z) | BIT_MASK(BTN_TL) | BIT_MASK(BTN_TR) |
+		BIT_MASK(BTN_START) | BIT_MASK(BTN_SELECT);
 	input_set_abs_params(input_dev, ABS_X, -64, 64, 0, 4);
 	input_set_abs_params(input_dev, ABS_Y, -64, 64, 0, 4);
 
diff -puN drivers/input/joystick/tmdc.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/tmdc.c
--- a/drivers/input/joystick/tmdc.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/tmdc.c
@@ -333,7 +333,7 @@ static int tmdc_setup_port(struct tmdc *
 	input_dev->open = tmdc_open;
 	input_dev->close = tmdc_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; i < port->absc && i < TMDC_ABS; i++)
 		if (port->abs[i] >= 0)
diff -puN drivers/input/joystick/turbografx.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/turbografx.c
--- a/drivers/input/joystick/turbografx.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/turbografx.c
@@ -229,7 +229,7 @@ static struct tgfx __init *tgfx_probe(in
 		input_dev->open = tgfx_open;
 		input_dev->close = tgfx_close;
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 		input_set_abs_params(input_dev, ABS_X, -1, 1, 0, 0);
 		input_set_abs_params(input_dev, ABS_Y, -1, 1, 0, 0);
 
diff -puN drivers/input/joystick/twidjoy.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/twidjoy.c
--- a/drivers/input/joystick/twidjoy.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/twidjoy.c
@@ -207,7 +207,7 @@ static int twidjoy_connect(struct serio 
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	input_set_abs_params(input_dev, ABS_X, -50, 50, 4, 4);
 	input_set_abs_params(input_dev, ABS_Y, -50, 50, 4, 4);
 
diff -puN drivers/input/joystick/warrior.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/warrior.c
--- a/drivers/input/joystick/warrior.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/warrior.c
@@ -162,9 +162,11 @@ static int warrior_connect(struct serio 
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TRIGGER)] = BIT(BTN_TRIGGER) | BIT(BTN_THUMB) | BIT(BTN_TOP) | BIT(BTN_TOP2);
-	input_dev->relbit[0] = BIT(REL_DIAL);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL) |
+		BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TRIGGER)] = BIT_MASK(BTN_TRIGGER) |
+		BIT_MASK(BTN_THUMB) | BIT_MASK(BTN_TOP) | BIT_MASK(BTN_TOP2);
+	input_dev->relbit[0] = BIT_MASK(REL_DIAL);
 	input_set_abs_params(input_dev, ABS_X, -64, 64, 0, 8);
 	input_set_abs_params(input_dev, ABS_Y, -64, 64, 0, 8);
 	input_set_abs_params(input_dev, ABS_THROTTLE, -112, 112, 0, 0);
diff -puN drivers/input/joystick/xpad.c~get-rid-of-input-bit-duplicate-defines drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/joystick/xpad.c
@@ -658,7 +658,7 @@ static int xpad_probe(struct usb_interfa
 	input_dev->open = xpad_open;
 	input_dev->close = xpad_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	/* set up buttons */
 	for (i = 0; xpad_btn[i] >= 0; i++)
diff -puN drivers/input/keyboard/aaed2000_kbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/aaed2000_kbd.c
--- a/drivers/input/keyboard/aaed2000_kbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/aaed2000_kbd.c
@@ -125,7 +125,7 @@ static int __devinit aaedkbd_probe(struc
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycode = aaedkbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(aaedkbd_keycode);
diff -puN drivers/input/keyboard/amikbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/amikbd.c
--- a/drivers/input/keyboard/amikbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/amikbd.c
@@ -209,7 +209,7 @@ static int __init amikbd_init(void)
 	amikbd_dev->id.product = 0x0001;
 	amikbd_dev->id.version = 0x0100;
 
-	amikbd_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	amikbd_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 
 	for (i = 0; i < 0x78; i++)
 		set_bit(i, amikbd_dev->keybit);
diff -puN drivers/input/keyboard/atakbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/atakbd.c
--- a/drivers/input/keyboard/atakbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/atakbd.c
@@ -237,7 +237,7 @@ static int __init atakbd_init(void)
 	atakbd_dev->id.product = 0x0001;
 	atakbd_dev->id.version = 0x0100;
 
-	atakbd_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	atakbd_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	atakbd_dev->keycode = atakbd_keycode;
 	atakbd_dev->keycodesize = sizeof(unsigned char);
 	atakbd_dev->keycodemax = ARRAY_SIZE(atakbd_keycode);
diff -puN drivers/input/keyboard/atkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/atkbd.c
@@ -900,27 +900,32 @@ static void atkbd_set_device_attrs(struc
 
 	input_set_drvdata(input_dev, atkbd);
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP) | BIT(EV_MSC);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+		BIT_MASK(EV_MSC);
 
 	if (atkbd->write) {
-		input_dev->evbit[0] |= BIT(EV_LED);
-		input_dev->ledbit[0] = BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL);
+		input_dev->evbit[0] |= BIT_MASK(EV_LED);
+		input_dev->ledbit[0] = BIT_MASK(LED_NUML) |
+			BIT_MASK(LED_CAPSL) | BIT_MASK(LED_SCROLLL);
 	}
 
 	if (atkbd->extra)
-		input_dev->ledbit[0] |= BIT(LED_COMPOSE) | BIT(LED_SUSPEND) |
-					BIT(LED_SLEEP) | BIT(LED_MUTE) | BIT(LED_MISC);
+		input_dev->ledbit[0] |= BIT_MASK(LED_COMPOSE) |
+			BIT_MASK(LED_SUSPEND) | BIT_MASK(LED_SLEEP) |
+			BIT_MASK(LED_MUTE) | BIT_MASK(LED_MISC);
 
 	if (!atkbd->softrepeat) {
 		input_dev->rep[REP_DELAY] = 250;
 		input_dev->rep[REP_PERIOD] = 33;
 	}
 
-	input_dev->mscbit[0] = atkbd->softraw ? BIT(MSC_SCAN) : BIT(MSC_RAW) | BIT(MSC_SCAN);
+	input_dev->mscbit[0] = atkbd->softraw ? BIT_MASK(MSC_SCAN) :
+		BIT_MASK(MSC_RAW) | BIT_MASK(MSC_SCAN);
 
 	if (atkbd->scroll) {
-		input_dev->evbit[0] |= BIT(EV_REL);
-		input_dev->relbit[0] = BIT(REL_WHEEL) | BIT(REL_HWHEEL);
+		input_dev->evbit[0] |= BIT_MASK(EV_REL);
+		input_dev->relbit[0] = BIT_MASK(REL_WHEEL) |
+			BIT_MASK(REL_HWHEEL);
 		set_bit(BTN_MIDDLE, input_dev->keybit);
 	}
 
diff -puN drivers/input/keyboard/corgikbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/corgikbd.c
--- a/drivers/input/keyboard/corgikbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/corgikbd.c
@@ -325,7 +325,8 @@ static int __init corgikbd_probe(struct 
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP) | BIT(EV_PWR) | BIT(EV_SW);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+		BIT_MASK(EV_PWR) | BIT_MASK(EV_SW);
 	input_dev->keycode = corgikbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(corgikbd_keycode);
diff -puN drivers/input/keyboard/gpio_keys.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -62,7 +62,7 @@ static int __devinit gpio_keys_probe(str
 
 	platform_set_drvdata(pdev, input);
 
-	input->evbit[0] = BIT(EV_KEY);
+	input->evbit[0] = BIT_MASK(EV_KEY);
 
 	input->name = pdev->name;
 	input->phys = "gpio-keys/input0";
diff -puN drivers/input/keyboard/hil_kbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/hil_kbd.c
--- a/drivers/input/keyboard/hil_kbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/hil_kbd.c
@@ -323,8 +323,9 @@ static int hil_kbd_connect(struct serio 
 		goto bail2;
 	}
 
-	kbd->dev->evbit[0]	= BIT(EV_KEY) | BIT(EV_REP);
-	kbd->dev->ledbit[0]	= BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL);
+	kbd->dev->evbit[0]	= BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	kbd->dev->ledbit[0]	= BIT_MASK(LED_NUML) | BIT_MASK(LED_CAPSL) |
+		BIT_MASK(LED_SCROLLL);
 	kbd->dev->keycodemax	= HIL_KEYCODES_SET1_TBLSIZE;
 	kbd->dev->keycodesize	= sizeof(hil_kbd_set1[0]);
 	kbd->dev->keycode	= hil_kbd_set1;
diff -puN drivers/input/keyboard/hilkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/hilkbd.c
@@ -266,8 +266,9 @@ hil_keyb_init(void)
 		if (hphilkeyb_keycode[i] != KEY_RESERVED)
 			set_bit(hphilkeyb_keycode[i], hil_dev.dev->keybit);
 
-	hil_dev.dev->evbit[0]	= BIT(EV_KEY) | BIT(EV_REP);
-	hil_dev.dev->ledbit[0]	= BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL);
+	hil_dev.dev->evbit[0]	= BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	hil_dev.dev->ledbit[0]	= BIT_MASK(LED_NUML) | BIT_MASK(LED_CAPSL) |
+		BIT_MASK(LED_SCROLLL);
 	hil_dev.dev->keycodemax	= HIL_KEYCODES_SET1_TBLSIZE;
 	hil_dev.dev->keycodesize= sizeof(hphilkeyb_keycode[0]);
 	hil_dev.dev->keycode	= hphilkeyb_keycode;
diff -puN drivers/input/keyboard/locomokbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/locomokbd.c
--- a/drivers/input/keyboard/locomokbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/locomokbd.c
@@ -233,7 +233,7 @@ static int locomokbd_probe(struct locomo
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycode = locomokbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(locomokbd_keycode);
diff -puN drivers/input/keyboard/newtonkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/newtonkbd.c
--- a/drivers/input/keyboard/newtonkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/newtonkbd.c
@@ -106,7 +106,7 @@ static int nkbd_connect(struct serio *se
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycode = nkbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(nkbd_keycode);
diff -puN drivers/input/keyboard/pxa27x_keyboard.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/pxa27x_keyboard.c
--- a/drivers/input/keyboard/pxa27x_keyboard.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/pxa27x_keyboard.c
@@ -183,8 +183,9 @@ static int __devinit pxakbd_probe(struct
 	input_dev->close = pxakbd_close;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP) | BIT(EV_REL);
-	input_dev->relbit[LONG(REL_WHEEL)] = BIT(REL_WHEEL);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+		BIT_MASK(EV_REL);
+	input_dev->relbit[BIT_WORD(REL_WHEEL)] = BIT_MASK(REL_WHEEL);
 	for (row = 0; row < pdata->nr_rows; row++) {
 		for (col = 0; col < pdata->nr_cols; col++) {
 			int code = pdata->keycodes[row][col];
diff -puN drivers/input/keyboard/spitzkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/spitzkbd.c
--- a/drivers/input/keyboard/spitzkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/spitzkbd.c
@@ -381,7 +381,8 @@ static int __init spitzkbd_probe(struct 
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP) | BIT(EV_PWR) | BIT(EV_SW);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) |
+		BIT_MASK(EV_PWR) | BIT_MASK(EV_SW);
 	input_dev->keycode = spitzkbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(spitzkbd_keycode);
diff -puN drivers/input/keyboard/stowaway.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/stowaway.c
--- a/drivers/input/keyboard/stowaway.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/stowaway.c
@@ -110,7 +110,7 @@ static int skbd_connect(struct serio *se
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycode = skbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(skbd_keycode);
diff -puN drivers/input/keyboard/sunkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/sunkbd.c
--- a/drivers/input/keyboard/sunkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/sunkbd.c
@@ -277,9 +277,11 @@ static int sunkbd_connect(struct serio *
 
 	input_dev->event = sunkbd_event;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_LED) | BIT(EV_SND) | BIT(EV_REP);
-	input_dev->ledbit[0] = BIT(LED_CAPSL) | BIT(LED_COMPOSE) | BIT(LED_SCROLLL) | BIT(LED_NUML);
-	input_dev->sndbit[0] = BIT(SND_CLICK) | BIT(SND_BELL);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_LED) |
+		BIT_MASK(EV_SND) | BIT_MASK(EV_REP);
+	input_dev->ledbit[0] = BIT_MASK(LED_CAPSL) | BIT_MASK(LED_COMPOSE) |
+		BIT_MASK(LED_SCROLLL) | BIT_MASK(LED_NUML);
+	input_dev->sndbit[0] = BIT_MASK(SND_CLICK) | BIT_MASK(SND_BELL);
 
 	input_dev->keycode = sunkbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
diff -puN drivers/input/keyboard/xtkbd.c~get-rid-of-input-bit-duplicate-defines drivers/input/keyboard/xtkbd.c
--- a/drivers/input/keyboard/xtkbd.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/keyboard/xtkbd.c
@@ -110,7 +110,7 @@ static int xtkbd_connect(struct serio *s
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycode = xtkbd->keycode;
 	input_dev->keycodesize = sizeof(unsigned char);
 	input_dev->keycodemax = ARRAY_SIZE(xtkbd_keycode);
diff -puN drivers/input/misc/ati_remote.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/ati_remote.c
@@ -662,10 +662,10 @@ static void ati_remote_input_init(struct
 	struct input_dev *idev = ati_remote->idev;
 	int i;
 
-	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	idev->keybit[LONG(BTN_MOUSE)] = ( BIT(BTN_LEFT) | BIT(BTN_RIGHT) |
-					  BIT(BTN_SIDE) | BIT(BTN_EXTRA) );
-	idev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	idev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_SIDE) | BIT_MASK(BTN_EXTRA);
+	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 	for (i = 0; ati_remote_tbl[i].kind != KIND_END; i++)
 		if (ati_remote_tbl[i].type == EV_KEY)
 			set_bit(ati_remote_tbl[i].code, idev->keybit);
diff -puN drivers/input/misc/ati_remote2.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/ati_remote2.c
--- a/drivers/input/misc/ati_remote2.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/ati_remote2.c
@@ -346,9 +346,10 @@ static int ati_remote2_input_init(struct
 	ar2->idev = idev;
 	input_set_drvdata(idev, ar2);
 
-	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP) | BIT(EV_REL);
-	idev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT);
-	idev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) | BIT_MASK(EV_REL);
+	idev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT);
+	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 	for (i = 0; ati_remote2_key_table[i].key_code != KEY_RESERVED; i++)
 		set_bit(ati_remote2_key_table[i].key_code, idev->keybit);
 
diff -puN drivers/input/misc/atlas_btns.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/atlas_btns.c
--- a/drivers/input/misc/atlas_btns.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/atlas_btns.c
@@ -81,7 +81,7 @@ static int atlas_acpi_button_add(struct 
 	input_dev->name = "Atlas ACPI button driver";
 	input_dev->phys = "ASIM0000/atlas/input0";
 	input_dev->id.bustype = BUS_HOST;
-	input_dev->evbit[LONG(EV_KEY)] = BIT(EV_KEY);
+	input_dev->evbit[BIT_WORD(EV_KEY)] = BIT_MASK(EV_KEY);
 
 	set_bit(KEY_F1, input_dev->keybit);
 	set_bit(KEY_F2, input_dev->keybit);
diff -puN drivers/input/misc/cobalt_btns.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/cobalt_btns.c
--- a/drivers/input/misc/cobalt_btns.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/cobalt_btns.c
@@ -104,7 +104,7 @@ static int __devinit cobalt_buttons_prob
 	input->id.bustype = BUS_HOST;
 	input->cdev.dev = &pdev->dev;
 
-	input->evbit[0] = BIT(EV_KEY);
+	input->evbit[0] = BIT_MASK(EV_KEY);
 	for (i = 0; i < ARRAY_SIZE(buttons_map); i++) {
 		set_bit(buttons_map[i].keycode, input->keybit);
 		buttons_map[i].count = 0;
diff -puN drivers/input/misc/ixp4xx-beeper.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/ixp4xx-beeper.c
--- a/drivers/input/misc/ixp4xx-beeper.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/ixp4xx-beeper.c
@@ -109,8 +109,8 @@ static int __devinit ixp4xx_spkr_probe(s
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT(EV_SND);
-	input_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
+	input_dev->evbit[0] = BIT_MASK(EV_SND);
+	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
diff -puN drivers/input/misc/keyspan_remote.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/keyspan_remote.c
--- a/drivers/input/misc/keyspan_remote.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/keyspan_remote.c
@@ -497,7 +497,7 @@ static int keyspan_probe(struct usb_inte
 	usb_to_input_id(udev, &input_dev->id);
 	input_dev->dev.parent = &interface->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY);		/* We will only report KEY events. */
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);		/* We will only report KEY events. */
 	for (i = 0; i < ARRAY_SIZE(keyspan_key_table); i++)
 		if (keyspan_key_table[i] != KEY_RESERVED)
 			set_bit(keyspan_key_table[i], input_dev->keybit);
diff -puN drivers/input/misc/m68kspkr.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/m68kspkr.c
--- a/drivers/input/misc/m68kspkr.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/m68kspkr.c
@@ -65,8 +65,8 @@ static int __devinit m68kspkr_probe(stru
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT(EV_SND);
-	input_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
+	input_dev->evbit[0] = BIT_MASK(EV_SND);
+	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	input_dev->event = m68kspkr_event;
 
 	err = input_register_device(input_dev);
diff -puN drivers/input/misc/pcspkr.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/pcspkr.c
--- a/drivers/input/misc/pcspkr.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/pcspkr.c
@@ -86,8 +86,8 @@ static int __devinit pcspkr_probe(struct
 	pcspkr_dev->id.version = 0x0100;
 	pcspkr_dev->dev.parent = &dev->dev;
 
-	pcspkr_dev->evbit[0] = BIT(EV_SND);
-	pcspkr_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
+	pcspkr_dev->evbit[0] = BIT_MASK(EV_SND);
+	pcspkr_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	pcspkr_dev->event = pcspkr_event;
 
 	err = input_register_device(pcspkr_dev);
diff -puN drivers/input/misc/powermate.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/powermate.c
--- a/drivers/input/misc/powermate.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/powermate.c
@@ -363,10 +363,11 @@ static int powermate_probe(struct usb_in
 
 	input_dev->event = powermate_input_event;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_MSC);
-	input_dev->keybit[LONG(BTN_0)] = BIT(BTN_0);
-	input_dev->relbit[LONG(REL_DIAL)] = BIT(REL_DIAL);
-	input_dev->mscbit[LONG(MSC_PULSELED)] = BIT(MSC_PULSELED);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL) |
+		BIT_MASK(EV_MSC);
+	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	input_dev->relbit[BIT_WORD(REL_DIAL)] = BIT_MASK(REL_DIAL);
+	input_dev->mscbit[BIT_WORD(MSC_PULSELED)] = BIT_MASK(MSC_PULSELED);
 
 	/* get a handle to the interrupt data pipe */
 	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
diff -puN drivers/input/misc/sparcspkr.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/sparcspkr.c
--- a/drivers/input/misc/sparcspkr.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/sparcspkr.c
@@ -115,8 +115,8 @@ static int __devinit sparcspkr_probe(str
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = dev;
 
-	input_dev->evbit[0] = BIT(EV_SND);
-	input_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
+	input_dev->evbit[0] = BIT_MASK(EV_SND);
+	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 
 	input_dev->event = state->event;
 
diff -puN drivers/input/misc/yealink.c~get-rid-of-input-bit-duplicate-defines drivers/input/misc/yealink.c
--- a/drivers/input/misc/yealink.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/misc/yealink.c
@@ -945,7 +945,7 @@ static int usb_probe(struct usb_interfac
 	/* input_dev->event = input_ev;	TODO */
 
 	/* register available key events */
-	input_dev->evbit[0] = BIT(EV_KEY);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	for (i = 0; i < 256; i++) {
 		int k = map_p1k_to_key(i);
 		if (k >= 0) {
diff -puN drivers/input/mouse/alps.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/alps.c
--- a/drivers/input/mouse/alps.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/alps.c
@@ -455,24 +455,25 @@ int alps_init(struct psmouse *psmouse)
 	if (alps_hw_init(psmouse, &version))
 		goto init_fail;
 
-	dev1->evbit[LONG(EV_KEY)] |= BIT(EV_KEY);
-	dev1->keybit[LONG(BTN_TOUCH)] |= BIT(BTN_TOUCH);
-	dev1->keybit[LONG(BTN_TOOL_FINGER)] |= BIT(BTN_TOOL_FINGER);
-	dev1->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
+	dev1->evbit[BIT_WORD(EV_KEY)] |= BIT_MASK(EV_KEY);
+	dev1->keybit[BIT_WORD(BTN_TOUCH)] |= BIT_MASK(BTN_TOUCH);
+	dev1->keybit[BIT_WORD(BTN_TOOL_FINGER)] |= BIT_MASK(BTN_TOOL_FINGER);
+	dev1->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 
-	dev1->evbit[LONG(EV_ABS)] |= BIT(EV_ABS);
+	dev1->evbit[BIT_WORD(EV_ABS)] |= BIT_MASK(EV_ABS);
 	input_set_abs_params(dev1, ABS_X, 0, 1023, 0, 0);
 	input_set_abs_params(dev1, ABS_Y, 0, 767, 0, 0);
 	input_set_abs_params(dev1, ABS_PRESSURE, 0, 127, 0, 0);
 
 	if (priv->i->flags & ALPS_WHEEL) {
-		dev1->evbit[LONG(EV_REL)] |= BIT(EV_REL);
-		dev1->relbit[LONG(REL_WHEEL)] |= BIT(REL_WHEEL);
+		dev1->evbit[BIT_WORD(EV_REL)] |= BIT_MASK(EV_REL);
+		dev1->relbit[BIT_WORD(REL_WHEEL)] |= BIT_MASK(REL_WHEEL);
 	}
 
 	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
-		dev1->keybit[LONG(BTN_FORWARD)] |= BIT(BTN_FORWARD);
-		dev1->keybit[LONG(BTN_BACK)] |= BIT(BTN_BACK);
+		dev1->keybit[BIT_WORD(BTN_FORWARD)] |= BIT_MASK(BTN_FORWARD);
+		dev1->keybit[BIT_WORD(BTN_BACK)] |= BIT_MASK(BTN_BACK);
 	}
 
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
@@ -483,9 +484,10 @@ int alps_init(struct psmouse *psmouse)
 	dev2->id.product = PSMOUSE_ALPS;
 	dev2->id.version = 0x0000;
 
-	dev2->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	dev2->relbit[LONG(REL_X)] |= BIT(REL_X) | BIT(REL_Y);
-	dev2->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
+	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	dev2->relbit[BIT_WORD(REL_X)] |= BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	dev2->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 
 	if (input_register_device(priv->dev2))
 		goto init_fail;
diff -puN drivers/input/mouse/amimouse.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/amimouse.c
--- a/drivers/input/mouse/amimouse.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/amimouse.c
@@ -111,9 +111,10 @@ static int __init amimouse_init(void)
 	amimouse_dev->id.product = 0x0002;
 	amimouse_dev->id.version = 0x0100;
 
-	amimouse_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	amimouse_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
-	amimouse_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
+	amimouse_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	amimouse_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	amimouse_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 	amimouse_dev->open = amimouse_open;
 	amimouse_dev->close = amimouse_close;
 
diff -puN drivers/input/mouse/atarimouse.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/atarimouse.c
--- a/drivers/input/mouse/atarimouse.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/atarimouse.c
@@ -137,9 +137,10 @@ static int __init atamouse_init(void)
 	atamouse_dev->id.product = 0x0002;
 	atamouse_dev->id.version = 0x0100;
 
-	atamouse_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	atamouse_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
-	atamouse_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
+	atamouse_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	atamouse_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	atamouse_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 	atamouse_dev->open = atamouse_open;
 	atamouse_dev->close = atamouse_close;
 
diff -puN drivers/input/mouse/hil_ptr.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/hil_ptr.c
--- a/drivers/input/mouse/hil_ptr.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/hil_ptr.c
@@ -298,12 +298,12 @@ static int hil_ptr_connect(struct serio 
 	idd = ptr->idd + 1;
 	txt = "unknown";
 	if ((did & HIL_IDD_DID_TYPE_MASK) == HIL_IDD_DID_TYPE_REL) {
-		ptr->dev->evbit[0] = BIT(EV_REL);
+		ptr->dev->evbit[0] = BIT_MASK(EV_REL);
 		txt = "relative";
 	}
 
 	if ((did & HIL_IDD_DID_TYPE_MASK) == HIL_IDD_DID_TYPE_ABS) {
-		ptr->dev->evbit[0] = BIT(EV_ABS);
+		ptr->dev->evbit[0] = BIT_MASK(EV_ABS);
 		txt = "absolute";
 	}
 	if (!ptr->dev->evbit[0])
@@ -311,7 +311,7 @@ static int hil_ptr_connect(struct serio 
 
 	ptr->nbtn = HIL_IDD_NUM_BUTTONS(idd);
 	if (ptr->nbtn)
-		ptr->dev->evbit[0] |= BIT(EV_KEY);
+		ptr->dev->evbit[0] |= BIT_MASK(EV_KEY);
 
 	naxsets = HIL_IDD_NUM_AXSETS(*idd);
 	ptr->naxes = HIL_IDD_NUM_AXES_PER_SET(*idd);
diff -puN drivers/input/mouse/inport.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/inport.c
--- a/drivers/input/mouse/inport.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/inport.c
@@ -163,9 +163,10 @@ static int __init inport_init(void)
 	inport_dev->id.product = 0x0001;
 	inport_dev->id.version = 0x0100;
 
-	inport_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	inport_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-	inport_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	inport_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	inport_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	inport_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	inport_dev->open  = inport_open;
 	inport_dev->close = inport_close;
diff -puN drivers/input/mouse/lifebook.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/lifebook.c
--- a/drivers/input/mouse/lifebook.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/lifebook.c
@@ -270,9 +270,10 @@ static int lifebook_create_relative_devi
 	dev2->id.version = 0x0000;
 	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
 
-	dev2->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	dev2->relbit[LONG(REL_X)] = BIT(REL_X) | BIT(REL_Y);
-	dev2->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT);
+	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	dev2->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT);
 
 	error = input_register_device(priv->dev2);
 	if (error)
@@ -295,9 +296,9 @@ int lifebook_init(struct psmouse *psmous
 	if (lifebook_absolute_mode(psmouse))
 		return -1;
 
-	dev1->evbit[0] = BIT(EV_ABS) | BIT(EV_KEY);
+	dev1->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
 	dev1->relbit[0] = 0;
-	dev1->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	dev1->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(dev1, ABS_X, 0, max_coord, 0, 0);
 	input_set_abs_params(dev1, ABS_Y, 0, max_coord, 0, 0);
 
diff -puN drivers/input/mouse/logibm.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/logibm.c
--- a/drivers/input/mouse/logibm.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/logibm.c
@@ -156,9 +156,10 @@ static int __init logibm_init(void)
 	logibm_dev->id.product = 0x0001;
 	logibm_dev->id.version = 0x0100;
 
-	logibm_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	logibm_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-	logibm_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	logibm_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	logibm_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	logibm_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	logibm_dev->open  = logibm_open;
 	logibm_dev->close = logibm_close;
diff -puN drivers/input/mouse/pc110pad.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/pc110pad.c
--- a/drivers/input/mouse/pc110pad.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/pc110pad.c
@@ -144,9 +144,9 @@ static int __init pc110pad_init(void)
 	pc110pad_dev->id.product = 0x0001;
 	pc110pad_dev->id.version = 0x0100;
 
-	pc110pad_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	pc110pad_dev->absbit[0] = BIT(ABS_X) | BIT(ABS_Y);
-	pc110pad_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	pc110pad_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	pc110pad_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
+	pc110pad_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	pc110pad_dev->absmax[ABS_X] = 0x1ff;
 	pc110pad_dev->absmax[ABS_Y] = 0x0ff;
diff -puN drivers/input/mouse/psmouse-base.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/psmouse-base.c
@@ -1115,9 +1115,10 @@ static int psmouse_switch_protocol(struc
 
 	input_dev->dev.parent = &psmouse->ps2dev.serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	input_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-	input_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	psmouse->set_rate = psmouse_set_rate;
 	psmouse->set_resolution = psmouse_set_resolution;
diff -puN drivers/input/mouse/rpcmouse.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/rpcmouse.c
--- a/drivers/input/mouse/rpcmouse.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/rpcmouse.c
@@ -78,9 +78,10 @@ static int __init rpcmouse_init(void)
 	rpcmouse_dev->id.product = 0x0001;
 	rpcmouse_dev->id.version = 0x0100;
 
-	rpcmouse_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	rpcmouse_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-	rpcmouse_dev->relbit[0]	= BIT(REL_X) | BIT(REL_Y);
+	rpcmouse_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	rpcmouse_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	rpcmouse_dev->relbit[0]	= BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	rpcmouse_lastx = (short) iomd_readl(IOMD_MOUSEX);
 	rpcmouse_lasty = (short) iomd_readl(IOMD_MOUSEY);
diff -puN drivers/input/mouse/sermouse.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/sermouse.c
--- a/drivers/input/mouse/sermouse.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/sermouse.c
@@ -268,9 +268,10 @@ static int sermouse_connect(struct serio
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	input_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT);
-	input_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT);
+	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	if (c & 0x01) set_bit(BTN_MIDDLE, input_dev->keybit);
 	if (c & 0x02) set_bit(BTN_SIDE, input_dev->keybit);
diff -puN drivers/input/mouse/touchkit_ps2.c~get-rid-of-input-bit-duplicate-defines drivers/input/mouse/touchkit_ps2.c
--- a/drivers/input/mouse/touchkit_ps2.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mouse/touchkit_ps2.c
@@ -85,7 +85,7 @@ int touchkit_ps2_detect(struct psmouse *
 		return -ENODEV;
 
 	if (set_properties) {
-		dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+		dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 		set_bit(BTN_TOUCH, dev->keybit);
 		input_set_abs_params(dev, ABS_X, 0, TOUCHKIT_MAX_XC, 0, 0);
 		input_set_abs_params(dev, ABS_Y, 0, TOUCHKIT_MAX_YC, 0, 0);
diff -puN drivers/input/mousedev.c~get-rid-of-input-bit-duplicate-defines drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/mousedev.c
@@ -998,34 +998,36 @@ static const struct input_device_id mous
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_KEYBIT |
 				INPUT_DEVICE_ID_MATCH_RELBIT,
-		.evbit = { BIT(EV_KEY) | BIT(EV_REL) },
-		.keybit = { [LONG(BTN_LEFT)] = BIT(BTN_LEFT) },
-		.relbit = { BIT(REL_X) | BIT(REL_Y) },
+		.evbit = { BIT_MASK(EV_KEY) | BIT_MASK(EV_REL) },
+		.keybit = { [BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) },
+		.relbit = { BIT_MASK(REL_X) | BIT_MASK(REL_Y) },
 	},	/* A mouse like device, at least one button,
 		   two relative axes */
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_RELBIT,
-		.evbit = { BIT(EV_KEY) | BIT(EV_REL) },
-		.relbit = { BIT(REL_WHEEL) },
+		.evbit = { BIT_MASK(EV_KEY) | BIT_MASK(EV_REL) },
+		.relbit = { BIT_MASK(REL_WHEEL) },
 	},	/* A separate scrollwheel */
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_KEYBIT |
 				INPUT_DEVICE_ID_MATCH_ABSBIT,
-		.evbit = { BIT(EV_KEY) | BIT(EV_ABS) },
-		.keybit = { [LONG(BTN_TOUCH)] = BIT(BTN_TOUCH) },
-		.absbit = { BIT(ABS_X) | BIT(ABS_Y) },
+		.evbit = { BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) },
+		.keybit = { [BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH) },
+		.absbit = { BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) },
 	},	/* A tablet like device, at least touch detection,
 		   two absolute axes */
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT |
 				INPUT_DEVICE_ID_MATCH_KEYBIT |
 				INPUT_DEVICE_ID_MATCH_ABSBIT,
-		.evbit = { BIT(EV_KEY) | BIT(EV_ABS) },
-		.keybit = { [LONG(BTN_TOOL_FINGER)] = BIT(BTN_TOOL_FINGER) },
-		.absbit = { BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_PRESSURE) |
-				BIT(ABS_TOOL_WIDTH) },
+		.evbit = { BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) },
+		.keybit = { [BIT_WORD(BTN_TOOL_FINGER)] =
+				BIT_MASK(BTN_TOOL_FINGER) },
+		.absbit = { BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) |
+				BIT_MASK(ABS_PRESSURE) |
+				BIT_MASK(ABS_TOOL_WIDTH) },
 	},	/* A touchpad */
 
 	{ },	/* Terminating entry */
diff -puN drivers/input/serio/maceps2.c~get-rid-of-input-bit-duplicate-defines drivers/input/serio/maceps2.c
--- a/drivers/input/serio/maceps2.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/serio/maceps2.c
@@ -31,6 +31,8 @@ MODULE_LICENSE("GPL");
 
 #define MACE_PS2_TIMEOUT 10000 /* in 50us unit */
 
+#define BIT(x) (1UL << (x))
+
 #define PS2_STATUS_CLOCK_SIGNAL  BIT(0) /* external clock signal */
 #define PS2_STATUS_CLOCK_INHIBIT BIT(1) /* clken output signal */
 #define PS2_STATUS_TX_INPROGRESS BIT(2) /* transmission in progress */
diff -puN drivers/input/tablet/acecad.c~get-rid-of-input-bit-duplicate-defines drivers/input/tablet/acecad.c
--- a/drivers/input/tablet/acecad.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/tablet/acecad.c
@@ -192,10 +192,14 @@ static int usb_acecad_probe(struct usb_i
 	input_dev->open = usb_acecad_open;
 	input_dev->close = usb_acecad_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->absbit[0] = BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_PRESSURE);
-	input_dev->keybit[LONG(BTN_LEFT)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
-	input_dev->keybit[LONG(BTN_DIGI)] = BIT(BTN_TOOL_PEN) |BIT(BTN_TOUCH) | BIT(BTN_STYLUS) | BIT(BTN_STYLUS2);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) |
+		BIT_MASK(ABS_PRESSURE);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] = BIT_MASK(BTN_TOOL_PEN) |
+		BIT_MASK(BTN_TOUCH) | BIT_MASK(BTN_STYLUS) |
+		BIT_MASK(BTN_STYLUS2);
 
 	switch (id->driver_info) {
 		case 0:
diff -puN drivers/input/tablet/gtco.c~get-rid-of-input-bit-duplicate-defines drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/tablet/gtco.c
@@ -573,10 +573,12 @@ static void gtco_setup_caps(struct input
 	struct gtco *device = input_get_drvdata(inputdev);
 
 	/* Which events */
-	inputdev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_MSC);
+	inputdev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) |
+		BIT_MASK(EV_MSC);
 
 	/* Misc event menu block */
-	inputdev->mscbit[0] = BIT(MSC_SCAN)|BIT(MSC_SERIAL)|BIT(MSC_RAW) ;
+	inputdev->mscbit[0] = BIT_MASK(MSC_SCAN) | BIT_MASK(MSC_SERIAL) |
+		BIT_MASK(MSC_RAW);
 
 	/* Absolute values based on HID report info */
 	input_set_abs_params(inputdev, ABS_X, device->min_X, device->max_X,
diff -puN drivers/input/tablet/kbtab.c~get-rid-of-input-bit-duplicate-defines drivers/input/tablet/kbtab.c
--- a/drivers/input/tablet/kbtab.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/tablet/kbtab.c
@@ -153,10 +153,13 @@ static int kbtab_probe(struct usb_interf
 	input_dev->open = kbtab_open;
 	input_dev->close = kbtab_close;
 
-	input_dev->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_MSC);
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_PEN) | BIT(BTN_TOUCH);
-	input_dev->mscbit[0] |= BIT(MSC_SERIAL);
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) |
+		BIT_MASK(EV_MSC);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_PEN) |
+		BIT_MASK(BTN_TOUCH);
+	input_dev->mscbit[0] |= BIT_MASK(MSC_SERIAL);
 	input_set_abs_params(input_dev, ABS_X, 0, 0x2000, 4, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, 0x1750, 4, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 0xff, 0, 0);
diff -puN drivers/input/tablet/wacom_sys.c~get-rid-of-input-bit-duplicate-defines drivers/input/tablet/wacom_sys.c
--- a/drivers/input/tablet/wacom_sys.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/tablet/wacom_sys.c
@@ -140,48 +140,58 @@ static void wacom_close(struct input_dev
 
 void input_dev_mo(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_1) | BIT(BTN_5);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_1) |
+		BIT_MASK(BTN_5);
 	input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
 }
 
 void input_dev_g4(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->evbit[0] |= BIT(EV_MSC);
-	input_dev->mscbit[0] |= BIT(MSC_SERIAL);
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_FINGER);
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_0) | BIT(BTN_4);
+	input_dev->evbit[0] |= BIT_MASK(EV_MSC);
+	input_dev->mscbit[0] |= BIT_MASK(MSC_SERIAL);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_FINGER);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_0) |
+		BIT_MASK(BTN_4);
 }
 
 void input_dev_g(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->evbit[0] |= BIT(EV_REL);
-	input_dev->relbit[0] |= BIT(REL_WHEEL);
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_RUBBER) | BIT(BTN_TOOL_MOUSE) | BIT(BTN_STYLUS2);
+	input_dev->evbit[0] |= BIT_MASK(EV_REL);
+	input_dev->relbit[0] |= BIT_MASK(REL_WHEEL);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_RUBBER) |
+		BIT_MASK(BTN_TOOL_MOUSE) | BIT_MASK(BTN_STYLUS2);
 	input_set_abs_params(input_dev, ABS_DISTANCE, 0, wacom_wac->features->distance_max, 0, 0);
 }
 
 void input_dev_i3s(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_FINGER);
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_0) | BIT(BTN_1) | BIT(BTN_2) | BIT(BTN_3);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_FINGER);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_0) |
+		BIT_MASK(BTN_1) | BIT_MASK(BTN_2) | BIT_MASK(BTN_3);
 	input_set_abs_params(input_dev, ABS_RX, 0, 4096, 0, 0);
 }
 
 void input_dev_i3(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_4) | BIT(BTN_5) | BIT(BTN_6) | BIT(BTN_7);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_4) |
+		BIT_MASK(BTN_5) | BIT_MASK(BTN_6) | BIT_MASK(BTN_7);
 	input_set_abs_params(input_dev, ABS_RY, 0, 4096, 0, 0);
 }
 
 void input_dev_i(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->evbit[0] |= BIT(EV_MSC) | BIT(EV_REL);
-	input_dev->mscbit[0] |= BIT(MSC_SERIAL);
-	input_dev->relbit[0] |= BIT(REL_WHEEL);
-	input_dev->keybit[LONG(BTN_LEFT)] |= BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE) | BIT(BTN_SIDE) | BIT(BTN_EXTRA);
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_RUBBER) | BIT(BTN_TOOL_MOUSE)	| BIT(BTN_TOOL_BRUSH)
-		| BIT(BTN_TOOL_PENCIL) | BIT(BTN_TOOL_AIRBRUSH) | BIT(BTN_TOOL_LENS) | BIT(BTN_STYLUS2);
+	input_dev->evbit[0] |= BIT_MASK(EV_MSC) | BIT_MASK(EV_REL);
+	input_dev->mscbit[0] |= BIT_MASK(MSC_SERIAL);
+	input_dev->relbit[0] |= BIT_MASK(REL_WHEEL);
+	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE) |
+		BIT_MASK(BTN_SIDE) | BIT_MASK(BTN_EXTRA);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_RUBBER) |
+		BIT_MASK(BTN_TOOL_MOUSE) | BIT_MASK(BTN_TOOL_BRUSH) |
+		BIT_MASK(BTN_TOOL_PENCIL) | BIT_MASK(BTN_TOOL_AIRBRUSH) |
+		BIT_MASK(BTN_TOOL_LENS) | BIT_MASK(BTN_STYLUS2);
 	input_set_abs_params(input_dev, ABS_DISTANCE, 0, wacom_wac->features->distance_max, 0, 0);
 	input_set_abs_params(input_dev, ABS_WHEEL, 0, 1023, 0, 0);
 	input_set_abs_params(input_dev, ABS_TILT_X, 0, 127, 0, 0);
@@ -192,12 +202,13 @@ void input_dev_i(struct input_dev *input
 
 void input_dev_pl(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_STYLUS2) | BIT(BTN_TOOL_RUBBER);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_STYLUS2) |
+		BIT_MASK(BTN_TOOL_RUBBER);
 }
 
 void input_dev_pt(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
 {
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_RUBBER);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_RUBBER);
 }
 
 static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *id)
@@ -243,12 +254,13 @@ static int wacom_probe(struct usb_interf
 	input_dev->open = wacom_open;
 	input_dev->close = wacom_close;
 
-	input_dev->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_DIGI)] |= BIT(BTN_TOOL_PEN) | BIT(BTN_TOUCH) | BIT(BTN_STYLUS);
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_PEN) |
+		BIT_MASK(BTN_TOUCH) | BIT_MASK(BTN_STYLUS);
 	input_set_abs_params(input_dev, ABS_X, 0, wacom_wac->features->x_max, 4, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, wacom_wac->features->y_max, 4, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, wacom_wac->features->pressure_max, 0, 0);
-	input_dev->absbit[LONG(ABS_MISC)] |= BIT(ABS_MISC);
+	input_dev->absbit[BIT_WORD(ABS_MISC)] |= BIT_MASK(ABS_MISC);
 
 	wacom_init_input_dev(input_dev, wacom_wac);
 
diff -puN drivers/input/touchscreen/ads7846.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/ads7846.c
@@ -917,8 +917,8 @@ static int __devinit ads7846_probe(struc
 	input_dev->phys = ts->phys;
 	input_dev->dev.parent = &spi->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(input_dev, ABS_X,
 			pdata->x_min ? : 0,
 			pdata->x_max ? : MAX_12BIT,
diff -puN drivers/input/touchscreen/corgi_ts.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/corgi_ts.c
--- a/drivers/input/touchscreen/corgi_ts.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/corgi_ts.c
@@ -302,8 +302,8 @@ static int __init corgits_probe(struct p
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN, PRESSURE_MAX, 0, 0);
diff -puN drivers/input/touchscreen/elo.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/elo.c
--- a/drivers/input/touchscreen/elo.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/elo.c
@@ -320,8 +320,8 @@ static int elo_connect(struct serio *ser
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	serio_set_drvdata(serio, elo);
 	err = serio_open(serio, drv);
diff -puN drivers/input/touchscreen/fujitsu_ts.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/fujitsu_ts.c
--- a/drivers/input/touchscreen/fujitsu_ts.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/fujitsu_ts.c
@@ -122,8 +122,8 @@ static int fujitsu_connect(struct serio 
 	input_dev->id.vendor = SERIO_FUJITSU;
 	input_dev->id.product = 0;
 	input_dev->id.version = 0x0100;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	input_set_abs_params(input_dev, ABS_X, 0, 4096, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, 4096, 0, 0);
diff -puN drivers/input/touchscreen/gunze.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/gunze.c
--- a/drivers/input/touchscreen/gunze.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/gunze.c
@@ -137,8 +137,8 @@ static int gunze_connect(struct serio *s
 	input_dev->id.product = 0x0051;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(input_dev, ABS_X, 24, 1000, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 24, 1000, 0, 0);
 
diff -puN drivers/input/touchscreen/h3600_ts_input.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/h3600_ts_input.c
--- a/drivers/input/touchscreen/h3600_ts_input.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/h3600_ts_input.c
@@ -373,8 +373,9 @@ static int h3600ts_connect(struct serio 
 
 	input_dev->event = h3600ts_event;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_LED) | BIT(EV_PWR);
-	input_dev->ledbit[0] = BIT(LED_SLEEP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) |
+		BIT_MASK(EV_LED) | BIT_MASK(EV_PWR);
+	input_dev->ledbit[0] = BIT_MASK(LED_SLEEP);
 	input_set_abs_params(input_dev, ABS_X, 60, 985, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 35, 1024, 0, 0);
 
diff -puN drivers/input/touchscreen/hp680_ts_input.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/hp680_ts_input.c
--- a/drivers/input/touchscreen/hp680_ts_input.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/hp680_ts_input.c
@@ -81,8 +81,8 @@ static int __init hp680_ts_init(void)
 	if (!hp680_ts_dev)
 		return -ENOMEM;
 
-	hp680_ts_dev->evbit[0] = BIT(EV_ABS) | BIT(EV_KEY);
-	hp680_ts_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	hp680_ts_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	hp680_ts_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	input_set_abs_params(hp680_ts_dev, ABS_X,
 		HP680_TS_ABS_X_MIN, HP680_TS_ABS_X_MAX, 0, 0);
diff -puN drivers/input/touchscreen/mk712.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/mk712.c
--- a/drivers/input/touchscreen/mk712.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/mk712.c
@@ -186,8 +186,8 @@ static int __init mk712_init(void)
 	mk712_dev->open    = mk712_open;
 	mk712_dev->close   = mk712_close;
 
-	mk712_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	mk712_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	mk712_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	mk712_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(mk712_dev, ABS_X, 0, 0xfff, 88, 0);
 	input_set_abs_params(mk712_dev, ABS_Y, 0, 0xfff, 88, 0);
 
diff -puN drivers/input/touchscreen/mtouch.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/mtouch.c
--- a/drivers/input/touchscreen/mtouch.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/mtouch.c
@@ -151,8 +151,8 @@ static int mtouch_connect(struct serio *
 	input_dev->id.product = 0;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(mtouch->dev, ABS_X, MTOUCH_MIN_XC, MTOUCH_MAX_XC, 0, 0);
 	input_set_abs_params(mtouch->dev, ABS_Y, MTOUCH_MIN_YC, MTOUCH_MAX_YC, 0, 0);
 
diff -puN drivers/input/touchscreen/penmount.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/penmount.c
--- a/drivers/input/touchscreen/penmount.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/penmount.c
@@ -113,8 +113,8 @@ static int pm_connect(struct serio *seri
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-        input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-        input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+        input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+        input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
         input_set_abs_params(pm->dev, ABS_X, 0, 0x3ff, 0, 0);
         input_set_abs_params(pm->dev, ABS_Y, 0, 0x3ff, 0, 0);
 
diff -puN drivers/input/touchscreen/touchright.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/touchright.c
--- a/drivers/input/touchscreen/touchright.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/touchright.c
@@ -125,8 +125,8 @@ static int tr_connect(struct serio *seri
 	input_dev->id.product = 0;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(tr->dev, ABS_X, TR_MIN_XC, TR_MAX_XC, 0, 0);
 	input_set_abs_params(tr->dev, ABS_Y, TR_MIN_YC, TR_MAX_YC, 0, 0);
 
diff -puN drivers/input/touchscreen/touchwin.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/touchwin.c
--- a/drivers/input/touchscreen/touchwin.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/touchwin.c
@@ -132,8 +132,8 @@ static int tw_connect(struct serio *seri
 	input_dev->id.product = 0;
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(tw->dev, ABS_X, TW_MIN_XC, TW_MAX_XC, 0, 0);
 	input_set_abs_params(tw->dev, ABS_Y, TW_MIN_YC, TW_MAX_YC, 0, 0);
 
diff -puN drivers/input/touchscreen/ucb1400_ts.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -517,7 +517,7 @@ static int ucb1400_ts_probe(struct devic
 	idev->id.product	= id;
 	idev->open		= ucb1400_ts_open;
 	idev->close		= ucb1400_ts_close;
-	idev->evbit[0]		= BIT(EV_ABS);
+	idev->evbit[0]		= BIT_MASK(EV_ABS);
 
 	ucb1400_adc_enable(ucb);
 	x_res = ucb1400_ts_read_xres(ucb);
diff -puN drivers/input/touchscreen/usbtouchscreen.c~get-rid-of-input-bit-duplicate-defines drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -868,8 +868,8 @@ static int usbtouch_probe(struct usb_int
 	input_dev->open = usbtouch_open;
 	input_dev->close = usbtouch_close;
 
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(input_dev, ABS_X, type->min_xc, type->max_xc, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, type->min_yc, type->max_yc, 0, 0);
 	if (type->max_press)
diff -puN drivers/macintosh/adbhid.c~get-rid-of-input-bit-duplicate-defines drivers/macintosh/adbhid.c
--- a/drivers/macintosh/adbhid.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/macintosh/adbhid.c
@@ -791,8 +791,10 @@ adbhid_input_register(int id, int defaul
 			if (hid->keycode[i])
 				set_bit(hid->keycode[i], input_dev->keybit);
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_LED) | BIT(EV_REP);
-		input_dev->ledbit[0] = BIT(LED_SCROLLL) | BIT(LED_CAPSL) | BIT(LED_NUML);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_LED) |
+			BIT_MASK(EV_REP);
+		input_dev->ledbit[0] = BIT_MASK(LED_SCROLLL) |
+			BIT_MASK(LED_CAPSL) | BIT_MASK(LED_NUML);
 		input_dev->event = adbhid_kbd_event;
 		input_dev->keycodemax = KEY_FN;
 		input_dev->keycodesize = sizeof(hid->keycode[0]);
@@ -801,16 +803,18 @@ adbhid_input_register(int id, int defaul
 	case ADB_MOUSE:
 		sprintf(hid->name, "ADB mouse");
 
-		input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-		input_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-		input_dev->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+		input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+		input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 		break;
 
 	case ADB_MISC:
 		switch (original_handler_id) {
 		case 0x02: /* Adjustable keyboard button device */
 			sprintf(hid->name, "ADB adjustable keyboard buttons");
-			input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+			input_dev->evbit[0] = BIT_MASK(EV_KEY) |
+				BIT_MASK(EV_REP);
 			set_bit(KEY_SOUND, input_dev->keybit);
 			set_bit(KEY_MUTE, input_dev->keybit);
 			set_bit(KEY_VOLUMEUP, input_dev->keybit);
@@ -818,7 +822,8 @@ adbhid_input_register(int id, int defaul
 			break;
 		case 0x1f: /* Powerbook button device */
 			sprintf(hid->name, "ADB Powerbook buttons");
-			input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+			input_dev->evbit[0] = BIT_MASK(EV_KEY) |
+				BIT_MASK(EV_REP);
 			set_bit(KEY_MUTE, input_dev->keybit);
 			set_bit(KEY_VOLUMEUP, input_dev->keybit);
 			set_bit(KEY_VOLUMEDOWN, input_dev->keybit);
diff -puN drivers/macintosh/mac_hid.c~get-rid-of-input-bit-duplicate-defines drivers/macintosh/mac_hid.c
--- a/drivers/macintosh/mac_hid.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/macintosh/mac_hid.c
@@ -117,9 +117,10 @@ static int emumousebtn_input_register(vo
 	emumousebtn->id.product = 0x0001;
 	emumousebtn->id.version = 0x0100;
 
-	emumousebtn->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	emumousebtn->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_MIDDLE) | BIT(BTN_RIGHT);
-	emumousebtn->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	emumousebtn->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	emumousebtn->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	emumousebtn->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	ret = input_register_device(emumousebtn);
 	if (ret)
diff -puN drivers/media/dvb/cinergyT2/cinergyT2.c~get-rid-of-input-bit-duplicate-defines drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -820,7 +820,7 @@ static int cinergyt2_register_rc(struct 
 
 	input_dev->name = DRIVER_NAME " remote control";
 	input_dev->phys = cinergyt2->phys;
-	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	for (i = 0; i < ARRAY_SIZE(rc_keys); i += 3)
 		set_bit(rc_keys[i + 2], input_dev->keybit);
 	input_dev->keycodesize = 0;
diff -puN drivers/media/dvb/dvb-usb/dvb-usb-remote.c~get-rid-of-input-bit-duplicate-defines drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -106,7 +106,7 @@ int dvb_usb_remote_init(struct dvb_usb_d
 	if (!input_dev)
 		return -ENOMEM;
 
-	input_dev->evbit[0] = BIT(EV_KEY);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	input_dev->name = "IR-receiver inside an USB DVB receiver";
 	input_dev->phys = d->rc_phys;
 	usb_to_input_id(d->udev, &input_dev->id);
diff -puN drivers/media/dvb/ttusb-dec/ttusb_dec.c~get-rid-of-input-bit-duplicate-defines drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1198,7 +1198,7 @@ static int ttusb_init_rc( struct ttusb_d
 
 	input_dev->name = "ttusb_dec remote control";
 	input_dev->phys = dec->rc_phys;
-	input_dev->evbit[0] = BIT(EV_KEY);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	input_dev->keycodesize = sizeof(u16);
 	input_dev->keycodemax = 0x1a;
 	input_dev->keycode = rc_keys;
diff -puN drivers/media/video/usbvideo/konicawc.c~get-rid-of-input-bit-duplicate-defines drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/media/video/usbvideo/konicawc.c
@@ -238,8 +238,8 @@ static void konicawc_register_input(stru
 	usb_to_input_id(dev, &input_dev->id);
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY);
-	input_dev->keybit[LONG(BTN_0)] = BIT(BTN_0);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
 
 	input_dev->private = cam;
 
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~get-rid-of-input-bit-duplicate-defines drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -102,8 +102,8 @@ static void qcm_register_input(struct qc
 	usb_to_input_id(dev, &input_dev->id);
 	input_dev->dev.parent = &dev->dev;
 
-	input_dev->evbit[0] = BIT(EV_KEY);
-	input_dev->keybit[LONG(BTN_0)] = BIT(BTN_0);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
 
 	input_dev->private = cam;
 
diff -puN drivers/misc/ibmasm/remote.c~get-rid-of-input-bit-duplicate-defines drivers/misc/ibmasm/remote.c
--- a/drivers/misc/ibmasm/remote.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/misc/ibmasm/remote.c
@@ -226,9 +226,9 @@ int ibmasm_init_remote_input_dev(struct 
 	mouse_dev->id.product = pdev->device;
 	mouse_dev->id.version = 1;
 	mouse_dev->dev.parent = sp->dev;
-	mouse_dev->evbit[0]  = BIT(EV_KEY) | BIT(EV_ABS);
-	mouse_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) |
-		BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
+	mouse_dev->evbit[0]  = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	mouse_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
 	set_bit(BTN_TOUCH, mouse_dev->keybit);
 	mouse_dev->name = "ibmasm RSA I remote mouse";
 	input_set_abs_params(mouse_dev, ABS_X, 0, MOUSE_X_MAX, 0, 0);
@@ -239,7 +239,7 @@ int ibmasm_init_remote_input_dev(struct 
 	keybd_dev->id.product = pdev->device;
 	keybd_dev->id.version = 2;
 	keybd_dev->dev.parent = sp->dev;
-	keybd_dev->evbit[0]  = BIT(EV_KEY);
+	keybd_dev->evbit[0]  = BIT_MASK(EV_KEY);
 	keybd_dev->name = "ibmasm RSA I remote keyboard";
 
 	for (i = 0; i < XLATE_SIZE; i++) {
diff -puN drivers/misc/sony-laptop.c~get-rid-of-input-bit-duplicate-defines drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~get-rid-of-input-bit-duplicate-defines
+++ a/drivers/misc/sony-laptop.c
@@ -411,9 +411,9 @@ static int sony_laptop_setup_input(void)
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
 
-	jog_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-	jog_dev->keybit[LONG(BTN_MOUSE)] = BIT(BTN_MIDDLE);
-	jog_dev->relbit[0] = BIT(REL_WHEEL);
+	jog_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	jog_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_MIDDLE);
+	jog_dev->relbit[0] = BIT_MASK(REL_WHEEL);
 
 	error = input_register_device(jog_dev);
 	if (error)
diff -puN include/linux/hid.h~get-rid-of-input-bit-duplicate-defines include/linux/hid.h
--- a/include/linux/hid.h~get-rid-of-input-bit-duplicate-defines
+++ a/include/linux/hid.h
@@ -469,8 +469,8 @@ struct hid_device {							/* device repo
 	/* handler for raw output data, used by hidraw */
 	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t);
 #ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-	unsigned long pb_pressed_fn[NBITS(KEY_MAX)];
-	unsigned long pb_pressed_numlock[NBITS(KEY_MAX)];
+	unsigned long pb_pressed_fn[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long pb_pressed_numlock[BITS_TO_LONGS(KEY_CNT)];
 #endif
 };
 
diff -puN include/linux/input.h~get-rid-of-input-bit-duplicate-defines include/linux/input.h
--- a/include/linux/input.h~get-rid-of-input-bit-duplicate-defines
+++ a/include/linux/input.h
@@ -98,6 +98,7 @@ struct input_absinfo {
 #define EV_PWR			0x16
 #define EV_FF_STATUS		0x17
 #define EV_MAX			0x1f
+#define EV_CNT			(EV_MAX+1)
 
 /*
  * Synchronization events.
@@ -567,6 +568,7 @@ struct input_absinfo {
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
 #define KEY_MAX			0x1ff
+#define KEY_CNT			(KEY_MAX+1)
 
 /*
  * Relative axes
@@ -583,6 +585,7 @@ struct input_absinfo {
 #define REL_WHEEL		0x08
 #define REL_MISC		0x09
 #define REL_MAX			0x0f
+#define REL_CNT			(REL_MAX+1)
 
 /*
  * Absolute axes
@@ -615,6 +618,7 @@ struct input_absinfo {
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
 #define ABS_MAX			0x3f
+#define ABS_CNT			(ABS_MAX+1)
 
 /*
  * Switch events
@@ -625,6 +629,7 @@ struct input_absinfo {
 #define SW_HEADPHONE_INSERT	0x02  /* set = inserted */
 #define SW_RADIO		0x03  /* set = radio enabled */
 #define SW_MAX			0x0f
+#define SW_CNT			(SW_MAX+1)
 
 /*
  * Misc events
@@ -636,6 +641,7 @@ struct input_absinfo {
 #define MSC_RAW			0x03
 #define MSC_SCAN		0x04
 #define MSC_MAX			0x07
+#define MSC_CNT			(MSC_MAX+1)
 
 /*
  * LEDs
@@ -653,6 +659,7 @@ struct input_absinfo {
 #define LED_MAIL		0x09
 #define LED_CHARGING		0x0a
 #define LED_MAX			0x0f
+#define LED_CNT			(LED_MAX+1)
 
 /*
  * Autorepeat values
@@ -670,6 +677,7 @@ struct input_absinfo {
 #define SND_BELL		0x01
 #define SND_TONE		0x02
 #define SND_MAX			0x07
+#define SND_CNT			(SND_MAX+1)
 
 /*
  * IDs.
@@ -920,6 +928,7 @@ struct ff_effect {
 #define FF_AUTOCENTER	0x61
 
 #define FF_MAX		0x7f
+#define FF_CNT		(FF_MAX+1)
 
 #ifdef __KERNEL__
 
@@ -932,10 +941,6 @@ struct ff_effect {
 #include <linux/timer.h>
 #include <linux/mod_devicetable.h>
 
-#define NBITS(x) (((x)/BITS_PER_LONG)+1)
-#define BIT(x)	(1UL<<((x)%BITS_PER_LONG))
-#define LONG(x) ((x)/BITS_PER_LONG)
-
 /**
  * struct input_dev - represents an input device
  * @name: name of the device
@@ -1020,15 +1025,15 @@ struct input_dev {
 	const char *uniq;
 	struct input_id id;
 
-	unsigned long evbit[NBITS(EV_MAX)];
-	unsigned long keybit[NBITS(KEY_MAX)];
-	unsigned long relbit[NBITS(REL_MAX)];
-	unsigned long absbit[NBITS(ABS_MAX)];
-	unsigned long mscbit[NBITS(MSC_MAX)];
-	unsigned long ledbit[NBITS(LED_MAX)];
-	unsigned long sndbit[NBITS(SND_MAX)];
-	unsigned long ffbit[NBITS(FF_MAX)];
-	unsigned long swbit[NBITS(SW_MAX)];
+	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
+	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
+	unsigned long absbit[BITS_TO_LONGS(ABS_CNT)];
+	unsigned long mscbit[BITS_TO_LONGS(MSC_CNT)];
+	unsigned long ledbit[BITS_TO_LONGS(LED_CNT)];
+	unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
+	unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
+	unsigned long swbit[BITS_TO_LONGS(SW_CNT)];
 
 	unsigned int keycodemax;
 	unsigned int keycodesize;
@@ -1046,10 +1051,10 @@ struct input_dev {
 	int abs[ABS_MAX + 1];
 	int rep[REP_MAX + 1];
 
-	unsigned long key[NBITS(KEY_MAX)];
-	unsigned long led[NBITS(LED_MAX)];
-	unsigned long snd[NBITS(SND_MAX)];
-	unsigned long sw[NBITS(SW_MAX)];
+	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
+	unsigned long led[BITS_TO_LONGS(LED_CNT)];
+	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
+	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
 	int absmax[ABS_MAX + 1];
 	int absmin[ABS_MAX + 1];
@@ -1293,7 +1298,7 @@ static inline void input_set_abs_params(
 	dev->absfuzz[axis] = fuzz;
 	dev->absflat[axis] = flat;
 
-	dev->absbit[LONG(axis)] |= BIT(axis);
+	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
 }
 
 extern struct class input_class;
@@ -1334,7 +1339,7 @@ struct ff_device {
 
 	void *private;
 
-	unsigned long ffbit[NBITS(FF_MAX)];
+	unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
 
 	struct mutex mutex;
 
diff -puN include/linux/uinput.h~get-rid-of-input-bit-duplicate-defines include/linux/uinput.h
--- a/include/linux/uinput.h~get-rid-of-input-bit-duplicate-defines
+++ a/include/linux/uinput.h
@@ -162,10 +162,6 @@ struct uinput_ff_erase {
 #define UI_FF_UPLOAD		1
 #define UI_FF_ERASE		2
 
-#ifndef NBITS
-#define NBITS(x) ((((x)-1)/(sizeof(long)*8))+1)
-#endif	/* NBITS */
-
 #define UINPUT_MAX_NAME_SIZE	80
 struct uinput_user_dev {
 	char name[UINPUT_MAX_NAME_SIZE];
diff -puN net/bluetooth/hidp/core.c~get-rid-of-input-bit-duplicate-defines net/bluetooth/hidp/core.c
--- a/net/bluetooth/hidp/core.c~get-rid-of-input-bit-duplicate-defines
+++ a/net/bluetooth/hidp/core.c
@@ -656,11 +656,13 @@ static inline int hidp_setup_input(struc
 	}
 
 	if (req->subclass & 0x80) {
-		input->evbit[0] = BIT(EV_KEY) | BIT(EV_REL);
-		input->keybit[LONG(BTN_MOUSE)] = BIT(BTN_LEFT) | BIT(BTN_RIGHT) | BIT(BTN_MIDDLE);
-		input->relbit[0] = BIT(REL_X) | BIT(REL_Y);
-		input->keybit[LONG(BTN_MOUSE)] |= BIT(BTN_SIDE) | BIT(BTN_EXTRA);
-		input->relbit[0] |= BIT(REL_WHEEL);
+		input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+		input->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+			BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+		input->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+		input->keybit[BIT_WORD(BTN_MOUSE)] |= BIT_MASK(BTN_SIDE) |
+			BIT_MASK(BTN_EXTRA);
+		input->relbit[0] |= BIT_MASK(REL_WHEEL);
 	}
 
 	input->dev.parent = hidp_get_device(session);
diff -puN net/rfkill/rfkill-input.c~get-rid-of-input-bit-duplicate-defines net/rfkill/rfkill-input.c
--- a/net/rfkill/rfkill-input.c~get-rid-of-input-bit-duplicate-defines
+++ a/net/rfkill/rfkill-input.c
@@ -146,18 +146,18 @@ static void rfkill_disconnect(struct inp
 static const struct input_device_id rfkill_ids[] = {
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_WLAN)] = BIT(KEY_WLAN) },
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_WLAN)] = BIT_MASK(KEY_WLAN) },
 	},
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_BLUETOOTH)] = BIT(KEY_BLUETOOTH) },
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_BLUETOOTH)] = BIT_MASK(KEY_BLUETOOTH) },
 	},
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_UWB)] = BIT(KEY_UWB) },
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
 	},
 	{ }
 };
diff -puN sound/ppc/beep.c~get-rid-of-input-bit-duplicate-defines sound/ppc/beep.c
--- a/sound/ppc/beep.c~get-rid-of-input-bit-duplicate-defines
+++ a/sound/ppc/beep.c
@@ -236,8 +236,8 @@ int __init snd_pmac_attach_beep(struct s
 	input_dev->id.product = 0x0001;
 	input_dev->id.version = 0x0100;
 
-	input_dev->evbit[0] = BIT(EV_SND);
-	input_dev->sndbit[0] = BIT(SND_BELL) | BIT(SND_TONE);
+	input_dev->evbit[0] = BIT_MASK(EV_SND);
+	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
 	input_dev->event = snd_pmac_beep_event;
 	input_dev->dev.parent = &chip->pdev->dev;
 	input_set_drvdata(input_dev, chip);
diff -puN sound/usb/caiaq/caiaq-input.c~get-rid-of-input-bit-duplicate-defines sound/usb/caiaq/caiaq-input.c
--- a/sound/usb/caiaq/caiaq-input.c~get-rid-of-input-bit-duplicate-defines
+++ a/sound/usb/caiaq/caiaq-input.c
@@ -200,8 +200,9 @@ int snd_usb_caiaq_input_init(struct snd_
 
         switch (dev->chip.usb_id) {
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_RIGKONTROL2):
-		input->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-		input->absbit[0] = BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_Z);
+		input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+		input->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) |
+			BIT_MASK(ABS_Z);
 		input->keycode = keycode_rk2;
 		input->keycodesize = sizeof(char);
 		input->keycodemax = ARRAY_SIZE(keycode_rk2);
@@ -228,8 +229,8 @@ int snd_usb_caiaq_input_init(struct snd_
 		snd_usb_caiaq_set_auto_msg(dev, 1, 10, 0);
 		break;
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_AK1):
-		input->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
-		input->absbit[0] = BIT(ABS_X);
+		input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+		input->absbit[0] = BIT_MASK(ABS_X);
 		input->keycode = keycode_ak1;
 		input->keycodesize = sizeof(char);
 		input->keycodemax = ARRAY_SIZE(keycode_ak1);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
