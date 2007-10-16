From: akpm@linux-foundation.org
Subject: - readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:06 -0700
Message-ID: <200710162031.l9GKV6No014469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966148AbXJPVtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, jens.axboe@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: remove the limit max_sectors_kb imposed on max_readahead_kb
has been removed from the -mm tree.  Its filename was
     readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: remove the limit max_sectors_kb imposed on max_readahead_kb
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove the size limit max_sectors_kb imposed on max_readahead_kb.

The size restriction is unreasonable.  Especially when max_sectors_kb cannot
grow larger than max_hw_sectors_kb, which can be rather small for some disk
drives.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN block/ll_rw_blk.c~readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb
+++ a/block/ll_rw_blk.c
@@ -3928,7 +3928,6 @@ queue_max_sectors_store(struct request_q
 			max_hw_sectors_kb = q->max_hw_sectors >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
-	int ra_kb;
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
@@ -3937,14 +3936,6 @@ queue_max_sectors_store(struct request_q
 	 * values synchronously:
 	 */
 	spin_lock_irq(q->queue_lock);
-	/*
-	 * Trim readahead window as well, if necessary:
-	 */
-	ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
-	if (ra_kb > max_sectors_kb)
-		q->backing_dev_info.ra_pages =
-				max_sectors_kb >> (PAGE_CACHE_SHIFT - 10);
-
 	q->max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
