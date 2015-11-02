From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-dont-split-thp-page-when-syscall-is-called.patch removed from -mm tree
Date: Mon, 02 Nov 2015 14:53:40 -0800
Message-ID: <5637e974.VP6jeO1mGYvobT8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbKBWxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, mhocko@suse.cz, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't split THP page when MADV_FREE syscall is called
has been removed from the -mm tree.  Its filename was
     mm-dont-split-thp-page-when-syscall-is-called.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: don't split THP page when MADV_FREE syscall is called

We don't need to split THP page when MADV_FREE syscall is called.  It
could be done when VM decide really frees it so we could avoid unnecessary
THP split.

[pebolle@tiscali.nl: fix comment typo "CONFIG_TRANSPARNTE_HUGE"]
[hughd@google.com: madvise_free_pte_range() has the args to split_huge_pmd() the wrong way round]
[akpm@linux-foundation.org: fix layout]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 +++
 include/linux/rmap.h    |    8 +------
 mm/huge_memory.c        |   34 ++++++++++++++++++++++++++++++
 mm/madvise.c            |   12 +++++++++-
 mm/rmap.c               |   38 ++++++----------------------------
 mm/swap_state.c         |    5 +---
 mm/vmscan.c             |   42 +++++++++++---------------------------
 7 files changed, 73 insertions(+), 70 deletions(-)

diff -puN include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called
+++ a/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 					  unsigned long addr,
 					  pmd_t *pmd,
 					  unsigned int flags);
+extern int madvise_free_huge_pmd(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			pmd_t *pmd, unsigned long addr);
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd, unsigned long addr);
@@ -52,6 +55,7 @@ extern pmd_t *page_check_address_pmd(str
 				     struct mm_struct *mm,
 				     unsigned long address,
 				     spinlock_t **ptl);
+extern int pmd_freeable(pmd_t pmd);
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
diff -puN mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/huge_memory.c
@@ -1530,6 +1530,40 @@ out:
 	return 0;
 }
 
+int madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		 pmd_t *pmd, unsigned long addr)
+
+{
+	spinlock_t *ptl;
+	struct mm_struct *mm = tlb->mm;
+	int ret = 1;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		struct page *page;
+		pmd_t orig_pmd;
+
+		if (is_huge_zero_pmd(*pmd))
+			goto out;
+
+		orig_pmd = pmdp_huge_get_and_clear(mm, addr, pmd);
+
+		/* No hugepage in swapcache */
+		page = pmd_page(orig_pmd);
+		VM_BUG_ON_PAGE(PageSwapCache(page), page);
+
+		orig_pmd = pmd_mkold(orig_pmd);
+		orig_pmd = pmd_mkclean(orig_pmd);
+
+		set_pmd_at(mm, addr, pmd, orig_pmd);
+		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+out:
+		spin_unlock(ptl);
+		ret = 0;
+	}
+
+	return ret;
+}
+
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/madvise.c
@@ -270,8 +270,17 @@ static int madvise_free_pte_range(pmd_t
 	spinlock_t *ptl;
 	pte_t *pte, ptent;
 	struct page *page;
+	unsigned long next;
+
+	next = pmd_addr_end(addr, end);
+	if (pmd_trans_huge(*pmd)) {
+		if (next - addr != HPAGE_PMD_SIZE)
+			split_huge_pmd(vma, pmd, addr);
+		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
+			goto next;
+		/* fall through */
+	}
 
-	split_huge_pmd(vma, addr, pmd);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
@@ -323,6 +332,7 @@ static int madvise_free_pte_range(pmd_t
 	}
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
+next:
 	cond_resched();
 	return 0;
 }
diff -puN mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called mm/rmap.c
--- a/mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called
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
@@ -835,10 +833,6 @@ static int page_referenced_one(struct pa
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 
-		/*
-		 * In this implmentation, MADV_FREE doesn't support THP free
-		 */
-		dirty++;
 		spin_unlock(ptl);
 	} else {
 		pte_t *pte;
@@ -869,9 +863,6 @@ static int page_referenced_one(struct pa
 				referenced++;
 		}
 
-		if (pte_dirty(*pte))
-			dirty++;
-
 		pte_unmap_unlock(pte, ptl);
 	}
 
