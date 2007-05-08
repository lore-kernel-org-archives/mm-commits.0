From: akpm@linux-foundation.org
Subject: - readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch removed from -mm tree
Date: Tue, 08 May 2007 01:16:02 -0700
Message-ID: <200705080816.l488G2eW019082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934596AbXEHIQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: remove size limit of max_sectors_kb on read_ahead_kb
has been removed from the -mm tree.  Its filename was
     readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: remove size limit of max_sectors_kb on read_ahead_kb
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Remove the correlation between max_sectors_kb and read_ahead_kb.  It's
unnecessary to reduce readahead size when setting max_sectors_kb.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN block/ll_rw_blk.c~readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb
+++ a/block/ll_rw_blk.c
@@ -3913,25 +3913,11 @@ queue_max_sectors_store(struct request_q
 			max_hw_sectors_kb = q->max_hw_sectors >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
-	int ra_kb;
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
-	/*
-	 * Take the queue lock to update the readahead and max_sectors
-	 * values synchronously:
-	 */
-	spin_lock_irq(q->queue_lock);
-	/*
-	 * Trim readahead window as well, if necessary:
-	 */
-	ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
-	if (ra_kb > max_sectors_kb)
-		q->backing_dev_info.ra_pages =
-				max_sectors_kb >> (PAGE_CACHE_SHIFT - 10);
 
 	q->max_sectors = max_sectors_kb << 1;
-	spin_unlock_irq(q->queue_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
