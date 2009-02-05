From: akpm@linux-foundation.org
Subject: [merged] usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:34 -0800
Message-ID: <200902051914.n15JEY07011912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358AbZBETSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:18:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: fsl_qe_udc: Fix QE USB controller initialization
has been removed from the -mm tree.  Its filename was
     usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fsl_qe_udc: Fix QE USB controller initialization
From: Anton Vorontsov <avorontsov@ru.mvista.com>

qe_udc_reg_init() leaves the USB controller enabled before muram memory
initialized.  Sometimes the uninitialized muram memory confuses the
controller, and it start sending the busy interrupts.

Fix this by disabling the controller, it will be enabled later by the
gadget driver, at bind time.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-qe-usb-controller-initialization drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-qe-usb-controller-initialization
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -2452,8 +2452,12 @@ static int __devinit qe_udc_reg_init(str
 	struct usb_ctlr __iomem *qe_usbregs;
 	qe_usbregs = udc->usb_regs;
 
-	/* Init the usb register */
+	/* Spec says that we must enable the USB controller to change mode. */
 	out_8(&qe_usbregs->usb_usmod, 0x01);
+	/* Mode changed, now disable it, since muram isn't initialized yet. */
+	out_8(&qe_usbregs->usb_usmod, 0x00);
+
+	/* Initialize the rest. */
 	out_be16(&qe_usbregs->usb_usbmr, 0);
 	out_8(&qe_usbregs->usb_uscom, 0);
 	out_be16(&qe_usbregs->usb_usber, USBER_ALL_CLEAR);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch

