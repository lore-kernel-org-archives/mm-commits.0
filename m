Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BD3E3D80
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314193; cv=none; b=P9YXlrVw93us39M02IrJ45TAerz6tpCxfqwAqCQgIQvLI5MRGs5X/EDc1XrgYJVMUyHzRtbkHCXeCV200RzPf0TvVqNgrA9bFcjRQiAjxcbHc6N9rGhUECIhlzoaqqOz94rAH5q2/znrWVaevrRzKnLcv0jpHVhxn05dFO3t8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314193; c=relaxed/simple;
	bh=MapPxFz7kYUf2dbkZaMffo0Zlg8hymEAlTmxqslaI80=;
	h=Date:To:From:Subject:Message-Id; b=rF2r7J8PcsPbPG+xLTI1B3NcYHPji+AFlpv3ENE0Okvj1r3ncSQuXENcvk08FMeM/yhHMgsoebk6sAXhqmRdhBBfxmtKv9R2a8kRycNBS6nS3ofG1vVk/0XKNhj+TVbj9UELS07vPinYly4OVUwOgMpY3RxALEu/XdzYaAqF1Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HPOY7Rsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HPOY7Rsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42070C2BCB7;
	Mon, 27 Apr 2026 18:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314193;
	bh=MapPxFz7kYUf2dbkZaMffo0Zlg8hymEAlTmxqslaI80=;
	h=Date:To:From:Subject:From;
	b=HPOY7RsknKpUtTkiYFqlvfzTuEz4G2GmToXcBPvPhkYpgaq+GjrFMVLN+f0T0VuQX
	 0udrCA9AGdjFc3X1aLVCQ6GULBf8lvOzyYosgOWQruW0mS2eN7hv3W7D7y9OzK9JPE
	 LLmlPXjBFNgj8IiSuDhvluUNRiTZ/rQs4KM0+FLA=
Date: Mon, 27 Apr 2026 11:23:12 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch added to mm-new branch
Message-Id: <20260427182313.42070C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: relocate the LRU scan batch limit to callers
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: relocate the LRU scan batch limit to callers
Date: Tue, 28 Apr 2026 02:06:54 +0800

Same as active / inactive LRU, MGLRU isolates and scans folios in batches.
The batch split is done hidden deep in the helper, which makes the code
harder to follow.  The helper's arguments are also confusing since callers
usually request more folios than the batch size, so the helper almost
never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-relocate-the-lru-scan-batch-limit-to-callers
+++ a/mm/vmscan.c
@@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lru
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruv
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

