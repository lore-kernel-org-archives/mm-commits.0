From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:15:28 -0700
Message-ID: <20200604171528.pTJT2tLQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRP3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:15:29 -0400
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

 Documentation/filesystems/dax.txt |    9 ----
 block/blk-core.c                  |    8 ----
 drivers/block/loop.c              |    4 --
 drivers/md/dm-zoned-metadata.c    |   12 ------
 drivers/nvme/host/rdma.c          |    4 --
 drivers/scsi/scsi_lib.c           |   56 ----------------------------
 fs/btrfs/inode.c                  |    7 ---
 fs/io_uring.c                     |   27 -------------
 8 files changed, 127 deletions(-)

--- a/block/blk-core.c~linux-next-git-rejects
+++ a/block/blk-core.c
@@ -1471,19 +1471,11 @@ unsigned long disk_start_io_acct(struct
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_stat_local_inc(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
-<<<<<<< HEAD
 
 	return now;
 }
 EXPORT_SYMBOL(disk_start_io_acct);
 
-=======
-
-	return now;
-}
-EXPORT_SYMBOL(disk_start_io_acct);
-
->>>>>>> linux-next/akpm-base
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time)
 {
--- a/Documentation/filesystems/dax.txt~linux-next-git-rejects
+++ a/Documentation/filesystems/dax.txt
@@ -25,11 +25,7 @@ size when creating the filesystem.
 Currently 3 filesystems support DAX: ext2, ext4 and xfs.  Enabling DAX on them
 is different.
 
-<<<<<<< HEAD
-Enabling DAX on ext4 and ext2
-=======
 Enabling DAX on ext2
->>>>>>> linux-next/akpm-base
 -----------------------------
 
 When mounting the filesystem, use the "-o dax" option on the command line or
@@ -37,13 +33,8 @@ add 'dax' to the options in /etc/fstab.
 within the filesystem.  It is equivalent to the '-o dax=always' behavior below.
 
 
-<<<<<<< HEAD
-Enabling DAX on xfs
--------------------
-=======
 Enabling DAX on xfs and ext4
 ----------------------------
->>>>>>> linux-next/akpm-base
 
 Summary
 -------
--- a/drivers/block/loop.c~linux-next-git-rejects
+++ a/drivers/block/loop.c
@@ -1149,12 +1149,8 @@ static int loop_configure(struct loop_de
 
 	if (config->block_size)
 		bsize = config->block_size;
-<<<<<<< HEAD
-	else if ((lo->lo_backing_file->f_flags & O_DIRECT) && inode->i_sb->s_bdev)
-=======
 	else if ((lo->lo_backing_file->f_flags & O_DIRECT) &&
 		 inode->i_sb->s_bdev)
->>>>>>> linux-next/akpm-base
 		/* In case of direct I/O, match underlying block size */
 		bsize = bdev_logical_block_size(inode->i_sb->s_bdev);
 	else
--- a/drivers/md/dm-zoned-metadata.c~linux-next-git-rejects
+++ a/drivers/md/dm-zoned-metadata.c
@@ -817,11 +817,7 @@ static int dmz_write_sb(struct dmz_metad
 	ret = dmz_rdwr_block(dev, REQ_OP_WRITE, zmd->sb[set].block,
 			     mblk->page);
 	if (ret == 0)
-<<<<<<< HEAD
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO);
-=======
 		ret = blkdev_issue_flush(dev->bdev, GFP_NOIO);
->>>>>>> linux-next/akpm-base
 
 	return ret;
 }
@@ -864,11 +860,7 @@ static int dmz_write_dirty_mblocks(struc
 
 	/* Flush drive cache (this will also sync data) */
 	if (ret == 0)
-<<<<<<< HEAD
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO);
-=======
 		ret = blkdev_issue_flush(dev->bdev, GFP_NOIO);
->>>>>>> linux-next/akpm-base
 
 	return ret;
 }
@@ -939,11 +931,7 @@ int dmz_flush_metadata(struct dmz_metada
 
 	/* If there are no dirty metadata blocks, just flush the device cache */
 	if (list_empty(&write_list)) {
-<<<<<<< HEAD
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO);
-=======
 		ret = blkdev_issue_flush(dev->bdev, GFP_NOIO);
->>>>>>> linux-next/akpm-base
 		goto err;
 	}
 
--- a/drivers/nvme/host/rdma.c~linux-next-git-rejects
+++ a/drivers/nvme/host/rdma.c
@@ -522,11 +522,7 @@ static int nvme_rdma_create_queue_ib(str
 		if (ret) {
 			dev_err(queue->ctrl->ctrl.device,
 				"failed to initialize PI MR pool sized %d for QID %d\n",
-<<<<<<< HEAD
-				queue->queue_size, idx);
-=======
 				queue->queue_size, nvme_rdma_queue_idx(queue));
->>>>>>> linux-next/akpm-base
 			goto out_destroy_mr_pool;
 		}
 	}
