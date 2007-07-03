From: akpm@linux-foundation.org
Subject: + irtouchsystems-support-for-usbtouchscreen.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:20:27 -0700
Message-ID: <200707031820.l63IKSCP007484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbXGCSVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     IRTOUCHSYSTEMS support for usbtouchscreen
has been added to the -mm tree.  Its filename is
     irtouchsystems-support-for-usbtouchscreen.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IRTOUCHSYSTEMS support for usbtouchscreen
From: Ondrej Zary <linux@rainbow-software.org>

Add support for IRTOUCHSYSTEMS (or UNITOP) infrared touchscreens.

The manufacturer (http://www.irtouch.com) provides only closed source
drivers for specific kernel versions (looks like GPL violation, btw.) which
I haven't even tried (as there's no chance that any of the modules could
work with 2.6.22-rc kernel).  They also don't provide any protocol
specification.

So I made this code after observing the data stream with usbmon for a
while.  If someone is interested in my observations, here are the results:

The touchscreen sends data in 8-byte packets.
BYTE 0 - unknown meaning, seen only one value: 0x54
BYTE 1 - unknown meaning, 3 lowest bits indicate touch state
        values seen: 0x81, 0x82 or 0x83
        bit 0 = set if the screen is touched and was not touched before (touch
        bit 1 = set if the screen is touched and was touched (dragging)
        bit 2 = set if the touch was ended (release)
BYTES 2 and 3 - X position, high-order-byte first, range = 0 to 0x0FFF
BYTES 4 and 5 - Y position, high-order-byte first, range = 0 to 0x0FFF
BYTE 6 - unknown meaning, seen only one value: 0xFF
BYTE 7 - unknown meaning, seen only one value: 0x00

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig          |    6 +++
 drivers/input/touchscreen/usbtouchscreen.c |   33 +++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN drivers/input/touchscreen/Kconfig~irtouchsystems-support-for-usbtouchscreen drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~irtouchsystems-support-for-usbtouchscreen
+++ a/drivers/input/touchscreen/Kconfig
@@ -190,6 +190,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 	  - some other eTurboTouch
 	  - Gunze AHL61
 	  - DMC TSC-10/25
+	  - IRTOUCHSYSTEMS/UNITOP
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -232,4 +233,9 @@ config TOUCHSCREEN_USB_DMC_TSC10
 	bool "DMC TSC-10/25 device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_IRTOUCH
+	default y
+	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 endif
diff -puN drivers/input/touchscreen/usbtouchscreen.c~irtouchsystems-support-for-usbtouchscreen drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~irtouchsystems-support-for-usbtouchscreen
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -9,6 +9,7 @@
  *  - eTurboTouch
  *  - Gunze AHL61
  *  - DMC TSC-10/25
+ *  - IRTOUCHSYSTEMS/UNITOP
  *
  * Copyright (C) 2004-2006 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -110,6 +111,7 @@ enum {
 	DEVTYPE_ETURBO,
 	DEVTYPE_GUNZE,
 	DEVTYPE_DMC_TSC10,
+	DEVTYPE_IRTOUCH,
 };
 
 static struct usb_device_id usbtouch_devices[] = {
@@ -150,6 +152,11 @@ static struct usb_device_id usbtouch_dev
 	{USB_DEVICE(0x0afa, 0x03e8), .driver_info = DEVTYPE_DMC_TSC10},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+	{USB_DEVICE(0x595a, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
+	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
+#endif
+
 	{}
 };
 
@@ -416,6 +423,21 @@ static int dmc_tsc10_read_data(struct us
 
 
 /*****************************************************************************
+ * IRTOUCH Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+static int irtouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	dev->x = (pkt[3] << 8) | pkt[2];
+	dev->y = (pkt[5] << 8) | pkt[4];
+	dev->touch = (pkt[1] & 0x03) ? 1 : 0;
+
+	return 1;
+}
+#endif
+
+
+/*****************************************************************************
  * the different device descriptors
  */
 static struct usbtouch_device_info usbtouch_dev_info[] = {
@@ -504,6 +526,17 @@ static struct usbtouch_device_info usbto
 		.read_data	= dmc_tsc10_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+	[DEVTYPE_IRTOUCH] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 8,
+		.read_data	= irtouch_read_data,
+	},
+#endif
 };
 
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

irtouchsystems-support-for-usbtouchscreen.patch
