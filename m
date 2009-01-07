From: akpm@linux-foundation.org
Subject: - badpage-remove-vma-from-page_remove_rmap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:09 -0800
Message-ID: <200901072214.n07ME9Y0014112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761634AbZAGWO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: remove vma from page_remove_rmap
has been removed from the -mm tree.  Its filename was
     badpage-remove-vma-from-page_remove_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: remove vma from page_remove_rmap
From: Hugh Dickins <hugh@veritas.com>

Remove page_remove_rmap()'s vma arg, which was only for the Eeek message. 
And remove the BUG_ON(page_mapcount(page) == 0) from CONFIG_DEBUG_VM's
page_dup_rmap(): we're trying to be more resilient about that than BUGs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/fremap.c          |    2 +-
 mm/memory.c          |    4 ++--
 mm/rmap.c            |    8 +++-----
 5 files changed, 8 insertions(+), 10 deletions(-)

diff -puN include/linux/rmap.h~badpage-remove-vma-from-page_remove_rmap include/linux/rmap.h
--- a/include/linux/rmap.h~badpage-remove-vma-from-page_remove_rmap
+++ a/include/linux/rmap.h
@@ -69,7 +69,7 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
-void page_remove_rmap(struct page *, struct vm_area_struct *);
+void page_remove_rmap(struct page *);
 
 #ifdef CONFIG_DEBUG_VM
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
diff -puN mm/filemap_xip.c~badpage-remove-vma-from-page_remove_rmap mm/filemap_xip.c
--- a/mm/filemap_xip.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/filemap_xip.c
@@ -193,7 +193,7 @@ retry:
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			dec_mm_counter(mm, file_rss);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
diff -puN mm/fremap.c~badpage-remove-vma-from-page_remove_rmap mm/fremap.c
--- a/mm/fremap.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/fremap.c
@@ -37,7 +37,7 @@ static void zap_pte(struct mm_struct *mm
 		if (page) {
 			if (pte_dirty(pte))
 				set_page_dirty(page);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
 			dec_mm_counter(mm, file_rss);
diff -puN mm/memory.c~badpage-remove-vma-from-page_remove_rmap mm/memory.c
--- a/mm/memory.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/memory.c
@@ -798,7 +798,7 @@ static unsigned long zap_pte_range(struc
 					mark_page_accessed(page);
 				file_rss--;
 			}
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			tlb_remove_page(tlb, page);
@@ -2023,7 +2023,7 @@ gotten:
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, vma);
+			page_remove_rmap(old_page);
 		}
 
 		/* Free the old page.. */
diff -puN mm/rmap.c~badpage-remove-vma-from-page_remove_rmap mm/rmap.c
--- a/mm/rmap.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/rmap.c
@@ -707,7 +707,6 @@ void page_add_file_rmap(struct page *pag
  */
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
 {
-	BUG_ON(page_mapcount(page) == 0);
 	if (PageAnon(page))
 		__page_check_anon_rmap(page, vma, address);
 	atomic_inc(&page->_mapcount);
@@ -717,11 +716,10 @@ void page_dup_rmap(struct page *page, st
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
- * @vma: the vm area in which the mapping is removed
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page, struct vm_area_struct *vma)
+void page_remove_rmap(struct page *page)
 {
 	if (atomic_add_negative(-1, &page->_mapcount)) {
 		/*
@@ -837,7 +835,7 @@ static int try_to_unmap_one(struct page 
 		dec_mm_counter(mm, file_rss);
 
 
-	page_remove_rmap(page, vma);
+	page_remove_rmap(page);
 	page_cache_release(page);
 
 out_unmap:
@@ -952,7 +950,7 @@ static int try_to_unmap_cluster(unsigned
 		if (pte_dirty(pteval))
 			set_page_dirty(page);
 
-		page_remove_rmap(page, vma);
+		page_remove_rmap(page);
 		page_cache_release(page);
 		dec_mm_counter(mm, file_rss);
 		(*mapcount)--;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

