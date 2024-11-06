Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F60D16C684
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854711; cv=none; b=Hq7ANR70X0c3eSi1cgrBBr2dSyJU2w8onFE4dUWTMaA43hQslnfkdVrvCXiGjvqcdGCh1v0MaHpEeRNVJkL9yZPvUKn2z0RGn6YHGKcdNJw8DV/iFmzzNQvxLYB8Jws2VUMa9DOnN826qmTD2OCIOggicd1kh+Ajo6OG7bX+UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854711; c=relaxed/simple;
	bh=RirwSRIUnuPuTdvlsHl2BFoDCCGi/5Cgzk6azGyGHF4=;
	h=Date:To:From:Subject:Message-Id; b=O2X+wpTF/25grXwDqygHHFZi/UBuirVV3l5QvtrNjthCkPrQ8bPKSQRFGrvvrFjX+BQS9vaqJGiOZJB14cYRTwrCtSJCYj+Vze2dLkUiSPEcjP5498fcKvBYYNmwJSMA/VYvlETSvBYKJereROuQm0LU5bjso5+yRHoEqsAEnqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+w5nVgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+w5nVgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85331C4CED1;
	Wed,  6 Nov 2024 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854710;
	bh=RirwSRIUnuPuTdvlsHl2BFoDCCGi/5Cgzk6azGyGHF4=;
	h=Date:To:From:Subject:From;
	b=O+w5nVgzb2OlwMlfB5gaCR3cI4ALio1cFbFxfKzrHknYRYiTBtS04lAs47PUChsvT
	 rEuGm4bS/BaCfy1noC+B56+pHCnms6C0V8xHIowlkNC+p8oC4J9k56vBIOGUL2wpip
	 lmSYav3G+7yy7G7w/yZSKVnN6Zuh50dkB425PnFs=
Date: Tue, 05 Nov 2024 16:58:30 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-under_wb-and-simplify-writeback.patch removed from -mm tree
Message-Id: <20241106005830.85331C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove UNDER_WB and simplify writeback
has been removed from the -mm tree.  Its filename was
     zram-remove-under_wb-and-simplify-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove UNDER_WB and simplify writeback
Date: Tue, 17 Sep 2024 11:09:12 +0900

We now have only one active post-processing at any time, so we don't have
same race conditions that we had before.  If slot selected for
post-processing gets freed or freed and reallocated it loses its PP_SLOT
flag and there is no way for such a slot to gain PP_SLOT flag again until
current post-processing terminates.

Link: https://lkml.kernel.org/r/20240917021020.883356-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   53 +++++++++-----------------------
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 16 insertions(+), 38 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-under_wb-and-simplify-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -390,10 +390,7 @@ static void mark_idle(struct zram *zram,
 
 	for (index = 0; index < nr_pages; index++) {
 		/*
-		 * Do not mark ZRAM_UNDER_WB slot as ZRAM_IDLE to close race.
-		 * See the comment in writeback_store.
-		 *
-		 * Also do not mark ZRAM_SAME slots as ZRAM_IDLE, because no
+		 * Do not mark ZRAM_SAME slots as ZRAM_IDLE, because no
 		 * post-processing (recompress, writeback) happens to the
 		 * ZRAM_SAME slot.
 		 *
@@ -402,7 +399,6 @@ static void mark_idle(struct zram *zram,
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index) ||
 		    zram_test_flag(zram, index, ZRAM_WB) ||
-		    zram_test_flag(zram, index, ZRAM_UNDER_WB) ||
 		    zram_test_flag(zram, index, ZRAM_SAME)) {
 			zram_slot_unlock(zram, index);
 			continue;
@@ -821,22 +817,17 @@ static ssize_t writeback_store(struct de
 
 		index = pps->index;
 		zram_slot_lock(zram, index);
-		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
-			goto next;
 		/*
-		 * Clearing ZRAM_UNDER_WB is duty of caller.
-		 * IOW, zram_free_page never clear it.
+		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
+		 * slots can change in the meantime. If slots are accessed or
+		 * freed they lose ZRAM_PP_SLOT flag and hence we don't
+		 * post-process them.
 		 */
-		zram_set_flag(zram, index, ZRAM_UNDER_WB);
-		/* Need for hugepage writeback racing */
-		zram_set_flag(zram, index, ZRAM_IDLE);
+		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
+			goto next;
 		zram_slot_unlock(zram, index);
-		if (zram_read_page(zram, page, index, NULL)) {
-			zram_slot_lock(zram, index);
-			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
-			zram_clear_flag(zram, index, ZRAM_IDLE);
-			zram_slot_unlock(zram, index);
 
+		if (zram_read_page(zram, page, index, NULL)) {
 			release_pp_slot(zram, pps);
 			continue;
 		}
@@ -852,11 +843,6 @@ static ssize_t writeback_store(struct de
 		 */
 		err = submit_bio_wait(&bio);
 		if (err) {
-			zram_slot_lock(zram, index);
-			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
-			zram_clear_flag(zram, index, ZRAM_IDLE);
-			zram_slot_unlock(zram, index);
-
 			release_pp_slot(zram, pps);
 			/*
 			 * BIO errors are not fatal, we continue and simply
@@ -871,25 +857,19 @@ static ssize_t writeback_store(struct de
 		}
 
 		atomic64_inc(&zram->stats.bd_writes);
+		zram_slot_lock(zram, index);
 		/*
-		 * We released zram_slot_lock so need to check if the slot was
-		 * changed. If there is freeing for the slot, we can catch it
-		 * easily by zram_allocated.
-		 * A subtle case is the slot is freed/reallocated/marked as
-		 * ZRAM_IDLE again. To close the race, idle_store doesn't
-		 * mark ZRAM_IDLE once it found the slot was ZRAM_UNDER_WB.
-		 * Thus, we could close the race by checking ZRAM_IDLE bit.
+		 * Same as above, we release slot lock during writeback so
+		 * slot can change under us: slot_free() or slot_free() and
+		 * reallocation (zram_write_page()). In both cases slot loses
+		 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
+		 * ZRAM_PP_SLOT on such slots until current post-processing
+		 * finishes.
 		 */
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index) ||
-			  !zram_test_flag(zram, index, ZRAM_IDLE)) {
-			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
-			zram_clear_flag(zram, index, ZRAM_IDLE);
+		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		}
 
 		zram_free_page(zram, index);
-		zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 		zram_set_flag(zram, index, ZRAM_WB);
 		zram_set_element(zram, index, blk_idx);
 		blk_idx = 0;
@@ -1538,7 +1518,6 @@ out:
 	atomic64_dec(&zram->stats.pages_stored);
 	zram_set_handle(zram, index, 0);
 	zram_set_obj_size(zram, index, 0);
-	WARN_ON_ONCE(zram->table[index].flags & ~(1UL << ZRAM_UNDER_WB));
 }
 
 /*
--- a/drivers/block/zram/zram_drv.h~zram-remove-under_wb-and-simplify-writeback
+++ a/drivers/block/zram/zram_drv.h
@@ -47,7 +47,6 @@
 enum zram_pageflags {
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,	/* Page consists the same element */
 	ZRAM_WB,	/* page is stored on backing_device */
-	ZRAM_UNDER_WB,	/* page is under writeback */
 	ZRAM_PP_SLOT,	/* Selected for post-processing */
 	ZRAM_HUGE,	/* Incompressible page */
 	ZRAM_IDLE,	/* not accessed page since last idle marking */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch

