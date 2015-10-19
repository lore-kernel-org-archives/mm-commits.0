From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch added to -mm tree
Date: Mon, 19 Oct 2015 14:37:54 -0700
Message-ID: <562562b2.KvBCeKtYIXjOiCd9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbJSVhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify reclaim path for MADV_FREE
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: simplify reclaim path for MADV_FREE

I made reclaim path mess to check and free MADV_FREEed page.  This patch
simplify it with tweaking add_to_swap.

So far, we mark page as PG_dirty when we add the page into swap cache(ie,
add_to_swap) to page out to swap device but this patch moves PG_dirty
marking under try_to_unmap_one when we decide to change pte from anon to
swapent so if any process's pte has swapent for the page, the page must be
swapped out.  IOW, there should be no funcional behavior change.  It makes
relcaim path really simple for MADV_FREE because we just need to check
PG_dirty of page to decide discarding the page or not.

Other thing this patch does is to pass TTU_BATCH_FLUSH to try_to_unmap
when we handle freeable page because I don't see any reason to prevent it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    6 ---
 mm/huge_memory.c     |    5 ---
 mm/rmap.c            |   42 ++++----------------------
 mm/swap_state.c      |    5 +--
 mm/vmscan.c          |   64 ++++++++++++-----------------------------
 5 files changed, 30 insertions(+), 92 deletions(-)

diff -puN include/linux/rmap.h~mm-dont-split-thp-page-when-syscall-is-called-fix-6 include/linux/rmap.h
--- a/include/linux/rmap.h~mm-dont-split-thp-page-when-syscall-is-called-fix-6
+++ a/include/linux/rmap.h
@@ -193,8 +193,7 @@ static inline void page_dup_rmap(struct
  * Called from mm/vmscan.c to handle paging out
  */
 int page_referenced(struct page *, int is_locked,
-			struct mem_cgroup *memcg, unsigned long *vm_flags,
-			int *is_pte_dirty);
+			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
@@ -272,11 +271,8 @@ int rmap_walk(struct page *page, struct
 static inline int page_referenced(struct page *page, int is_locked,
 				  struct mem_cgroup *memcg,
 				  unsigned long *vm_flags,
-				  int *is_pte_dirty)
 {
 	*vm_flags = 0;
-	if (is_pte_dirty)
-		*is_pte_dirty = 0;
 	return 0;
 }
 
diff -puN mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6
+++ a/mm/huge_memory.c
@@ -1753,11 +1753,6 @@ unlock:
 	return NULL;
 }
 
-int pmd_freeable(pmd_t pmd)
-{
-	return !pmd_dirty(pmd);
-}
-
 #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
diff -puN mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6 mm/rmap.c
--- a/mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6
+++ a/mm/rmap.c
@@ -797,7 +797,6 @@ int page_mapped_in_vma(struct page *page
 }
 
 struct page_referenced_arg {
-	int dirtied;
 	int mapcount;
 	int referenced;
 	unsigned long vm_flags;
@@ -812,7 +811,6 @@ static int page_referenced_one(struct pa
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	int referenced = 0;
-	int dirty = 0;
 	struct page_referenced_arg *pra = arg;
 
 	if (unlikely(PageTransHuge(page))) {
@@ -835,14 +833,6 @@ static int page_referenced_one(struct pa
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 
-		/*
-		 * Use pmd_freeable instead of raw pmd_dirty because in some
-		 * of architecture, pmd_dirty is not defined unless
-		 * CONFIG_TRANSPARENT_HUGEPAGE is enabled
-		 */
-		if (!pmd_freeable(*pmd))
-			dirty++;
-
 		spin_unlock(ptl);
 	} else {
 		pte_t *pte;
@@ -873,9 +863,6 @@ static int page_referenced_one(struct pa
 				referenced++;
 		}
 
-		if (pte_dirty(*pte))
-			dirty++;
-
 		pte_unmap_unlock(pte, ptl);
 	}
 
@@ -889,9 +876,6 @@ static int page_referenced_one(struct pa
 		pra->vm_flags |= vma->vm_flags;
 	}
 
-	if (dirty)
-		pra->dirtied++;
-
 	pra->mapcount--;
 	if (!pra->mapcount)
 		return SWAP_SUCCESS; /* To break the loop */
@@ -916,7 +900,6 @@ static bool invalid_page_referenced_vma(
  * @is_locked: caller holds lock on the page
  * @memcg: target memory cgroup
  * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
- * @is_pte_dirty: ptes which have marked dirty bit - used for lazyfree page
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
@@ -924,8 +907,7 @@ static bool invalid_page_referenced_vma(
 int page_referenced(struct page *page,
 		    int is_locked,
 		    struct mem_cgroup *memcg,
-		    unsigned long *vm_flags,
-		    int *is_pte_dirty)
+		    unsigned long *vm_flags)
 {
 	int ret;
 	int we_locked = 0;
@@ -940,8 +922,6 @@ int page_referenced(struct page *page,
 	};
 
 	*vm_flags = 0;
-	if (is_pte_dirty)
-		*is_pte_dirty = 0;
 
 	if (!page_mapped(page))
 		return 0;
@@ -970,9 +950,6 @@ int page_referenced(struct page *page,
 	if (we_locked)
 		unlock_page(page);
 
-	if (is_pte_dirty)
-		*is_pte_dirty = pra.dirtied;
-
 	return pra.referenced;
 }
 
@@ -1453,17 +1430,10 @@ static int try_to_unmap_one(struct page
 		swp_entry_t entry = { .val = page_private(page) };
 		pte_t swp_pte;
 
-		if (flags & TTU_FREE) {
-			VM_BUG_ON_PAGE(PageSwapCache(page), page);
-			if (!PageDirty(page)) {
-				/* It's a freeable page by MADV_FREE */
-				dec_mm_counter(mm, MM_ANONPAGES);
-				goto discard;
-			} else {
-				set_pte_at(mm, address, pte, pteval);
-				ret = SWAP_FAIL;
-				goto out_unmap;
-			}
+		if (!PageDirty(page) && (flags & TTU_FREE)) {
+			/* It's a freeable page by MADV_FREE */
+			dec_mm_counter(mm, MM_ANONPAGES);
+			goto discard;
 		}
 
 		if (PageSwapCache(page)) {
@@ -1476,6 +1446,8 @@ static int try_to_unmap_one(struct page
 				ret = SWAP_FAIL;
 				goto out_unmap;
 			}
+			if (!PageDirty(page))
+				SetPageDirty(page);
 			if (list_empty(&mm->mmlist)) {
 				spin_lock(&mmlist_lock);
 				if (list_empty(&mm->mmlist))
diff -puN mm/swap_state.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6 mm/swap_state.c
--- a/mm/swap_state.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6
+++ a/mm/swap_state.c
@@ -185,13 +185,12 @@ int add_to_swap(struct page *page, struc
 	 * deadlock in the swap out path.
 	 */
 	/*
-	 * Add it to the swap cache and mark it dirty
+	 * Add it to the swap cache.
 	 */
 	err = add_to_swap_cache(page, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
 
-	if (!err) {	/* Success */
-		SetPageDirty(page);
+	if (!err) {
 		return 1;
 	} else {	/* -ENOMEM radix-tree allocation failure */
 		/*
diff -puN mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6 mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called-fix-6
+++ a/mm/vmscan.c
@@ -791,17 +791,15 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct scan_control *sc,
-						  bool *freeable)
+						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
-	int pte_dirty;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
-					  &vm_flags, &pte_dirty);
+					  &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/*
@@ -842,10 +840,6 @@ static enum page_references page_check_r
 		return PAGEREF_KEEP;
 	}
 
-	if (PageAnon(page) && !pte_dirty && !PageSwapCache(page) &&
-			!PageDirty(page))
-		*freeable = true;
-
 	/* Reclaim if clean, defer dirty pages to writeback */
 	if (referenced_page && !PageSwapBacked(page))
 		return PAGEREF_RECLAIM_CLEAN;
@@ -1037,8 +1031,7 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (!force_reclaim)
-			references = page_check_references(page, sc,
-							&freeable);
+			references = page_check_references(page, sc);
 
 		switch (references) {
 		case PAGEREF_ACTIVATE:
@@ -1055,31 +1048,24 @@ static unsigned long shrink_page_list(st
 		 * Try to allocate it some swap space here.
 		 */
 		if (PageAnon(page) && !PageSwapCache(page)) {
-			if (!freeable) {
-				if (!(sc->gfp_mask & __GFP_IO))
-					goto keep_locked;
-				if (!add_to_swap(page, page_list))
-					goto activate_locked;
-				may_enter_fs = 1;
-				/* Adding to swap updated mapping */
-				mapping = page_mapping(page);
-			} else {
-				if (likely(!PageTransHuge(page)))
-					goto unmap;
-				/* try_to_unmap isn't aware of THP page */
-				if (unlikely(split_huge_page_to_list(page,
-								page_list)))
-					goto keep_locked;
-			}
+			if (!(sc->gfp_mask & __GFP_IO))
+				goto keep_locked;
+			if (!add_to_swap(page, page_list))
+				goto activate_locked;
+			freeable = true;
+			may_enter_fs = 1;
+			/* Adding to swap updated mapping */
+			mapping = page_mapping(page);
 		}
-unmap:
+
 		/*
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (page_mapped(page) && (mapping || freeable)) {
+		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, freeable ?
-					TTU_FREE : ttu_flags|TTU_BATCH_FLUSH)) {
+					ttu_flags | TTU_BATCH_FLUSH | TTU_FREE :
+					ttu_flags | TTU_BATCH_FLUSH)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -1087,20 +1073,7 @@ unmap:
 			case SWAP_MLOCK:
 				goto cull_mlocked;
 			case SWAP_SUCCESS:
-				/* try to free the page below */
-				if (!freeable)
-					break;
-				/*
-				 * Freeable anon page doesn't have mapping
-				 * due to skipping of swapcache so we free
-				 * page in here rather than __remove_mapping.
-				 */
-				VM_BUG_ON_PAGE(PageSwapCache(page), page);
-				if (!page_freeze_refs(page, 1))
-					goto keep_locked;
-				__ClearPageLocked(page);
-				count_vm_event(PGLAZYFREED);
-				goto free_it;
+				; /* try to free the page below */
 			}
 		}
 
@@ -1217,6 +1190,9 @@ unmap:
 		 */
 		__ClearPageLocked(page);
 free_it:
+		if (freeable && !PageDirty(page))
+			count_vm_event(PGLAZYFREED);
+
 		nr_reclaimed++;
 
 		/*
@@ -1847,7 +1823,7 @@ static void shrink_active_list(unsigned
 		}
 
 		if (page_referenced(page, 0, sc->target_mem_cgroup,
-				    &vm_flags, NULL)) {
+				    &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
_

Patches currently in -mm which might be from minchan@kernel.org are

thp-use-is_zero_pfn-only-after-pte_present-check.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-5.patch
mm-support-madvisemadv_free-fix-6.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
mm-mark-stable-page-dirty-in-ksm.patch

