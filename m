From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:02:12 -0400
Message-ID: <201004271803.o3RI3jsT011014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622Ab0D0SIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maheshkuruganti@gmail.com, gregkh@suse.de, smurf@smurf.noris.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/option.c: ZTEAC8710 support with Device ID 0xffff
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial/option.c: ZTEAC8710 support with Device ID 0xffff
From: Mahesh Kuruganti <maheshkuruganti@gmail.com>

Extend support to AC8710 with 0xffff product ID.  I tested it and it
compiled with no problem and I am using it now as i type.

Signed-off-by: Mahesh Kuruganti <maheshkuruganti@gmail.com>
Cc: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/serial/option.c~drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff
+++ a/drivers/usb/serial/option.c
@@ -305,6 +305,8 @@ static int  option_resume(struct usb_ser
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 #define ZTE_PRODUCT_AC8710			0xfff1
 #define ZTE_PRODUCT_AC2726			0xfff5
+/* There seems to be an Alternate Device ID for the AC8710 supplied in India */
+#define ZTE_PRODUCT_AC8710T			0xffff
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -678,6 +680,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
_

Patches currently in -mm which might be from maheshkuruganti@gmail.com are

linux-next.patch

