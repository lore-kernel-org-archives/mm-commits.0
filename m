Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB13170A13
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006248; cv=none; b=mV57FPBKM0qnwYIQdX2tWou13NbDkSpvdXXV0Hf/U6ywm4AOfSZAFzLoPluQSezYMjpS6Pl1q4bQ+l0ifzBUSHkzhlgHDfEYcvBKtARFTUmdX416HuXSksoPkxPD2LdrT3DyoSE/Ab+YT4ojOKOYBk4vfa6oADduxubWfzP67Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006248; c=relaxed/simple;
	bh=JJIjFQ1jDEiZC5JSnC3hyI1uqb0DvzmU2xhzIMlFUOQ=;
	h=Date:To:From:Subject:Message-Id; b=YKsKxu3J6+WYEiugRvBYclonYoLnJJli/PSvt7ugAimEnt3ee/1cLHPCJl0Rpw1OmL8/g1yUY2slZ0jzJaWIm2lpTLorqg9CvcFJ3KoGwM8xW15TVSeEXgDaIsFBj2+04mTNQl3hs9MOjoUL+weGTlcY05DCWQzbf6SnVaKtqNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFrR03o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFrR03o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936EAC4CED6;
	Thu, 16 Jan 2025 05:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006247;
	bh=JJIjFQ1jDEiZC5JSnC3hyI1uqb0DvzmU2xhzIMlFUOQ=;
	h=Date:To:From:Subject:From;
	b=tFrR03o23fVU8yZ3+siEYT03U7iMsYhKqzrXdguic8vVRX2PCYxTUb4W8QKbPZE3A
	 +yBcar6wfYQmET7mOljA5174y1dmJ4vgh0W04Oaj1N19T0+tvokBTUBqWzx6XY5XQo
	 bReYNKtCJ0g1OdC4OG3oZl03TduyPggJrlpp6Xgc=
Date: Wed, 15 Jan 2025 21:44:07 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-cluster-lock-for-hdd.patch removed from -mm tree
Message-Id: <20250116054407.936EAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: use cluster lock for HDD
has been removed from the -mm tree.  Its filename was
     mm-swap-use-cluster-lock-for-hdd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


