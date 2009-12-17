From: akpm@linux-foundation.org
Subject: + hid-logitech-g13-driver-002.patch added to -mm tree
Date: Wed, 16 Dec 2009 16:24:47 -0800
Message-ID: <200912170024.nBH0OlUE024514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762859AbZLQAZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 19:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rvinyard@cs.nmsu.edu, dtor@mail.ru, jkosina@suse.cz, oliver@neukum.org


The patch titled
     hid: Logitech G13 driver 0.0.2
has been added to the -mm tree.  Its filename is
     hid-logitech-g13-driver-002.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: Logitech G13 driver 0.0.2
From: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>

This is a driver for the Logitech G13 gamepad, and contains three key
parts.  In the USB reports the device identifies itself as a HID, and as a
result this driver is under the HID framework.

There are two primary sub-components to this driver; an input device and a
framebuffer device.

Although identified as a HID, the device does not support standard HID
input messages.  As a result, a sub-input device is allocated and
registered separately in g13_probe().  The raw events are monitored and
key presses/joystick activity is reported through the input device after
referencing an indexed keymap.

Additionally, this device contains a 160x43 monochrome LCD display.  A
registered framebuffer device manages this display.  The design of this
portion of the driver was based on the design of the hecubafb driver with
deferred framebuffer I/O since there is no real memory to map.

Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/Kconfig          |   14 
 drivers/hid/Makefile         |    3 
 drivers/hid/hid-core.c       |    1 
 drivers/hid/hid-g13-logo.xbm |   75 +
 drivers/hid/hid-g13.c        | 1526 +++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h        |    1 
 6 files changed, 1620 insertions(+)

diff -puN drivers/hid/Kconfig~hid-logitech-g13-driver-002 drivers/hid/Kconfig
--- a/drivers/hid/Kconfig~hid-logitech-g13-driver-002
+++ a/drivers/hid/Kconfig
@@ -183,6 +183,20 @@ config LOGIRUMBLEPAD2_FF
 	  Say Y here if you want to enable force feedback support for Logitech
 	  Rumblepad 2 devices.
 
+config LOGITECH_G13
+	tristate "Logitech G13 gameboard support"
+	depends on HID_LOGITECH
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  This provides support for Logitech G13 gameboard
+	  devices. This includes support for the device
+	  as a keypad input with mappable keys as well as
+	  a framebuffer for the LCD display.
+
 config HID_MICROSOFT
 	tristate "Microsoft" if EMBEDDED
 	depends on USB_HID
diff -puN drivers/hid/Makefile~hid-logitech-g13-driver-002 drivers/hid/Makefile
--- a/drivers/hid/Makefile~hid-logitech-g13-driver-002
+++ a/drivers/hid/Makefile
@@ -18,6 +18,9 @@ endif
 ifdef CONFIG_LOGIRUMBLEPAD2_FF
 	hid-logitech-objs	+= hid-lg2ff.o
 endif