@@ -885,9 +876,6 @@ static int page_referenced_one(struct pa
 		pra->vm_flags |= vma->vm_flags;
 	}
 
-	if (dirty)
-		pra->dirtied++;
-
 	pra->mapcount--;
 	if (!pra->mapcount)
 		return SWAP_SUCCESS; /* To break the loop */
@@ -912,7 +900,6 @@ static bool invalid_page_referenced_vma(
  * @is_locked: caller holds lock on the page
  * @memcg: target memory cgroup
  * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
- * @is_pte_dirty: ptes which have marked dirty bit - used for lazyfree page
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
@@ -920,8 +907,7 @@ static bool invalid_page_referenced_vma(
 int page_referenced(struct page *page,
 		    int is_locked,
 		    struct mem_cgroup *memcg,
-		    unsigned long *vm_flags,
-		    int *is_pte_dirty)
+		    unsigned long *vm_flags)
 {
 	int ret;
 	int we_locked = 0;
@@ -936,8 +922,6 @@ int page_referenced(struct page *page,
 	};
 
 	*vm_flags = 0;
-	if (is_pte_dirty)
-		*is_pte_dirty = 0;
 
 	if (!page_mapped(page))
 		return 0;
@@ -966,9 +950,6 @@ int page_referenced(struct page *page,
 	if (we_locked)
 		unlock_page(page);
 
-	if (is_pte_dirty)
-		*is_pte_dirty = pra.dirtied;
-
 	return pra.referenced;
 }
 
@@ -1469,17 +1450,10 @@ static int try_to_unmap_one(struct page
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
 
 		/*
@@ -1492,6 +1466,8 @@ static int try_to_unmap_one(struct page
 			ret = SWAP_FAIL;
 			goto out_unmap;
 		}
+		if (!PageDirty(page))
+			SetPageDirty(page);
 		if (list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			if (list_empty(&mm->mmlist))
diff -puN mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-split-thp-page-when-syscall-is-called
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
@@ -1054,13 +1047,13 @@ static unsigned long shrink_page_list(st
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */
-		if (PageAnon(page) && !PageSwapCache(page) && !freeable) {
+		if (PageAnon(page) && !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (!add_to_swap(page, page_list))
 				goto activate_locked;
+			freeable = true;
 			may_enter_fs = 1;
-
 			/* Adding to swap updated mapping */
 			mapping = page_mapping(page);
 		}
@@ -1069,9 +1062,10 @@ static unsigned long shrink_page_list(st
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
@@ -1079,20 +1073,7 @@ static unsigned long shrink_page_list(st
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
 
@@ -1209,6 +1190,9 @@ static unsigned long shrink_page_list(st
 		 */
 		__ClearPageLocked(page);
 free_it:
+		if (freeable && !PageDirty(page))
+			count_vm_event(PGLAZYFREED);
+
 		nr_reclaimed++;
 
 		/*
@@ -1839,7 +1823,7 @@ static void shrink_active_list(unsigned
 		}
 
 		if (page_referenced(page, 0, sc->target_mem_cgroup,
-				    &vm_flags, NULL)) {
+				    &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
diff -puN include/linux/rmap.h~mm-dont-split-thp-page-when-syscall-is-called include/linux/rmap.h
--- a/include/linux/rmap.h~mm-dont-split-thp-page-when-syscall-is-called
+++ a/include/linux/rmap.h
@@ -193,8 +193,7 @@ static inline void page_dup_rmap(struct
  * Called from mm/vmscan.c to handle paging out
  */
 int page_referenced(struct page *, int is_locked,
-			struct mem_cgroup *memcg, unsigned long *vm_flags,
-			int *is_pte_dirty);
+			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
@@ -271,12 +270,9 @@ int rmap_walk(struct page *page, struct
 
 static inline int page_referenced(struct page *page, int is_locked,
 				  struct mem_cgroup *memcg,
-				  unsigned long *vm_flags,
-				  int *is_pte_dirty)
+				  unsigned long *vm_flags)
 {
 	*vm_flags = 0;
-	if (is_pte_dirty)
-		*is_pte_dirty = 0;
 	return 0;
 }
 
diff -puN mm/swap_state.c~mm-dont-split-thp-page-when-syscall-is-called mm/swap_state.c
--- a/mm/swap_state.c~mm-dont-split-thp-page-when-syscall-is-called
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
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch

