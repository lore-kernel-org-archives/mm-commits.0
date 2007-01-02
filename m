From: akpm@osdl.org
Subject: + aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:34:03 -0800
Message-ID: <200701022134.l02LY4tV030452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbXABVhv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenneth.w.chen@intel.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com


The patch titled
     aio: fix buggy put_ioctx call in aio_complete - v2
has been added to the -mm tree.  Its filename is
     aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: fix buggy put_ioctx call in aio_complete - v2
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

An AIO bug was reported that sleeping function is being called in softirq
context:

BUG: warning at kernel/mutex.c:132/__mutex_lock_common()
Call Trace:
     [<a000000100577b00>] __mutex_lock_slowpath+0x640/0x6c0
     [<a000000100577ba0>] mutex_lock+0x20/0x40
     [<a0000001000a25b0>] flush_workqueue+0xb0/0x1a0
     [<a00000010018c0c0>] __put_ioctx+0xc0/0x240
     [<a00000010018d470>] aio_complete+0x2f0/0x420
     [<a00000010019cc80>] finished_one_bio+0x200/0x2a0
     [<a00000010019d1c0>] dio_bio_complete+0x1c0/0x200
     [<a00000010019d260>] dio_bio_end_aio+0x60/0x80
     [<a00000010014acd0>] bio_endio+0x110/0x1c0
     [<a0000001002770e0>] __end_that_request_first+0x180/0xba0
     [<a000000100277b90>] end_that_request_chunk+0x30/0x60
     [<a0000002073c0c70>] scsi_end_request+0x50/0x300 [scsi_mod]
     [<a0000002073c1240>] scsi_io_completion+0x200/0x8a0 [scsi_mod]
     [<a0000002074729b0>] sd_rw_intr+0x330/0x860 [sd_mod]
     [<a0000002073b3ac0>] scsi_finish_command+0x100/0x1c0 [scsi_mod]
     [<a0000002073c2910>] scsi_softirq_done+0x230/0x300 [scsi_mod]
     [<a000000100277d20>] blk_done_softirq+0x160/0x1c0
     [<a000000100083e00>] __do_softirq+0x200/0x240
     [<a000000100083eb0>] do_softirq+0x70/0xc0

See report: http://marc.theaimsgroup.com/?l=linux-kernel&m=116599593200888&w=2

flush_workqueue() is not allowed to be called in the softirq context.
However, aio_complete() called from I/O interrupt can potentially call
put_ioctx with last ref count on ioctx and triggers bug.  It is simply
incorrect to perform ioctx freeing from aio_complete.

The bug is trigger-able from a race between io_destroy() and aio_complete().
A possible scenario:

cpu0                               cpu1
io_destroy                         aio_complete
  wait_for_all_aios {                __aio_put_req
     ...                                 ctx->reqs_active--;
     if (!ctx->reqs_active)
        return;
  }
  ...
  put_ioctx(ioctx)

                                     put_ioctx(ctx);
                                        __put_ioctx
                                          bam! Bug trigger!

The real problem is that the condition check of ctx->reqs_active in
wait_for_all_aios() is incorrect that access to reqs_active is not
being properly protected by spin lock.

This patch adds that protective spin lock, and at the same time removes
all duplicate ref counting for each kiocb as reqs_active is already used
as a ref count for each active ioctx.  This also ensures that buggy call
to flush_workqueue() in softirq context is eliminated.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c      |   20 +++++++++-----------
 fs/aio.c.orig |   20 +++++++++++---------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/aio.c~aio-fix-buggy-put_ioctx-call-in-aio_complete-v2 fs/aio.c
