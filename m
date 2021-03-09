Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32E1C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 04:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA586528A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Mar 2021 04:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCIEF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhCIEFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 23:05:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 596E265273;
        Tue,  9 Mar 2021 04:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615262721;
        bh=3qC1LhFH9UnNeJuBI38Q7FmYklCpGayO8zxjll32rrc=;
        h=Date:From:To:Subject:From;
        b=1DQyj93WPHdl99bM+eKFXFggKm5/C5Rf/EAj364L0aI1Bfa2JZm9xtKS6fbd4YFOv
         /ftxE3j77tYLxTI3S4OfOTKLQnB+yk5mcRMyhq45Um6sd7+n2+K6AfN2WIsfO5wwUL
         CpuheCmIZ/WduO+VEPddkbvvAKzT9e38rvJTfv10=
Date:   Mon, 08 Mar 2021 20:05:21 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210309040521.8f5cN2toN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    3 -
 drivers/tty/hvc/hvcs.c                         |   15 ------
 fs/btrfs/delayed-inode.c                       |   14 -----
 fs/io-wq.c                                     |   28 -----------
 fs/io_uring.c                                  |   36 ---------------
 5 files changed, 96 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -77,12 +77,9 @@ MODULE_FIRMWARE("amdgpu/dimgrey_cavefish
 
 #define mmTHM_BACO_CNTL_ARCT			0xA7
 #define mmTHM_BACO_CNTL_ARCT_BASE_IDX		0
-<<<<<<< HEAD
 
 static int link_width[] = {0, 1, 2, 4, 8, 12, 16};
 static int link_speed[] = {25, 50, 80, 160};
-=======
->>>>>>> linux-next/akpm-base
 
 int smu_v11_0_init_microcode(struct smu_context *smu)
 {
--- a/drivers/tty/hvc/hvcs.c~linux-next-git-rejects
+++ a/drivers/tty/hvc/hvcs.c
@@ -295,21 +295,6 @@ static int hvcs_rescan_devices_list(void
 
 static void hvcs_partner_free(struct hvcs_struct *hvcsd);
 
-<<<<<<< HEAD
-static int hvcs_enable_device(struct hvcs_struct *hvcsd,
-		uint32_t unit_address, unsigned int irq, struct vio_dev *dev);
-
-static int hvcs_open(struct tty_struct *tty, struct file *filp);
-static void hvcs_close(struct tty_struct *tty, struct file *filp);
-static void hvcs_hangup(struct tty_struct * tty);
-
-static int hvcs_probe(struct vio_dev *dev,
-		const struct vio_device_id *id);
-static int hvcs_remove(struct vio_dev *dev);
-static int __init hvcs_module_init(void);
-static void __exit hvcs_module_exit(void);
-=======
->>>>>>> linux-next/akpm-base
 static int hvcs_initialize(void);
 
 #define HVCS_SCHED_READ	0x00000001
--- a/fs/btrfs/delayed-inode.c~linux-next-git-rejects
+++ a/fs/btrfs/delayed-inode.c
@@ -636,22 +636,8 @@ static int btrfs_delayed_inode_reserve_m
 		ASSERT(ret == 0 || ret == -ENOSPC);
 		if (ret)
 			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
-<<<<<<< HEAD
-		}
-		if (!ret) {
-			node->bytes_reserved = num_bytes;
-			trace_btrfs_space_reservation(fs_info,
-						      "delayed_inode",
-						      btrfs_ino(inode),
-						      num_bytes, 1);
-		} else {
-			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
-		}
-		return ret;
-=======
 	} else {
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, true);
->>>>>>> linux-next/akpm-base
 	}
 
 	if (!ret) {
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -6732,17 +6732,8 @@ static int io_sq_thread(void *data)
 	 * park if necessary. The ordering with the park bit and the lock
 	 * ensures that we catch this reliably.
 	 */
-<<<<<<< HEAD
-	if (!mutex_trylock(&sqd->lock)) {
-		if (io_sq_thread_should_park(sqd))
-			io_sq_thread_parkme(sqd);
-		mutex_lock(&sqd->lock);
-	}
-
-=======
 	complete(&sqd->completion);
 	mutex_lock(&sqd->lock);
->>>>>>> linux-next/akpm-base
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 		ctx->sqo_exec = 1;
@@ -7800,20 +7791,12 @@ static int io_sq_thread_fork(struct io_s
 	int ret;
 
 	clear_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-<<<<<<< HEAD
-	reinit_completion(&sqd->parked);
-=======
 	reinit_completion(&sqd->completion);
->>>>>>> linux-next/akpm-base
 	ctx->sqo_exec = 0;
 	sqd->task_pid = current->pid;
 	tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
 	if (IS_ERR(tsk))
-<<<<<<< HEAD
-		return PTR_ERR(tsk);
-=======
 		return ret;
->>>>>>> linux-next/akpm-base
 	ret = io_uring_alloc_task_context(tsk, ctx);
 	if (ret)
 		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
@@ -7885,15 +7868,8 @@ static int io_sq_offload_create(struct i
 
 		sqd->task_pid = current->pid;
 		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
-<<<<<<< HEAD
-		if (IS_ERR(tsk)) {
-			ret = PTR_ERR(tsk);
-			goto err;
-		}
-=======
 		if (IS_ERR(tsk))
 			goto err;
->>>>>>> linux-next/akpm-base
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		if (ret)
 			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
@@ -8700,14 +8676,11 @@ static void io_uring_cancel_task_request
 		if (ctx->flags & IORING_SETUP_R_DISABLED) {
 			io_sq_offload_start(ctx);
 			return;
-<<<<<<< HEAD
-=======
 		}
 		did_park = io_sq_thread_park(ctx->sq_data);
 		if (did_park) {
 			task = ctx->sq_data->thread;
 			atomic_inc(&task->io_uring->in_idle);
->>>>>>> linux-next/akpm-base
 		}
 		io_sq_thread_park(ctx->sq_data);
 		task = ctx->sq_data->thread;
@@ -8824,25 +8797,16 @@ static void io_uring_cancel_sqpoll(struc
 
 	if (!sqd)
 		return;
-<<<<<<< HEAD
-	io_sq_thread_park(sqd);
-	if (!sqd->thread || !sqd->thread->io_uring) {
-		io_sq_thread_unpark(sqd);
-=======
 	if (!io_sq_thread_park(sqd))
->>>>>>> linux-next/akpm-base
 		return;
 	}
 	tctx = ctx->sq_data->thread->io_uring;
-<<<<<<< HEAD
-=======
 	/* can happen on fork/alloc failure, just ignore that state */
 	if (!tctx) {
 		io_sq_thread_unpark(sqd);
 		return;
 	}
 
->>>>>>> linux-next/akpm-base
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
--- a/fs/io-wq.c~linux-next-git-rejects
+++ a/fs/io-wq.c
@@ -481,12 +481,6 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	char buf[TASK_COMM_LEN];
-<<<<<<< HEAD
-
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-	io_wqe_inc_running(worker);
-=======
->>>>>>> linux-next/akpm-base
 
 	sprintf(buf, "iou-wrk-%d", wq->task_pid);
 	set_task_comm(current, buf);
@@ -592,14 +586,6 @@ static bool create_io_worker(struct io_w
 		return false;
 	}
 
-<<<<<<< HEAD
-	tsk->pf_io_worker = worker;
-	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
-	tsk->flags |= PF_NOFREEZE | PF_NO_SETAFFINITY;
-
-=======
->>>>>>> linux-next/akpm-base
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
@@ -610,8 +596,6 @@ static bool create_io_worker(struct io_w
 		worker->flags |= IO_WORKER_F_FIXED;
 	acct->nr_workers++;
 	raw_spin_unlock_irq(&wqe->lock);
-<<<<<<< HEAD
-=======
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	io_wqe_inc_running(worker);
@@ -619,7 +603,6 @@ static bool create_io_worker(struct io_w
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
 	tsk->flags |= PF_NOFREEZE | PF_NO_SETAFFINITY;
->>>>>>> linux-next/akpm-base
 	wake_up_new_task(tsk);
 	return true;
 }
@@ -742,14 +725,6 @@ static int io_wq_manager(void *data)
 	if (atomic_read(&wq->worker_refs))
 		wait_for_completion(&wq->worker_done);
 
-<<<<<<< HEAD
-	spin_lock_irq(&wq->hash->wait.lock);
-	for_each_node(node)
-		list_del_init(&wq->wqes[node]->wait.entry);
-	spin_unlock_irq(&wq->hash->wait.lock);
-
-=======
->>>>>>> linux-next/akpm-base
 	io_wq_cancel_pending(wq);
 	complete(&wq->exited);
 	do_exit(0);
@@ -1077,11 +1052,8 @@ static void io_wq_destroy(struct io_wq *
 
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
-<<<<<<< HEAD
-=======
 
 		list_del_init(&wqe->wait.entry);
->>>>>>> linux-next/akpm-base
 		WARN_ON_ONCE(!wq_list_empty(&wqe->work_list));
 		kfree(wqe);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

