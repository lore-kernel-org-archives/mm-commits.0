From: akpm@linux-foundation.org
Subject: + readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:21 -0700
Message-ID: <200707240353.l6O3rLL3026893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbXGXDzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, jens.axboe@oracle.com, rusty@rustcorp.com.au


The patch titled
     readahead: remove the limit max_sectors_kb imposed on max_readahead_kb
has been added to the -mm tree.  Its filename is
     readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -4054,7 +4054,6 @@ queue_max_sectors_store(struct request_q
 			max_hw_sectors_kb = q->max_hw_sectors >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
-	int ra_kb;
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
@@ -4063,14 +4062,6 @@ queue_max_sectors_store(struct request_q
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

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
radixtree-introduce-radix_tree_scan_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
convert-ill-defined-log2-to-ilog2.patch
