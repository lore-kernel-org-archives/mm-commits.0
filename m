Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043005695
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813980; cv=none; b=pNjLQbhktgFFfFguMa1K+XVGZDtWWrTdxh3ResWpBXwfhm/AFKQcr6bmv0FSJqA79WqzbBWxC0/ZrrB5bVeYxaWQToj791cuJVW4PHZ5H/VbZA6CTrCQfb3FBOK6MM5iVg3Bij33tYt4qHBlfS0PA+1MQER4Lv9HzOlg9zF/zqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813980; c=relaxed/simple;
	bh=+ngGN7f2hcSSU0EFxA2bLtOo2vidpBTGIO82a5GzJQE=;
	h=Date:To:From:Subject:Message-Id; b=L6RhUAYWigFeJvKo5zkTbDgxU1Jy7l+H755fKg3SfRU+hjRJTdtlhy9gZuS8Ne1UUJAYwnXLYAqo2jSLeiEzpk6E1XklMZ61WS+oHLM+2NNonvLpmvzjjJomuLuDDiZZVdTKl/3F6Im2HkcueywoOx4X9PFM+/CSzyValu6C0NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVYTNduR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVYTNduR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5A8C4CED6;
	Tue, 14 Jan 2025 00:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736813979;
	bh=+ngGN7f2hcSSU0EFxA2bLtOo2vidpBTGIO82a5GzJQE=;
	h=Date:To:From:Subject:From;
	b=oVYTNduR1n2SumjZrQmPxAND83HzvMBfttxq9cLJgMW9+y9Xvxy2+65yHC1InxwmY
	 PtzkseiVg89od/3kRhevIhKyLgWSX9Nv33pEbB0G9Yim+DhCwQDfW89QLyqg8lFFhU
	 LHCRoAkRvy7XMIMbo/SdvmCmoF8eQ5Ofb6FfsFaw=
Date: Mon, 13 Jan 2025 16:19:38 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-cluster-lock-for-hdd.patch added to mm-unstable branch
Message-Id: <20250114001939.8D5A8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: use cluster lock for HDD
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-cluster-lock-for-hdd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-cluster-lock-for-hdd.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: use cluster lock for HDD
Date: Tue, 14 Jan 2025 01:57:23 +0800

Cluster lock (ci->lock) was introduced to reduce contention for certain
operations.  Using cluster lock for HDD is not helpful as HDD have a poor
performance, so locking isn't the bottleneck.  But having different set of
locks for HDD / non-HDD prevents further rework of device lock (si->lock).

This commit just changed all lock_cluster_or_swap_info to lock_cluster,
which is a safe and straight conversion since cluster info is always
allocated now, also removed all cluster_info related checks.

Link: https://lkml.kernel.org/r/20250113175732.48099-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |  109 +++++++++++++++---------------------------------
 1 file changed, 35 insertions(+), 74 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-cluster-lock-for-hdd
