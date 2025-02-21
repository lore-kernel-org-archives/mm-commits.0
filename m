Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DA524C67B
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181365; cv=none; b=Lg3a6ukBXPvuG5jT5vidjtw6xPb5URQD1g1WcNuzUtN3ReblbhhaJSvmexF10pgiI2E4wWM3rRpfqDZpezjR+zALBga54pE7rCF7gG/5OQfVXbAfX6GzNRQOQ4NybafP7Q6sLjwLt2eW+mfoFk2iwkSOCB1K4PnCGHWn2qBsOtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181365; c=relaxed/simple;
	bh=RY5vDPBbw5h+B5nGqTS9Kpod73pk4Q0mUI4YhL+oDmY=;
	h=Date:To:From:Subject:Message-Id; b=LVkSaR6RE636QtueAAShT/RfBaE3pAmDDKuq/nCezyW49Cg1K4yrup0c6VyG35ro68RkrWoykHjYr5hpveXZ0tduwkq/OaAAglHszcGXEv6bJKOox9fkDHZiWNCcvW7mkIJjc+ptxPRUeDue+Sh2LthOdT/w2u0XZBbxYS6ju7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQ0aNoR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQ0aNoR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE114C4CED6;
	Fri, 21 Feb 2025 23:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181364;
	bh=RY5vDPBbw5h+B5nGqTS9Kpod73pk4Q0mUI4YhL+oDmY=;
	h=Date:To:From:Subject:From;
	b=qQ0aNoR8QIhdLH/KYK7yZIBmIVl5uSKZ97I8MMym4AYbjuA2ojvxa0Z0kBlMok6uO
	 ys2FO7WB63A3QpvOw47kh2E7zc1Qv7V7X3AX7Zuzoy47+v7ygpj4hy8FPkvz6zpuaf
	 LbBWxLhCGmy2Ymr4aupsDZiBexa9GSOFUK9V8M1A=
Date: Fri, 21 Feb 2025 15:42:44 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-filter-out-recomp-targets-based-on-priority.patch added to mm-unstable branch
Message-Id: <20250221234244.CE114C4CED6@smtp.kernel.org>
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
Date: Sat, 22 Feb 2025 07:25:39 +0900

Do no select for post processing slots that are already compressed with
same or higher priority compression algorithm.

This should save some memory, as previously we would still put those
entries into corresponding post-processing buckets and filter them out
later in recompress_slot().

Link: https://lkml.kernel.org/r/20250221222958.2225035-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-filter-out-recomp-targets-based-on-priority
+++ a/drivers/block/zram/zram_drv.c
@@ -1827,7 +1827,7 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -1859,6 +1859,10 @@ static int scan_slots_for_recompress(str
 		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
+		/* Already compressed with same of higher priority */
+		if (zram_get_priority(zram, index) + 1 >= prio_max)
+			goto next;
+
 		pps->index = index;
 		place_pp_slot(zram, ctl, pps);
 		pps = NULL;
@@ -1915,6 +1919,16 @@ static int recompress_slot(struct zram *
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
@@ -1923,13 +1937,6 @@ static int recompress_slot(struct zram *
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
@@ -2154,7 +2161,7 @@ static ssize_t recompress_store(struct d
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
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

