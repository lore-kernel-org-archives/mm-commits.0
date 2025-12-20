Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC6C2F3609
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268334; cv=none; b=ZPwaRbExhK69NwKsk6R3T5fNs13zGRtDEAcqv0vW6XaJjaTTkI4SZ+ufo6S9v0iIXNWJDCEORB8I+iAZL+eAtzP5rs2UWYoEd0wMvUYQY8uEKOJgnqCPa6M4fI2YSsXsVzP6i1twDkpK0xT+tnswGEp3B7LkghnTRlmQtRSGg8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268334; c=relaxed/simple;
	bh=TfWvl03hmm3nt6uGEL0x/9FmF5oBKsY2W8wT0YMyR9U=;
	h=Date:To:From:Subject:Message-Id; b=nA20FgZz83ZtB6IekCZcQDUTH2jMuX3exKsj4l/GpkrynWNs9Qeu/E31uQZBWLQlmtlqBdzbW0rRrsJiXt596Hu+Y7s2ykf7ndK7UZytUOA/XU96KHdgk5l1s5k/laE/pOP1rNXNDWolH873dZw9Ye3fnlcKeba9EKjWDBKYJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzVVrz0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzVVrz0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ADEC4CEF5;
	Sat, 20 Dec 2025 22:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268334;
	bh=TfWvl03hmm3nt6uGEL0x/9FmF5oBKsY2W8wT0YMyR9U=;
	h=Date:To:From:Subject:From;
	b=QzVVrz0iV5HgRasV0gRSk602V3UjR1b3iHjYS/dFKrLnzzPnOj2VKGoBcJeGNKyBU
	 7BlS6jYHQCLYAIhhVs8ibc/91BucUBxT32qDe3VwP3pRZTA8HgLqDO6982jjCgUIAs
	 u0Vqu/1ZfeC8SJzIGu6PFr0tBQwfWE9SXLZeA+lM=
Date: Sat, 20 Dec 2025 14:05:33 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-drop-the-swap_has_cache-flag.patch added to mm-new branch
Message-Id: <20251220220534.10ADEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: drop the SWAP_HAS_CACHE flag
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-drop-the-swap_has_cache-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-drop-the-swap_has_cache-flag.patch

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
Subject: mm, swap: drop the SWAP_HAS_CACHE flag
Date: Sat, 20 Dec 2025 03:43:47 +0800

Now, the swap cache is managed by the swap table.  All swap cache users
are checking the swap table directly to check the swap cache state. 
SWAP_HAS_CACHE is now just a temporary pin before the first increase from
0 to 1 of a slot's swap count (swap_dup_entries) after swap allocation
(folio_alloc_swap), or before the final free of slots pinned by folio in
swap cache (put_swap_folio).

Drop these two usages.  For the first dup, SWAP_HAS_CACHE pinning was hard
to kill because it used to have multiple meanings, more than just "a slot
is cached".  We have just simplified that and defined that the first dup
is always done with folio locked in swap cache (folio_dup_swap), so stop
checking the SWAP_HAS_CACHE bit and just check the swap cache (swap table)
directly, and add a WARN if a swap entry's count is being increased for
the first time while the folio is not in swap cache.

As for freeing, just let the swap cache free all swap entries of a folio
that have a swap count of zero directly upon folio removal.  We have also
just cleaned up batch freeing to check the swap cache usage using the swap
table: a slot with swap cache in the swap table will not be freed until
its cache is gone, and no SWAP_HAS_CACHE bit is involved anymore.  And
besides, the removal of a folio and freeing of the slots are being done in
the same critical section now, which should improve the performance.

After these two changes, SWAP_HAS_CACHE no longer has any users.  Swap
cache synchronization is also done by the swap table directly, so using
SWAP_HAS_CACHE to pin a slot before adding the cache is also no longer
needed.  Remove all related logic and helpers.  swap_map is now only used
for tracking the count, so all swap_map users can just read it directly,
ignoring the swap_count helper, which was previously used to filter out
the SWAP_HAS_CACHE bit.

