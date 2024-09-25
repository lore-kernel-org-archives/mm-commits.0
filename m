Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D641849
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225604; cv=none; b=AXJm0HVz/gR7h7ON7AbWkRUNIs34qsY69COiajD2YfxmgAVAljgESzTwrbx9a9lJ5YyT33Vj3X14FeOtcgEo/Ta+fq0L9WoHTjHfK9MHuVc6zYbE/bg0fJ4ZJeX+fCKLGIvfRo+bHz9Lk90HkRKuS5k5NLcfnsICuDQK0oDCzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225604; c=relaxed/simple;
	bh=qtlpGLaBm7xeQ7NrO4+h45v2sbu8vXrcZccsClukamI=;
	h=Date:To:From:Subject:Message-Id; b=LzkJYQjX3h+hRKdspb5tZhjqrazs+y8ZUNZZP7LOMIOvFxcwjgQOECrw8JKtddg1Nic4DmTRYbuH86yrD42VC7l2Gno46VMWFDwmgonuCes69m7284H/3V/HvdMhsoo+62KFJQd8n88LEukBYCqzqLtx+EdgpD9xi+04KoAB7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TWSIRohT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TWSIRohT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65865C4CEC7;
	Wed, 25 Sep 2024 00:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225603;
	bh=qtlpGLaBm7xeQ7NrO4+h45v2sbu8vXrcZccsClukamI=;
	h=Date:To:From:Subject:From;
	b=TWSIRohTs0M31DKlmC1O4SLUP5kaDW+OZnEdhdWD3g8DuYrS4FQ+TBEyXJ81opwKT
	 nJ7dEh7dc09w6L/w3ibH8bUO4cmDHVo4EIPUTC43VSyu/8C6S5bGvqVahXmqu8jwn/
	 dq9bKvjCafaPPUtKTNCjNWWIKU7WWbKplnwIeOH8=
Date: Tue, 24 Sep 2024 17:53:22 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-under_wb-and-simplify-writeback.patch added to mm-unstable branch
Message-Id: <20240925005323.65865C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove UNDER_WB and simplify writeback
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-under_wb-and-simplify-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-under_wb-and-simplify-writeback.patch

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

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch

