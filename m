From: akpm@linux-foundation.org
Subject: + usb-serial-ftdi-add-contec-vendor-and-product-id.patch added to -mm tree
Date: Mon, 22 Feb 2010 17:08:00 -0800
Message-ID: <201002230108.o1N1803t002488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0BWBIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 20:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.sangorrin@gmail.com, andi@lisas.de, gregkh@suse.de, liboska@uochb.cas.cz


The patch titled
     usb: serial: ftdi: add CONTEC vendor and product id
has been added to the -mm tree.  Its filename is
     usb-serial-ftdi-add-contec-vendor-and-product-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: serial: ftdi: add CONTEC vendor and product id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds identifiers for
CONTEC USB serial converter.  I tested it with the device COM-1(USB)H

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
@@ -1004,6 +1004,13 @@
 #define EVO_RCM4_PID		0x0303	/* Evolution robotics RCM4 PID */
 
 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * MJS Gadgets HD Radio / XM Radio / Sirius Radio interfaces (using VID 0x0403)
  */
 #define MJSG_GENERIC_PID	0x9378
_

Patches currently in -mm which might be from daniel.sangorrin@gmail.com are

usb-serial-ftdi-add-contec-vendor-and-product-id.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch

