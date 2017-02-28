From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch added to -mm tree
Date: Tue, 28 Feb 2017 14:13:36 -0800
Message-ID: <58b5f610.ceWVeZ0wBtk3GPDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbdB1X13 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:27:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: release all ctx in dup_userfaultfd_complete
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -526,16 +526,12 @@ out:
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
 
@@ -551,7 +547,6 @@ static int userfaultfd_event_wait_comple
 			break;
 		if (ACCESS_ONCE(ctx->released) ||
 		    fatal_signal_pending(current)) {
-			ret = -1;
 			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
 			break;
 		}
@@ -572,7 +567,6 @@ static int userfaultfd_event_wait_comple
 	 */
 out:
 	userfaultfd_ctx_put(ctx);
-	return ret;
 }
 
 static void userfaultfd_event_complete(struct userfaultfd_ctx *ctx,
@@ -630,7 +624,7 @@ int dup_userfaultfd(struct vm_area_struc
 	return 0;
 }
 
-static int dup_fctx(struct userfaultfd_fork_ctx *fctx)
+static void dup_fctx(struct userfaultfd_fork_ctx *fctx)
 {
 	struct userfaultfd_ctx *ctx = fctx->orig;
 	struct userfaultfd_wait_queue ewq;
@@ -640,17 +634,15 @@ static int dup_fctx(struct userfaultfd_f
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

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-shmem-__do_fault-requires-vm_fault_nopage.patch
userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch
userfaultfd-non-cooperative-robustness-check.patch
userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch

