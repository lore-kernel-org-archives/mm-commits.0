Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942816C437
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458498; cv=none; b=sBFhGql6qnJn3ENafNzmKxg94Hl3KHkvYw7Kvnlct95MII8RfawezPAxEMqoV72R0XwC+qweOLAOf4xdB/J5M6HixhWrYILwVoWRnSvuisprkpoDzx+HhyJeLR+TzEWS1V9Dgm8lgVwPdaCc2/+BNX+c/u/DIIOpRizpQ50aycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458498; c=relaxed/simple;
	bh=Oy93CJdo/Az/iogU4snhUZ9U3XOQslpCua0V/ZRRPFE=;
	h=Date:To:From:Subject:Message-Id; b=m5ZBRNfImeDxErye8l/1QZnM6Hv5VJEpLbtuUxBKYHP5Pt44qW+vGu44CxcbvQ1h8AxVWZRLM1+IWwWsrCf/eMzr3Fz5OvI7zYRnUnXrYzFL9YtTOjfAChhp1pBMRWg+nmov8qER0Bfxp0PRw3gxHjc1awtcd9RkoZN3letehVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DUxuqlVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DUxuqlVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A050C4AF0C;
	Wed, 31 Jul 2024 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722458498;
	bh=Oy93CJdo/Az/iogU4snhUZ9U3XOQslpCua0V/ZRRPFE=;
	h=Date:To:From:Subject:From;
	b=DUxuqlVXZ5MjuJemyFofM8KsmYxOOrfJfcYW74IolAlJlpqRExG+6pw/Kefv4eT0x
	 UXvWmAW8ju+VmYE3HaFSXF9dsrAEn8lAwOBtPPjbKIL9osiGf/BsdZaaxOL/21Xkoj
	 eYgJH//de3uZp7VsHrxN97kv3wW7UTaExEfY4X90=
Date: Wed, 31 Jul 2024 13:41:37 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch added to mm-unstable branch
Message-Id: <20240731204138.7A050C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: allow cache reclaim to skip slot cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch

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
Subject: mm: swap: allow cache reclaim to skip slot cache
Date: Tue, 30 Jul 2024 23:49:18 -0700

Currently we free the reclaimed slots through slot cache even if the slot
is required to be empty immediately.  As a result the reclaim caller will
see the slot still occupied even after a successful reclaim, and need to
keep reclaiming until slot cache get flushed.  This caused ineffective or
over reclaim when SWAP is under stress.

So introduce a new flag allowing the slot to be emptied bypassing the slot
cache.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-6-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |  152 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 109 insertions(+), 43 deletions(-)

--- a/mm/swapfile.c~mm-swap-allow-cache-reclaim-to-skip-slot-cache
+++ a/mm/swapfile.c
@@ -53,8 +53,15 @@
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
+static void swap_entry_range_free(struct swap_info_struct *si, swp_entry_t entry,
+				  unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si, unsigned long offset,
 			     unsigned int nr_entries);
