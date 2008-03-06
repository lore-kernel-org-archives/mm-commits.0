From: akpm@linux-foundation.org
Subject: - cypress_m8-added-ups-powercom-0d9f0002.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:18 -0800
Message-ID: <200803062222.m26MMIGx020800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbYCFWe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shapin@googlemail.com, greg@kroah.com, shapin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cypress_m8: add UPS Powercom (0d9f:0002)
has been removed from the -mm tree.  Its filename was
     cypress_m8-added-ups-powercom-0d9f0002.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


