From: akpm@linux-foundation.org
Subject: - usb-bandrich-bandluxe-hsdpa-data-card-driver.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:54:42 -0700
Message-ID: <200704281054.l3SAsgXP020135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965737AbXD1Ky7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: upleong@bandrich.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: BandRich BandLuxe HSDPA Data Card Driver
has been removed from the -mm tree.  Its filename was
     usb-bandrich-bandluxe-hsdpa-data-card-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: BandRich BandLuxe HSDPA Data Card Driver
From: Leon Leong <upleong@bandrich.com>

Add the detection for the BandRich BandLuxe C100/C100S/C120 HSDPA Data
Card.  With the vendor and product IDs are set properly, the data card can
be detected and works fine.

Signed-off-by: Leon Leong <upleong@bandrich.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/usb/serial/option.c~usb-bandrich-bandluxe-hsdpa-data-card-driver drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-bandrich-bandluxe-hsdpa-data-card-driver
+++ a/drivers/usb/serial/option.c
@@ -113,6 +113,10 @@ static int  option_send_setup(struct usb
 #define ANYDATA_VENDOR_ID			0x16d5
 #define ANYDATA_PRODUCT_ID			0x6501
 
+#define BANDRICH_VENDOR_ID			0x1A8D
+#define BANDRICH_PRODUCT_C100_1			0x1002
+#define BANDRICH_PRODUCT_C100_2			0x1003
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -165,6 +169,8 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2130) }, /* Novatel Merlin ES620 SM Bus */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2410) }, /* Novatel EU740 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
_

Patches currently in -mm which might be from upleong@bandrich.com are

origin.patch
