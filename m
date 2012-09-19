From: akpm@linux-foundation.org
Subject: + mm-remove-vma-arg-from-page_evictable.patch added to -mm tree
Date: Wed, 19 Sep 2012 15:02:02 -0700
Message-ID: <20120919220202.F3E1B200069@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39128 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2ISWCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 18:02:07 -0400
Received: by eekd4 with SMTP id d4so91587eek.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 15:02:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: remove vma arg from page_evictable
has been added to the -mm tree.  Its filename is
     mm-remove-vma-arg-from-page_evictable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove vma arg from page_evictable

page_evictable(page, vma) is an irritant: almost all its callers pass
NULL for vma.  Remove the vma arg and use mlocked_vma_newpage(vma, page)
explicitly in the couple of places it's needed.  But in those places we
don't even need page_evictable() itself!  They're dealing with a freshly
allocated anonymous page, which has no "mapping" and cannot be mlocked yet.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   10 ++-------
 include/linux/swap.h                 |    2 -
 mm/internal.h                        |    5 +---
 mm/ksm.c                             |    2 -
 mm/rmap.c                            |    2 -
 mm/swap.c                            |    2 -
 mm/vmscan.c                          |   27 ++++++++-----------------
 7 files changed, 18 insertions(+), 32 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-remove-vma-arg-from-page_evictable Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-remove-vma-arg-from-page_evictable
+++ a/Documentation/vm/unevictable-lru.txt
@@ -197,12 +197,8 @@ the pages are also "rescued" from the un
 freeing them.
 
 page_evictable() also checks for mlocked pages by testing an additional page
-flag, PG_mlocked (as wrapped by PageMlocked()).  If the page is NOT mlocked,
-and a non-NULL VMA is supplied, page_evictable() will check whether the VMA is
-VM_LOCKED via is_mlocked_vma().  is_mlocked_vma() will SetPageMlocked() and
-update the appropriate statistics if the vma is VM_LOCKED.  This method allows
-efficient "culling" of pages in the fault path that are being faulted in to
-VM_LOCKED VMAs.
+flag, PG_mlocked (as wrapped by PageMlocked()), which is set when a page is
+faulted into a VM_LOCKED vma, or found in a vma being VM_LOCKED.
 
 
 VMSCAN'S HANDLING OF UNEVICTABLE PAGES
@@ -651,7 +647,7 @@ PAGE RECLAIM IN shrink_*_list()
 -------------------------------
 
 shrink_active_list() culls any obviously unevictable pages - i.e.
-!page_evictable(page, NULL) - diverting these to the unevictable list.
+!page_evictable(page) - diverting these to the unevictable list.
 However, shrink_active_list() only sees unevictable pages that made it onto the
 active/inactive lru lists.  Note that these pages do not have PageUnevictable
 set - otherwise they would be on the unevictable list and shrink_active_list
diff -puN include/linux/swap.h~mm-remove-vma-arg-from-page_evictable include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-vma-arg-from-page_evictable
+++ a/include/linux/swap.h
@@ -281,7 +281,7 @@ static inline int zone_reclaim(struct zo
 }
 #endif
 
-extern int page_evictable(struct page *page, struct vm_area_struct *vma);
+extern int page_evictable(struct page *page);
 extern void check_move_unevictable_pages(struct page **, int nr_pages);
 
 extern unsigned long scan_unevictable_pages;
diff -puN mm/internal.h~mm-remove-vma-arg-from-page_evictable mm/internal.h
--- a/mm/internal.h~mm-remove-vma-arg-from-page_evictable
+++ a/mm/internal.h
@@ -169,9 +169,8 @@ static inline void munlock_vma_pages_all
 }
 
 /*
- * Called only in fault path via page_evictable() for a new page
- * to determine if it's being mapped into a LOCKED vma.
- * If so, mark page as mlocked.
+ * Called only in fault path, to determine if a new page is being
+ * mapped into a LOCKED vma.  If it is, mark page as mlocked.
  */
 static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