+++ a/mm/swapfile.c
@@ -58,10 +58,9 @@ static void swap_entry_range_free(struct
 static void swap_range_alloc(struct swap_info_struct *si, unsigned long offset,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
-static struct swap_cluster_info *lock_cluster_or_swap_info(
-		struct swap_info_struct *si, unsigned long offset);
-static void unlock_cluster_or_swap_info(struct swap_info_struct *si,
-					struct swap_cluster_info *ci);
+static struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
+					      unsigned long offset);
+static void unlock_cluster(struct swap_cluster_info *ci);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -222,9 +221,9 @@ static int __try_to_reclaim_swap(struct
 	 * swap_map is HAS_CACHE only, which means the slots have no page table
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	need_reclaim = swap_is_has_cache(si, offset, nr_pages);
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	if (!need_reclaim)
 		goto out_unlock;
 
@@ -404,45 +403,15 @@ static inline struct swap_cluster_info *
 {
 	struct swap_cluster_info *ci;
 
-	ci = si->cluster_info;
-	if (ci) {
-		ci += offset / SWAPFILE_CLUSTER;
-		spin_lock(&ci->lock);
-	}
-	return ci;
-}
-
-static inline void unlock_cluster(struct swap_cluster_info *ci)
-{
-	if (ci)
-		spin_unlock(&ci->lock);
-}
-
-/*
- * Determine the locking method in use for this device.  Return
- * swap_cluster_info if SSD-style cluster-based locking is in place.
- */
-static inline struct swap_cluster_info *lock_cluster_or_swap_info(
-		struct swap_info_struct *si, unsigned long offset)
-{
-	struct swap_cluster_info *ci;
-
-	/* Try to use fine-grained SSD-style locking if available: */
-	ci = lock_cluster(si, offset);
-	/* Otherwise, fall back to traditional, coarse locking: */
-	if (!ci)
-		spin_lock(&si->lock);
+	ci = &si->cluster_info[offset / SWAPFILE_CLUSTER];
+	spin_lock(&ci->lock);
 
 	return ci;
 }
 
-static inline void unlock_cluster_or_swap_info(struct swap_info_struct *si,
-					       struct swap_cluster_info *ci)
+static inline void unlock_cluster(struct swap_cluster_info *ci)
 {
-	if (ci)
-		unlock_cluster(ci);
-	else
-		spin_unlock(&si->lock);
+	spin_unlock(&ci->lock);
 }
 
 /* Add a cluster to discard list and schedule it to do discard */
@@ -558,9 +527,6 @@ static void inc_cluster_info_page(struct
 	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
 	struct swap_cluster_info *ci;
 
-	if (!cluster_info)
-		return;
-
 	ci = cluster_info + idx;
 	ci->count++;
 
@@ -576,9 +542,6 @@ static void inc_cluster_info_page(struct
 static void dec_cluster_info_page(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci, int nr_pages)
 {
-	if (!si->cluster_info)
-		return;
-
 	VM_BUG_ON(ci->count < nr_pages);
 	VM_BUG_ON(cluster_is_free(ci));
 	lockdep_assert_held(&si->lock);
@@ -940,7 +903,7 @@ static void swap_range_alloc(struct swap
 		si->highest_bit = 0;
 		del_from_avail_list(si);
 
-		if (si->cluster_info && vm_swap_full())
+		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
 }
@@ -1007,8 +970,6 @@ static int cluster_alloc_swap(struct swa
 {
 	int n_ret = 0;
 
-	VM_BUG_ON(!si->cluster_info);
-
 	si->flags += SWP_SCANNING;
 
 	while (n_ret < nr) {
@@ -1052,10 +1013,10 @@ static int scan_swap_map_slots(struct sw
 		}
 
 		/*
-		 * Swapfile is not block device or not using clusters so unable
+		 * Swapfile is not block device so unable
 		 * to allocate large entries.
 		 */
-		if (!(si->flags & SWP_BLKDEV) || !si->cluster_info)
+		if (!(si->flags & SWP_BLKDEV))
 			return 0;
 	}
 
@@ -1295,9 +1256,9 @@ static unsigned char __swap_entry_free(s
 	unsigned long offset = swp_offset(entry);
 	unsigned char usage;
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	usage = __swap_entry_free_locked(si, offset, 1);
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	if (!usage)
 		free_swap_slot(entry);
 
@@ -1320,14 +1281,14 @@ static bool __swap_entries_free(struct s
 	if (nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER)
 		goto fallback;
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
-		unlock_cluster_or_swap_info(si, ci);
+		unlock_cluster(ci);
 		goto fallback;
 	}
 	for (i = 0; i < nr; i++)
 		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 
 	if (!has_cache) {
 		for (i = 0; i < nr; i++)
@@ -1383,7 +1344,7 @@ static void cluster_swap_free_nr(struct
 	DECLARE_BITMAP(to_free, BITS_PER_LONG) = { 0 };
 	int i, nr;
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	while (nr_pages) {
 		nr = min(BITS_PER_LONG, nr_pages);
 		for (i = 0; i < nr; i++) {
@@ -1391,18 +1352,18 @@ static void cluster_swap_free_nr(struct
 				bitmap_set(to_free, i, 1);
 		}
 		if (!bitmap_empty(to_free, BITS_PER_LONG)) {
-			unlock_cluster_or_swap_info(si, ci);
+			unlock_cluster(ci);
 			for_each_set_bit(i, to_free, BITS_PER_LONG)
 				free_swap_slot(swp_entry(si->type, offset + i));
 			if (nr == nr_pages)
 				return;
 			bitmap_clear(to_free, 0, BITS_PER_LONG);
-			ci = lock_cluster_or_swap_info(si, offset);
+			ci = lock_cluster(si, offset);
 		}
 		offset += nr;
 		nr_pages -= nr;
 	}
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 }
 
 /*
@@ -1441,9 +1402,9 @@ void put_swap_folio(struct folio *folio,
 	if (!si)
 		return;
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	if (size > 1 && swap_is_has_cache(si, offset, size)) {
-		unlock_cluster_or_swap_info(si, ci);
+		unlock_cluster(ci);
 		spin_lock(&si->lock);
 		swap_entry_range_free(si, entry, size);
 		spin_unlock(&si->lock);
@@ -1451,14 +1412,14 @@ void put_swap_folio(struct folio *folio,
 	}
 	for (int i = 0; i < size; i++, entry.val++) {
 		if (!__swap_entry_free_locked(si, offset + i, SWAP_HAS_CACHE)) {
-			unlock_cluster_or_swap_info(si, ci);
+			unlock_cluster(ci);
 			free_swap_slot(entry);
 			if (i == size - 1)
 				return;
-			lock_cluster_or_swap_info(si, offset);
+			lock_cluster(si, offset);
 		}
 	}
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 }
 
 static int swp_entry_cmp(const void *ent1, const void *ent2)
@@ -1522,9 +1483,9 @@ int swap_swapcount(struct swap_info_stru
 	struct swap_cluster_info *ci;
 	int count;
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 	count = swap_count(si->swap_map[offset]);
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	return count;
 }
 
@@ -1547,7 +1508,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	offset = swp_offset(entry);
 
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 
 	count = swap_count(si->swap_map[offset]);
 	if (!(count & COUNT_CONTINUED))
@@ -1570,7 +1531,7 @@ int swp_swapcount(swp_entry_t entry)
 		n *= (SWAP_CONT_MAX + 1);
 	} while (tmp_count & COUNT_CONTINUED);
 out:
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	return count;
 }
 
@@ -1585,8 +1546,8 @@ static bool swap_page_trans_huge_swapped
 	int i;
 	bool ret = false;
 
-	ci = lock_cluster_or_swap_info(si, offset);
-	if (!ci || nr_pages == 1) {
+	ci = lock_cluster(si, offset);
+	if (nr_pages == 1) {
 		if (swap_count(map[roffset]))
 			ret = true;
 		goto unlock_out;
@@ -1598,7 +1559,7 @@ static bool swap_page_trans_huge_swapped
 		}
 	}
 unlock_out:
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	return ret;
 }
 
@@ -3428,7 +3389,7 @@ static int __swap_duplicate(swp_entry_t
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
 	VM_WARN_ON(usage == 1 && nr > 1);
-	ci = lock_cluster_or_swap_info(si, offset);
+	ci = lock_cluster(si, offset);
 
 	err = 0;
 	for (i = 0; i < nr; i++) {
@@ -3483,7 +3444,7 @@ static int __swap_duplicate(swp_entry_t
 	}
 
 unlock_out:
-	unlock_cluster_or_swap_info(si, ci);
+	unlock_cluster(ci);
 	return err;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

