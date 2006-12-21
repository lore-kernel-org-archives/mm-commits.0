From: akpm@osdl.org
Subject: + fix-lock-inversion-aio_kick_handler.patch added to -mm tree
Date: Thu, 21 Dec 2006 01:05:45 -0800
Message-ID: <200612210905.kBL95jK8022347@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422882AbWLUJGe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 04:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach.brown@oracle.com, bcrl@kvack.org, kenneth.w.chen@intel.com, suparna@in.ibm.com


The patch titled
     Fix lock inversion aio_kick_handler()
has been added to the -mm tree.  Its filename is
     fix-lock-inversion-aio_kick_handler.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix lock inversion aio_kick_handler()
From: Zach Brown <zach.brown@oracle.com>

lockdep found a AB BC CA lock inversion in retry-based AIO:

1) The task struct's alloc_lock (A) is acquired in process context with
   interrupts enabled.  An interrupt might arrive and call wake_up() which
   grabs the wait queue's q->lock (B).

2) When performing retry-based AIO the AIO core registers
   aio_wake_function() as the wake funtion for iocb->ki_wait.  It is called
   with the wait queue's q->lock (B) held and then tries to add the iocb to
   the run list after acquiring the ctx_lock (C).

3) aio_kick_handler() holds the ctx_lock (C) while acquiring the
   alloc_lock (A) via lock_task() and unuse_mm().  Lockdep emits a warning
   saying that we're trying to connect the irq-safe q->lock to the
   irq-unsafe alloc_lock via ctx_lock.

This fixes the inversion by calling unuse_mm() in the AIO kick handing path
after we've released the ctx_lock.  As Ben LaHaise pointed out __put_ioctx
could set ctx->mm to NULL, so we must only access ctx->mm while we have the
lock.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/aio.c~fix-lock-inversion-aio_kick_handler fs/aio.c
--- a/fs/aio.c~fix-lock-inversion-aio_kick_handler
+++ a/fs/aio.c
@@ -596,9 +596,6 @@ static void use_mm(struct mm_struct *mm)
  *	by the calling kernel thread
  *	(Note: this routine is intended to be called only
  *	from a kernel thread context)
- *
- * Comments: Called with ctx->ctx_lock held. This nests
- * task_lock instead ctx_lock.
  */
 static void unuse_mm(struct mm_struct *mm)
 {
@@ -846,14 +843,16 @@ static void aio_kick_handler(struct work
 {
 	struct kioctx *ctx = container_of(work, struct kioctx, wq.work);
 	mm_segment_t oldfs = get_fs();
+	struct mm_struct *mm;
 	int requeue;
 
 	set_fs(USER_DS);
 	use_mm(ctx->mm);
 	spin_lock_irq(&ctx->ctx_lock);
 	requeue =__aio_run_iocbs(ctx);
- 	unuse_mm(ctx->mm);
+	mm = ctx->mm;
 	spin_unlock_irq(&ctx->ctx_lock);
+ 	unuse_mm(mm);
 	set_fs(oldfs);
 	/*
 	 * we're in a worker thread already, don't use queue_delayed_work,
_

Patches currently in -mm which might be from zach.brown@oracle.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete.patch
fix-lock-inversion-aio_kick_handler.patch

