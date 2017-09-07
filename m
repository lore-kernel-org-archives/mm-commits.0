From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:39:46 -0700
Message-ID: <20170907183946.B4gOneY24%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754650AbdIGSjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, THP, swap: make reuse_swap_page() works for THP swapped out
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: make reuse_swap_page() works for THP swapped out

After supporting to delay THP (Transparent Huge Page) splitting after
swapped out, it is possible that some page table mappings of the THP are
turned into swap entries.  So reuse_swap_page() need to check the swap
count in addition to the map count as before.  This patch done that.

In the huge PMD write protect fault handler, in addition to the page map
count, the swap count need to be checked too, so the page lock need to be
acquired too when calling reuse_swap_page() in addition to the page table
lock.

[ying.huang@intel.com: silence a compiler warning]
  Link: http://lkml.kernel.org/r/87bmnzizjy.fsf@yhuang-dev.intel.com
Link: http://lkml.kernel.org/r/20170724051840.2309-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 -
 mm/huge_memory.c     |   16 ++++++
 mm/memory.c          |    6 +-
 mm/swapfile.c        |  102 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 113 insertions(+), 15 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out
+++ a/include/linux/swap.h
@@ -510,8 +510,8 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-#define reuse_swap_page(page, total_mapcount) \
-	(page_trans_huge_mapcount(page, total_mapcount) == 1)
+#define reuse_swap_page(page, total_map_swapcount) \
+	(page_trans_huge_mapcount(page, total_map_swapcount) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
diff -puN mm/huge_memory.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out
+++ a/mm/huge_memory.c
@@ -1240,15 +1240,29 @@ int do_huge_pmd_wp_page(struct vm_fault
 	 * We can only reuse the page if nobody else maps the huge page or it's
 	 * part.
 	 */
-	if (page_trans_huge_mapcount(page, NULL) == 1) {
+	if (!trylock_page(page)) {
+		get_page(page);
+		spin_unlock(vmf->ptl);
+		lock_page(page);
+		spin_lock(vmf->ptl);
+		if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+			unlock_page(page);
+			put_page(page);
+			goto out_unlock;
+		}
+		put_page(page);
+	}
+	if (reuse_swap_page(page, NULL)) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry,  1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		ret |= VM_FAULT_WRITE;
+		unlock_page(page);
 		goto out_unlock;
 	}
+	unlock_page(page);
 	get_page(page);
 	spin_unlock(vmf->ptl);
 alloc:
diff -puN mm/memory.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out mm/memory.c
--- a/mm/memory.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out
+++ a/mm/memory.c
@@ -2619,7 +2619,7 @@ static int do_wp_page(struct vm_fault *v
 	 * not dirty accountable.
 	 */
 	if (PageAnon(vmf->page) && !PageKsm(vmf->page)) {
-		int total_mapcount;
+		int total_map_swapcount;
 		if (!trylock_page(vmf->page)) {
 			get_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -2634,8 +2634,8 @@ static int do_wp_page(struct vm_fault *v
 			}
 			put_page(vmf->page);
 		}
-		if (reuse_swap_page(vmf->page, &total_mapcount)) {
-			if (total_mapcount == 1) {
+		if (reuse_swap_page(vmf->page, &total_map_swapcount)) {
+			if (total_map_swapcount == 1) {
 				/*
 				 * The page is all ours. Move it to
 				 * our anon_vma so the rmap code will
diff -puN mm/swapfile.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out
+++ a/mm/swapfile.c
@@ -1405,9 +1405,89 @@ static bool page_swapped(struct page *pa
 		return swap_page_trans_huge_swapped(si, entry);
 	return false;
 }
+
+static int page_trans_huge_map_swapcount(struct page *page, int *total_mapcount,
+					 int *total_swapcount)
+{
+	int i, map_swapcount, _total_mapcount, _total_swapcount;
+	unsigned long offset = 0;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci = NULL;
+	unsigned char *map = NULL;
+	int mapcount, swapcount = 0;
+
+	/* hugetlbfs shouldn't call it */
+	VM_BUG_ON_PAGE(PageHuge(page), page);
+
+	if (likely(!PageTransCompound(page))) {
+		mapcount = atomic_read(&page->_mapcount) + 1;
+		if (total_mapcount)
+			*total_mapcount = mapcount;
+		if (PageSwapCache(page))
+			swapcount = page_swapcount(page);
+		if (total_swapcount)
+			*total_swapcount = swapcount;
+		return mapcount + swapcount;
+	}
+
+	page = compound_head(page);
+
+	_total_mapcount = _total_swapcount = map_swapcount = 0;
+	if (PageSwapCache(page)) {
+		swp_entry_t entry;
+
+		entry.val = page_private(page);
+		si = _swap_info_get(entry);
+		if (si) {
+			map = si->swap_map;
+			offset = swp_offset(entry);
+		}
+	}
+	if (map)
+		ci = lock_cluster(si, offset);
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		mapcount = atomic_read(&page[i]._mapcount) + 1;
+		_total_mapcount += mapcount;
+		if (map) {
+			swapcount = swap_count(map[offset + i]);
+			_total_swapcount += swapcount;
+		}
+		map_swapcount = max(map_swapcount, mapcount + swapcount);
+	}
+	unlock_cluster(ci);
+	if (PageDoubleMap(page)) {
+		map_swapcount -= 1;
+		_total_mapcount -= HPAGE_PMD_NR;
+	}
+	mapcount = compound_mapcount(page);
+	map_swapcount += mapcount;
+	_total_mapcount += mapcount;
+	if (total_mapcount)
+		*total_mapcount = _total_mapcount;
+	if (total_swapcount)
+		*total_swapcount = _total_swapcount;
+
+	return map_swapcount;
+}
 #else
 #define swap_page_trans_huge_swapped(si, entry)	swap_swapcount(si, entry)
 #define page_swapped(page)			(page_swapcount(page) != 0)
+
+static int page_trans_huge_map_swapcount(struct page *page, int *total_mapcount,
+					 int *total_swapcount)
+{
+	int mapcount, swapcount = 0;
+
+	/* hugetlbfs shouldn't call it */
+	VM_BUG_ON_PAGE(PageHuge(page), page);
+
+	mapcount = page_trans_huge_mapcount(page, total_mapcount);
+	if (PageSwapCache(page))
+		swapcount = page_swapcount(page);
+	if (total_swapcount)
+		*total_swapcount = swapcount;
+	return mapcount + swapcount;
+}
 #endif
 
 /*
@@ -1416,23 +1496,27 @@ static bool page_swapped(struct page *pa
  * on disk will never be read, and seeking back there to write new content
  * later would only waste time away from clustering.
  *
- * NOTE: total_mapcount should not be relied upon by the caller if
+ * NOTE: total_map_swapcount should not be relied upon by the caller if
  * reuse_swap_page() returns false, but it may be always overwritten
  * (see the other implementation for CONFIG_SWAP=n).
  */
-bool reuse_swap_page(struct page *page, int *total_mapcount)
+bool reuse_swap_page(struct page *page, int *total_map_swapcount)
 {
-	int count;
+	int count, total_mapcount, total_swapcount;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	if (unlikely(PageKsm(page)))
 		return false;
-	count = page_trans_huge_mapcount(page, total_mapcount);
-	if (count <= 1 && PageSwapCache(page)) {
-		count += page_swapcount(page);
-		if (count != 1)
-			goto out;
+	count = page_trans_huge_map_swapcount(page, &total_mapcount,
+					      &total_swapcount);
+	if (total_map_swapcount)
+		*total_map_swapcount = total_mapcount + total_swapcount;
+	if (count == 1 && PageSwapCache(page) &&
+	    (likely(!PageTransCompound(page)) ||
+	     /* The remaining swap count will be freed soon */
+	     total_swapcount == page_swapcount(page))) {
 		if (!PageWriteback(page)) {
+			page = compound_head(page);
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
 		} else {
@@ -1448,7 +1532,7 @@ bool reuse_swap_page(struct page *page,
 			spin_unlock(&p->lock);
 		}
 	}
-out:
+
 	return count <= 1;
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are