diff -puN mm/ksm.c~mm-remove-vma-arg-from-page_evictable mm/ksm.c
--- a/mm/ksm.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/ksm.c
@@ -1586,7 +1586,7 @@ struct page *ksm_does_need_to_copy(struc
 		SetPageSwapBacked(new_page);
 		__set_page_locked(new_page);
 
-		if (page_evictable(new_page, vma))
+		if (!mlocked_vma_newpage(vma, new_page))
 			lru_cache_add_lru(new_page, LRU_ACTIVE_ANON);
 		else
 			add_page_to_unevictable_list(new_page);
diff -puN mm/rmap.c~mm-remove-vma-arg-from-page_evictable mm/rmap.c
--- a/mm/rmap.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/rmap.c
@@ -1083,7 +1083,7 @@ void page_add_new_anon_rmap(struct page 
 	else
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__page_set_anon_rmap(page, vma, address, 1);
-	if (page_evictable(page, vma))
+	if (!mlocked_vma_newpage(vma, page))
 		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
 		add_page_to_unevictable_list(page);
diff -puN mm/swap.c~mm-remove-vma-arg-from-page_evictable mm/swap.c
--- a/mm/swap.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/swap.c
@@ -751,7 +751,7 @@ void lru_add_page_tail(struct page *page
 
 	SetPageLRU(page_tail);
 
-	if (page_evictable(page_tail, NULL)) {
+	if (page_evictable(page_tail)) {
 		if (PageActive(page)) {
 			SetPageActive(page_tail);
 			active = 1;
diff -puN mm/vmscan.c~mm-remove-vma-arg-from-page_evictable mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/vmscan.c
@@ -553,7 +553,7 @@ void putback_lru_page(struct page *page)
 redo:
 	ClearPageUnevictable(page);
 
-	if (page_evictable(page, NULL)) {
+	if (page_evictable(page)) {
 		/*
 		 * For evictable pages, we can use the cache.
 		 * In event of a race, worst case is we end up with an
@@ -587,7 +587,7 @@ redo:
 	 * page is on unevictable list, it never be freed. To avoid that,
 	 * check after we added it to the list, again.
 	 */
-	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
+	if (lru == LRU_UNEVICTABLE && page_evictable(page)) {
 		if (!isolate_lru_page(page)) {
 			put_page(page);
 			goto redo;
@@ -709,7 +709,7 @@ static unsigned long shrink_page_list(st
 
 		sc->nr_scanned++;
 
-		if (unlikely(!page_evictable(page, NULL)))
+		if (unlikely(!page_evictable(page)))
 			goto cull_mlocked;
 
 		if (!sc->may_unmap && page_mapped(page))
@@ -1217,7 +1217,7 @@ putback_inactive_pages(struct lruvec *lr
 
 		VM_BUG_ON(PageLRU(page));
 		list_del(&page->lru);
-		if (unlikely(!page_evictable(page, NULL))) {
+		if (unlikely(!page_evictable(page))) {
 			spin_unlock_irq(&zone->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&zone->lru_lock);
@@ -1470,7 +1470,7 @@ static void shrink_active_list(unsigned 
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
 
-		if (unlikely(!page_evictable(page, NULL))) {
+		if (unlikely(!page_evictable(page))) {
 			putback_lru_page(page);
 			continue;
 		}
@@ -3406,27 +3406,18 @@ int zone_reclaim(struct zone *zone, gfp_
 /*
  * page_evictable - test whether a page is evictable
  * @page: the page to test
- * @vma: the VMA in which the page is or will be mapped, may be NULL
  *
  * Test whether page is evictable--i.e., should be placed on active/inactive
- * lists vs unevictable list.  The vma argument is !NULL when called from the
- * fault path to determine how to instantate a new page.
+ * lists vs unevictable list.
  *
  * Reasons page might not be evictable:
  * (1) page's mapping marked unevictable
  * (2) page is part of an mlocked VMA
  *
  */
-int page_evictable(struct page *page, struct vm_area_struct *vma)
+int page_evictable(struct page *page)
 {
-
-	if (mapping_unevictable(page_mapping(page)))
-		return 0;
-
-	if (PageMlocked(page) || (vma && mlocked_vma_newpage(vma, page)))
-		return 0;
-
-	return 1;
+	return !mapping_unevictable(page_mapping(page)) && !PageMlocked(page);
 }
 
 #ifdef CONFIG_SHMEM
@@ -3464,7 +3455,7 @@ void check_move_unevictable_pages(struct
 		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
 
-		if (page_evictable(page, NULL)) {
+		if (page_evictable(page)) {
 			enum lru_list lru = page_lru_base_type(page);
 
 			VM_BUG_ON(PageActive(page));
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-remove-vma-arg-from-page_evictable.patch
mm-clear_page_mlock-in-page_remove_rmap.patch
mm-remove-free_page_mlock.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch

