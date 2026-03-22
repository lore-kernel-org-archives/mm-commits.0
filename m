Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEC364952
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139851; cv=none; b=OoRp6V6BPJF/+PVP4MEN4lE97NQSVeKAIwRi/qXAENH4Hi2G2ERP4e+/jU6h3TGobFlczlSA3KBmFCrA5xthpMkCivvrv7OLdz5CEKbC2nkCaGnmOpTtPtfHv1HmqhkXWiF/NZhiZjhN+dZqx4gMndgGJY7FWtbh5z/Hr7C8AFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139851; c=relaxed/simple;
	bh=e0StW82FzVKUPK8JpTqzcEQuF4XIPsZTeb5jJUbcYHI=;
	h=Date:To:From:Subject:Message-Id; b=LKNr48S4R6GCt9c24t9dihjXE6zpbMF6j0xo4PYOcuD+sfCJSdEo/YlJXDyPHtmUreACs6Z6tnVrAP/zAPnkSiwoKMFfslbH/CkNUho6H3Wmp+CKeMjyZVjkjHib9qEnBZw3De2xNwFqJv1agmiVBEkSkyEyThtgohG48PlIF1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iltAwVLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iltAwVLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38780C19421;
	Sun, 22 Mar 2026 00:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139851;
	bh=e0StW82FzVKUPK8JpTqzcEQuF4XIPsZTeb5jJUbcYHI=;
	h=Date:To:From:Subject:From;
	b=iltAwVLhmxJMJGzp2n0u9hf7KgyR2trL/lqre8Q8Eu48o2GCxPu3GzjNXm3pTldbE
	 hTMTyQQInEhvcS/8O5vAPPAKMBP0pVA/ZODhM7wRdAGwYqprAd2WJy9yWq8ozUuEDu
	 6Kqxn6DHqVh4adSZeVsHrw0nAeun05GQB636kt0w=
Date: Sat, 21 Mar 2026 17:37:30 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-do-not-slot_free-written-back-slots.patch removed from -mm tree
Message-Id: <20260322003731.38780C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not slot_free() written-back slots
has been removed from the -mm tree.  Its filename was
     zram-do-not-slot_free-written-back-slots.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not slot_free() written-back slots
Date: Thu, 19 Mar 2026 12:44:56 +0900

slot_free() basically completely resets the slots by clearing all of
its flags and attributes.  While zram_writeback_complete() restores
some of flags back (those that are necessary for async read
decompression) we still lose a lot of slot's metadata.  For example,
slot's ac-time, or ZRAM_INCOMPRESSIBLE.

More importantly, restoring flags/attrs requires extra attention as
some of the flags are directly affecting zram device stats.  And the
original code did not pay that attention.  Namely ZRAM_HUGE slots
handling in zram_writeback_complete().  The call to slot_free() would
decrement ->huge_pages, however when zram_writeback_complete() restored
the slot's ZRAM_HUGE flag, it would not get reflected in an incremented
->huge_pages.  So when the slot would finally get freed, slot_free()
would decrement ->huge_pages again, leading to underflow.

Fix this by open-coding the required memory free and stats updates in
zram_writeback_complete(), rather than calling the destructive
slot_free().  Since we now preserve the ZRAM_HUGE flag on written-back
slots (for the deferred decompression path), we also update slot_free()
to skip decrementing ->huge_pages if ZRAM_WB is set.

Link: https://lkml.kernel.org/r/20260320023143.2372879-1-senozhatsky@chromium.org
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

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch
zram-propagate-read_from_bdev_async-errors.patch
zram-change-scan_slots-to-return-void.patch

