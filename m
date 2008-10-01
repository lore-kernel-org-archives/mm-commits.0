From: akpm@linux-foundation.org
Subject: - usb-ftdi_sio-add-support-for-domintell-devices.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:09 -0700
Message-ID: <200810012152.m91Lq9FN006030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYJAVwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcpatch@gmail.com, abbotti@mev.co.uk, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: ftdi_sio: add support for Domintell devices
has been removed from the -mm tree.  Its filename was
     usb-ftdi_sio-add-support-for-domintell-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: ftdi_sio: add support for Domintell devices
From: Gaetan Carlier <gcpatch@gmail.com>

Support for Domintell devices (FTDI FT232BM based) : DGQG and DUSB01
module.  PIDs were missing.

Signed-off-by: Gaetan Carlier <gcpatch@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-add-support-for-domintell-devices drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-add-support-for-domintell-devices
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -655,6 +655,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/ftdi_sio.h~usb-ftdi_sio-add-support-for-domintell-devices drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~usb-ftdi_sio-add-support-for-domintell-devices
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -839,6 +839,10 @@
 /* Rig Expert Ukraine devices */
 #define FTDI_REU_TINY_PID		0xED22	/* RigExpert Tiny */
 
+/* Domintell products  http://www.domintell.com */
+#define FTDI_DOMINTELL_DGQG_PID	0xEF50	/* Master */
+#define FTDI_DOMINTELL_DUSB_PID	0xEF51	/* DUSB01 module */
+
 /* Commands */
 #define FTDI_SIO_RESET 		0 /* Reset the port */
 #define FTDI_SIO_MODEM_CTRL 	1 /* Set the modem control register */
_

Patches currently in -mm which might be from gcpatch@gmail.com are


