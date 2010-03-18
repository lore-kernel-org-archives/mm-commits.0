From: akpm@linux-foundation.org
Subject: [merged] usb-serial-ftdi-add-contec-vendor-and-product-id.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:07 -0400
Message-ID: <201003181809.o2II9mwh007596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab0CRSK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.sangorrin@gmail.com, andi@lisas.de, gregkh@suse.de, liboska@uochb.cas.cz, mm-commits@vger.kernel.org


The patch titled
     usb: serial: ftdi: add CONTEC vendor and product id
has been removed from the -mm tree.  Its filename was
     usb-serial-ftdi-add-contec-vendor-and-product-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: serial: ftdi: add CONTEC vendor and product id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds identifiers for
CONTEC USB serial converter.  I tested it with the device COM-1(USB)H

[akpm@linux-foundation.org: keep the VIDs sorted a bit]
Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Radek Liboska <liboska@uochb.cas.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi-add-contec-vendor-and-product-id drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi-add-contec-vendor-and-product-id
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -658,6 +658,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(EVOLUTION_VID, EVOLUTION_ER1_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_HYBRID_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_RCM4_PID) },
+	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ARTEMIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16C_PID) },
diff -puN drivers/usb/serial/ftdi_sio_ids.h~usb-serial-ftdi-add-contec-vendor-and-product-id drivers/usb/serial/ftdi_sio_ids.h
--- a/drivers/usb/serial/ftdi_sio_ids.h~usb-serial-ftdi-add-contec-vendor-and-product-id
+++ a/drivers/usb/serial/ftdi_sio_ids.h
@@ -501,6 +501,13 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
 
 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
_

Patches currently in -mm which might be from daniel.sangorrin@gmail.com are

linux-next.patch

