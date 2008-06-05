From: akpm@linux-foundation.org
Subject: - usbhid-fix-fn-key-on-macbook-pro-41-and-macbook-air.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:24 -0700
Message-ID: <200806051821.m55ILOcC023225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYFESVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:21:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander@comm.utoronto.ca, dtor@mail.ru, greg@kroah.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     usbhid: fix fn key on Macbook Pro 4,1 and Macbook Air
has been removed from the -mm tree.  Its filename was
     usbhid-fix-fn-key-on-macbook-pro-41-and-macbook-air.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbhid: fix fn key on Macbook Pro 4,1 and Macbook Air
From: Alexandre Karpenko <alexander@comm.utoronto.ca>

Added device ids to hid-quriks for detection of keyboards on 4th
generation Macbook Pro and Macbook Air

The naming scheme is consistent with past Apple keyboards in hid-quirks;
as defined by Apple (including device ids) in:
/System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/Contents/Info.plist
Patch was originally posted and tested at:
https://bugs.launchpad.net/mactel-support/+bug/207127

Signed-off-by: Alexandre Karpenko <alexander@comm.utoronto.ca>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-quirks.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/hid/usbhid/hid-quirks.c~usbhid-fix-fn-key-on-macbook-pro-41-and-macbook-air drivers/hid/usbhid/hid-quirks.c
--- a/drivers/hid/usbhid/hid-quirks.c~usbhid-fix-fn-key-on-macbook-pro-41-and-macbook-air
+++ a/drivers/hid/usbhid/hid-quirks.c
@@ -75,6 +75,12 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI   0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO    0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS    0x0225
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI   0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO    0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS    0x0232
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL	0x8240
@@ -646,6 +652,12 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_HAS_FN },
 
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
_

Patches currently in -mm which might be from alexander@comm.utoronto.ca are

linux-next.patch

