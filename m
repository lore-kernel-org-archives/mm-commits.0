From: akpm@osdl.org
Subject: + input-hid-add-cidc-usb-device-to-hid-blacklist.patch added to -mm tree
Date: Tue, 02 Jan 2007 12:48:25 -0800
Message-ID: <200701022048.l02KmQsD029168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXABUt0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 15:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhengxiaojun@hsic.com.cn, dtor@mail.ru, greg@kroah.com


The patch titled
     input: HID: add CIDC USB device to HID blacklist
has been added to the -mm tree.  Its filename is
     input-hid-add-cidc-usb-device-to-hid-blacklist.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: HID: add CIDC USB device to HID blacklist
From: Zheng XiaoJun <zhengxiaojun@hsic.com.cn>

Add CIDC USB device to HID blacklist since it is actually a USB token
and has its own driver.

Signed-off-by: Zheng XiaoJun <zhengxiaojun@hsic.com.cn>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/input/hid-core.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/usb/input/hid-core.c~input-hid-add-cidc-usb-device-to-hid-blacklist drivers/usb/input/hid-core.c
--- a/drivers/usb/input/hid-core.c~input-hid-add-cidc-usb-device-to-hid-blacklist
+++ a/drivers/usb/input/hid-core.c
@@ -965,6 +965,8 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_USB_RECEIVER, HID_QUIRK_BAD_RELATIVE_KEYS },
 
+	{ USB_VENDOR_ID_CIDC, 0x0103, HID_QUIRK_IGNORE },
+
 	{ 0, 0 }
 };
 
@@ -1015,6 +1017,8 @@ static void hid_free_buffers(struct usb_
 		usb_buffer_free(dev, usbhid->bufsize, usbhid->ctrlbuf, usbhid->ctrlbuf_dma);
 }
 
+#define USB_VENDOR_ID_CIDC		0x1677
+
 /*
  * Cherry Cymotion keyboard have an invalid HID report descriptor,
  * that needs fixing before we can parse it.
_

Patches currently in -mm which might be from zhengxiaojun@hsic.com.cn are

input-hid-add-cidc-usb-device-to-hid-blacklist.patch
