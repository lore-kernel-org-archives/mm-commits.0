From: akpm@linux-foundation.org
Subject: [patch 19/21] rmap: do not call mmu_notifier_invalidate_page()
 under ptl
Date: Thu, 10 Aug 2017 15:24:27 -0700
Message-ID: <598cdd1b.kfDVtAo8u4/Jv9pU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdHJWY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, Tim.Writer@amd.com, alexander.deucher@amd.com, axie@amd.com, jglisse@redhat.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: do not call mmu_notifier_invalidate_page() under ptl

MMU notifiers can sleep, but in page_mkclean_one() we call
mmu_notifier_invalidate_page() under page table lock.

Let's instead use mmu_notifier_invalidate_range() outside
page_vma_mapped_walk() loop.

[jglisse@redhat.com: try_to_unmap_one() do not call mmu_notifier under ptl]
  Link: http://lkml.kernel.org/r/20170809204333.27485-1-jglisse@redhat.com
Link: http://lkml.kernel.org/r/20170804134928.l4klfcnqatni7vsc@black.fi.intel.com
Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reported-by: axie <axie@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Writer, Tim" <Tim.Writer@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   52 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff -puN mm/rmap.c~rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl mm/rmap.c
--- a/mm/rmap.c~rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl
+++ a/mm/rmap.c
@@ -888,10 +888,10 @@ static bool page_mkclean_one(struct page
 		.flags = PVMW_SYNC,
 	};
 	int *cleaned = arg;
+	bool invalidation_needed = false;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		int ret = 0;
-		address = pvmw.address;
 		if (pvmw.pte) {
 			pte_t entry;
 			pte_t *pte = pvmw.pte;
@@ -899,11 +899,11 @@ static bool page_mkclean_one(struct page
 			if (!pte_dirty(*pte) && !pte_write(*pte))
 				continue;
 
-			flush_cache_page(vma, address, pte_pfn(*pte));
-			entry = ptep_clear_flush(vma, address, pte);
+			flush_cache_page(vma, pvmw.address, pte_pfn(*pte));
+			entry = ptep_clear_flush(vma, pvmw.address, pte);
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
-			set_pte_at(vma->vm_mm, address, pte, entry);
+			set_pte_at(vma->vm_mm, pvmw.address, pte, entry);
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
@@ -913,11 +913,11 @@ static bool page_mkclean_one(struct page
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, page_to_pfn(page));
-			entry = pmdp_huge_clear_flush(vma, address, pmd);
+			flush_cache_page(vma, pvmw.address, page_to_pfn(page));
+			entry = pmdp_huge_clear_flush(vma, pvmw.address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
-			set_pmd_at(vma->vm_mm, address, pmd, entry);
+			set_pmd_at(vma->vm_mm, pvmw.address, pmd, entry);
 			ret = 1;
 #else
 			/* unexpected pmd-mapped page? */
@@ -926,11 +926,16 @@ static bool page_mkclean_one(struct page
 		}
 
 		if (ret) {
-			mmu_notifier_invalidate_page(vma->vm_mm, address);
 			(*cleaned)++;
+			invalidation_needed = true;
 		}
 	}
 
+	if (invalidation_needed) {
+		mmu_notifier_invalidate_range(vma->vm_mm, address,
+				address + (1UL << compound_order(page)));
+	}
+
 	return true;
 }
 
@@ -1323,7 +1328,7 @@ static bool try_to_unmap_one(struct page
 	};
 	pte_t pteval;
 	struct page *subpage;
-	bool ret = true;
+	bool ret = true, invalidation_needed = false;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
@@ -1363,11 +1368,9 @@ static bool try_to_unmap_one(struct page
 		VM_BUG_ON_PAGE(!pvmw.pte, page);
 
 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
-		address = pvmw.address;
-
 
 		if (!(flags & TTU_IGNORE_ACCESS)) {
-			if (ptep_clear_flush_young_notify(vma, address,
+			if (ptep_clear_flush_young_notify(vma, pvmw.address,
 						pvmw.pte)) {
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
@@ -1376,7 +1379,7 @@ static bool try_to_unmap_one(struct page
 		}
 
 		/* Nuke the page table entry. */
-		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
+		flush_cache_page(vma, pvmw.address, pte_pfn(*pvmw.pte));
 		if (should_defer_flush(mm, flags)) {
 			/*
 			 * We clear the PTE but do not flush so potentially
@@ -1386,11 +1389,12 @@ static bool try_to_unmap_one(struct page
 			 * transition on a cached TLB entry is written through
 			 * and traps if the PTE is unmapped.
 			 */
-			pteval = ptep_get_and_clear(mm, address, pvmw.pte);
+			pteval = ptep_get_and_clear(mm, pvmw.address,
+						    pvmw.pte);
 
 			set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
 		} else {
-			pteval = ptep_clear_flush(vma, address, pvmw.pte);
+			pteval = ptep_clear_flush(vma, pvmw.address, pvmw.pte);
 		}
 
 		/* Move the dirty bit to the page. Now the pte is gone. */
@@ -1405,12 +1409,12 @@ static bool try_to_unmap_one(struct page
 			if (PageHuge(page)) {
 				int nr = 1 << compound_order(page);
 				hugetlb_count_sub(nr, mm);
-				set_huge_swap_pte_at(mm, address,
+				set_huge_swap_pte_at(mm, pvmw.address,
 						     pvmw.pte, pteval,
 						     vma_mmu_pagesize(vma));
 			} else {
 				dec_mm_counter(mm, mm_counter(page));
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, pvmw.address, pvmw.pte, pteval);
 			}
 
 		} else if (pte_unused(pteval)) {
@@ -1434,7 +1438,7 @@ static bool try_to_unmap_one(struct page
 			swp_pte = swp_entry_to_pte(entry);
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 		} else if (PageAnon(page)) {
 			swp_entry_t entry = { .val = page_private(subpage) };
 			pte_t swp_pte;
@@ -1460,7 +1464,7 @@ static bool try_to_unmap_one(struct page
 				 * If the page was redirtied, it cannot be
 				 * discarded. Remap the page to page table.
 				 */
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, pvmw.address, pvmw.pte, pteval);
 				SetPageSwapBacked(page);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
@@ -1468,7 +1472,7 @@ static bool try_to_unmap_one(struct page
 			}
 
 			if (swap_duplicate(entry) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, pvmw.address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -1484,14 +1488,18 @@ static bool try_to_unmap_one(struct page
 			swp_pte = swp_entry_to_pte(entry);
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 		} else
 			dec_mm_counter(mm, mm_counter_file(page));
 discard:
 		page_remove_rmap(subpage, PageHuge(page));
 		put_page(page);
-		mmu_notifier_invalidate_page(mm, address);
+		invalidation_needed = true;
 	}
+
+	if (invalidation_needed)
+		mmu_notifier_invalidate_range(mm, address,
+				address + (1UL << compound_order(page)));
 	return ret;
 }
 
_
