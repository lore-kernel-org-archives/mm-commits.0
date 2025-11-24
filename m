Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817C0335577
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025847; cv=none; b=h5mU6irwj0z/ilLCyxDOs84vHczTX4FpWl1HkO8sFWCZ6h+KyBBfxGuSN+ip6wAXRZQ8BVbSp9XJM3J9eaeAQygnwKTBZ157aVTkvGk5fiOeh9/4to9gS6tnAYcnJVUy5vpAG2q2UeD5PjF7DMSCik+yeqkeNAGSzJTAvifyPeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025847; c=relaxed/simple;
	bh=6pKC44i16kpXDCsjDbew5a2jfcjffYPFihZGpJyFwFc=;
	h=Date:To:From:Subject:Message-Id; b=jNN5L+mfpHSGywi/Lg1P/VC1cMNHZg8LGeb+kobiS0QR7/ozawlO7DMGFjHZi1LjSXAa3IVtMzNfMv/5+czaJiwUYD6dBQu5hmOuFAggeiZM+UpoiNxcd/YKUkogRKxHO+XWNW+Sw4xBWpgXAEoniquCRyCww6ZC0gOlaZj2Xcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DH8Hm0z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DH8Hm0z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B45C4CEF1;
	Mon, 24 Nov 2025 23:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025847;
	bh=6pKC44i16kpXDCsjDbew5a2jfcjffYPFihZGpJyFwFc=;
	h=Date:To:From:Subject:From;
	b=DH8Hm0z2hvfj7gnLthxvUv24rTS+ckMHPXr2l39QMPION5nZsxD5o59NGWS3XV3I0
	 xeK2n0NO4z0xNbVKe1EG6iINzmW4JDEdGO8wN1VGo9tgMLGtoRSpaXcUfsd1zBTJ/L
	 ASULCLYiY2zgKzZ9DsK+y4SFwY3UWe/KCufwR6/0=
Date: Mon, 24 Nov 2025 15:10:46 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-rework-bdev-block-allocation.patch removed from -mm tree
Message-Id: <20251124231047.57B45C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: rework bdev block allocation
has been removed from the -mm tree.  Its filename was
     zram-rework-bdev-block-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rework bdev block allocation
Date: Sat, 22 Nov 2025 16:40:28 +0900

First, writeback bdev ->bitmap bits are set only from one context, as we
can have only one single task performing writeback, so we cannot race with
anything else.  Remove retry path.

Second, we always check ZRAM_WB flag to distinguish writtenback slots, so
we should not confuse 0 bdev block index and 0 handle.  We can use first
bdev block (0 bit) for writeback as well.

While at it, give functions slightly more accurate names, as we don't
alloc/free anything there, we reserve a block for async writeback or
release the block.

Link: https://lkml.kernel.org/r/20251122074029.3948921-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   37 +++++++++++++++-----------------
 1 file changed, 18 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rework-bdev-block-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -500,6 +500,8 @@ out:
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+#define INVALID_BDEV_BLOCK		(~0UL)
+
 struct zram_wb_ctl {
 	/* idle list is accessed only by the writeback task, no concurency */
 	struct list_head idle_reqs;
@@ -746,23 +748,20 @@ out:
 	return err;
 }
 
-static unsigned long alloc_block_bdev(struct zram *zram)
+static unsigned long zram_reserve_bdev_block(struct zram *zram)
 {
-	unsigned long blk_idx = 1;
-retry:
-	/* skip 0 bit to confuse zram.handle = 0 */
-	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, blk_idx);
-	if (blk_idx == zram->nr_pages)
-		return 0;
+	unsigned long blk_idx;
 
-	if (test_and_set_bit(blk_idx, zram->bitmap))
-		goto retry;
+	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, 0);
+	if (blk_idx == zram->nr_pages)
+		return INVALID_BDEV_BLOCK;
 
+	set_bit(blk_idx, zram->bitmap);
 	atomic64_inc(&zram->stats.bd_count);
 	return blk_idx;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 	int was_set;
 
@@ -887,7 +886,7 @@ static int zram_writeback_complete(struc
 		 * (if enabled).
 		 */
 		zram_account_writeback_rollback(zram);
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		return err;
 	}
 
@@ -901,7 +900,7 @@ static int zram_writeback_complete(struc
 	 * finishes.
 	 */
 	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		goto out;
 	}
 
@@ -990,8 +989,8 @@ static int zram_writeback_slots(struct z
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
 {
+	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
-	unsigned long blk_idx = 0;
 	struct zram_pp_slot *pps;
 	int ret = 0, err = 0;
 	u32 index = 0;
@@ -1023,9 +1022,9 @@ static int zram_writeback_slots(struct z
 				ret = err;
 		}
 
-		if (!blk_idx) {
-			blk_idx = alloc_block_bdev(zram);
-			if (!blk_idx) {
+		if (blk_idx == INVALID_BDEV_BLOCK) {
+			blk_idx = zram_reserve_bdev_block(zram);
+			if (blk_idx == INVALID_BDEV_BLOCK) {
 				ret = -ENOSPC;
 				break;
 			}
@@ -1059,7 +1058,7 @@ static int zram_writeback_slots(struct z
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
-		blk_idx = 0;
+		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
 		cond_resched();
 		continue;
@@ -1366,7 +1365,7 @@ static int read_from_bdev(struct zram *z
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 }
 #endif
@@ -1890,7 +1889,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_handle(zram, index));
+		zram_release_bdev_block(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


