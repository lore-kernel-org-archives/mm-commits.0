From: akpm@linux-foundation.org
Subject: +
 mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2.patch added
 to -mm tree
Date: Wed, 09 Aug 2017 13:46:35 -0700
Message-ID: <598b74ab.07+5n7VIJwDAFyyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbdHIUqg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 16:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: try_to_unmap_one() do not call mmu_notifier under ptl v2
has been added to the -mm tree.  Its filename is
     mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/rmap: try_to_unmap_one() do not call mmu_notifier under ptl v2

MMU notifiers can sleep, but in try_to_unmap_one() we call
mmu_notifier_invalidate_page() under page table lock.

Let's instead use mmu_notifier_invalidate_range() outside
page_vma_mapped_walk() loop.

Link: http://lkml.kernel.org/r/20170809204333.27485-1-jglisse@redhat.com
Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN mm/rmap.c~mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2 mm/rmap.c
--- a/mm/rmap.c~mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2
+++ a/mm/rmap.c
@@ -1328,7 +1328,7 @@ static bool try_to_unmap_one(struct page
 	};
 	pte_t pteval;
 	struct page *subpage;
-	bool ret = true;
+	bool ret = true, invalidation_needed = false;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
@@ -1368,11 +1368,9 @@ static bool try_to_unmap_one(struct page
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
@@ -1381,7 +1379,7 @@ static bool try_to_unmap_one(struct page
 		}
 
 		/* Nuke the page table entry. */
-		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
+		flush_cache_page(vma, pvmw.address, pte_pfn(*pvmw.pte));
 		if (should_defer_flush(mm, flags)) {
 			/*
 			 * We clear the PTE but do not flush so potentially
@@ -1391,11 +1389,12 @@ static bool try_to_unmap_one(struct page
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
@@ -1410,12 +1409,12 @@ static bool try_to_unmap_one(struct page
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
@@ -1439,7 +1438,7 @@ static bool try_to_unmap_one(struct page
 			swp_pte = swp_entry_to_pte(entry);
 			if (pte_soft_dirty(pteval))
 				swp_pte = pte_swp_mksoft_dirty(swp_pte);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 		} else if (PageAnon(page)) {
 			swp_entry_t entry = { .val = page_private(subpage) };
 			pte_t swp_pte;
@@ -1465,7 +1464,7 @@ static bool try_to_unmap_one(struct page
 				 * If the page was redirtied, it cannot be
 				 * discarded. Remap the page to page table.
 				 */
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, pvmw.address, pvmw.pte, pteval);
 				SetPageSwapBacked(page);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
@@ -1473,7 +1472,7 @@ static bool try_to_unmap_one(struct page
 			}
 
 			if (swap_duplicate(entry) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, pvmw.address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -1489,14 +1488,18 @@ static bool try_to_unmap_one(struct page
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

Patches currently in -mm which might be from jglisse@redhat.com are

mm-rmap-try_to_unmap_one-do-not-call-mmu_notifier-under-ptl-v2.patch
lib-interval_tree-fast-overlap-detection-fix.patch