The idea of dropping SWAP_HAS_CACHE and using the swap table directly was
initially from Chris's idea of merging all the metadata usage of all swaps
into one place.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-18-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swap.h            |   13 +--
 mm/swap_state.c      |   28 +++---
 mm/swapfile.c        |  168 +++++++++++++----------------------------
 4 files changed, 78 insertions(+), 132 deletions(-)

--- a/include/linux/swap.h~mm-swap-drop-the-swap_has_cache-flag
+++ a/include/linux/swap.h
@@ -224,7 +224,6 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /* Bit flag in swap_map */
-#define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
 #define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
 
 /* Special value in first swap_map */
--- a/mm/swapfile.c~mm-swap-drop-the-swap_has_cache-flag
+++ a/mm/swapfile.c
@@ -48,21 +48,18 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
+#include "swap_table.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage);
+				  unsigned long offset);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -149,11 +146,6 @@ static struct swap_info_struct *swap_ent
 	return swap_type_to_info(swp_type(entry));
 }
 
-static inline unsigned char swap_count(unsigned char ent)
-{
-	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
-}
-
 /*
  * Use the second highest bit of inuse_pages counter as the indicator
  * if one swap device is on the available plist, so the atomic can
@@ -185,15 +177,20 @@ static long swap_usage_in_pages(struct s
 #define TTRS_FULL		0x4
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
-			      unsigned long offset, int nr_pages)
+				struct swap_cluster_info *ci,
+				unsigned long offset, int nr_pages)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
+	unsigned long swp_tb;
 
 	do {
-		VM_BUG_ON(!(*map & SWAP_HAS_CACHE));
-		if (*map != SWAP_HAS_CACHE)
+		swp_tb = __swap_table_get(ci, ci_off);
+		VM_WARN_ON_ONCE(!swp_tb_is_folio(swp_tb));
+		if (*map)
 			return false;
+		++ci_off;
 	} while (++map < map_end);
 
 	return true;
@@ -248,12 +245,12 @@ again:
 		goto out_unlock;
 
 	/*
-	 * It's safe to delete the folio from swap cache only if the folio's
-	 * swap_map is HAS_CACHE only, which means the slots have no page table
+	 * It's safe to delete the folio from swap cache only if the folio
+	 * is in swap cache with swap count == 0. The slots have no page table
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = swap_cluster_lock(si, offset);
-	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, ci, offset, nr_pages);
 	swap_cluster_unlock(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -779,7 +776,7 @@ static bool cluster_reclaim_range(struct
 
 	spin_unlock(&ci->lock);
 	do {
-		if (swap_count(READ_ONCE(map[offset])))
+		if (READ_ONCE(map[offset]))
 			break;
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
@@ -809,7 +806,7 @@ static bool cluster_reclaim_range(struct
 	 */
 	for (offset = start; offset < end; offset++) {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
+		if (map[offset] || !swp_tb_is_null(swp_tb))
 			return false;
 	}
 
