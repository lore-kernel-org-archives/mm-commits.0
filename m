From: akpm@linux-foundation.org
Subject: + usb-bandrich-bandluxe-hsdpa-data-card-driver.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:44:31 -0700
Message-ID: <200704132044.l3DKiVw0008997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXDMUog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: upleong@bandrich.com, greg@kroah.com


The patch titled
     USB: BandRich BandLuxe HSDPA Data Card Driver
has been added to the -mm tree.  Its filename is
     usb-bandrich-bandluxe-hsdpa-data-card-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+)

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

usb-bandrich-bandluxe-hsdpa-data-card-driver.patch
