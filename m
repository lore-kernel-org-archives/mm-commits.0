From: akpm@linux-foundation.org
Subject: + usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:21:03 -0800
Message-ID: <200812302121.mBULL3re031997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbYL3VVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: fsl_qe_udc: Fix QE USB controller initialization
has been added to the -mm tree.  Its filename is
     usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch

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
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch

