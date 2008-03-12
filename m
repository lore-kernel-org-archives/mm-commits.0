From: akpm@linux-foundation.org
Subject: + svcrdma-add-xprt-refs-to-fix-close-unmount-crash.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:57:07 -0700
Message-ID: <200803120457.m2C4v7wj010917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYCLE56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom@opengridcomputing.com, bfields@citi.umich.edu, rolandd@cisco.com


The patch titled
     SVCRDMA: Add xprt refs to fix close/unmount crash
has been added to the -mm tree.  Its filename is
     svcrdma-add-xprt-refs-to-fix-close-unmount-crash.patch

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
Subject: SVCRDMA: Add xprt refs to fix close/unmount crash
From: Tom Tucker <tom@opengridcomputing.com>

RDMA connection shutdown on an SMP machine can cause a kernel crash due
to the transport close path racing with the I/O tasklet.

Additional transport references were added as follows:
- A reference when on the DTO Q to avoid having the transport
  deleted while queued for I/O.
- A reference while there is a QP able to generate events.
- A reference until the DISCONNECTED event is received on the CM ID

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_transport.c |   96 ++++++++++++---------
 1 file changed, 58 insertions(+), 38 deletions(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_transport.c~svcrdma-add-xprt-refs-to-fix-close-unmount-crash net/sunrpc/xprtrdma/svc_rdma_transport.c
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c~svcrdma-add-xprt-refs-to-fix-close-unmount-crash
+++ a/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -54,7 +54,6 @@ static struct svc_xprt *svc_rdma_create(
 					int flags);
 static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt);
 static void svc_rdma_release_rqst(struct svc_rqst *);
-static void rdma_destroy_xprt(struct svcxprt_rdma *xprt);
 static void dto_tasklet_func(unsigned long data);
 static void svc_rdma_detach(struct svc_xprt *xprt);
 static void svc_rdma_free(struct svc_xprt *xprt);
@@ -247,6 +246,7 @@ static void dto_tasklet_func(unsigned lo
 			sq_cq_reap(xprt);
 		}
 
+		svc_xprt_put(&xprt->sc_xprt);
 		spin_lock_irqsave(&dto_lock, flags);
 	}
 	spin_unlock_irqrestore(&dto_lock, flags);
@@ -275,8 +275,10 @@ static void rq_comp_handler(struct ib_cq
 	 * add it
 	 */
 	spin_lock_irqsave(&dto_lock, flags);
-	if (list_empty(&xprt->sc_dto_q))
+	if (list_empty(&xprt->sc_dto_q)) {
+		svc_xprt_get(&xprt->sc_xprt);
 		list_add_tail(&xprt->sc_dto_q, &dto_xprt_q);
+	}
 	spin_unlock_irqrestore(&dto_lock, flags);
 
 	/* Tasklet does all the work to avoid irqsave locks. */
@@ -386,8 +388,10 @@ static void sq_comp_handler(struct ib_cq
 	 * add it
 	 */
 	spin_lock_irqsave(&dto_lock, flags);
-	if (list_empty(&xprt->sc_dto_q))
+	if (list_empty(&xprt->sc_dto_q)) {
+		svc_xprt_get(&xprt->sc_xprt);
 		list_add_tail(&xprt->sc_dto_q, &dto_xprt_q);
+	}
 	spin_unlock_irqrestore(&dto_lock, flags);
 
 	/* Tasklet does all the work to avoid irqsave locks. */
@@ -611,6 +615,7 @@ static int rdma_cma_handler(struct rdma_
 	switch (event->event) {
 	case RDMA_CM_EVENT_ESTABLISHED:
 		/* Accept complete */
+		svc_xprt_get(xprt);
 		dprintk("svcrdma: Connection completed on DTO xprt=%p, "
 			"cm_id=%p\n", xprt, cma_id);
 		clear_bit(RDMAXPRT_CONN_PENDING, &rdma->sc_flags);
@@ -661,15 +666,15 @@ static struct svc_xprt *svc_rdma_create(
 
 	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);
 	if (IS_ERR(listen_id)) {
-		rdma_destroy_xprt(cma_xprt);
+		svc_xprt_put(&cma_xprt->sc_xprt);
 		dprintk("svcrdma: rdma_create_id failed = %ld\n",
 			PTR_ERR(listen_id));
 		return (void *)listen_id;
 	}
 	ret = rdma_bind_addr(listen_id, sa);
 	if (ret) {
-		rdma_destroy_xprt(cma_xprt);
 		rdma_destroy_id(listen_id);
+		svc_xprt_put(&cma_xprt->sc_xprt);
 		dprintk("svcrdma: rdma_bind_addr failed = %d\n", ret);
 		return ERR_PTR(ret);
 	}
@@ -678,8 +683,9 @@ static struct svc_xprt *svc_rdma_create(
 	ret = rdma_listen(listen_id, RPCRDMA_LISTEN_BACKLOG);
 	if (ret) {
 		rdma_destroy_id(listen_id);
-		rdma_destroy_xprt(cma_xprt);
+		svc_xprt_put(&cma_xprt->sc_xprt);
 		dprintk("svcrdma: rdma_listen failed = %d\n", ret);
+		return ERR_PTR(ret);
 	}
 
 	/*
@@ -820,6 +826,7 @@ static struct svc_xprt *svc_rdma_accept(
 		newxprt->sc_sq_depth = qp_attr.cap.max_send_wr;
 		newxprt->sc_max_requests = qp_attr.cap.max_recv_wr;
 	}
+	svc_xprt_get(&newxprt->sc_xprt);
 	newxprt->sc_qp = newxprt->sc_cm_id->qp;
 
 	/* Register all of physical memory */
@@ -891,8 +898,15 @@ static struct svc_xprt *svc_rdma_accept(
 
  errout:
 	dprintk("svcrdma: failure accepting new connection rc=%d.\n", ret);
+	/* Take a reference in case the DTO handler runs */
+	svc_xprt_get(&newxprt->sc_xprt);
+	if (newxprt->sc_qp && !IS_ERR(newxprt->sc_qp)) {
+		ib_destroy_qp(newxprt->sc_qp);
+		svc_xprt_put(&newxprt->sc_xprt);
+	}
 	rdma_destroy_id(newxprt->sc_cm_id);
-	rdma_destroy_xprt(newxprt);
+	/* This call to put will destroy the transport */
+	svc_xprt_put(&newxprt->sc_xprt);
 	return NULL;
 }
 
@@ -919,54 +933,60 @@ static void svc_rdma_release_rqst(struct
 	rqstp->rq_xprt_ctxt = NULL;
 }
 
-/* Disable data ready events for this connection */
+/*
+ * When connected, an svc_xprt has at least three references:
+ *
+ * - A reference held by the QP. We still hold that here because this
+ *   code deletes the QP and puts the reference.
+ *
+ * - A reference held by the cm_id between the ESTABLISHED and
+ *   DISCONNECTED events. If the remote peer disconnected first, this
+ *   reference could be gone.
+ *
+ * - A reference held by the svc_recv code that called this function
+ *   as part of close processing.
+ *
+ * At a minimum two references should still be held.
+ */
 static void svc_rdma_detach(struct svc_xprt *xprt)
 {
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
-	unsigned long flags;
-
 	dprintk("svc: svc_rdma_detach(%p)\n", xprt);
-	/*
-	 * Shutdown the connection. This will ensure we don't get any
-	 * more events from the provider.
-	 */
+
+	/* Disconnect and flush posted WQE */
 	rdma_disconnect(rdma->sc_cm_id);
-	rdma_destroy_id(rdma->sc_cm_id);
 
-	/* We may already be on the DTO list */
-	spin_lock_irqsave(&dto_lock, flags);
-	if (!list_empty(&rdma->sc_dto_q))
-		list_del_init(&rdma->sc_dto_q);
-	spin_unlock_irqrestore(&dto_lock, flags);
+	/* Destroy the QP if present (not a listener) */
+	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp)) {
+		ib_destroy_qp(rdma->sc_qp);
+		svc_xprt_put(xprt);
+	}
+
+	/* Destroy the CM ID */
+	rdma_destroy_id(rdma->sc_cm_id);
 }
 
 static void svc_rdma_free(struct svc_xprt *xprt)
 {
 	struct svcxprt_rdma *rdma = (struct svcxprt_rdma *)xprt;
 	dprintk("svcrdma: svc_rdma_free(%p)\n", rdma);
-	rdma_destroy_xprt(rdma);
-	kfree(rdma);
-}
-
-static void rdma_destroy_xprt(struct svcxprt_rdma *xprt)
-{
-	if (xprt->sc_qp && !IS_ERR(xprt->sc_qp))
-		ib_destroy_qp(xprt->sc_qp);
-
-	if (xprt->sc_sq_cq && !IS_ERR(xprt->sc_sq_cq))
-		ib_destroy_cq(xprt->sc_sq_cq);
+	/* We should only be called from kref_put */
+	BUG_ON(atomic_read(&xprt->xpt_ref.refcount) != 0);
+	if (rdma->sc_sq_cq && !IS_ERR(rdma->sc_sq_cq))
+		ib_destroy_cq(rdma->sc_sq_cq);
 
-	if (xprt->sc_rq_cq && !IS_ERR(xprt->sc_rq_cq))
-		ib_destroy_cq(xprt->sc_rq_cq);
+	if (rdma->sc_rq_cq && !IS_ERR(rdma->sc_rq_cq))
+		ib_destroy_cq(rdma->sc_rq_cq);
 
-	if (xprt->sc_phys_mr && !IS_ERR(xprt->sc_phys_mr))
-		ib_dereg_mr(xprt->sc_phys_mr);
+	if (rdma->sc_phys_mr && !IS_ERR(rdma->sc_phys_mr))
+		ib_dereg_mr(rdma->sc_phys_mr);
 
-	if (xprt->sc_pd && !IS_ERR(xprt->sc_pd))
-		ib_dealloc_pd(xprt->sc_pd);
+	if (rdma->sc_pd && !IS_ERR(rdma->sc_pd))
+		ib_dealloc_pd(rdma->sc_pd);
 
-	destroy_context_cache(xprt->sc_ctxt_head);
+	destroy_context_cache(rdma->sc_ctxt_head);
+	kfree(rdma);
 }
 
 static int svc_rdma_has_wspace(struct svc_xprt *xprt)
_

Patches currently in -mm which might be from tom@opengridcomputing.com are

svcrdma-add-xprt-refs-to-fix-close-unmount-crash.patch
svcrdma-fix-erroneous-bug_on-in-send_write.patch

