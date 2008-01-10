From: akpm@linux-foundation.org
Subject: + usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter.patch added to -mm tree
Date: Thu, 10 Jan 2008 00:06:44 -0800
Message-ID: <200801100806.m0A86OUk012154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbYAJIHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 03:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dexter@debian.org, greg@kroah.com, mingo@elte.hu


The patch titled
     usb: add support for 4348:5523 WinChipHead USB->RS 232 adapter
has been added to the -mm tree.  Its filename is
     usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: add support for 4348:5523 WinChipHead USB->RS 232 adapter
From: Piotr Roszatycki <dexter@debian.org>

add support for:

  4348:5523 WinChipHead USB->RS 232 adapter with Prolifec PL 2303 chipset

[ mingo@elte.hu: merged it and nursed it upstream ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN drivers/usb/serial/pl2303.c~usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter
+++ a/drivers/usb/serial/pl2303.c
@@ -87,6 +87,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
+	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff -puN drivers/usb/serial/pl2303.h~usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter drivers/usb/serial/pl2303.h
--- a/drivers/usb/serial/pl2303.h~usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter
+++ a/drivers/usb/serial/pl2303.h
@@ -107,3 +107,8 @@
 /* Corega CG-USBRS232R Serial Adapter */
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
+
+/* HL HL-340 (ID: 4348:5523) */
+#define HL340_VENDOR_ID		0x4348
+#define HL340_PRODUCT_ID	0x5523
+
_

Patches currently in -mm which might be from dexter@debian.org are

usb-add-support-for-43485523-winchiphead-usb-rs-232-adapter.patch