+static bool folio_swapcache_freeable(struct folio *folio);
+static struct swap_cluster_info *lock_cluster_or_swap_info(
+		struct swap_info_struct *si, unsigned long offset);
+static void unlock_cluster_or_swap_info(struct swap_info_struct *si,
+					struct swap_cluster_info *ci);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -129,8 +136,25 @@ static inline unsigned char swap_count(u
  * corresponding page
  */
 #define TTRS_UNMAPPED		0x2
-/* Reclaim the swap entry if swap is getting full*/
+/* Reclaim the swap entry if swap is getting full */
 #define TTRS_FULL		0x4
+/* Reclaim directly, bypass the slot cache and don't touch device lock */
+#define TTRS_DIRECT		0x8
+
+static bool swap_is_has_cache(struct swap_info_struct *si,
+			      unsigned long offset, int nr_pages)
+{
+	unsigned char *map = si->swap_map + offset;
+	unsigned char *map_end = map + nr_pages;
+
+	do {
+		VM_BUG_ON(!(*map & SWAP_HAS_CACHE));
+		if (*map != SWAP_HAS_CACHE)
+			return false;
+	} while (++map < map_end);
+
+	return true;
+}
 
 /*
  * returns number of pages in the folio that backs the swap entry. If positive,
@@ -141,12 +165,22 @@ static int __try_to_reclaim_swap(struct
 				 unsigned long offset, unsigned long flags)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
+	struct address_space *address_space = swap_address_space(entry);
+	struct swap_cluster_info *ci;
 	struct folio *folio;
-	int ret = 0;
+	int ret, nr_pages;
+	bool need_reclaim;
 
-	folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
+	folio = filemap_get_folio(address_space, swap_cache_index(entry));
 	if (IS_ERR(folio))
 		return 0;
+
+	/* offset could point to the middle of a large folio */
+	entry = folio->swap;
+	offset = swp_offset(entry);
+	nr_pages = folio_nr_pages(folio);
+	ret = -nr_pages;
+
 	/*
 	 * When this function is called from scan_swap_map_slots() and it's
 	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
@@ -154,14 +188,50 @@ static int __try_to_reclaim_swap(struct
 	 * case and you should use folio_free_swap() with explicit folio_lock()
 	 * in usual operations.
 	 */
-	if (folio_trylock(folio)) {
-		if ((flags & TTRS_ANYWAY) ||
-		    ((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-		    ((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)))
-			ret = folio_free_swap(folio);
-		folio_unlock(folio);
+	if (!folio_trylock(folio))
+		goto out;
+
+	need_reclaim = ((flags & TTRS_ANYWAY) ||
+			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
+			((flags & TTRS_FULL) && mem_cgroup_swap_full(folio)));
+	if (!need_reclaim || !folio_swapcache_freeable(folio))
+		goto out_unlock;
+
+	/*
+	 * It's safe to delete the folio from swap cache only if the folio's
+	 * swap_map is HAS_CACHE only, which means the slots have no page table
+	 * reference or pending writeback, and can't be allocated to others.
+	 */
+	ci = lock_cluster_or_swap_info(si, offset);
+	need_reclaim = swap_is_has_cache(si, offset, nr_pages);
+	unlock_cluster_or_swap_info(si, ci);
+	if (!need_reclaim)
+		goto out_unlock;
+
+	if (!(flags & TTRS_DIRECT)) {
+		/* Free through slot cache */
+		delete_from_swap_cache(folio);
+		folio_set_dirty(folio);
+		ret = nr_pages;
+		goto out_unlock;
 	}
-	ret = ret ? folio_nr_pages(folio) : -folio_nr_pages(folio);
+
+	xa_lock_irq(&address_space->i_pages);
+	__delete_from_swap_cache(folio, entry, NULL);
+	xa_unlock_irq(&address_space->i_pages);
+	folio_ref_sub(folio, nr_pages);
+	folio_set_dirty(folio);
+
+	spin_lock(&si->lock);
+	/* Only sinple page folio can be backed by zswap */
+	if (!nr_pages)
+		zswap_invalidate(entry);
+	swap_entry_range_free(si, entry, nr_pages);
+	spin_unlock(&si->lock);
+	ret = nr_pages;
+out_unlock:
+	folio_unlock(folio);
+out:
 	folio_put(folio);
 	return ret;
 }
@@ -895,7 +965,7 @@ checks:
 	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&si->lock);
-		swap_was_freed = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
+		swap_was_freed = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY | TTRS_DIRECT);
 		spin_lock(&si->lock);
 		/* entry was freed successfully, try to use this again */
 		if (swap_was_freed > 0)
@@ -1333,9 +1403,6 @@ void put_swap_folio(struct folio *folio,
 	unsigned long offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned char *map;
-	unsigned int i, free_entries = 0;
-	unsigned char val;
 	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
@@ -1343,23 +1410,14 @@ void put_swap_folio(struct folio *folio,
 		return;
 
 	ci = lock_cluster_or_swap_info(si, offset);
-	if (size > 1) {
-		map = si->swap_map + offset;
-		for (i = 0; i < size; i++) {
-			val = map[i];
-			VM_BUG_ON(!(val & SWAP_HAS_CACHE));
-			if (val == SWAP_HAS_CACHE)
-				free_entries++;
-		}
-		if (free_entries == size) {
-			unlock_cluster_or_swap_info(si, ci);
-			spin_lock(&si->lock);
-			swap_entry_range_free(si, entry, size);
-			spin_unlock(&si->lock);
-			return;
-		}
+	if (size > 1 && swap_is_has_cache(si, offset, size)) {
+		unlock_cluster_or_swap_info(si, ci);
+		spin_lock(&si->lock);
+		swap_entry_range_free(si, entry, size);
+		spin_unlock(&si->lock);
+		return;
 	}
-	for (i = 0; i < size; i++, entry.val++) {
+	for (int i = 0; i < size; i++, entry.val++) {
 		if (!__swap_entry_free_locked(si, offset + i, SWAP_HAS_CACHE)) {
 			unlock_cluster_or_swap_info(si, ci);
 			free_swap_slot(entry);
@@ -1519,16 +1577,7 @@ static bool folio_swapped(struct folio *
 	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
 }
 
-/**
- * folio_free_swap() - Free the swap space used for this folio.
- * @folio: The folio to remove.
- *
- * If swap is getting full, or if there are no more mappings of this folio,
- * then call folio_free_swap to free its swap space.
- *
- * Return: true if we were able to release the swap space.
- */
-bool folio_free_swap(struct folio *folio)
+static bool folio_swapcache_freeable(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
@@ -1536,8 +1585,6 @@ bool folio_free_swap(struct folio *folio
 		return false;
 	if (folio_test_writeback(folio))
 		return false;
-	if (folio_swapped(folio))
-		return false;
 
 	/*
 	 * Once hibernation has begun to create its image of memory,
@@ -1557,6 +1604,25 @@ bool folio_free_swap(struct folio *folio
 	if (pm_suspended_storage())
 		return false;
 
+	return true;
+}
+
+/**
+ * folio_free_swap() - Free the swap space used for this folio.
+ * @folio: The folio to remove.
+ *
+ * If swap is getting full, or if there are no more mappings of this folio,
+ * then call folio_free_swap to free its swap space.
+ *
+ * Return: true if we were able to release the swap space.
+ */
+bool folio_free_swap(struct folio *folio)
+{
+	if (!folio_swapcache_freeable(folio))
+		return false;
+	if (folio_swapped(folio))
+		return false;
+
 	delete_from_swap_cache(folio);
 	folio_set_dirty(folio);
 	return true;
@@ -1633,7 +1699,7 @@ void free_swap_and_cache_nr(swp_entry_t
 			 * to the next boundary.
 			 */
 			nr = __try_to_reclaim_swap(si, offset,
-					      TTRS_UNMAPPED | TTRS_FULL);
+						   TTRS_UNMAPPED | TTRS_FULL);
 			if (nr == 0)
 				nr = 1;
 			else if (nr < 0)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-clean-up-initialization-helper.patch
mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-swap-add-a-fragment-cluster-list.patch
mm-swap-relaim-the-cached-parts-that-got-scanned.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

