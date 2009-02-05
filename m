From: akpm@linux-foundation.org
Subject: [merged] usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:29 -0800
Message-ID: <200902051914.n15JETX6011683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759794AbZBETPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: fsl_qe_udc: Fix oops on QE UDC probe failure
has been removed from the -mm tree.  Its filename was
     usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fsl_qe_udc: Fix oops on QE UDC probe failure
From: Anton Vorontsov <avorontsov@ru.mvista.com>

In case of probing errors the driver kfrees the udc_controller, but it
doesn't set the pointer to NULL.

When usb_gadget_register_driver is called, it checks for udc_controller !=
NULL, the check passes and the driver accesses nonexistent memory.  Fix
this by setting udc_controller to NULL in case of errors.

While at it, also implement irq_of_parse_and_map()'s failure and cleanup
cases.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -2604,6 +2604,10 @@ static int __devinit qe_udc_probe(struct
 			(unsigned long)udc_controller);
 	/* request irq and disable DR  */
 	udc_controller->usb_irq = irq_of_parse_and_map(np, 0);
+	if (!udc_controller->usb_irq) {
+		ret = -EINVAL;
+		goto err_noirq;
+	}
 
 	ret = request_irq(udc_controller->usb_irq, qe_udc_irq, 0,
 				driver_name, udc_controller);
@@ -2625,6 +2629,8 @@ static int __devinit qe_udc_probe(struct
 err6:
 	free_irq(udc_controller->usb_irq, udc_controller);
 err5:
+	irq_dispose_mapping(udc_controller->usb_irq);
+err_noirq:
 	if (udc_controller->nullmap) {
 		dma_unmap_single(udc_controller->gadget.dev.parent,
 			udc_controller->nullp, 256,
@@ -2648,7 +2654,7 @@ err2:
 	iounmap(udc_controller->usb_regs);
 err1:
 	kfree(udc_controller);
-
+	udc_controller = NULL;
 	return ret;
 }
 
@@ -2710,6 +2716,7 @@ static int __devexit qe_udc_remove(struc
 	kfree(ep->txframe);
 
 	free_irq(udc_controller->usb_irq, udc_controller);
+	irq_dispose_mapping(udc_controller->usb_irq);
 
 	tasklet_kill(&udc_controller->rx_tasklet);
 
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

