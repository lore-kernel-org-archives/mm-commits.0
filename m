Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EDE2C0287
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268307; cv=none; b=uHRhX/I3U5gdbNr0VUE88c6kaPOi9a2n34qQmS5n/JSvLiFd5FjQFy+1Z+WKESR3h3EV9zt3URE/dCrjOrybNGr2qUHgM+Vy4T9G24zYv3mFM8xzH0VNKbc+5X5ZmyARnVlAJzZmtc9ZGrGfFjLufhmEr2O2O0MQlNb/G4adNUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268307; c=relaxed/simple;
	bh=yBhgv9450Ax0i0TwHvhME9X/UCQWJyXJ1VVmg02gItc=;
	h=Date:To:From:Subject:Message-Id; b=Zj8NavqNF2AtD+GXro/GiKIeuiJN/cPsayIVGBMqqkdqmdau1u5GKZ5Go00+WA6nbq5ZUiUcwO/KdkoXJeLyAfr5nUfDuOmO0/to+pP0cbZO9YlICWtNWMYBRe34mnFb+t3SgQjXX09SlGfvbVM3SkbIf3kYPIG0lBYWf3RgTsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CihLkezB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CihLkezB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01866C4CEF5;
	Sat, 20 Dec 2025 22:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268307;
	bh=yBhgv9450Ax0i0TwHvhME9X/UCQWJyXJ1VVmg02gItc=;
	h=Date:To:From:Subject:From;
	b=CihLkezBqFdB5T2FlYQ5+/p1tHrz1CurYg1F2nybzNriBhOXAyQMXS43giia9z9aC
	 aHS83NKyr/pqmrgZ3K/p8G1lFZ6uZSK1x5JatOEOkfR4HhFhg4q2n2J577dTiHV+kP
	 mMu5DDxkIC3lQSr+qctXSeyTQlEZVQxOwOiiD5zo=
Date: Sat, 20 Dec 2025 14:05:06 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-consolidate-cluster-reclaim-and-usability-check.patch added to mm-new branch
Message-Id: <20251220220507.01866C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: consolidate cluster reclaim and usability check
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-consolidate-cluster-reclaim-and-usability-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-consolidate-cluster-reclaim-and-usability-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm, swap: consolidate cluster reclaim and usability check
Date: Sat, 20 Dec 2025 03:43:39 +0800

Swap cluster cache reclaim requires releasing the lock, so the cluster may
become unusable after the reclaim.  To prepare for checking swap cache
using the swap table directly, consolidate the swap cluster reclaim and
the check logic.

We will want to avoid touching the cluster's data completely with the swap
table, to avoid RCU overhead here.  And by moving the cluster usable check
into the reclaim helper, it will also help avoid a redundant scan of the
slots if the cluster is no longer usable, and we will want to avoid
touching the cluster.

Also, adjust it very slightly while at it: always scan the whole region
during reclaim, don't skip slots covered by a reclaimed folio.  Because
the reclaim is lockless, it's possible that new cache lands at any time. 
And for allocation, we want all caches to be reclaimed to avoid
fragmentation.  Besides, if the scan offset is not aligned with the size
of the reclaimed folio, we might skip some existing cache and fail the
reclaim unexpectedly.

There should be no observable behavior change.  It might slightly improve
the fragmentation issue or performance.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-10-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-consolidate-cluster-reclaim-and-usability-check
+++ a/mm/swapfile.c
@@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(s
 	return 0;
 }
 
+/*
+ * Reclaim drops the ci lock, so the cluster may become unusable (freed or
+ * stolen by a lower order). @usable will be set to false if that happens.
+ */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+				  unsigned long start, unsigned int order,
+				  bool *usable)
 {
+	unsigned int nr_pages = 1 << order;
+	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
-			offset++;
 			break;
 		case SWAP_HAS_CACHE:
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim > 0)
-				offset += nr_reclaim;
-			else
+			if (nr_reclaim < 0)
 				goto out;
 			break;
 		default:
 			goto out;
 		}
-	} while (offset < end);
+	} while (++offset < end);
 out:
 	spin_lock(&ci->lock);
+
+	/*
+	 * We just dropped ci->lock so cluster could be used by another
+	 * order or got freed, check if it's still usable or empty.
+	 */
+	if (!cluster_is_usable(ci, order)) {
+		*usable = false;
+		return false;
+	}
+	*usable = true;
+
+	/* Fast path, no need to scan if the whole cluster is empty */
+	if (cluster_is_empty(ci))
+		return true;
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
@@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_clus
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON(!cluster_is_usable(ci, order));
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_clus
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
-			/*
-			 * Reclaim drops ci->lock and cluster could be used
-			 * by another order. Not checking flag as off-list
-			 * cluster has no flag set, and change of list
-			 * won't cause fragmentation.
-			 */
-			if (!cluster_is_usable(ci, order))
+			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
 				offset = start;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