@@ -829,11 +826,10 @@ static bool cluster_scan_range(struct sw
 		return true;
 
 	do {
-		if (swap_count(map[offset]))
+		if (map[offset])
 			return false;
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
-			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
@@ -891,11 +887,6 @@ static bool cluster_alloc_range(struct s
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
-		/*
-		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
-		 * This is the legacy allocation behavior, will drop it very soon.
-		 */
-		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
@@ -1012,8 +1003,8 @@ static void swap_reclaim_full_clusters(s
 		to_scan--;
 
 		while (offset < end) {
-			if (!swap_count(READ_ONCE(map[offset])) &&
-			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			if (!READ_ONCE(map[offset]) &&
+			    swp_tb_is_folio(swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1115,7 +1106,7 @@ new_cluster:
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
 		 * failure is not critical. Scanning one cluster still
-		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
@@ -1450,8 +1441,8 @@ static void swap_put_entries_cluster(str
 	do {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		count = si->swap_map[offset];
-		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
-		if (swap_count(count) == 1) {
+		VM_WARN_ON(count < 1 || count == SWAP_MAP_BAD);
+		if (count == 1) {
 			/* count == 1 and non-cached slots will be batch freed. */
 			if (!swp_tb_is_folio(swp_tb)) {
 				if (!batch_start)
@@ -1459,7 +1450,6 @@ static void swap_put_entries_cluster(str
 				continue;
 			}
 			/* count will be 0 after put, slot can be reclaimed */
-			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
 			need_reclaim = true;
 		}
 		/*
@@ -1468,7 +1458,7 @@ static void swap_put_entries_cluster(str
 		 * slots will be freed when folio is removed from swap cache
 		 * (__swap_cache_del_folio).
 		 */
-		swap_put_entry_locked(si, ci, offset, 1);
+		swap_put_entry_locked(si, ci, offset);
 		if (batch_start) {
 			swap_entries_free(si, ci, batch_start, offset - batch_start);
 			batch_start = SWAP_ENTRY_INVALID;
@@ -1625,7 +1615,8 @@ static struct swap_info_struct *_swap_in
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]))
+	if (data_race(!si->swap_map[swp_offset(entry)]) &&
+	    !swap_cache_has_folio(entry))
 		goto bad_free;
 	return si;
 
@@ -1646,21 +1637,12 @@ out:
 
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage)
+				  unsigned long offset)
 {
 	unsigned char count;
-	unsigned char has_cache;
 
 	count = si->swap_map[offset];
-
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-
-	if (usage == SWAP_HAS_CACHE) {
-		VM_BUG_ON(!has_cache);
-		has_cache = 0;
-	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
+	if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
 				count = SWAP_MAP_MAX | COUNT_CONTINUED;
@@ -1670,10 +1652,8 @@ static void swap_put_entry_locked(struct
 			count--;
 	}
 
-	usage = count | has_cache;
-	if (usage)
-		WRITE_ONCE(si->swap_map[offset], usage);
-	else
+	WRITE_ONCE(si->swap_map[offset], count);
+	if (!count && !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
 		swap_entries_free(si, ci, offset, 1);
 }
 
@@ -1743,20 +1723,12 @@ put_out:
 }
 
 /*
- * Check if it's the last ref of swap entry in the freeing path.
- */
-static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
-{
-	return (count == SWAP_HAS_CACHE) || (count == 1);
-}
-
-/*
  * Drop the last ref of swap entries, caller have to ensure all entries
  * belong to the same cgroup and cluster.
  */
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long offset, unsigned int nr_pages)
+void swap_entries_free(struct swap_info_struct *si,
+		       struct swap_cluster_info *ci,
+		       unsigned long offset, unsigned int nr_pages)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
@@ -1769,7 +1741,7 @@ static void swap_entries_free(struct swa
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
+		VM_WARN_ON(*map > 1);
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1788,7 +1760,7 @@ int __swap_count(swp_entry_t entry)
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
-	return swap_count(si->swap_map[offset]);
+	return si->swap_map[offset];
 }
 
 /**
@@ -1803,7 +1775,7 @@ bool swap_entry_swapped(struct swap_info
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	swap_cluster_unlock(ci);
 
 	return count && count != SWAP_MAP_BAD;
@@ -1830,7 +1802,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
@@ -1868,12 +1840,12 @@ static bool swap_page_trans_huge_swapped
 
 	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
-		if (swap_count(map[roffset]))
+		if (map[roffset])
 			ret = true;
 		goto unlock_out;
 	}
 	for (i = 0; i < nr_pages; i++) {
-		if (swap_count(map[offset + i])) {
+		if (map[offset + i]) {
 			ret = true;
 			break;
 		}
@@ -2027,7 +1999,7 @@ void swap_free_hibernation_slot(swp_entr
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_put_entry_locked(si, ci, offset, 1);
+	swap_put_entry_locked(si, ci, offset);
 	WARN_ON(swap_entry_swapped(si, entry));
 	swap_cluster_unlock(ci);
 
@@ -2433,6 +2405,7 @@ static unsigned int find_next_to_unuse(s
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned long swp_tb;
 	unsigned char count;
 
 	/*
@@ -2443,7 +2416,11 @@ static unsigned int find_next_to_unuse(s
 	 */
 	for (i = prev + 1; i < si->max; i++) {
 		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
+					i % SWAPFILE_CLUSTER);
+		if (count == SWAP_MAP_BAD)
+			continue;
+		if (count || swp_tb_is_folio(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -3668,8 +3645,7 @@ void si_swapinfo(struct sysinfo *val)
  * Returns error code in following case.
  * - success -> 0
  * - swp_entry is invalid -> EINVAL
- * - swap-cache reference is requested but there is already one. -> EEXIST
- * - swap-cache reference is requested but the entry is not used. -> ENOENT
+ * - swap-mapped reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
 static int swap_dup_entries(struct swap_info_struct *si,
@@ -3678,39 +3654,30 @@ static int swap_dup_entries(struct swap_
 			    unsigned char usage, int nr)
 {
 	int i;
-	unsigned char count, has_cache;
+	unsigned char count;
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-
 		/*
 		 * For swapin out, allocator never allocates bad slots. for
 		 * swapin, readahead is guarded by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+		if (WARN_ON(count == SWAP_MAP_BAD))
 			return -ENOENT;
-
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (!count && !has_cache) {
+		/*
+		 * Swap count duplication must be guarded by either swap cache folio (from
+		 * folio_dup_swap) or external lock of existing entry (from swap_dup_entry_direct).
+		 */
+		if (WARN_ON(!count &&
+			    !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))))
 			return -ENOENT;
-		} else if (usage == SWAP_HAS_CACHE) {
-			if (has_cache)
-				return -EEXIST;
-		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
+		if (WARN_ON((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX))
 			return -EINVAL;
-		}
 	}
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (usage == SWAP_HAS_CACHE)
-			has_cache = SWAP_HAS_CACHE;
-		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
 		else if (swap_count_continued(si, offset + i, count))
 			count = COUNT_CONTINUED;
@@ -3722,7 +3689,7 @@ static int swap_dup_entries(struct swap_
 			return -ENOMEM;
 		}
 
-		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
+		WRITE_ONCE(si->swap_map[offset + i], count);
 	}
 
 	return 0;
@@ -3768,27 +3735,6 @@ int swap_dup_entry_direct(swp_entry_t en
 	return err;
 }
 
-/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry)
-{
-	WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACHE, 1));
-}
-
-/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr)
-{
-	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, swp_offset(entry), nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
-	}
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
@@ -3834,7 +3780,7 @@ int add_swap_count_continuation(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*
--- a/mm/swap.h~mm-swap-drop-the-swap_has_cache-flag
+++ a/mm/swap.h
@@ -205,6 +205,11 @@ int folio_alloc_swap(struct folio *folio
 int folio_dup_swap(struct folio *folio, struct page *subpage);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
+/* For internal use */
+extern void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      unsigned long offset, unsigned int nr_pages);
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
@@ -256,14 +261,6 @@ static inline bool folio_matches_swap_en
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
-/* Temporary internal helpers */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry);
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr);
-
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stabilize the device by any of the following ways:
--- a/mm/swap_state.c~mm-swap-drop-the-swap_has_cache-flag
+++ a/mm/swap_state.c
@@ -211,17 +211,6 @@ static int swap_cache_add_folio(struct f
 			shadow = swp_tb_to_shadow(old_tb);
 		offset++;
 	} while (++ci_off < ci_end);
-
-	ci_off = ci_start;
-	offset = swp_offset(entry);
-	do {
-		/*
-		 * Still need to pin the slots with SWAP_HAS_CACHE since
-		 * swap allocator depends on that.
-		 */
-		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		offset++;
-	} while (++ci_off < ci_end);
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
@@ -252,6 +241,7 @@ void __swap_cache_del_folio(struct swap_
 	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
+	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) != ci);
@@ -269,13 +259,27 @@ void __swap_cache_del_folio(struct swap_
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
 			     swp_tb_to_folio(old_tb) != folio);
+		if (__swap_count(swp_entry(si->type,
+				 swp_offset(entry) + ci_off - ci_start)))
+			folio_swapped = true;
+		else
+			need_free = true;
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-	__swapcache_clear_cached(si, ci, entry, nr_pages);
+
+	if (!folio_swapped) {
+		swap_entries_free(si, ci, swp_offset(entry), nr_pages);
+	} else if (need_free) {
+		do {
+			if (!__swap_count(entry))
+				swap_entries_free(si, ci, swp_offset(entry), 1);
+			entry.val++;
+		} while (--nr_pages);
+	}
 }
 
 /**
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

