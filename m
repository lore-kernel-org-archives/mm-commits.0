Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B455A945
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048730; cv=none; b=SV+p/AI6uKvqX9QobThrU7mm4TkNKLNRrIQszrmOKkAH5v9vj/uEpqPrfUUzvMnTPOv4zJCEh6phCGMt+zmadVR0OKGsIh4v3rTKOQ1iLyF5Gx6s+Bg5I1lS9tzmBcs5XJ6nsSjSARtvu8axSgnotvbwhUWRr9HD4vxnw/OkbJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048730; c=relaxed/simple;
	bh=wVbxKU0IVJfrx9Bq2r60O1wROAYm04CBldyMB4zvK0U=;
	h=Date:To:From:Subject:Message-Id; b=geFcwpplc55TjQkf5nCKYzEloy+S9Qt/JQkyDmJT+xZ5Tt7/6DWRwO2L86qKjx5psrWpOG1CxLj/yhbKH1eR8pwn2nWcvvM+JheK1DI9lzQZo54+tmY0iv9Vi4qZcsWNZWoh85UvdFv2+M/ncu1yGpRtDAHfvYcR5zvp5xhr9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QbwAMXmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QbwAMXmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C8AC4CEE4;
	Tue,  4 Mar 2025 00:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048729;
	bh=wVbxKU0IVJfrx9Bq2r60O1wROAYm04CBldyMB4zvK0U=;
	h=Date:To:From:Subject:From;
	b=QbwAMXmMIJibE0XstjuJumx+Rw6p3paFI/BCz/Jhnl+pz/VneNxKvoCz6NNX4OIS8
	 +M6u9juIQ+0ENQw9G1Hm/WADBDJklLFw2+0zn8MGLqjC9yaM1EjU5AWl84tQxM0xxg
	 aHn1izzDbzx5vHQ7t5GMLJRBwokifWFkB+DVPEA0=
Date: Mon, 03 Mar 2025 16:38:49 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-filter-out-recomp-targets-based-on-priority.patch added to mm-unstable branch
Message-Id: <20250304003849.97C8AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: filter out recomp targets based on priority
has been added to the -mm mm-unstable branch.  Its filename is
     zram-filter-out-recomp-targets-based-on-priority.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-filter-out-recomp-targets-based-on-priority.patch

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
Subject: zram: filter out recomp targets based on priority
Date: Mon, 3 Mar 2025 11:03:18 +0900

Do no select for post processing slots that are already compressed with
same or higher priority compression algorithm.

This should save some memory, as previously we would still put those
entries into corresponding post-processing buckets and filter them out
later in recompress_slot().

Link: https://lkml.kernel.org/r/20250303022425.285971-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-filter-out-recomp-targets-based-on-priority
+++ a/drivers/block/zram/zram_drv.c
@@ -1823,7 +1823,7 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -1855,6 +1855,10 @@ static int scan_slots_for_recompress(str
 		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
+		/* Already compressed with same of higher priority */
+		if (zram_get_priority(zram, index) + 1 >= prio_max)
+			goto next;
+
 		pps->index = index;
 		place_pp_slot(zram, ctl, pps);
 		pps = NULL;
@@ -1911,6 +1915,16 @@ static int recompress_slot(struct zram *
 	zram_clear_flag(zram, index, ZRAM_IDLE);
 
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
+
+	prio = max(prio, zram_get_priority(zram, index) + 1);
+	/*
+	 * Recompression slots scan should not select slots that are
+	 * already compressed with a higher priority algorithm, but
+	 * just in case
+	 */
+	if (prio >= prio_max)
+		return 0;
+
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
 	 * and try to recompress the page.
@@ -1919,13 +1933,6 @@ static int recompress_slot(struct zram *
 		if (!zram->comps[prio])
 			continue;
 
-		/*
-		 * Skip if the object is already re-compressed with a higher
-		 * priority algorithm (or same algorithm).
-		 */
-		if (prio <= zram_get_priority(zram, index))
-			continue;
-
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_local_page(page);
@@ -2150,7 +2157,7 @@ static ssize_t recompress_store(struct d
 		goto release_init_lock;
 	}
 
-	scan_slots_for_recompress(zram, mode, ctl);
+	scan_slots_for_recompress(zram, mode, prio_max, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zram-move-post-processing-target-allocation.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-sleepable-zspage-reader-lock.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

