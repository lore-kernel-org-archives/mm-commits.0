From: akpm@linux-foundation.org
Subject: + usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch added to -mm tree
Date: Tue, 30 Dec 2008 13:21:01 -0800
Message-ID: <200812302121.mBULL12x031935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYL3VXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 16:23:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: fsl_qe_udc: Fix recursive locking bug in ch9getstatus()
has been added to the -mm tree.  Its filename is
     usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch

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
Subject: usb: fsl_qe_udc: Fix recursive locking bug in ch9getstatus()
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The call chain is this:

qe_udc_irq() <- grabs the udc->lock spinlock
rx_irq()
qe_ep0_rx()
ep0_setup_handle()
setup_received_handle()
ch9getstatus()
qe_ep_queue() <- tries to grab the udc->lock again

It seems unsafe to temporarily drop the lock in the ch9getstatus(), so to
fix that bug the lock-less __qe_ep_queue() function implemented and used
by the ch9getstatus().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/fsl_qe_udc.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus drivers/usb/gadget/fsl_qe_udc.c
--- a/drivers/usb/gadget/fsl_qe_udc.c~usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus
+++ a/drivers/usb/gadget/fsl_qe_udc.c
@@ -1681,14 +1681,11 @@ static void qe_free_request(struct usb_e
 		kfree(req);
 }
 
-/* queues (submits) an I/O request to an endpoint */
-static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
-				gfp_t gfp_flags)
+static int __qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct qe_ep *ep = container_of(_ep, struct qe_ep, ep);
 	struct qe_req *req = container_of(_req, struct qe_req, req);
 	struct qe_udc *udc;
-	unsigned long flags;
 	int reval;
 
 	udc = ep->udc;
@@ -1732,7 +1729,7 @@ static int qe_ep_queue(struct usb_ep *_e
 	list_add_tail(&req->queue, &ep->queue);
 	dev_vdbg(udc->dev, "gadget have request in %s! %d\n",
 			ep->name, req->req.length);
-	spin_lock_irqsave(&udc->lock, flags);
+
 	/* push the request to device */
 	if (ep_is_in(ep))
 		reval = ep_req_send(ep, req);
@@ -1748,11 +1745,24 @@ static int qe_ep_queue(struct usb_ep *_e
 	if (ep->dir == USB_DIR_OUT)
 		reval = ep_req_receive(ep, req);
 
-	spin_unlock_irqrestore(&udc->lock, flags);
-
 	return 0;
 }
 
+/* queues (submits) an I/O request to an endpoint */
+static int qe_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
+		       gfp_t gfp_flags)
+{
+	struct qe_ep *ep = container_of(_ep, struct qe_ep, ep);
+	struct qe_udc *udc = ep->udc;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&udc->lock, flags);
+	ret = __qe_ep_queue(_ep, _req);
+	spin_unlock_irqrestore(&udc->lock, flags);
+	return ret;
+}
+
 /* dequeues (cancels, unlinks) an I/O request from an endpoint */
 static int qe_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 {
@@ -2008,7 +2018,7 @@ static void ch9getstatus(struct qe_udc *
 	udc->ep0_dir = USB_DIR_IN;
 
 	/* data phase */
-	status = qe_ep_queue(&ep->ep, &req->req, GFP_ATOMIC);
+	status = __qe_ep_queue(&ep->ep, &req->req);
 
 	if (status == 0)
 		return;
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

