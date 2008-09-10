From: akpm@linux-foundation.org
Subject: + usb-ftdi_sio-add-support-for-domintell-devices.patch added to -mm tree
Date: Wed, 10 Sep 2008 15:00:01 -0700
Message-ID: <200809102200.m8AM01h1028420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbYIJWAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 18:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcpatch@gmail.com, abbotti@mev.co.uk, gregkh@suse.de


The patch titled
     usb: ftdi_sio: add support for Domintell devices
has been added to the -mm tree.  Its filename is
     usb-ftdi_sio-add-support-for-domintell-devices.patch

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
@@ -654,6 +654,8 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/ftdi_sio.h~usb-ftdi_sio-add-support-for-domintell-devices drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~usb-ftdi_sio-add-support-for-domintell-devices
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -838,6 +838,10 @@
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

usb-ftdi_sio-add-support-for-domintell-devices.patch

