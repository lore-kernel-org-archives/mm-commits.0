From: akpm@linux-foundation.org
Subject: + usbhid-add-asus-lcm-to-the-blacklist.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:40:52 -0700
Message-ID: <200707270640.l6R6equi009940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850AbXG0Gk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chunkeey@web.de, greg@kroah.com


The patch titled
     usbhid: add ASUS LCM to the blacklist
has been added to the -mm tree.  Its filename is
     usbhid-add-asus-lcm-to-the-blacklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbhid: add ASUS LCM to the blacklist
From: Christian Lamparter <chunkeey@web.de>

Some of ASUS' notebooks (e.g G Series) include a tiny oled display, which
is attached to an internal USB bus.  Unfortunatly the device reports a
wrong DeviceDescriptor and is therefore identified as a HID device...

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-quirks.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/hid/usbhid/hid-quirks.c~usbhid-add-asus-lcm-to-the-blacklist drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~usbhid-add-asus-lcm-to-the-blacklist
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -63,6 +63,9 @@
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IR		0x8240
 
+#define USB_VENDOR_ID_ASUS		0x0b05
+#define USB_DEVICE_ID_ASUS_LCM		0x1726
+
 #define USB_VENDOR_ID_ATEN		0x0557
 #define USB_DEVICE_ID_ATEN_UC100KM	0x2004
 #define USB_DEVICE_ID_ATEN_CS124U	0x2202
@@ -464,6 +467,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
 
+	{ USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_LCM, HID_QUIRK_IGNORE},
+
 	{ 0, 0 }
 };
 
_

Patches currently in -mm which might be from chunkeey@web.de are

usbhid-add-asus-lcm-to-the-blacklist.patch
