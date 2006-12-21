From: akpm@osdl.org
Subject: + aio-fix-buggy-put_ioctx-call-in-aio_complete.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:05:50 -0800
Message-ID: <200612210405.kBL45oN2015174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422687AbWLUEGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com, bcrl@kvack.org, zach.brown@oracle.com


The patch titled
     aio: fix buggy put_ioctx call in aio_complete
has been added to the -mm tree.  Its filename is
     aio-fix-buggy-put_ioctx-call-in-aio_complete.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: fix buggy put_ioctx call in aio_complete
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

Regarding to a bug report on:
http://marc.theaimsgroup.com/?l=linux-kernel&m=116599593200888&w=2

flush_workqueue() is not allowed to be called in the softirq context. 
However, aio_complete() called from I/O interrupt can potentially call
put_ioctx with last ref count on ioctx and trigger a bug warning.  It is
simply incorrect to perform ioctx freeing from aio_complete.

This patch removes all duplicate ref counting for each kiocb as reqs_active
already used as a request ref count for each active ioctx.  This also
ensures that buggy call to flush_workqueue() in softirq context is
eliminated.  wait_for_all_aios currently will wait on last active kiocb. 
However, it is racy.  This patch also tighten it up by utilizing rcu
synchronization mechanism to ensure no further reference to ioctx before
put_ioctx function is run.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/aio.c~aio-fix-buggy-put_ioctx-call-in-aio_complete fs/aio.c
--- a/fs/aio.c~aio-fix-buggy-put_ioctx-call-in-aio_complete
+++ a/fs/aio.c
@@ -307,6 +307,7 @@ static void wait_for_all_aios(struct kio
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
 	__set_task_state(tsk, TASK_RUNNING);
+	synchronize_rcu();
 	remove_wait_queue(&ctx->wait, &wait);
 }
 
@@ -423,7 +424,6 @@ static struct kiocb fastcall *__aio_get_
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
 	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
 		list_add(&req->ki_list, &ctx->active_reqs);
-		get_ioctx(ctx);
 		ctx->reqs_active++;
 		okay = 1;
 	}
@@ -535,8 +535,6 @@ int fastcall aio_put_req(struct kiocb *r
 	spin_lock_irq(&ctx->ctx_lock);
 	ret = __aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
-	if (ret)
-		put_ioctx(ctx);
 	return ret;
 }
 
@@ -781,8 +779,7 @@ static int __aio_run_iocbs(struct kioctx
 		 */
 		iocb->ki_users++;       /* grab extra reference */
 		aio_run_iocb(iocb);
-		if (__aio_put_req(ctx, iocb))  /* drop extra ref */
-			put_ioctx(ctx);
+		__aio_put_req(ctx, iocb);
  	}
 	if (!list_empty(&ctx->run_list))
 		return 1;
@@ -995,6 +992,7 @@ int fastcall aio_complete(struct kiocb *
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
+	rcu_read_lock();
 	ret = __aio_put_req(ctx, iocb);
 
 	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
@@ -1002,9 +1000,7 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	if (ret)
-		put_ioctx(ctx);
-
+	rcu_read_unlock();
 	return ret;
 }
 
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete.patch
ia64-alignment-bug-in-ldscript.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

