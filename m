From: akpm@linux-foundation.org
Subject: [patch 10/26] userfaultfd: non-cooperative: release all ctx in
 dup_userfaultfd_complete
Date: Thu, 09 Mar 2017 16:16:54 -0800
Message-ID: <58c1f076.kHQfnykLVSjgmj2i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753878AbdCJAQ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:16:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: release all ctx in dup_userfaultfd_complete

Don't stop running dup_fctx() even if userfaultfd_event_wait_completion
fails as it has to run userfaultfd_ctx_put on all ctx to pair against the
userfaultfd_ctx_get that was run on all fctx->orig in dup_userfaultfd.

Link: http://lkml.kernel.org/r/20170224181957.19736-4-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete
+++ a/fs/userfaultfd.c
@@ -527,16 +527,12 @@ out:
 	return ret;
 }
 
-static int userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
-					     struct userfaultfd_wait_queue *ewq)
+static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
+					      struct userfaultfd_wait_queue *ewq)
 {
-	int ret;
-
-	ret = -1;
 	if (WARN_ON_ONCE(current->flags & PF_EXITING))
 		goto out;
 
-	ret = 0;
 	ewq->ctx = ctx;
 	init_waitqueue_entry(&ewq->wq, current);
 
@@ -552,7 +548,6 @@ static int userfaultfd_event_wait_comple
 			break;
 		if (ACCESS_ONCE(ctx->released) ||
 		    fatal_signal_pending(current)) {
-			ret = -1;
 			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
 			break;
 		}
@@ -573,7 +568,6 @@ static int userfaultfd_event_wait_comple
 	 */
 out:
 	userfaultfd_ctx_put(ctx);
-	return ret;
 }
 
 static void userfaultfd_event_complete(struct userfaultfd_ctx *ctx,
@@ -631,7 +625,7 @@ int dup_userfaultfd(struct vm_area_struc
 	return 0;
 }
 
-static int dup_fctx(struct userfaultfd_fork_ctx *fctx)
+static void dup_fctx(struct userfaultfd_fork_ctx *fctx)
 {
 	struct userfaultfd_ctx *ctx = fctx->orig;
 	struct userfaultfd_wait_queue ewq;
@@ -641,17 +635,15 @@ static int dup_fctx(struct userfaultfd_f
 	ewq.msg.event = UFFD_EVENT_FORK;
 	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
 
-	return userfaultfd_event_wait_completion(ctx, &ewq);
+	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
 void dup_userfaultfd_complete(struct list_head *fcs)
 {
-	int ret = 0;
 	struct userfaultfd_fork_ctx *fctx, *n;
 
 	list_for_each_entry_safe(fctx, n, fcs, list) {
-		if (!ret)
-			ret = dup_fctx(fctx);
+		dup_fctx(fctx);
 		list_del(&fctx->list);
 		kfree(fctx);
 	}
_
