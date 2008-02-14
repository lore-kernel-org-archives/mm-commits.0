From: akpm@linux-foundation.org
Subject: + cypress_m8-added-ups-powercom-0d9f0002.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:39:46 -0800
Message-ID: <200802142239.m1EMdkFS006704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbYBNWkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shapin@googlemail.com, greg@kroah.com, shapin@gmail.com


The patch titled
     cypress_m8: add UPS Powercom (0d9f:0002)
has been added to the -mm tree.  Its filename is
     cypress_m8-added-ups-powercom-0d9f0002.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cypress_m8: add UPS Powercom (0d9f:0002)
From: Dmitry Shapin <shapin@googlemail.com>

Add support for UPS Powercom USB interface (0d9f:0002) in chip CY7C63723. 
In my case, this Powercom BNT800AP.

Signed-off-by: Dmitry Shapin <shapin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cypress_m8.c |    2 ++
 drivers/usb/serial/cypress_m8.h |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN drivers/usb/serial/cypress_m8.c~cypress_m8-added-ups-powercom-0d9f0002 drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~cypress_m8-added-ups-powercom-0d9f0002
+++ a/drivers/usb/serial/cypress_m8.c
@@ -94,6 +94,7 @@ static struct usb_device_id id_table_ear
 
 static struct usb_device_id id_table_cyphidcomrs232 [] = {
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
 	{ }						/* Terminating entry */
 };
 
@@ -106,6 +107,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB) },
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
+	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
 	{ USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
 	{ }						/* Terminating entry */
 };
diff -puN drivers/usb/serial/cypress_m8.h~cypress_m8-added-ups-powercom-0d9f0002 drivers/usb/serial/cypress_m8.h
--- a/drivers/usb/serial/cypress_m8.h~cypress_m8-added-ups-powercom-0d9f0002
+++ a/drivers/usb/serial/cypress_m8.h
@@ -19,6 +19,10 @@
 #define VENDOR_ID_CYPRESS		 0x04b4
 #define PRODUCT_ID_CYPHIDCOM		 0x5500
 
+/* Powercom UPS, chip CY7C63723 */
+#define VENDOR_ID_POWERCOM		 0x0d9f
+#define PRODUCT_ID_UPS			 0x0002
+
 /* Nokia CA-42 USB to serial cable */
 #define VENDOR_ID_DAZZLE		0x07d0
 #define PRODUCT_ID_CA42			0x4101
_

Patches currently in -mm which might be from shapin@googlemail.com are

cypress_m8-added-ups-powercom-0d9f0002.patch