--- a/fs/aio.c~aio-fix-buggy-put_ioctx-call-in-aio_complete-v2
+++ a/fs/aio.c
@@ -297,17 +297,23 @@ static void wait_for_all_aios(struct kio
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 
+	spin_lock_irq(&ctx->ctx_lock);
 	if (!ctx->reqs_active)
-		return;
+		goto out;
 
 	add_wait_queue(&ctx->wait, &wait);
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (ctx->reqs_active) {
+		spin_unlock_irq(&ctx->ctx_lock);
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		spin_lock_irq(&ctx->ctx_lock);
 	}
 	__set_task_state(tsk, TASK_RUNNING);
 	remove_wait_queue(&ctx->wait, &wait);
+
+out:
+	spin_unlock_irq(&ctx->ctx_lock);
 }
 
 /* wait_on_sync_kiocb:
@@ -423,7 +429,6 @@ static struct kiocb fastcall *__aio_get_
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
 	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
 		list_add(&req->ki_list, &ctx->active_reqs);
-		get_ioctx(ctx);
 		ctx->reqs_active++;
 		okay = 1;
 	}
@@ -535,8 +540,6 @@ int fastcall aio_put_req(struct kiocb *r
 	spin_lock_irq(&ctx->ctx_lock);
 	ret = __aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
-	if (ret)
-		put_ioctx(ctx);
 	return ret;
 }
 
@@ -778,8 +781,7 @@ static int __aio_run_iocbs(struct kioctx
 		 */
 		iocb->ki_users++;       /* grab extra reference */
 		aio_run_iocb(iocb);
-		if (__aio_put_req(ctx, iocb))  /* drop extra ref */
-			put_ioctx(ctx);
+		__aio_put_req(ctx, iocb);
  	}
 	if (!list_empty(&ctx->run_list))
 		return 1;
@@ -996,14 +998,10 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	if (ret)
-		put_ioctx(ctx);
-
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
 }
 
diff -puN fs/aio.c.orig~aio-fix-buggy-put_ioctx-call-in-aio_complete-v2 fs/aio.c.orig
--- a/fs/aio.c.orig~aio-fix-buggy-put_ioctx-call-in-aio_complete-v2
+++ a/fs/aio.c.orig
@@ -297,23 +297,17 @@ static void wait_for_all_aios(struct kio
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 
-	spin_lock_irq(&ctx->ctx_lock);
 	if (!ctx->reqs_active)
-		goto out;
+		return;
 
 	add_wait_queue(&ctx->wait, &wait);
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (ctx->reqs_active) {
-		spin_unlock_irq(&ctx->ctx_lock);
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		spin_lock_irq(&ctx->ctx_lock);
 	}
 	__set_task_state(tsk, TASK_RUNNING);
 	remove_wait_queue(&ctx->wait, &wait);
-
-out:
-	spin_unlock_irq(&ctx->ctx_lock);
 }
 
 /* wait_on_sync_kiocb:
@@ -429,6 +423,7 @@ static struct kiocb fastcall *__aio_get_
 	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
 	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
 		list_add(&req->ki_list, &ctx->active_reqs);
+		get_ioctx(ctx);
 		ctx->reqs_active++;
 		okay = 1;
 	}
@@ -540,6 +535,8 @@ int fastcall aio_put_req(struct kiocb *r
 	spin_lock_irq(&ctx->ctx_lock);
 	ret = __aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
+	if (ret)
+		put_ioctx(ctx);
 	return ret;
 }
 
@@ -781,7 +778,8 @@ static int __aio_run_iocbs(struct kioctx
 		 */
 		iocb->ki_users++;       /* grab extra reference */
 		aio_run_iocb(iocb);
-		__aio_put_req(ctx, iocb);
+		if (__aio_put_req(ctx, iocb))  /* drop extra ref */
+			put_ioctx(ctx);
  	}
 	if (!list_empty(&ctx->run_list))
 		return 1;
@@ -998,10 +996,14 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	if (ret)
+		put_ioctx(ctx);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

ia64-alignment-bug-in-ldscript.patch
aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
aio-add-per-task-aio-wait-event-condition.patch
aio-streamline-read-events-after-woken-up.patch
aio-remove-spurious-ring-head-index-modulo-info-nr.patch
aio-make-aio_ring_info-nr_pages-an-unsigned-int.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
