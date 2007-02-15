From: akpm@linux-foundation.org
Subject: - input-hid-add-cidc-usb-device-to-hid-blacklist.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:28 -0800
Message-ID: <200702150851.l1F8pSSE025299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965586AbXBOIwc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhengxiaojun@hsic.com.cn, dtor@mail.ru, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     input: HID: add CIDC USB device to HID blacklist
has been removed from the -mm tree.  Its filename was
     input-hid-add-cidc-usb-device-to-hid-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: input: HID: add CIDC USB device to HID blacklist
From: Zheng XiaoJun <zhengxiaojun@hsic.com.cn>

Add CIDC USB device to HID blacklist since it is actually a USB token
and has its own driver.

Signed-off-by: Zheng XiaoJun <zhengxiaojun@hsic.com.cn>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/input/hid-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/input/hid-core.c~input-hid-add-cidc-usb-device-to-hid-blacklist drivers/usb/input/hid-core.c
--- a/drivers/usb/input/hid-core.c~input-hid-add-cidc-usb-device-to-hid-blacklist
+++ a/drivers/usb/input/hid-core.c
@@ -516,6 +516,7 @@ void usbhid_close(struct hid_device *hid
 
 #define USB_VENDOR_ID_TURBOX		0x062a
 #define USB_DEVICE_ID_TURBOX_KEYBOARD	0x0201
+#define USB_VENDOR_ID_CIDC		0x1677
 
 /*
  * Initialize all reports
@@ -954,6 +955,8 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER, HID_QUIRK_SONY_PS3_CONTROLLER },
 
+	{ USB_VENDOR_ID_CIDC, 0x0103, HID_QUIRK_IGNORE },
+
 	{ 0, 0 }
 };
 
_

Patches currently in -mm which might be from zhengxiaojun@hsic.com.cn are
