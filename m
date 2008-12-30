From: akpm@linux-foundation.org
Subject: + usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:21:09 -0800
Message-ID: <200812302121.mBULL9k3032012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYL3VVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: fsl_qe_udc: Fix stalled TX requests bug
has been added to the -mm tree.  Its filename is
     usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

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
Subject: usb: fsl_qe_udc: Fix stalled TX requests bug
From: Anton Vorontsov <avorontsov@ru.mvista.com>

While disabling an endpoint the driver nuking any pending requests, thus
completing them with -ESHUTDOWN status.  But the driver doesn't clear the
tx_req, which means that a next TX request (after ep_enable), might get
stalled, since the driver won't queue the new reqests.

This patch fixes a bug I'm observing with ethernet gadget while playing
with ifconfig usb0 up/down (the up/down sequence disables and enables `in'
and `out' endpoints).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-stalled-tx-requests-bug drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-stalled-tx-requests-bug
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -1622,6 +1622,7 @@ static int qe_ep_disable(struct usb_ep *
 	nuke(ep, -ESHUTDOWN);
 	ep->desc = NULL;
 	ep->stopped = 1;
+	ep->tx_req = NULL;
 	qe_ep_reset(udc, ep->epnum);
 	spin_unlock_irqrestore(&udc->lock, flags);
 
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