+ifdef CONFIG_LOGITECH_G13
+	hid-logitech-objs	+= hid-g13.o
+endif
 
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
diff -puN drivers/hid/hid-core.c~hid-logitech-g13-driver-002 drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-logitech-g13-driver-002
+++ a/drivers/hid/hid-core.c
@@ -1325,6 +1325,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
diff -puN /dev/null drivers/hid/hid-g13-logo.xbm
--- /dev/null
+++ a/drivers/hid/hid-g13-logo.xbm
@@ -0,0 +1,75 @@
+#define g13_lcd_width 160
+#define g13_lcd_height 43
+static unsigned char g13_lcd_bits[] = {
+   0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x28, 0x03, 0x00, 0x40, 0x01, 0x00, 0xc0, 0x3f, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa1,
+   0x08, 0x00, 0x08, 0x00, 0x00, 0xe0, 0x7f, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3c, 0x25, 0x00, 0xf3, 0x03,
+   0x00, 0xe0, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x0e, 0x05, 0x00, 0x20, 0x16, 0x00, 0xf0, 0xff, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x09,
+   0x00, 0x00, 0x00, 0x42, 0x00, 0xf0, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x05, 0x60, 0x80, 0x00, 0x14,
+   0x00, 0x30, 0xe7, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x90, 0x00, 0x00, 0x20, 0x00, 0x10, 0x00, 0x10, 0xe3, 0x01,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90, 0x02,
+   0xe0, 0xdd, 0x03, 0x90, 0x00, 0x50, 0xcb, 0x01, 0x00, 0xfe, 0xff, 0x7f,
+   0xf0, 0x3f, 0x00, 0xff, 0xff, 0x7f, 0x80, 0x00, 0xfa, 0xe3, 0x07, 0x38,
+   0x00, 0x10, 0xc1, 0x01, 0x00, 0xff, 0xff, 0x7f, 0xf0, 0x3f, 0x00, 0xff,
+   0xff, 0xff, 0xd0, 0x00, 0xfc, 0x87, 0x0f, 0x90, 0x00, 0x30, 0xe0, 0x01,
+   0x80, 0xff, 0xff, 0x7f, 0xf0, 0x3f, 0x00, 0xff, 0xff, 0xff, 0x81, 0x80,
+   0xfe, 0xa7, 0x3f, 0x30, 0x00, 0x30, 0xc0, 0x01, 0xc0, 0xff, 0xff, 0x7f,
+   0xf0, 0x3f, 0x00, 0xff, 0xff, 0xff, 0x93, 0x42, 0x0f, 0x08, 0x3a, 0x30,
+   0x00, 0x10, 0xe8, 0x01, 0xc0, 0xff, 0xff, 0x7f, 0xf0, 0x3f, 0x00, 0xff,
+   0xff, 0xff, 0x93, 0xa4, 0x41, 0x20, 0x20, 0x94, 0x00, 0x30, 0xf4, 0x03,
+   0xc0, 0x07, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x93, 0x41,
+   0x60, 0x48, 0xe1, 0x98, 0x00, 0x70, 0xda, 0x07, 0xc0, 0x07, 0x00, 0x00,
+   0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x83, 0x77, 0x10, 0x82, 0xc5, 0x1f,
+   0x00, 0xd0, 0xcc, 0x07, 0xc0, 0x07, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00,
+   0x00, 0xe0, 0x23, 0x3f, 0x00, 0x90, 0xc0, 0x4f, 0x00, 0x98, 0x83, 0x0f,
+   0xc0, 0x07, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x3f,
+   0x00, 0x85, 0x86, 0x27, 0x00, 0x0c, 0x80, 0x0f, 0xc0, 0x07, 0x00, 0x00,
+   0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x3e, 0xc0, 0x83, 0x86, 0x0b,
+   0x00, 0x0c, 0x80, 0x1f, 0xc0, 0x07, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00,
+   0x00, 0xe0, 0x03, 0x11, 0x00, 0x00, 0x04, 0x0d, 0x00, 0x0e, 0x00, 0x3f,
+   0xc0, 0x07, 0xff, 0xff, 0x00, 0x3e, 0x00, 0xff, 0xff, 0xff, 0x03, 0x0c,
+   0x10, 0x00, 0x02, 0x02, 0x00, 0x0f, 0x00, 0x3f, 0xc0, 0x07, 0xff, 0xff,
+   0x00, 0x3e, 0x00, 0xff, 0xff, 0xff, 0x01, 0x00, 0x08, 0x00, 0x1c, 0x02,
+   0x00, 0x07, 0x00, 0x7e, 0xc0, 0x07, 0xff, 0xff, 0x00, 0x3e, 0x00, 0xff,
+   0xff, 0xff, 0x00, 0x00, 0x04, 0x00, 0x28, 0x04, 0x80, 0x03, 0x00, 0x7e,
+   0xc0, 0x07, 0xff, 0xff, 0x00, 0x3e, 0x00, 0xff, 0xff, 0xff, 0x01, 0x08,
+   0x02, 0x58, 0x08, 0x00, 0x80, 0x03, 0x00, 0xfc, 0xc0, 0x07, 0xff, 0xff,
+   0x00, 0x3e, 0x00, 0xff, 0xff, 0xff, 0x01, 0x00, 0x01, 0x08, 0x21, 0x00,
+   0x80, 0x03, 0x00, 0xfc, 0xc0, 0x07, 0x00, 0xf8, 0x00, 0x3e, 0x00, 0x00,
+   0x00, 0xe0, 0x03, 0xa4, 0x01, 0x28, 0x00, 0x00, 0xc0, 0x01, 0x00, 0xfc,
+   0xc0, 0x07, 0x00, 0xf8, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x2e,
+   0x02, 0x00, 0x00, 0x00, 0xc0, 0x01, 0x00, 0xfc, 0xc1, 0x07, 0x00, 0xf8,
+   0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x20, 0x00, 0x02, 0x00, 0x00,
+   0xe0, 0x01, 0x00, 0xfc, 0xc1, 0x07, 0x00, 0xf8, 0x00, 0x3e, 0x00, 0x00,
+   0x00, 0xe0, 0x03, 0x20, 0x02, 0x00, 0x10, 0x00, 0xe0, 0x01, 0x00, 0xe8,
+   0xc1, 0x07, 0x00, 0xf8, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x20,
+   0x02, 0x04, 0x00, 0x00, 0xe0, 0x00, 0x00, 0xfc, 0xc1, 0x07, 0x00, 0xf8,
+   0x00, 0x3e, 0x00, 0x00, 0x00, 0xe0, 0x03, 0x00, 0x0c, 0x00, 0x00, 0x00,
+   0xf0, 0x01, 0x00, 0xfe, 0xc0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0x0f, 0xff,
+   0xff, 0xff, 0x03, 0x40, 0x08, 0x08, 0x0d, 0x00, 0x58, 0x03, 0x00, 0x7c,
+   0xc0, 0xff, 0xff, 0xff, 0xf0, 0xff, 0x0f, 0xff, 0xff, 0xff, 0x03, 0x40,
+   0x10, 0xa0, 0x18, 0x00, 0xa8, 0x06, 0x00, 0xb8, 0x81, 0xff, 0xff, 0xff,
+   0xf0, 0xff, 0x0f, 0xff, 0xff, 0xff, 0x01, 0x00, 0x10, 0x00, 0x00, 0x00,
+   0x5e, 0x1d, 0x00, 0xe8, 0x82, 0xff, 0xff, 0xff, 0xf0, 0xff, 0x0f, 0xff,
+   0xff, 0xff, 0x01, 0x00, 0x20, 0xc0, 0x07, 0x00, 0xab, 0x3a, 0x00, 0x54,
+   0x03, 0xfe, 0xff, 0xff, 0xf0, 0xff, 0x0f, 0xff, 0xff, 0x7f, 0x00, 0x80,
+   0x40, 0x01, 0x01, 0x00, 0x55, 0x3d, 0x00, 0xaa, 0x06, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x81, 0x01, 0x01, 0x00,
+   0xab, 0x1a, 0xc0, 0x55, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x80, 0x03, 0x00, 0x00, 0x55, 0x35, 0xe0, 0xab,
+   0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0xc0, 0x43, 0x01, 0x00, 0xab, 0xaa, 0xff, 0x55, 0x03, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc7, 0x00, 0x00,
+   0x57, 0xf5, 0xff, 0xaa, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0xfc, 0x00, 0x00, 0xaa, 0xea, 0xff, 0xd5,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0xfe, 0x03, 0x00, 0x7c, 0x75, 0x80, 0x2b, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x03, 0x00,
+   0x80, 0x1f, 0x00, 0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+   0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x01, 0x00 };
diff -puN /dev/null drivers/hid/hid-g13.c
--- /dev/null
+++ a/drivers/hid/hid-g13.c
@@ -0,0 +1,1526 @@
+/***************************************************************************
+ *   Copyright (C) 2009 by Rick L. Vinyard, Jr.                            *
+ *   rvinyard@cs.nmsu.edu                                                  *
+ *                                                                         *
+ *   This program is free software: you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation, either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This driver is distributed in the hope that it will be useful, but    *
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU      *
+ *   General Public License for more details.                              *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this software. If not see <http://www.gnu.org/licenses/>.  *
+ ***************************************************************************/
+#include <linux/fb.h>
+#include <linux/hid.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/mm.h>
+#include <linux/sysfs.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+#include <linux/vmalloc.h>
+
+#include "hid-ids.h"
+#include "usbhid/usbhid.h"
+#include "hid-g13-logo.xbm"
+
+#define G13_NAME "Logitech G13"
+
+/* Key defines */
+#define G13_KEYS 35
+#define G13_KEYMAP_SIZE (G13_KEYS*3)
+
+/* G1-G22 indices */
+#define G13_G1		 0
+#define G13_G2		 1
+#define G13_G3		 2
+#define G13_G4		 3
+#define G13_G5		 4
+#define G13_G6		 5
+#define G13_G7		 6
+#define G13_G8		 7
+#define G13_G9		 8
+#define G13_G10		 9
+#define G13_G11		10
+#define G13_G12		11
+#define G13_G13		12
+#define G13_G14		13
+#define G13_G15		14
+#define G13_G16		15
+#define G13_G17		16
+#define G13_G18		17
+#define G13_G19		18
+#define G13_G20		19
+#define G13_G21		20
+#define G13_G22		21
+#define G13_FUNC	22
+#define G13_LCD1	23
+#define G13_LCD2	24
+#define G13_LCD3	25
+#define G13_LCD4	26
+#define G13_M1		27
+#define G13_M2		28
+#define G13_M3		29
+#define G13_MR		30
+#define G13_BTN_LEFT	31
+#define G13_BTN_DOWN	32
+#define G13_BTN_STICK	33
+#define G13_LIGHT	34
+
+/* Framebuffer defines */
+#define G13FB_NAME "g13fb"
+#define G13FB_WIDTH (160)
+#define G13FB_LINE_LENGTH (160/8)
+#define G13FB_HEIGHT (43)
+
+/*
+ * 160*43 rounded to nearest whole byte which is 160*48 since bytes are
+ *  vertical the y component must be a multiple of 8
+ */
+#define G13FB_SIZE (160*48/8)
+
+#define G13FB_UPDATE_RATE_LIMIT 20
+#define G13FB_UPDATE_RATE_DEFAULT 10
+#define G13_VBITMAP_SIZE (G13FB_SIZE + 32)
+
+/* Backlight defaults */
+#define G13_DEFAULT_RED 0
+#define G13_DEFAULT_GREEN 255
+#define G13_DEFAULT_BLUE 0
+
+/* Per device data structure */
+struct g13_data {
+	/* HID reports */
+	struct hid_device *hdev;
+	struct hid_report *backlight_report;
+	struct hid_report *start_input_report;
+	struct hid_report *report_4;
+	struct hid_report *mled_report;
+	struct input_dev *input_dev;
+
+	char *name;
+	int ready;
+	int ready2;
+	u32 keycode[G13_KEYMAP_SIZE];
+	u8 rgb[3];
+	u8 mled;
+	u8 curkeymap;
+	u8 emit_msc_raw;
+	u8 keymap_switching;
+
+	/* Framebuffer stuff */
+	u8 fb_update_rate;
+	u8 *fb_vbitmap;
+	u8 *fb_bitmap;
+	struct fb_info *fb_info;
+	struct fb_deferred_io fb_defio;
+
+	/* Housekeeping stuff */
+	rwlock_t lock;
+};
+
+/* Convenience macros */
+#define hid_get_g13data(hdev) \
+	((hdev == NULL) ? NULL : (struct g13_data *)(hid_get_drvdata(hdev)))
+
+#define input_get_hdev(idev) \
+	((idev == NULL) ? NULL : (struct hid_device *)(input_get_drvdata(idev)))
+
+#define input_get_g13data(idev) (hid_get_g13data(input_get_hdev(idev)))
+
+static ssize_t g13_set_mled(struct hid_device *hdev, unsigned mled);
+
+static unsigned int g13_default_key_map[G13_KEYS] = {
+  /* first row g1 - g7 */
+  KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7,
+  /* second row g8 - g11 */
+  KEY_UNKNOWN, KEY_UNKNOWN, KEY_BACK, KEY_UP,
+  /* second row g12 - g13 */
+  KEY_FORWARD, KEY_UNKNOWN, KEY_UNKNOWN,
+  /* third row g15 - g19 */
+  KEY_UNKNOWN, KEY_LEFT, KEY_DOWN, KEY_RIGHT, KEY_UNKNOWN,
+  /* fourth row g20 - g22 */
+  KEY_BACKSPACE, KEY_ENTER, KEY_SPACE,
+  /* next, light left, light center left, light center right, light right */
+  BTN_0, BTN_1, BTN_2, BTN_3, BTN_4,
+  /* M1, M2, M3, MR */
+  KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+  /* button left, button down, button stick, light */
+  BTN_LEFT, BTN_RIGHT, BTN_MIDDLE, KEY_RESERVED,
+};
+
+/* Frambuffer visual structures */
+static struct fb_fix_screeninfo g13fb_fix = {
+	.id = G13FB_NAME,
+	.type = FB_TYPE_PACKED_PIXELS,
+	.visual = FB_VISUAL_MONO01,
+	.xpanstep = 0,
+	.ypanstep = 0,
+	.ywrapstep = 0,
+	.line_length = G13FB_LINE_LENGTH,
+	.accel = FB_ACCEL_NONE,
+};
+
+static struct fb_var_screeninfo g13fb_var = {
+	.xres = G13FB_WIDTH,
+	.yres = G13FB_HEIGHT,
+	.xres_virtual = G13FB_WIDTH,
+	.yres_virtual = G13FB_HEIGHT,
+	.bits_per_pixel = 1,
+	.nonstd = 1,
+};
+
+/* Send the current framebuffer vbitmap as an interrupt message */
+static int g13_fb_vbitmap_send(struct hid_device *hdev)
+{
+	struct usb_interface *intf;
+	struct usb_device *usbdev;
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	/* Get the usb device to send the image on */
+	intf = to_usb_interface(hdev->dev.parent);
+	usbdev = interface_to_usbdev(intf);
+
+	return usb_interrupt_msg(usbdev, usb_sndintpipe(usbdev, 0x02),
+				 data->fb_vbitmap, G13_VBITMAP_SIZE,
+				 NULL, USB_CTRL_SET_TIMEOUT*2);
+}
+
+/* Update fb_vbitmap from the screen_base and send to the device */
+static void g13_fb_update(struct g13_data *data)
+{
+	int row;
+	int col;
+	int bit;
+	u8 *u;
+	size_t offset;
+	u8 temp;
+
+	/* Clear the vbitmap and set the necessary magic number */
+	memset(data->fb_vbitmap, 0x00, G13_VBITMAP_SIZE);
+	data->fb_vbitmap[0] = 0x03;
+
+	/*
+	 * Translate the XBM format screen_base into the format needed by the
+	 * G13. This format places the pixels in a vertical rather than
+	 * horizontal format. Assuming a grid with 0,0 in the upper left corner
+	 * and 159,42 in the lower right corner, the first byte contains the
+	 * pixels 0,0 through 0,7 and the second byte contains the pixels 1,0
+	 * through 1,7. Within the byte, bit 0 represents 0,0; bit 1 0,1; etc.
+	 *
+	 * This loop operates in reverse to shift the lower bits into their
+	 * respective positions, shifting the lower rows into the higher bits.
+	 *
+	 * The offset is calculated for every 8 rows and is adjusted by 32 since
+	 * that is what the G13 image message expects.
+	 */
+	for (row = G13FB_HEIGHT-1; row >= 0; row--) {
+		offset = 32 + row/8 * G13FB_WIDTH;
+		u = data->fb_vbitmap + offset;
+		/*
+		 * Iterate across the screen_base columns to get the
+		 * individual bits
+		 */
+		for (col = 0; col < G13FB_LINE_LENGTH; col++) {
+			/*
+			 * We will work with a temporary value since we don't
+			 * want to modify screen_base as we shift each bit
+			 * downward.
+			 */
+			temp = data->fb_bitmap[row * G13FB_LINE_LENGTH + col];
+
+			/*
+			 * For each bit in the pixel row we will shift it onto
+			 * the appropriate by by shift the g13 byte up by 1 and
+			 * simply doing a bitwise or of the low byte
+			 */
+			for (bit = 0; bit < 8; bit++) {
+				/*Shift the g13 byte up by 1 for this new row*/
+				u[bit] <<= 1;
+				/* Bring in the new pixel of temp */
+				u[bit] |= (temp & 0x01);
+				/*
+				 * Shift temp down so the low pixel is ready
+				 * for the next byte
+				 */
+				temp >>= 1;
+			}
+
+			/*
+			 * The last byte represented 8 vertical pixels so we'll
+			 * jump ahead 8
+			 */
+			u += 8;
+		}
+	}
+
+	/*
+	 * Now that we have translated screen_base into a format expected by
+	 * the g13 let's send out the vbitmap
+	 */
+	g13_fb_vbitmap_send(data->hdev);
+
+}
+
+/* Callback from deferred IO workqueue */
+static void g13_fb_deferred_io(struct fb_info *info, struct list_head *pagelist)
+{
+	g13_fb_update(info->par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_fillrect(struct fb_info *info,
+			    const struct fb_fillrect *rect)
+{
+	struct g13_data *par = info->par;
+
+	sys_fillrect(info, rect);
+
+	g13_fb_update(par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_copyarea(struct fb_info *info,
+			    const struct fb_copyarea *area)
+{
+	struct g13_data *par = info->par;
+
+	sys_copyarea(info, area);
+
+	g13_fb_update(par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	struct g13_data *par = info->par;
+
+	sys_imageblit(info, image);
+
+	g13_fb_update(par);
+}
+
+/*
+ * this is the slow path from userspace. they can seek and write to
+ * the fb. it's inefficient to do anything less than a full screen draw
+ */
+static ssize_t g13_fb_write(struct fb_info *info, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct g13_data *par = info->par;
+	unsigned long p = *ppos;
+	void *dst;
+	int err = 0;
+	unsigned long total_size;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->fix.smem_len;
+
+	if (p > total_size)
+		return -EFBIG;
+
+	if (count > total_size) {
+		err = -EFBIG;
+		count = total_size;
+	}
+
+	if (count + p > total_size) {
+		if (!err)
+			err = -ENOSPC;
+
+		count = total_size - p;
+	}
+
+	dst = (void __force *)(info->screen_base + p);
+
+	if (copy_from_user(dst, buf, count))
+		err = -EFAULT;
+
+	if (!err)
+		*ppos += count;
+
+	g13_fb_update(par);
+
+	return (err) ? err : count;
+}
+
+static struct fb_ops g13fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_read = fb_sys_read,
+	.fb_write = g13_fb_write,
+	.fb_fillrect  = g13_fb_fillrect,
+	.fb_copyarea  = g13_fb_copyarea,
+	.fb_imageblit = g13_fb_imageblit,
+};
+
+/*
+ * The "fb_node" attribute
+ */
+static ssize_t g13_fb_node_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned fb_node;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	fb_node = data->fb_info->node;
+
+	return sprintf(buf, "%u\n", fb_node);
+}
+
+static DEVICE_ATTR(fb_node, 0444, g13_fb_node_show, NULL);
+
+
+/*
+ * The "fb_update_rate" attribute
+ */
+static ssize_t g13_fb_update_rate_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	unsigned fb_update_rate;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	fb_update_rate = data->fb_update_rate;
+
+	return sprintf(buf, "%u\n", fb_update_rate);
+}
+
+static ssize_t g13_set_fb_update_rate(struct hid_device *hdev,
+				      unsigned fb_update_rate)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	if (fb_update_rate > G13FB_UPDATE_RATE_LIMIT)
+		data->fb_update_rate = G13FB_UPDATE_RATE_LIMIT;
+	else if (fb_update_rate == 0)
+		data->fb_update_rate = 1;
+	else
+		data->fb_update_rate = fb_update_rate;
+
+	data->fb_defio.delay = HZ / data->fb_update_rate;
+
+	return 0;
+}
+
+static ssize_t g13_fb_update_rate_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned u;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &u);
+	if (i != 1) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_fb_update_rate(hdev, u);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(fb_update_rate, 0666,
+		   g13_fb_update_rate_show,
+		   g13_fb_update_rate_store);
+
+static int g13_raw_event(struct hid_device *hdev,
+			 struct hid_report *report,
+			 u8 *raw_data, int size)
+{
+	/*
+	 * On initialization receive a 258 byte message with
+	 * data = 6 0 255 255 255 255 255 255 255 255 ...
+	 */
+	int i;
+	int mask;
+	int offset;
+	u8 val;
+	struct g13_data *g13data;
+	g13data = dev_get_drvdata(&hdev->dev);
+
+	if (g13data == NULL)
+		return 1;
+
+	switch (report->id) {
+	case 6:
+		g13data->ready = 1;
+		break;
+	case 1:
+		g13data->ready2 = 1;
+
+		if (g13data->input_dev == NULL)
+			break;
+
+		if (g13data->curkeymap < 3)
+			offset = G13_KEYS * g13data->curkeymap;
+		else
+			offset = 0;
+
+		for (i = 0, mask = 0x01; i < 8; i++, mask <<= 1) {
+			/* Keys G1 through G8 */
+			if (g13data->keycode[i] != KEY_RESERVED)
+				input_report_key(g13data->input_dev,
+						 g13data->keycode[i+offset],
+						 raw_data[3] & mask);
+			input_event(g13data->input_dev, EV_MSC, MSC_SCAN, i);
+
+			/* Keys G9 through G16 */
+			if (g13data->keycode[i+8] != KEY_RESERVED)
+				input_report_key(g13data->input_dev,
+						 g13data->keycode[i+8+offset],
+						 raw_data[4] & mask);
+			input_event(g13data->input_dev, EV_MSC, MSC_SCAN, i+8);
+
+			/* Keys G17 through G22 */
+			if (i <= 5 && g13data->keycode[i+16] != KEY_RESERVED)
+				input_report_key(g13data->input_dev,
+						 g13data->keycode[i+16+offset],
+						 raw_data[5] & mask);
+			input_event(g13data->input_dev, EV_MSC, MSC_SCAN, i+16);
+
+			/* Keys FUNC through M3 */
+			if (g13data->keycode[i+22] != KEY_RESERVED)
+				input_report_key(g13data->input_dev,
+						 g13data->keycode[i+22+offset],
+						 raw_data[6] & mask);
+			input_event(g13data->input_dev, EV_MSC, MSC_SCAN, i+22);
+
+			/* Keys MR through LIGHT */
+			if (i <= 4 && g13data->keycode[i+30] != KEY_RESERVED)
+				input_report_key(g13data->input_dev,
+						 g13data->keycode[i+30+offset],
+						 raw_data[7] & mask);
+			input_event(g13data->input_dev, EV_MSC, MSC_SCAN, i+30);
+		}
+
+		if (g13data->emit_msc_raw) {
+			/*
+			 * Outputs an MSC_RAW value with the low four
+			 * bits = M1-MR, Low bit = M1
+			 */
+			val = raw_data[6] >> 5;
+			val |= (raw_data[7] & 0x01 << 3);
+			input_event(g13data->input_dev, EV_MSC, MSC_RAW, val);
+		}
+
+		if (g13data->keymap_switching) {
+			if (raw_data[6] & 0x20) {
+				g13data->curkeymap = 0;
+				g13_set_mled(hdev, 0x01);
+			} else if (raw_data[6] & 0x40) {
+				g13data->curkeymap = 1;
+				g13_set_mled(hdev, 0x02);
+			} else if (raw_data[6] & 0x80) {
+				g13data->curkeymap = 2;
+				g13_set_mled(hdev, 0x04);
+			}
+		}
+
+		input_report_abs(g13data->input_dev, ABS_X, raw_data[1]);
+		input_report_abs(g13data->input_dev, ABS_Y, raw_data[2]);
+		input_sync(g13data->input_dev);
+
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void g13_initialize_keymap(struct g13_data *data)
+{
+	int i;
+
+	write_lock(&data->lock);
+
+	for (i = 0; i < G13_KEYS; i++) {
+		data->keycode[i] = g13_default_key_map[i];
+		set_bit(data->keycode[i], data->input_dev->keybit);
+	}
+
+	clear_bit(0, data->input_dev->keybit);
+
+	write_unlock(&data->lock);
+
+}
+
+static int g13_input_setkeycode(struct input_dev *dev,
+				int scancode,
+				int keycode)
+{
+	int old_keycode;
+	int i;
+	struct g13_data *data = input_get_g13data(dev);
+
+	if (data == NULL)
+		return -EINVAL;
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	if (!dev->keycodesize)
+		return -EINVAL;
+
+	if (dev->keycodesize < sizeof(keycode) &&
+	    (keycode >> (dev->keycodesize * 8)))
+		return -EINVAL;
+
+	write_lock(&data->lock);
+
+	old_keycode = data->keycode[scancode];
+	data->keycode[scancode] = keycode;
+
+	clear_bit(old_keycode, dev->keybit);
+	set_bit(keycode, dev->keybit);
+
+	for (i = 0; i < dev->keycodemax; i++) {
+		if (data->keycode[i] == old_keycode) {
+			set_bit(old_keycode, dev->keybit);
+			break; /* Setting the bit twice is useless, so break */
+		}
+	}
+
+	write_unlock(&data->lock);
+
+	return 0;
+}
+
+static int g13_input_getkeycode(struct input_dev *dev,
+				int scancode,
+				int *keycode)
+{
+	struct g13_data *data = input_get_g13data(dev);
+
+	if (!dev->keycodesize)
+		return -EINVAL;
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	read_lock(&data->lock);
+
+	*keycode = data->keycode[scancode];
+
+	read_unlock(&data->lock);
+
+	return 0;
+}
+
+
+/*
+ * The "keymap" attribute
+ */
+static ssize_t g13_keymap_index_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	return sprintf(buf, "%u\n", data->curkeymap);
+}
+
+static ssize_t g13_set_keymap_index(struct hid_device *hdev, unsigned k)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	if (k > 2)
+		return -EINVAL;
+
+	data->curkeymap = k;
+
+	if (data->keymap_switching)
+		g13_set_mled(hdev, 1<<k);
+
+	return 0;
+}
+
+static ssize_t g13_keymap_index_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned k;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &k);
+	if (i != 1) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_keymap_index(hdev, k);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(keymap_index, 0666,
+		   g13_keymap_index_show,
+		   g13_keymap_index_store);
+
+/*
+ * The "keycode" attribute
+ */
+static ssize_t g13_keymap_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	int i;
+	int offset = 0;
+	int result;
+
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	for (i = 0; i < G13_KEYMAP_SIZE; i++) {
+		result = sprintf(buf+offset,
+				 "0x%03x 0x%04x\n",
+				 i, data->keycode[i]);
+		if (result < 0)
+			return -EINVAL;
+		offset += result;
+	}
+
+	return offset+1;
+}
+
+static ssize_t g13_keymap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int scanned;
+	int consumed;
+	int scancd;
+	int keycd;
+	int set_result;
+	int set = 0;
+	int gkey;
+	int index;
+	int good;
+	struct g13_data *data;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	/* Now, let's get the data structure */
+	data = hid_get_g13data(hdev);
+	if (data == NULL)
+		return -ENODATA;
+
+	do {
+		good = 0;
+
+		/* Look for scancode keycode pair in hex */
+		scanned = sscanf(buf,
+				 "%x %x%n",
+				 &scancd, &keycd, &consumed);
+		if (scanned == 2) {
+			buf += consumed;
+			set_result = g13_input_setkeycode(data->input_dev,
+							  scancd,
+							  keycd);
+			if (set_result < 0)
+				return set_result;
+			set++;
+			good = 1;
+		} else {
+			/*
+			 * Look for Gkey keycode pair and assign to current
+			 * keymap
+			 */
+			scanned = sscanf(buf,
+					 "G%d %x%n",
+					 &gkey, &keycd, &consumed);
+			if (scanned == 2 && gkey > 0 && gkey <= G13_KEYS) {
+				buf += consumed;
+				scancd = data->curkeymap * G13_KEYS + gkey - 1;
+				set_result =
+					g13_input_setkeycode(data->input_dev,
+							     scancd, keycd);
+				if (set_result < 0)
+					return set_result;
+				set++;
+				good = 1;
+			} else {
+				/*
+				 * Look for Gkey-index keycode pair and assign
+				 * to indexed keymap
+				 */
+				scanned = sscanf(buf,
+						 "G%d-%d %x%n",
+						 &gkey,
+						 &index,
+						 &keycd,
+						 &consumed);
+				if (scanned == 3 &&
+				    gkey > 0 && gkey <= G13_KEYS &&
+				    index >= 0 && index <= 2) {
+					buf += consumed;
+					scancd = index * G13_KEYS + gkey - 1;
+					set_result =
+					  g13_input_setkeycode(data->input_dev,
+							       scancd, keycd);
+					if (set_result < 0)
+						return set_result;
+					set++;
+					good = 1;
+				}
+			}
+		}
+
+	} while (good);
+
+	if (set == 0) {
+		printk(KERN_ERR "unrecognized keycode input: %s", buf);
+		return -1;
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(keymap, 0666, g13_keymap_show, g13_keymap_store);
+
+/*
+ * The "emit_msc_raw" attribute
+ */
+static ssize_t g13_emit_msc_raw_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	return sprintf(buf, "%u\n", data->emit_msc_raw);
+}
+
+static ssize_t g13_set_emit_msc_raw(struct hid_device *hdev, unsigned k)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	data->emit_msc_raw = k;
+
+	return 0;
+}
+
+static ssize_t g13_emit_msc_raw_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned k;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &k);
+	if (i != 1) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_emit_msc_raw(hdev, k);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(emit_msc_raw, 0666,
+		   g13_emit_msc_raw_show,
+		   g13_emit_msc_raw_store);
+
+
+/*
+ * The "keymap_switching" attribute
+ */
+static ssize_t g13_keymap_switching_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	return sprintf(buf, "%u\n", data->keymap_switching);
+}
+
+static ssize_t g13_set_keymap_switching(struct hid_device *hdev, unsigned k)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	data->keymap_switching = k;
+
+	if (data->keymap_switching)
+		g13_set_mled(hdev, 1<<(data->curkeymap));
+
+	return 0;
+}
+
+static ssize_t g13_keymap_switching_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned k;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &k);
+	if (i != 1) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_keymap_switching(hdev, k);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(keymap_switching, 0666,
+		   g13_keymap_switching_show,
+		   g13_keymap_switching_store);
+
+
+static ssize_t g13_name_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+	int result;
+
+	if (data == NULL)
+		return -ENODATA;
+
+	if (data->name == NULL) {
+		buf[0] = 0x00;
+		return 1;
+	}
+
+	read_lock(&data->lock);
+	result = sprintf(buf, "%s", data->name);
+	read_unlock(&data->lock);
+
+	return result;
+}
+
+static ssize_t g13_name_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+	size_t limit = count;
+	char *end;
+
+	if (data == NULL)
+		return -ENODATA;
+
+	write_lock(&data->lock);
+
+	if (data->name != NULL) {
+		kfree(data->name);
+		data->name = NULL;
+	}
+
+	end = strpbrk(buf, "\n\r");
+	if (end != NULL)
+		limit = end - buf;
+
+	if (end != buf) {
+
+		if (limit > 100)
+			limit = 100;
+
+		data->name = kzalloc(limit+1, GFP_KERNEL);
+
+		strncpy(data->name, buf, limit);
+	}
+
+	write_unlock(&data->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
+
+/*
+ * The "rgb" attribute
+ * red green blue
+ * each with values 0 - 255 (black - full intensity)
+ */
+static ssize_t g13_rgb_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned r, g, b;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	r = data->rgb[0];
+	g = data->rgb[1];
+	b = data->rgb[2];
+
+	return sprintf(buf, "%u %u %u\n", r, g, b);
+}
+
+static ssize_t g13_set_rgb(struct hid_device *hdev,
+			   unsigned r, unsigned g, unsigned b)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL || data->backlight_report == NULL)
+		return -ENODATA;
+
+	data->backlight_report->field[0]->value[0] = r;
+	data->backlight_report->field[0]->value[1] = g;
+	data->backlight_report->field[0]->value[2] = b;
+	data->backlight_report->field[0]->value[3] = 0x00;
+
+	usbhid_submit_report(hdev, data->backlight_report, USB_DIR_OUT);
+
+	data->rgb[0] = r;
+	data->rgb[1] = g;
+	data->rgb[2] = b;
+
+	return 0;
+}
+
+static ssize_t g13_rgb_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned r;
+	unsigned g;
+	unsigned b;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u %u %u", &r, &g, &b);
+	if (i != 3) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_rgb(hdev, r, g, b);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
+
+/*
+ * The "mled" attribute
+ * on or off for each of the four M led's (M1 M2 M3 MR)
+ */
+static ssize_t g13_mled_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned mled;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	if (data == NULL)
+		return -ENODATA;
+
+	mled = data->mled;
+
+	return sprintf(buf, "%u\n", mled);
+}
+
+static ssize_t g13_set_mled(struct hid_device *hdev, unsigned mled)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (data == NULL || data->mled_report == NULL)
+		return -ENODATA;
+
+	data->mled_report->field[0]->value[0] = mled&0x0F;
+	data->mled_report->field[0]->value[1] = 0x00;
+	data->mled_report->field[0]->value[2] = 0x00;
+	data->mled_report->field[0]->value[3] = 0x00;
+
+	usbhid_submit_report(hdev, data->mled_report, USB_DIR_OUT);
+
+	data->mled = mled;
+
+	return 0;
+}
+
+static ssize_t g13_mled_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned m[4];
+	unsigned mled;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u %u %u %u", m, m+1, m+2, m+3);
+	if (!(i == 4 || i == 1)) {
+		printk(KERN_ERR "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	if (i == 1)
+		mled = m[0];
+	else
+		mled = (m[0] ? 1 : 0) | (m[1] ? 2 : 0) |
+		       (m[2] ? 4 : 0) | (m[3] ? 8 : 0);
+
+	set_result = g13_set_mled(hdev, mled);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(mled, 0666, g13_mled_show, g13_mled_store);
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *g13_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_rgb.attr,
+	&dev_attr_mled.attr,
+	&dev_attr_keymap_index.attr,
+	&dev_attr_emit_msc_raw.attr,
+	&dev_attr_keymap_switching.attr,
+	&dev_attr_keymap.attr,
+	&dev_attr_fb_update_rate.attr,
+	&dev_attr_fb_node.attr,
+	NULL,	 /* need to NULL terminate the list of attributes */
+};
+
+/*
+ * An unnamed attribute group will put all of the attributes directly in
+ * the kobject directory.  If we specify a name, a subdirectory will be
+ * created for the attributes with the directory being the name of the
+ * attribute group.
+ */
+static struct attribute_group g13_attr_group = {
+	.attrs = g13_attrs,
+};
+
+static struct fb_deferred_io g13_fb_defio = {
+	.delay = HZ / G13FB_UPDATE_RATE_DEFAULT,
+	.deferred_io = g13_fb_deferred_io,
+};
+
+static int g13_probe(struct hid_device *hdev,
+		     const struct hid_device_id *id)
+{
+	int error;
+	struct g13_data *data;
+	int i;
+	struct list_head *feature_report_list =
+		&hdev->report_enum[HID_FEATURE_REPORT].report_list;
+	struct hid_report *report;
+
+	dev_dbg(&hdev->dev, "Logitech G13 HID hardware probe...");
+
+	/*
+	 * Let's allocate the g13 data structure, set some reasonable
+	 * defaults, and associate it with the device
+	 */
+	data = kzalloc(sizeof(struct g13_data), GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(&hdev->dev,
+		  "can't allocate space for Logitech G13 device attributes\n");
+		error = -ENOMEM;
+		goto err_no_cleanup;
+	}
+
+	rwlock_init(&data->lock);
+
+	data->hdev = hdev;
+
+	data->fb_bitmap = vmalloc(G13FB_SIZE);
+	if (data->fb_bitmap == NULL) {
+		dev_err(&hdev->dev,
+			G13_NAME
+			": ERROR: can't get a free page for framebuffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_data;
+	}
+	memcpy(data->fb_bitmap, g13_lcd_bits, G13FB_SIZE);
+
+	data->fb_vbitmap = kmalloc(sizeof(u8) * G13_VBITMAP_SIZE, GFP_KERNEL);
+	if (data->fb_vbitmap == NULL) {
+		dev_err(&hdev->dev,
+		  G13_NAME
+		  ": ERROR: can't alloc vbitmap image buffer (%i bytes)\n",
+		  G13_VBITMAP_SIZE);
+		error = -ENOMEM;
+		goto err_cleanup_fb_bitmap;
+	}
+
+	hid_set_drvdata(hdev, data);
+
+	dbg_hid("Preparing to parse " G13_NAME " hid reports\n");
+
+	/* Parse the device reports and start it up */
+	error = hid_parse(hdev);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " device report parse failed\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	mdelay(10);
+
+	error = hid_hw_start(hdev,
+			     HID_CONNECT_DEFAULT | HID_CONNECT_HIDINPUT_FORCE);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " hardware start failed\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	dbg_hid(G13_NAME " claimed: %d\n", hdev->claimed);
+
+	error = hdev->ll_driver->open(hdev);
+	if (error) {
+		dev_err(&hdev->dev,
+			G13_NAME
+			" failed to open input interrupt pipe for key and "
+			"joystick events\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	/* Set up the input device for the key I/O */
+	data->input_dev = input_allocate_device();
+	if (data->input_dev == NULL) {
+		dev_err(&hdev->dev,
+			G13_NAME " error initializing the input device");
+		error = -ENOMEM;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	input_set_drvdata(data->input_dev,	hdev);
+
+	data->input_dev->name = G13_NAME;
+	data->input_dev->phys = hdev->phys;
+	data->input_dev->uniq = hdev->uniq;
+	data->input_dev->id.bustype = hdev->bus;
+	data->input_dev->id.vendor = hdev->vendor;
+	data->input_dev->id.product = hdev->product;
+	data->input_dev->id.version = hdev->version;
+	data->input_dev->dev.parent = hdev->dev.parent;
+	data->input_dev->keycode = data->keycode;
+	data->input_dev->keycodemax = G13_KEYMAP_SIZE;
+	data->input_dev->keycodesize = sizeof(u32);
+	data->input_dev->setkeycode = g13_input_setkeycode;
+	data->input_dev->getkeycode = g13_input_getkeycode;
+
+	input_set_capability(data->input_dev, EV_ABS, ABS_X);
+	input_set_capability(data->input_dev, EV_ABS, ABS_Y);
+	input_set_capability(data->input_dev, EV_MSC, MSC_SCAN);
+	input_set_capability(data->input_dev, EV_KEY, KEY_UNKNOWN);
+	data->input_dev->evbit[0] |= BIT_MASK(EV_REP);
+
+	/* 4 center values */
+	input_set_abs_params(data->input_dev, ABS_X, 0, 0xff, 0, 4);
+	input_set_abs_params(data->input_dev, ABS_Y, 0, 0xff, 0, 4);
+
+	g13_initialize_keymap(data);
+
+	error = input_register_device(data->input_dev);
+	if (error) {
+		dev_err(&hdev->dev,
+			G13_NAME " error registering the input device");
+		error = -EINVAL;
+		goto err_cleanup_input_dev;
+	}
+
+	/* Set up the framebuffer device */
+	data->fb_update_rate = G13FB_UPDATE_RATE_DEFAULT;
+	data->fb_info = framebuffer_alloc(0, &hdev->dev);
+	if (data->fb_info == NULL) {
+		dev_err(&hdev->dev,
+			G13_NAME " failed to allocate a framebuffer\n");
+		goto err_cleanup_input_dev;
+	}
+
+	dbg_hid(KERN_INFO G13_NAME " allocated framebuffer\n");
+
+	data->fb_defio = g13_fb_defio;
+	data->fb_info->fbdefio = &data->fb_defio;
+
+	dbg_hid(KERN_INFO G13_NAME " allocated deferred IO structure\n");
+
+	data->fb_info->screen_base = (char __force __iomem *) data->fb_bitmap;
+	data->fb_info->fbops = &g13fb_ops;
+	data->fb_info->var = g13fb_var;
+	data->fb_info->fix = g13fb_fix;
+	data->fb_info->fix.smem_len = G13FB_SIZE;
+	data->fb_info->par = data;
+	data->fb_info->flags = FBINFO_FLAG_DEFAULT;
+
+	fb_deferred_io_init(data->fb_info);
+
+	if (register_framebuffer(data->fb_info) < 0)
+		goto err_cleanup_fb;
+
+	/* Add the sysfs attributes */
+	error = sysfs_create_group(&(hdev->dev.kobj), &g13_attr_group);
+	if (error) {
+		dev_err(&hdev->dev,
+		  "Logitech G13 failed to create sysfs group attributes\n");
+		goto err_cleanup_fb;
+	}
+
+	dbg_hid("Waiting for G13 to activate\n");
+
+	if (list_empty(feature_report_list)) {
+		dev_err(&hdev->dev, "no feature report found\n");
+		error = -ENODEV;
+		goto err_cleanup_fb;
+	}
+	dbg_hid("G13 feature report found\n");
+
+	list_for_each_entry(report, feature_report_list, list) {
+		switch (report->id) {
+		case 0x04:
+			data->report_4 = report;
+			break;
+		case 0x05:
+			data->mled_report = report;
+			break;
+		case 0x06:
+			data->start_input_report = report;
+			break;
+		case 0x07:
+			data->backlight_report = report;
+			break;
+		default:
+			break;
+		}
+		dbg_hid("G13 Feature report: id=%u type=%u size=%u maxfield=%u"
+			" report_count=%u\n",
+			report->id, report->type, report->size,
+			report->maxfield, report->field[0]->report_count);
+	}
+
+	dbg_hid("Found all reports\n");
+
+	for (i = 0; i < 20; i++) {
+		if (data->ready && data->ready2)
+			break;
+		mdelay(10);
+	}
+
+	if (!(data->ready && data->ready2))
+		printk(KERN_ERR
+		       "G13 hasn't responded yet, "
+		       "forging ahead with initialization\n");
+	else
+		dbg_hid("G13 initialized\n");
+
+	/*
+	 * Set the initial color and load the linux logo
+	 * We're going to ignore the error values. If there is an error at this
+	 * point we'll forge ahead.
+	 */
+
+	dbg_hid("Set default color\n");
+
+	error = g13_set_rgb(hdev,
+			    G13_DEFAULT_RED,
+			    G13_DEFAULT_GREEN,
+			    G13_DEFAULT_BLUE);
+
+	usbhid_submit_report(hdev, data->start_input_report, USB_DIR_IN);
+
+	g13_fb_update(data);
+
+	dbg_hid("G13 activated and initialized\n");
+
+	/* Everything went well */
+	return 0;
+
+err_cleanup_fb:
+	framebuffer_release(data->fb_info);
+
+err_cleanup_input_dev:
+	input_free_device(data->input_dev);
+
+err_cleanup_fb_vbitmap:
+	kfree(data->fb_vbitmap);
+
+err_cleanup_fb_bitmap:
+	vfree(data->fb_bitmap);
+
+err_cleanup_data:
+	/* Make sure we clean up the allocated data structure */
+	kfree(data);
+
+err_no_cleanup:
+
+	hid_set_drvdata(hdev, NULL);
+
+	return error;
+}
+
+static void g13_remove(struct hid_device *hdev)
+{
+	struct g13_data *data;
+
+	hdev->ll_driver->close(hdev);
+
+	hid_hw_stop(hdev);
+
+	/* Get the internal g13 data buffer */
+	data = hid_get_drvdata(hdev);
+
+	/* Clean up the buffer */
+	if (data != NULL) {
+		write_lock(&data->lock);
+		input_unregister_device(data->input_dev);
+		kfree(data->name);
+		write_unlock(&data->lock);
+		if (data->fb_info != NULL) {
+			fb_deferred_io_cleanup(data->fb_info);
+			unregister_framebuffer(data->fb_info);
+			framebuffer_release(data->fb_info);
+		}
+		vfree(data->fb_bitmap);
+		kfree(data->fb_vbitmap);
+		kfree(data);
+	}
+
+}
+
+static const struct hid_device_id g13_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13)
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, g13_devices);
+
+static struct hid_driver g13_driver = {
+	.name =		"hid-g13",
+	.id_table =	g13_devices,
+	.probe =	g13_probe,
+	.remove =	g13_remove,
+	.raw_event =	g13_raw_event,
+};
+
+static int __init g13_init(void)
+{
+	return hid_register_driver(&g13_driver);
+}
+
+static void __exit g13_exit(void)
+{
+	hid_unregister_driver(&g13_driver);
+}
+
+module_init(g13_init);
+module_exit(g13_exit);
+MODULE_DESCRIPTION("Logitech G13 HID Driver");
+MODULE_AUTHOR("Rick L Vinyard Jr (rvinyard@cs.nmsu.edu)");
+MODULE_LICENSE("GPL");
diff -puN drivers/hid/hid-ids.h~hid-logitech-g13-driver-002 drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~hid-logitech-g13-driver-002
+++ a/drivers/hid/hid-ids.h
@@ -295,6 +295,7 @@
 #define USB_DEVICE_ID_LOGITECH_EXTREME_3D	0xc215
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2	0xc218
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2	0xc219
+#define USB_DEVICE_ID_LOGITECH_G13		0xc21c
 #define USB_DEVICE_ID_LOGITECH_WINGMAN_F3D	0xc283
 #define USB_DEVICE_ID_LOGITECH_FORCE3D_PRO	0xc286
 #define USB_DEVICE_ID_LOGITECH_WHEEL	0xc294
_

Patches currently in -mm which might be from rvinyard@cs.nmsu.edu are

hid-logitech-g13-driver-002.patch