--- a/drivers/scsi/scsi_lib.c~linux-next-git-rejects
+++ a/drivers/scsi/scsi_lib.c
@@ -960,61 +960,6 @@ static inline bool scsi_cmd_needs_dma_dr
 	       !op_is_write(req_op(rq)) &&
 	       sdev->host->hostt->dma_need_drain(rq);
 }
-<<<<<<< HEAD
-
-/*
- * Function:    scsi_init_io()
- *
- * Purpose:     SCSI I/O initialize function.
- *
- * Arguments:   cmd   - Command descriptor we wish to initialize
- *
- * Returns:     BLK_STS_OK on success
- *		BLK_STS_RESOURCE if the failure is retryable
- *		BLK_STS_IOERR if the failure is fatal
- */
-blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct request *rq = cmd->request;
-	unsigned short nr_segs = blk_rq_nr_phys_segments(rq);
-	struct scatterlist *last_sg = NULL;
-	blk_status_t ret;
-	bool need_drain = scsi_cmd_needs_dma_drain(sdev, rq);
-	int count;
-
-	if (WARN_ON_ONCE(!nr_segs))
-		return BLK_STS_IOERR;
-
-	/*
-	 * Make sure there is space for the drain.  The driver must adjust
-	 * max_hw_segments to be prepared for this.
-	 */
-	if (need_drain)
-		nr_segs++;
-
-	/*
-	 * If sg table allocation fails, requeue request later.
-	 */
-	if (unlikely(sg_alloc_table_chained(&cmd->sdb.table, nr_segs,
-			cmd->sdb.table.sgl, SCSI_INLINE_SG_CNT)))
-		return BLK_STS_RESOURCE;
-
-	/*
-	 * Next, walk the list, and fill in the addresses and sizes of
-	 * each segment.
-	 */
-	count = __blk_rq_map_sg(rq->q, rq, cmd->sdb.table.sgl, &last_sg);
-
-	if (blk_rq_bytes(rq) & rq->q->dma_pad_mask) {
-		unsigned int pad_len =
-			(rq->q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
-
-		last_sg->length += pad_len;
-		cmd->extra_len += pad_len;
-	}
-
-=======
 
 /**
  * scsi_init_io - SCSI I/O initialization function.
@@ -1066,7 +1011,6 @@ blk_status_t scsi_init_io(struct scsi_cm
 		cmd->extra_len += pad_len;
 	}
 
->>>>>>> linux-next/akpm-base
 	if (need_drain) {
 		sg_unmark_end(last_sg);
 		last_sg = sg_next(last_sg);
--- a/fs/btrfs/inode.c~linux-next-git-rejects
+++ a/fs/btrfs/inode.c
@@ -7823,13 +7823,6 @@ const struct iomap_ops btrfs_dio_iomap_o
 	.iomap_begin            = btrfs_dio_iomap_begin,
 	.iomap_end              = btrfs_dio_iomap_end,
 };
-<<<<<<< HEAD
-
-const struct iomap_dio_ops btrfs_dops = {
-	.submit_io		= btrfs_submit_direct,
-};
-=======
->>>>>>> linux-next/akpm-base
 
 const struct iomap_dio_ops btrfs_dops = {
 	.submit_io		= btrfs_submit_direct,
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -1114,7 +1114,6 @@ static void __io_queue_deferred(struct i
 	do {
 		struct io_kiocb *req = list_first_entry(&ctx->defer_list,
 							struct io_kiocb, list);
-<<<<<<< HEAD
 
 		if (req_need_defer(req))
 			break;
@@ -1135,28 +1134,6 @@ static void io_flush_timeouts(struct io_
 					- atomic_read(&ctx->cq_timeouts))
 			break;
 
-=======
-
-		if (req_need_defer(req))
-			break;
-		list_del_init(&req->list);
-		io_queue_async_work(req);
-	} while (!list_empty(&ctx->defer_list));
-}
-
-static void io_flush_timeouts(struct io_ring_ctx *ctx)
-{
-	while (!list_empty(&ctx->timeout_list)) {
-		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-							struct io_kiocb, list);
-
-		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
-			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
-			break;
-
->>>>>>> linux-next/akpm-base
 		list_del_init(&req->list);
 		io_kill_timeout(req);
 	}
@@ -6103,11 +6080,7 @@ static int io_submit_sqes(struct io_ring
 			break;
 		}
 
-<<<<<<< HEAD
-		err = io_init_req(ctx, req, sqe, statep);
-=======
 		err = io_init_req(ctx, req, sqe, &state);
->>>>>>> linux-next/akpm-base
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
