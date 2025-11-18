Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B23587AB
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489570; cv=none; b=Ptk4uUxpBkpmldoDBX9rJy5ICDOayFWxJ4fr/YJpWBdK28IxHgAfZC0EaN8tiGZqnRZVvFLqcJu74jNVioDhDHqqwte3FFx/oQHah2cauLck1B/AgTM3X0vvrFehGO6ESFQ6gi/XEsWXWpOgtJ7iV4HiyAjPu7ONRIqqtbJO5h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489570; c=relaxed/simple;
	bh=iWTCX8ln45P7WA9hC16y2IDMbUaoBe5hVSRAQ73KRvQ=;
	h=Date:To:From:Subject:Message-Id; b=OdM9YoO0fc4RL+yhZHyGfZrz1AazicFDxXW22Nzq/UavQ/9vnpMdIquKrYhOAsfnR2h991jcDHGe5TLOurKWQkWm5uAa6K26k/X94CvLgCXKTUyqqQx5s9yWQRwBL0sDX1h6sVBDDbgWZkPG9Tg57Q0ySwmYKpx0eGEy9uB6wqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=picfhJXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="picfhJXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6573C4CEF5;
	Tue, 18 Nov 2025 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763489569;
	bh=iWTCX8ln45P7WA9hC16y2IDMbUaoBe5hVSRAQ73KRvQ=;
	h=Date:To:From:Subject:From;
	b=picfhJXlXSucCTaSjvTmD6K/1gSzgShyhLJT46ynz2suiWiZM3cNMj65INxTlTzv7
	 /P8B6D8rYzn47oNnr/gkXm399MCm5gmdcTZwAm/cxS/3aPrqZWaK7KbwM0L6XawvEk
	 71Fz7heQ1QeoRFHVkO/uhxHq6IlSL9rBg2kiRaI4=
Date: Tue, 18 Nov 2025 10:12:47 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rework-bdev-block-allocation.patch added to mm-unstable branch
Message-Id: <20251118181248.E6573C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: rework bdev block allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rework-bdev-block-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rework-bdev-block-allocation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rework bdev block allocation
Date: Tue, 18 Nov 2025 16:29:59 +0900

First, writeback bdev ->bitmap bits are set only from one context, as we
can have only one single task performing writeback, so we cannot race with
anything else.  Remove retry path.

Second, we always check ZRAM_WB flag to distinguish writtenback slots, so
we should not confuse 0 bdev block index and 0 handle.  We can use first
bdev block (0 bit) for writeback as well.

While at it, give functions slightly more accurate names, as we don't
alloc/free anything there, we reserve a block for async writeback or
release the block.

Link: https://lkml.kernel.org/r/20251118073000.1928107-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
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
 	struct list_head idle_reqs;
 	struct list_head inflight_reqs;
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
 
@@ -882,7 +881,7 @@ static int zram_writeback_complete(struc
 		 * (if enabled).
 		 */
 		zram_account_writeback_rollback(zram);
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		return err;
 	}
 
@@ -896,7 +895,7 @@ static int zram_writeback_complete(struc
 	 * finishes.
 	 */
 	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		goto out;
 	}
 
@@ -975,8 +974,8 @@ static int zram_writeback_slots(struct z
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
 {
+	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
-	unsigned long blk_idx = 0;
 	struct zram_pp_slot *pps;
 	struct blk_plug io_plug;
 	int ret = 0, err;
@@ -1009,9 +1008,9 @@ static int zram_writeback_slots(struct z
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
@@ -1046,7 +1045,7 @@ static int zram_writeback_slots(struct z
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
-		blk_idx = 0;
+		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
 		continue;
 
@@ -1351,7 +1350,7 @@ static int read_from_bdev(struct zram *z
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 }
 #endif
@@ -1875,7 +1874,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_handle(zram, index));
+		zram_release_bdev_block(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch
zram-rework-bdev-block-allocation.patch
zram-read-slot-block-idx-under-slot-lock.patch

