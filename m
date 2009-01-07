From: akpm@linux-foundation.org
Subject: - badpage-zap-print_bad_pte-on-swap-and-file.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:06 -0800
Message-ID: <200901072214.n07ME6QG014061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761770AbZAGWOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: zap print_bad_pte on swap and file
has been removed from the -mm tree.  Its filename was
     badpage-zap-print_bad_pte-on-swap-and-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: zap print_bad_pte on swap and file
From: Hugh Dickins <hugh@veritas.com>

Complete zap_pte_range()'s coverage of bad pagetable entries by calling
print_bad_pte() on a pte_file in a linear vma and on a bad swap entry. 
That needs free_swap_and_cache() to tell it, which will also have shown
one of those "swap_free" errors (but with much less information).

Similar checks in fork's copy_one_pte()?  No, that would be more noisy
than helpful: we'll see them when parent and child exec or exit.

Where do_nonlinear_fault() calls print_bad_pte(): omit !VM_CAN_NONLINEAR
case, that could only be a bug in sys_remap_file_pages(), not a bad pte. 
VM_FAULT_OOM rather than VM_FAULT_SIGBUS?  Well, okay, that is consistent
with what happens if do_swap_page() operates a bad swap entry; but don't
we have patches to be more careful about killing when VM_FAULT_OOM?

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 +++---------
 mm/memory.c          |   11 +++++++----
 mm/swapfile.c        |    7 ++++---
 3 files changed, 14 insertions(+), 16 deletions(-)

diff -puN include/linux/swap.h~badpage-zap-print_bad_pte-on-swap-and-file include/linux/swap.h
--- a/include/linux/swap.h~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/include/linux/swap.h
@@ -302,7 +302,7 @@ extern swp_entry_t get_swap_page_of_type
 extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
-extern void free_swap_and_cache(swp_entry_t);
+extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
@@ -352,14 +352,8 @@ static inline void show_swap_cache_info(
 {
 }
 
-static inline void free_swap_and_cache(swp_entry_t swp)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
-{
-	return 0;
-}
+#define free_swap_and_cache(swp)	is_migration_entry(swp)
+#define swap_duplicate(swp)		is_migration_entry(swp)
 
 static inline void swap_free(swp_entry_t swp)
 {
diff -puN mm/memory.c~badpage-zap-print_bad_pte-on-swap-and-file mm/memory.c
--- a/mm/memory.c~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/mm/memory.c
@@ -810,8 +810,12 @@ static unsigned long zap_pte_range(struc
 		 */
 		if (unlikely(details))
 			continue;
-		if (!pte_file(ptent))
-			free_swap_and_cache(pte_to_swp_entry(ptent));
+		if (pte_file(ptent)) {
+			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
+				print_bad_pte(vma, addr, ptent, NULL);
+		} else if
+		  (unlikely(!free_swap_and_cache(pte_to_swp_entry(ptent))))
+			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
@@ -2707,8 +2711,7 @@ static int do_nonlinear_fault(struct mm_
 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
 		return 0;
 
-	if (unlikely(!(vma->vm_flags & VM_NONLINEAR) ||
-			!(vma->vm_flags & VM_CAN_NONLINEAR))) {
+	if (unlikely(!(vma->vm_flags & VM_NONLINEAR))) {
 		/*
 		 * Page table corrupted: show pte and kill process.
 		 */
diff -puN mm/swapfile.c~badpage-zap-print_bad_pte-on-swap-and-file mm/swapfile.c
--- a/mm/swapfile.c~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/mm/swapfile.c
@@ -571,13 +571,13 @@ int try_to_free_swap(struct page *page)
  * Free the swap entry like above, but also try to
  * free the page cache entry if it is the last user.
  */
-void free_swap_and_cache(swp_entry_t entry)
+int free_swap_and_cache(swp_entry_t entry)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	struct page *page = NULL;
 
 	if (is_migration_entry(entry))
-		return;
+		return 1;
 
 	p = swap_info_get(entry);
 	if (p) {
@@ -603,6 +603,7 @@ void free_swap_and_cache(swp_entry_t ent
 		unlock_page(page);
 		page_cache_release(page);
 	}
+	return p != NULL;
 }
 
 #ifdef CONFIG_HIBERNATION
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

