From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 066/131] khugepaged: allow to collapse PTE-mapped
 compound pages
Date: Wed, 03 Jun 2020 16:00:23 -0700
Message-ID: <20200603230023.ZyVnewr_F%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:25 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: allow to collapse PTE-mapped compound pages

We can collapse PTE-mapped compound pages.  We only need to avoid handling
them more than once: lock/unlock page only once if it's present in the PMD
range multiple times as it handled on compound level.  The same goes for
LRU isolation and putback.

Link: http://lkml.kernel.org/r/20200416160026.16538-7-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   99 ++++++++++++++++++++++++++++++----------------
 1 file changed, 65 insertions(+), 34 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-pte-mapped-compound-pages
+++ a/mm/khugepaged.c
@@ -512,17 +512,30 @@ void __khugepaged_exit(struct mm_struct
 
 static void release_pte_page(struct page *page)
 {
-	dec_node_page_state(page, NR_ISOLATED_ANON + page_is_file_lru(page));
+	mod_node_page_state(page_pgdat(page),
+			NR_ISOLATED_ANON + page_is_file_lru(page),
+			-compound_nr(page));
 	unlock_page(page);
 	putback_lru_page(page);
 }
 
-static void release_pte_pages(pte_t *pte, pte_t *_pte)
+static void release_pte_pages(pte_t *pte, pte_t *_pte,
+		struct list_head *compound_pagelist)
 {
+	struct page *page, *tmp;
+
 	while (--_pte >= pte) {
 		pte_t pteval = *_pte;
-		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)))
-			release_pte_page(pte_page(pteval));
+
+		page = pte_page(pteval);
+		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)) &&
+				!PageCompound(page))
+			release_pte_page(page);
+	}
+
+	list_for_each_entry_safe(page, tmp, compound_pagelist, lru) {
+		list_del(&page->lru);
+		release_pte_page(page);
 	}
 }
 
@@ -539,7 +552,8 @@ static bool is_refcount_suitable(struct
 
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
-					pte_t *pte)
+					pte_t *pte,
+					struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	pte_t *_pte;
@@ -569,13 +583,21 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 
-		/* TODO: teach khugepaged to collapse THP mapped with pte */
+		VM_BUG_ON_PAGE(!PageAnon(page), page);
+
 		if (PageCompound(page)) {
-			result = SCAN_PAGE_COMPOUND;
-			goto out;
-		}
+			struct page *p;
+			page = compound_head(page);
 
-		VM_BUG_ON_PAGE(!PageAnon(page), page);
+			/*
+			 * Check if we have dealt with the compound page
+			 * already
+			 */
+			list_for_each_entry(p, compound_pagelist, lru) {
+				if (page == p)
+					goto next;
+			}
+		}
 
 		/*
 		 * We can do it before isolate_lru_page because the
@@ -604,19 +626,15 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PAGE_COUNT;
 			goto out;
 		}
-		if (pte_write(pteval)) {
-			writable = true;
-		} else {
-			if (PageSwapCache(page) &&
-			    !reuse_swap_page(page, NULL)) {
-				unlock_page(page);
-				result = SCAN_SWAP_CACHE_PAGE;
-				goto out;
-			}
+		if (!pte_write(pteval) && PageSwapCache(page) &&
+				!reuse_swap_page(page, NULL)) {
 			/*
-			 * Page is not in the swap cache. It can be collapsed
-			 * into a THP.
+			 * Page is in the swap cache and cannot be re-used.
+			 * It cannot be collapsed into a THP.
 			 */
+			unlock_page(page);
+			result = SCAN_SWAP_CACHE_PAGE;
+			goto out;
 		}
 
 		/*
@@ -628,16 +646,23 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
 		}
-		inc_node_page_state(page,
-				NR_ISOLATED_ANON + page_is_file_lru(page));
+		mod_node_page_state(page_pgdat(page),
+				NR_ISOLATED_ANON + page_is_file_lru(page),
+				compound_nr(page));
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 
+		if (PageCompound(page))
+			list_add_tail(&page->lru, compound_pagelist);
+next:
 		/* There should be enough young pte to collapse the page */
 		if (pte_young(pteval) ||
 		    page_is_young(page) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced++;
+
+		if (pte_write(pteval))
+			writable = true;
 	}
 	if (likely(writable)) {
 		if (likely(referenced)) {
@@ -651,7 +676,7 @@ static int __collapse_huge_page_isolate(
 	}
 
 out:
-	release_pte_pages(pte, _pte);
+	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(page, none_or_zero,
 					    referenced, writable, result);
 	return 0;
@@ -660,13 +685,14 @@ out:
 static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
 				      struct vm_area_struct *vma,
 				      unsigned long address,
-				      spinlock_t *ptl)
+				      spinlock_t *ptl,
+				      struct list_head *compound_pagelist)
 {
+	struct page *src_page, *tmp;
 	pte_t *_pte;
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 				_pte++, page++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
-		struct page *src_page;
 
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			clear_user_highpage(page, address);
@@ -686,7 +712,8 @@ static void __collapse_huge_page_copy(pt
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
-			release_pte_page(src_page);
+			if (!PageCompound(src_page))
+				release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
@@ -703,6 +730,11 @@ static void __collapse_huge_page_copy(pt
 			free_page_and_swap_cache(src_page);
 		}
 	}
+
+	list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
+		list_del(&src_page->lru);
+		release_pte_page(src_page);
+	}
 }
 
 static void khugepaged_alloc_sleep(void)
@@ -961,6 +993,7 @@ static void collapse_huge_page(struct mm
 				   struct page **hpage,
 				   int node, int referenced, int unmapped)
 {
+	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
@@ -1061,7 +1094,8 @@ static void collapse_huge_page(struct mm
 	mmu_notifier_invalidate_range_end(&range);
 
 	spin_lock(pte_ptl);
-	isolated = __collapse_huge_page_isolate(vma, address, pte);
+	isolated = __collapse_huge_page_isolate(vma, address, pte,
+			&compound_pagelist);
 	spin_unlock(pte_ptl);
 
 	if (unlikely(!isolated)) {
@@ -1086,7 +1120,8 @@ static void collapse_huge_page(struct mm
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl);
+	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl,
+			&compound_pagelist);
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
@@ -1205,11 +1240,7 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		/* TODO: teach khugepaged to collapse THP mapped with pte */
-		if (PageCompound(page)) {
-			result = SCAN_PAGE_COMPOUND;
-			goto out_unmap;
-		}
+		page = compound_head(page);
 
 		/*
 		 * Record which node the original page is from and save this
_
