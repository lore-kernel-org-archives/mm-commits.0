Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D782FDC22
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268328; cv=none; b=VmnApwiTsGVNb3bELvsKSwiB0UlD5n+/j2HwCNHHySUMz6FH8DGpyeR5giYK4y6uMQ7Y6wJz7witMunhS7y92XLeM9JN3IJ281qrofxaenR2xu6UG7QddawI9HceQL7vskbiflNFpfy9WnTVHTnZMZWY+xh5VjxP60ikqXPu9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268328; c=relaxed/simple;
	bh=Jo0EGkCQ22byIq14de12/qslllVBu0Ar5PSQsBNbuo0=;
	h=Date:To:From:Subject:Message-Id; b=Iowiozjk3Myhx5D9hsPEt6HtPBIOmlHDBZ0bAoPhh0jvzIAeTIgiQXshc3lKVn+DL/Wn78kn2wiDjerm++r9hPWqp4YSvkjtaLtqsbkvO5fGES/PT5gBbzfxaS8md+sEKMSCkX/wtT1MIBIdlG9CS8UkqWI0KIVNisg5HbwGr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jgSE4gzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgSE4gzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB2CC4CEF5;
	Sat, 20 Dec 2025 22:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268328;
	bh=Jo0EGkCQ22byIq14de12/qslllVBu0Ar5PSQsBNbuo0=;
	h=Date:To:From:Subject:From;
	b=jgSE4gzC9Xd6n3VfYjuAYKtFDoZiNuCzjlol9srq1wpk34hA/d7onfjnWGE58kneL
	 qizIaN2SG3xw5ru6st4iEr2MtMvZ8uAYBL7Hbihn/kOoHP4xWLzxAXhqP33X5fJpdN
	 uW/LUpk4H/qeXwJBOLknkZH1Zc6hNoZqpnji/hg8=
Date: Sat, 20 Dec 2025 14:05:27 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-check-swap-table-directly-for-checking-cache.patch added to mm-new branch
Message-Id: <20251220220528.5BB2CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: check swap table directly for checking cache
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-check-swap-table-directly-for-checking-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-check-swap-table-directly-for-checking-cache.patch

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
Subject: mm, swap: check swap table directly for checking cache
Date: Sat, 20 Dec 2025 03:43:45 +0800

Instead of looking at the swap map, check swap table directly to tell if a
swap slot is cached.  Prepares for the removal of SWAP_HAS_CACHE.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-16-8862a265a033@tencent.com
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

 mm/swap.h        |   11 ++++++---
 mm/swap_state.c  |   16 +++++++++++++
 mm/swapfile.c    |   55 +++++++++++++++++++++++----------------------
 mm/userfaultfd.c |   10 ++------
 4 files changed, 56 insertions(+), 36 deletions(-)

--- a/mm/swapfile.c~mm-swap-check-swap-table-directly-for-checking-cache
+++ a/mm/swapfile.c
@@ -792,23 +792,18 @@ static bool cluster_reclaim_range(struct
 	unsigned int nr_pages = 1 << order;
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	int nr_reclaim;
+	unsigned long swp_tb;
 
 	spin_unlock(&ci->lock);
 	do {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
+		if (swap_count(READ_ONCE(map[offset])))
 			break;
-		case SWAP_HAS_CACHE:
-			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim < 0)
-				goto out;
-			break;
-		default:
-			goto out;
+		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
+				break;
 		}
 	} while (++offset < end);
-out:
 	spin_lock(&ci->lock);
 
 	/*
@@ -829,37 +824,41 @@ out:
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
-	for (offset = start; offset < end; offset++)
-		if (READ_ONCE(map[offset]))
+	for (offset = start; offset < end; offset++) {
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
 			return false;
+	}
 
 	return true;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
 			       struct swap_cluster_info *ci,
-			       unsigned long start, unsigned int nr_pages,
+			       unsigned long offset, unsigned int nr_pages,
 			       bool *need_reclaim)
 {
-	unsigned long offset, end = start + nr_pages;
+	unsigned long end = offset + nr_pages;
 	unsigned char *map = si->swap_map;
+	unsigned long swp_tb;
 
 	if (cluster_is_empty(ci))
 		return true;
 
-	for (offset = start; offset < end; offset++) {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
-			continue;
-		case SWAP_HAS_CACHE:
+	do {
+		if (swap_count(map[offset]))
+			return false;
+		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_folio(swp_tb)) {
+			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
-			continue;
-		default:
-			return false;
+		} else {
+			/* A entry with no count and no cache must be null */
+			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
 		}
-	}
+	} while (++offset < end);
 
 	return true;
 }
@@ -1030,7 +1029,8 @@ static void swap_reclaim_full_clusters(s
 		to_scan--;
 
 		while (offset < end) {
-			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
+			if (!swap_count(READ_ONCE(map[offset])) &&
+			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1981,6 +1981,7 @@ void swap_put_entries_direct(swp_entry_t
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
+	unsigned long swp_tb;
 
 	si = get_swap_device(entry);
 	if (WARN_ON_ONCE(!si))
@@ -2005,7 +2006,9 @@ void swap_put_entries_direct(swp_entry_t
 	 */
 	for (offset = start_offset; offset < end_offset; offset += nr) {
 		nr = 1;
-		if (READ_ONCE(si->swap_map[offset]) == SWAP_HAS_CACHE) {
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, offset),
+					offset % SWAPFILE_CLUSTER);
+		if (!swap_count(READ_ONCE(si->swap_map[offset])) && swp_tb_is_folio(swp_tb)) {
 			/*
 			 * Folios are always naturally aligned in swap so
 			 * advance forward to the next boundary. Zero means no
--- a/mm/swap.h~mm-swap-check-swap-table-directly-for-checking-cache
+++ a/mm/swap.h
@@ -275,6 +275,7 @@ void __swapcache_clear_cached(struct swa
  *   swap entries in the page table, similar to locking swap cache folio.
  * - See the comment of get_swap_device() for more complex usage.
  */
+bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
@@ -335,8 +336,6 @@ static inline int swap_zeromap_batch(swp
 
 static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
-	pgoff_t offset = swp_offset(entry);
 	int i;
 
 	/*
@@ -345,8 +344,9 @@ static inline int non_swapcache_batch(sw
 	 * be in conflict with the folio in swap cache.
 	 */
 	for (i = 0; i < max_nr; i++) {
-		if ((si->swap_map[offset + i] & SWAP_HAS_CACHE))
+		if (swap_cache_has_folio(entry))
 			return i;
+		entry.val++;
 	}
 
 	return i;
@@ -449,6 +449,11 @@ static inline int swap_writeout(struct f
 	return 0;
 }
 
+static inline bool swap_cache_has_folio(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
--- a/mm/swap_state.c~mm-swap-check-swap-table-directly-for-checking-cache
+++ a/mm/swap_state.c
@@ -104,6 +104,22 @@ struct folio *swap_cache_get_folio(swp_e
 }
 
 /**
+ * swap_cache_has_folio - Check if a swap slot has cache.
+ * @entry: swap entry indicating the slot.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap
+ * device with reference count or locks.
+ */
+bool swap_cache_has_folio(swp_entry_t entry)
+{
+	unsigned long swp_tb;
+
+	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+				swp_cluster_offset(entry));
+	return swp_tb_is_folio(swp_tb);
+}
+
+/**
  * swap_cache_get_shadow - Looks up a shadow in the swap cache.
  * @entry: swap entry used for the lookup.
  *
--- a/mm/userfaultfd.c~mm-swap-check-swap-table-directly-for-checking-cache
+++ a/mm/userfaultfd.c
@@ -1190,17 +1190,13 @@ static int move_swap_pte(struct mm_struc
 		 * Check if the swap entry is cached after acquiring the src_pte
 		 * lock. Otherwise, we might miss a newly loaded swap cache folio.
 		 *
-		 * Check swap_map directly to minimize overhead, READ_ONCE is sufficient.
 		 * We are trying to catch newly added swap cache, the only possible case is
 		 * when a folio is swapped in and out again staying in swap cache, using the
 		 * same entry before the PTE check above. The PTL is acquired and released
-		 * twice, each time after updating the swap_map's flag. So holding
-		 * the PTL here ensures we see the updated value. False positive is possible,
-		 * e.g. SWP_SYNCHRONOUS_IO swapin may set the flag without touching the
-		 * cache, or during the tiny synchronization window between swap cache and
-		 * swap_map, but it will be gone very quickly, worst result is retry jitters.
+		 * twice, each time after updating the swap table. So holding
+		 * the PTL here ensures we see the updated value.
 		 */
-		if (READ_ONCE(si->swap_map[swp_offset(entry)]) & SWAP_HAS_CACHE) {
+		if (swap_cache_has_folio(entry)) {
 			double_pt_unlock(dst_ptl, src_ptl);
 			return -EAGAIN;
 		}
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

