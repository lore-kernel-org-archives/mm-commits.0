Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256237A48D
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960297; cv=none; b=M34oPOzeFic2SUEEkZ+TjmsVZnfykdcHFAqVITg6b9yoLSx2onNvOCemd5/wPB9CtXJJTuBKXhki3ajV4gRTzVhbWcAxxbPFgDFERN9viQebkxKUSoq/8NpWTvhYiOdO+UkHukBvzN/fbeWO3tBtlbtoYYSqU/QjaUPt9/J7PIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960297; c=relaxed/simple;
	bh=NlzP2fsjrWh6vHevW3EAiWMMFvR9ybvpi3Jsm5dEyd0=;
	h=Date:To:From:Subject:Message-Id; b=HaIJHySR565b/dnVXQ9DFupKcJ+YVq/YJ4/USc+4nGBxmXycDCXdHFjk6723bV9nBPQBeEJRgUir2KFxc6BcIXJqLbGFNPjEjNU0R2FqUwuSUhuFtseznRrFsqMV99LAdSu6jdK9mPkMOUkWtUtGWZPDY6fznwVBj9Ft35U6gPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cFo4vo1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cFo4vo1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488D2C2BC9E;
	Thu, 19 Mar 2026 22:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960297;
	bh=NlzP2fsjrWh6vHevW3EAiWMMFvR9ybvpi3Jsm5dEyd0=;
	h=Date:To:From:Subject:From;
	b=cFo4vo1Dgm0QaysYYq3zgH46iECMTFs6c8O32QNlpgoUquFpTn5I8DZTveqM2yAFa
	 mVHr0QamDVFk7OcvRbtUvahSFqfUqICRiIbWiN0TMbqI5BqVn47JvzjJ08bx2a8wmB
	 nM/8RpNko32OWo34AWs9PxNn1dcy2Vmo4ps7hpIY=
Date: Thu, 19 Mar 2026 15:44:56 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-slot_free-written-back-slots.patch added to mm-hotfixes-unstable branch
Message-Id: <20260319224457.488D2C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not slot_free() written-back slots
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-do-not-slot_free-written-back-slots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-slot_free-written-back-slots.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not slot_free() written-back slots
Date: Thu, 19 Mar 2026 12:44:56 +0900

slot_free() basically completely resets the slots by clearing all of its
flags and attributes.  While zram_writeback_complete() restores some of
flags back (those that are necessary for async read decompression) we
still lose a lot of slot's metadata.  For example, slot's ac-time, or
ZRAM_INCOMPRESSIBLE.

Do not slot_free() on writeback, instead clear only those flags/attrs that
we need to clear.

Link: https://lkml.kernel.org/r/20260319034912.1894770-1-senozhatsky@chromium.org
Fixes: d38fab605c667 ("zram: introduce compressed data writeback")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   39 +++++++++++---------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-slot_free-written-back-slots
+++ a/drivers/block/zram/zram_drv.c
@@ -917,9 +917,8 @@ static void zram_account_writeback_submi
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 {
-	u32 size, index = req->pps->index;
-	int err, prio;
-	bool huge;
+	u32 index = req->pps->index;
+	int err;
 
 	err = blk_status_to_errno(req->bio.bi_status);
 	if (err) {
@@ -946,28 +945,13 @@ static int zram_writeback_complete(struc
 		goto out;
 	}
 
-	if (zram->compressed_wb) {
-		/*
-		 * ZRAM_WB slots get freed, we need to preserve data required
-		 * for read decompression.
-		 */
-		size = get_slot_size(zram, index);
-		prio = get_slot_comp_priority(zram, index);
-		huge = test_slot_flag(zram, index, ZRAM_HUGE);
-	}
-
-	slot_free(zram, index);
-	set_slot_flag(zram, index, ZRAM_WB);
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	if (test_slot_flag(zram, index, ZRAM_HUGE))
+		atomic64_dec(&zram->stats.huge_pages);
+	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
+	zs_free(zram->mem_pool, get_slot_handle(zram, index));
 	set_slot_handle(zram, index, req->blk_idx);
-
-	if (zram->compressed_wb) {
-		if (huge)
-			set_slot_flag(zram, index, ZRAM_HUGE);
-		set_slot_size(zram, index, size);
-		set_slot_comp_priority(zram, index, prio);
-	}
-
-	atomic64_inc(&zram->stats.pages_stored);
+	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
 	slot_unlock(zram, index);
@@ -2010,8 +1994,13 @@ static void slot_free(struct zram *zram,
 	set_slot_comp_priority(zram, index, 0);
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
+		/*
+		 * Writeback completion decrements ->huge_pages but keeps
+		 * ZRAM_HUGE flag for deferred decompression path.
+		 */
+		if (!test_slot_flag(zram, index, ZRAM_WB))
+			atomic64_dec(&zram->stats.huge_pages);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
-		atomic64_dec(&zram->stats.huge_pages);
 	}
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-slot_free-written-back-slots.patch
zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch
zram-propagate-read_from_bdev_async-errors.patch
zram-change-scan_slots-to-return-void.patch

