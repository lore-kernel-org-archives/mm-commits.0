From: akpm@linux-foundation.org
Subject: + usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:21:05 -0800
Message-ID: <200812302121.mBULL6hh032000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYL3VV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: fsl_qe_udc: Fix disconnects reporting during bus reset
has been added to the -mm tree.  Its filename is
     usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch

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
Subject: usb: fsl_qe_udc: Fix disconnects reporting during bus reset
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Freescale QE UDC controllers can't report the "port change" states, so the
only way to handle disconnects is to process bus reset interrupts.  The
bus reset can take some time, that is, few irqs.  Gadgets may print the
disconnection events, and this causes few repetitive messages in the
kernel log.

This patch fixes the issue by using the usb_state machine, if the usb
controller has been already reset, just quit the reset irq early.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -2161,6 +2161,9 @@ static int reset_irq(struct qe_udc *udc)
 {
 	unsigned char i;
 
+	if (udc->usb_state == USB_STATE_DEFAULT)
+		return 0;
+
 	qe_usb_disable();
 	out_8(&udc->usb_regs->usb_usadr, 0);
 
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

