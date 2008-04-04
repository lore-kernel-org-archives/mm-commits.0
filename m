From: akpm@linux-foundation.org
Subject: - xpad-match-xbox-360-devices-with-interface-info.patch removed from -mm tree
Date: Fri, 04 Apr 2008 14:51:04 -0700
Message-ID: <200804042151.m34Lp51b010602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbYDDVvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 17:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anssi.hannula@gmail.com, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     xpad: match xbox 360 devices with interface info
has been removed from the -mm tree.  Its filename was
     xpad-match-xbox-360-devices-with-interface-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xpad: match xbox 360 devices with interface info
From: Anssi Hannula <anssi.hannula@gmail.com>

Match Xbox 360 controllers using the interface info, i.e.  interface class 255
(Vendor specific), subclass 93 and protocol 1, instead of specifying the
device ids individually.  As the class is vendor-specific, we have to still
match against vendor id as well, though.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/xpad.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN drivers/input/joystick/xpad.c~xpad-match-xbox-360-devices-with-interface-info drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~xpad-match-xbox-360-devices-with-interface-info
+++ a/drivers/input/joystick/xpad.c
@@ -91,6 +91,7 @@
 
 #define XTYPE_XBOX        0
 #define XTYPE_XBOX360     1
+#define XTYPE_UNKNOWN     2
 
 static int dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -138,7 +139,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
-	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_XBOX }
+	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_UNKNOWN }
 };
 
 static const signed short xpad_btn[] = {
@@ -173,12 +174,20 @@ static const signed short xpad_abs_pad[]
 	-1			/* terminating entry */
 };
 
-/* Xbox 360 has a vendor-specific (sub)class, so we cannot match it with only
- * USB_INTERFACE_INFO, more to that this device has 4 InterfaceProtocols,
- * but we need only one of them. */
+/* Xbox 360 has a vendor-specific class, so we cannot match it with only
+ * USB_INTERFACE_INFO (also specifically refused by USB subsystem), so we
+ * match against vendor id as well. Also, some Xbox 360 devices have multiple
+ * interface protocols, we only need protocol 1. */
+#define XPAD_XBOX360_VENDOR(vend) \
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
+	.idVendor = (vend), \
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
+	.bInterfaceSubClass = 93, \
+	.bInterfaceProtocol = 1
+
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
-	{ USB_DEVICE_INTERFACE_PROTOCOL(0x045e, 0x028e, 1) },	/* X-Box 360 controller */
+	{ XPAD_XBOX360_VENDOR(0x045e) },	/* Microsoft X-Box 360 controllers */
 	{ }
 };
 
@@ -645,6 +654,8 @@ static int xpad_probe(struct usb_interfa
 	xpad->xtype = xpad_device[i].xtype;
 	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
 		xpad->dpad_mapping = dpad_to_buttons;
+	if (xpad->xtype == XTYPE_UNKNOWN)
+		xpad->xtype = (intf->cur_altsetting->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC);
 	xpad->dev = input_dev;
 	usb_make_path(udev, xpad->phys, sizeof(xpad->phys));
 	strlcat(xpad->phys, "/input0", sizeof(xpad->phys));
_

Patches currently in -mm which might be from anssi.hannula@gmail.com are

git-hid.patch
git-input.patch

