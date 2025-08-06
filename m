Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596935898
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519221; cv=none; b=aHk/k+KQ5uZ6UH/BnARe6ih5kXI0FhtFnUM+Q5dLBq77zPhoWpc3gFH42kVK3vlNsuxZlYdlTgjijaOWd59P/YKvzZgB+JF+0JnXLJtSFVBeNrHihLWdOmcZn+irGtqzMVV70Vnjv65dz0++zQ8DSn8hXwUvrJAkQzfYcUEuYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519221; c=relaxed/simple;
	bh=W5ZLbpZS5xxmhDgytbJ6Enxh8Ji643w6jeH1u/kJyKw=;
	h=Date:To:From:Subject:Message-Id; b=K/3H5Le2O2GwwJTirbjL8LpgvYhwXuLo9xluntjV/tdCfXAvDtYEQl2XEugUwHjbYdlmwLoLGwHRREFFfLzfIQSw9p2y2ETEvf4OWCI00zHSnDfxRIAy/v8PJgaaChTUAF/nx6jF13iZHnK+Au++5dHtldx93b6kwOKA/0Gd8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdV8X724; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdV8X724"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B59C4CEE7;
	Wed,  6 Aug 2025 22:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754519220;
	bh=W5ZLbpZS5xxmhDgytbJ6Enxh8Ji643w6jeH1u/kJyKw=;
	h=Date:To:From:Subject:From;
	b=ZdV8X724UO00SJb+iFkLKPA3PuNhS4od7xFMKP7IUg4ae11wA1csImwNXMxwlRjyZ
	 Da7gkd3ok3C7Gbguyf9CZItcdF8F+f5cYGxxCUvK5UzjhSoHIh8PTzB/i9eqqvHj5v
	 o7iyY1gwwnQ1gLS3b9cXcfdB6fbbFNAZAltbIaM8=
Date: Wed, 06 Aug 2025 15:27:00 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-only-scan-one-cluster-in-fragment-list.patch added to mm-new branch
Message-Id: <20250806222700.B8B59C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: only scan one cluster in fragment list
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-only-scan-one-cluster-in-fragment-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-only-scan-one-cluster-in-fragment-list.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: only scan one cluster in fragment list
Date: Thu, 7 Aug 2025 00:17:46 +0800

Patch series "mm, swap: improve cluster scan strategy", v2.

This series improves the large allocation performance and reduces the
failure rate.  Some design of the cluster alloactor was later found to be
improvable after thorough testing.

The allocator spent too much effort scanning the fragment list, which is
not helpful in most setups, but causes serious contention of the list lock
(si->lock).  Besides, the allocator prefers free clusters when searching
for a new cluster due to historical reasons, which causes fragmentation
issues.

So make the allocator only scan one cluster for high order allocation, and
prefer nonfull cluster.  This both improves the performance and reduces
fragmentation.

For example, build kernel test with make -j96 and 10G ZRAM with 64kB mTHP
enabled shows better performance and a lower failure rate:

Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback: 20917
After:  sys time: 5587.53s   64kB/swpout: 1811598  64kB/swpout_fallback: 0

System time is cut in half, and the failure rate drops to zero. Larger
allocations in a hybrid workload also showed a major improvement:

512kB swap failure rate:
Before: swpout:11663  swpout_fallback:1767
After:  swpout:14480  swpout_fallback:6

2M swap failure rate:
Before: swpout:24     swpout_fallback:1442
After:  swpout:1329   swpout_fallback:7


This patch (of 3):

Fragment clusters were mostly failing high order allocation already.  The
reason we scan it through now is that a swap slot may get freed without
releasing the swap cache, so a swap map entry will end up in HAS_CACHE
only status, and the cluster won't be moved back to non-full or free
cluster list.  This may cause a higher allocation failure rate.

Usually only !SWP_SYNCHRONOUS_IO devices may have a large number of slots
stuck in HAS_CACHE only status.  Because when a !SWP_SYNCHRONOUS_IO
device's usage is low (!vm_swap_full()), it will try to lazy free the swap
cache.

But this fragment list scan out is a bit overkill.  Fragmentation is only
an issue for the allocator when the device is getting full, and by that
time, swap will be releasing the swap cache aggressively already.  Only
scan one fragment cluster at a time is good enough to reclaim already
pinned slots, and move the cluster back to nonfull.

And besides, only high order allocation requires iterating over the list,
order 0 allocation will succeed on the first attempt.  And high order
allocation failure isn't a serious problem.

So the iteration of fragment clusters is trivial, but it will slow down
large allocation by a lot when the fragment cluster list is long.  So it's
better to drop this fragment cluster iteration design.

Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio only:

Before: sys time: 4432.56s
After:  sys time: 4430.18s

Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:

Before: sys time: 11609.69s  64kB/swpout: 1787051  64kB/swpout_fallback: 20917
After:  sys time: 5572.85s   64kB/swpout: 1797612  64kB/swpout_fallback: 19254

Change to 8G ZRAM:

Before: sys time: 21524.35s  64kB/swpout: 1687142  64kB/swpout_fallback: 128496
After:  sys time: 6278.45s   64kB/swpout: 1679127  64kB/swpout_fallback: 130942

Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 7393.50s  64kB/swpout:1788246  swpout_fallback: 0
After:  sys time: 7399.88s  64kB/swpout:1784257  swpout_fallback: 0

Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 26292.26s 64kB/swpout:1645236  swpout_fallback: 138945
After:  sys time: 9463.16s  64kB/swpout:1581376  swpout_fallback: 259979

The performance is a lot better for large folios, and the large order
allocation failure rate is only very slightly higher or unchanged even
for !SWP_SYNCHRONOUS_IO devices high pressure.

Link: https://lkml.kernel.org/r/20250806161748.76651-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250806161748.76651-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/mm/swapfile.c~mm-swap-only-scan-one-cluster-in-fragment-list
+++ a/mm/swapfile.c
@@ -926,32 +926,25 @@ new_cluster:
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
-		unsigned int frags = 0, frags_existing;
-
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			/* Clusters failed to allocate are moved to frag_clusters */
-			frags++;
 		}
 
-		frags_existing = atomic_long_read(&si->frag_cluster_nr[order]);
-		while (frags < frags_existing &&
-		       (ci = isolate_lock_cluster(si, &si->frag_clusters[order]))) {
-			atomic_long_dec(&si->frag_cluster_nr[order]);
-			/*
-			 * Rotate the frag list to iterate, they were all
-			 * failing high order allocation or moved here due to
-			 * per-CPU usage, but they could contain newly released
-			 * reclaimable (eg. lazy-freed swap cache) slots.
-			 */
+		/*
+		 * Scan only one fragment cluster is good enough. Order 0
+		 * allocation will surely success, and large allocation
+		 * failure is not critical. Scanning one cluster still
+		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 */
+		ci = isolate_lock_cluster(si, &si->frag_clusters[order]);
+		if (ci) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			frags++;
 		}
 	}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch

