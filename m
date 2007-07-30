From: akpm@linux-foundation.org
Subject: - usbhid-add-asus-lcm-to-the-blacklist.patch removed from -mm tree
Date: Mon, 30 Jul 2007 11:51:29 -0700
Message-ID: <200707301851.l6UIpTUN024907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763031AbXG3Svh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 14:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chunkeey@web.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usbhid: add ASUS LCM to the blacklist
has been removed from the -mm tree.  Its filename was
     usbhid-add-asus-lcm-to-the-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hid.patch
