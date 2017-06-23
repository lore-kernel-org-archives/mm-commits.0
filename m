From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Fri, 23 Jun 2017 11:49:08 -0700
Message-ID: <20170623184908.8H8NlYurO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754549AbdFWStJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 14:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   15 --
 block/blk-mq-sched.c                    |  124 ----------------------
 2 files changed, 139 deletions(-)

diff -puN arch/powerpc/kvm/book3s_hv_rmhandlers.S~linux-next-git-rejects arch/powerpc/kvm/book3s_hv_rmhandlers.S
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S~linux-next-git-rejects
+++ a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -45,11 +45,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define NAPPING_NOVCPU	2
 
 /* Stack frame offsets for kvmppc_hv_entry */
-<<<<<<< HEAD
-#define SFS			144
-=======
 #define SFS			160
->>>>>>> linux-next/akpm-base
 #define STACK_SLOT_TRAP		(SFS-4)
 #define STACK_SLOT_TID		(SFS-16)
 #define STACK_SLOT_PSSCR	(SFS-24)
@@ -58,10 +54,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_CIABR	(SFS-48)
 #define STACK_SLOT_DAWR		(SFS-56)
 #define STACK_SLOT_DAWRX	(SFS-64)
-<<<<<<< HEAD
-=======
 #define STACK_SLOT_HFSCR	(SFS-72)
->>>>>>> linux-next/akpm-base
 
 /*
  * Call kvmppc_hv_entry in real mode.
@@ -785,11 +778,8 @@ BEGIN_FTR_SECTION
 	std	r6, STACK_SLOT_PSSCR(r1)
 	std	r7, STACK_SLOT_PID(r1)
 	std	r8, STACK_SLOT_IAMR(r1)
-<<<<<<< HEAD
-=======
 	mfspr	r5, SPRN_HFSCR
 	std	r5, STACK_SLOT_HFSCR(r1)
->>>>>>> linux-next/akpm-base
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_CIABR
@@ -2464,10 +2454,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_TM)
 	mfspr	r3, SPRN_DEC
 	mfspr	r4, SPRN_HDEC
 	mftb	r5
-<<<<<<< HEAD
-	extsw	r3, r3
-	EXTEND_HDEC(r4)
-=======
 BEGIN_FTR_SECTION
 	/* On P9 check whether the guest has large decrementer mode enabled */
 	ld	r6, HSTATE_KVM_VCORE(r13)
@@ -2477,7 +2463,6 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	extsw	r3, r3
 68:	EXTEND_HDEC(r4)
->>>>>>> linux-next/akpm-base
 	cmpd	r3, r4
 	ble	67f
 	mtspr	SPRN_DEC, r4
diff -puN block/blk-mq-sched.c~linux-next-git-rejects block/blk-mq-sched.c
--- a/block/blk-mq-sched.c~linux-next-git-rejects
+++ a/block/blk-mq-sched.c
@@ -48,130 +48,6 @@ void blk_mq_sched_assign_ioc(struct requ
 	}
 	get_io_context(icq->ioc);
 	rq->elv.icq = icq;
-<<<<<<< HEAD
-	if (!blk_mq_sched_get_rq_priv(q, rq, bio)) {
-		rq->rq_flags |= RQF_ELVPRIV;
-		get_io_context(icq->ioc);
-		return;
-	}
-
-	rq->elv.icq = NULL;
-}
-
-static void blk_mq_sched_assign_ioc(struct request_queue *q,
-				    struct request *rq, struct bio *bio)
-{
-	struct io_context *ioc;
-
-	ioc = rq_ioc(bio);
-	if (ioc)
-		__blk_mq_sched_assign_ioc(q, rq, bio, ioc);
-}
-
-/*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
- */
-static void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
-{
-	if (test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
-		return;
-
-	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
-		struct request_queue *q = hctx->queue;
-
-		if (!test_and_set_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
-			atomic_inc(&q->shared_hctx_restart);
-	} else
-		set_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
-}
-
-static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
-{
-	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
-		return false;
-
-	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
-		struct request_queue *q = hctx->queue;
-
-		if (test_and_clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
-			atomic_dec(&q->shared_hctx_restart);
-	} else
-		clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
-
-	if (blk_mq_hctx_has_pending(hctx)) {
-		blk_mq_run_hw_queue(hctx, true);
-		return true;
-	}
-
-	return false;
-}
-
-struct request *blk_mq_sched_get_request(struct request_queue *q,
-					 struct bio *bio,
-					 unsigned int op,
-					 struct blk_mq_alloc_data *data)
-{
-	struct elevator_queue *e = q->elevator;
-	struct request *rq;
-
-	blk_queue_enter_live(q);
-	data->q = q;
-	if (likely(!data->ctx))
-		data->ctx = blk_mq_get_ctx(q);
-	if (likely(!data->hctx))
-		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
-
-	if (e) {
-		data->flags |= BLK_MQ_REQ_INTERNAL;
-
-		/*
-		 * Flush requests are special and go directly to the
-		 * dispatch list.
-		 */
-		if (!op_is_flush(op) && e->type->ops.mq.get_request) {
-			rq = e->type->ops.mq.get_request(q, op, data);
-			if (rq)
-				rq->rq_flags |= RQF_QUEUED;
-		} else
-			rq = __blk_mq_alloc_request(data, op);
-	} else {
-		rq = __blk_mq_alloc_request(data, op);
-	}
-
-	if (rq) {
-		if (!op_is_flush(op)) {
-			rq->elv.icq = NULL;
-			if (e && e->type->icq_cache)
-				blk_mq_sched_assign_ioc(q, rq, bio);
-		}
-		data->hctx->queued++;
-		return rq;
-	}
-
-	blk_queue_exit(q);
-	return NULL;
-}
-
-void blk_mq_sched_put_request(struct request *rq)
-{
-	struct request_queue *q = rq->q;
-	struct elevator_queue *e = q->elevator;
-
-	if (rq->rq_flags & RQF_ELVPRIV) {
-		blk_mq_sched_put_rq_priv(rq->q, rq);
-		if (rq->elv.icq) {
-			put_io_context(rq->elv.icq->ioc);
-			rq->elv.icq = NULL;
-		}
-	}
-
-	if ((rq->rq_flags & RQF_QUEUED) && e && e->type->ops.mq.put_request)
-		e->type->ops.mq.put_request(rq);
-	else
-		blk_mq_finish_request(rq);
-=======
->>>>>>> linux-next/akpm-base
 }
 
 void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

