From: akpm@linux-foundation.org
Subject: - mm-further-cleanup-page_add_new_anon_rmap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:23 -0800
Message-ID: <200901072212.n07MCNP1012619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226AbZAGWMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: further cleanup page_add_new_anon_rmap
has been removed from the -mm tree.  Its filename was
     mm-further-cleanup-page_add_new_anon_rmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: further cleanup page_add_new_anon_rmap
From: Hugh Dickins <hugh@veritas.com>

Moving lru_cache_add_active_or_unevictable() into page_add_new_anon_rmap()
was good but stupid: we can and should SetPageSwapBacked() there too; and
we know for sure that this anonymous, swap-backed page is not file cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ---
 mm/rmap.c   |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-further-cleanup-page_add_new_anon_rmap mm/memory.c
--- a/mm/memory.c~mm-further-cleanup-page_add_new_anon_rmap
+++ a/mm/memory.c
@@ -1948,7 +1948,6 @@ gotten:
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
-		SetPageSwapBacked(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
@@ -2444,7 +2443,6 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
-	SetPageSwapBacked(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
 
@@ -2592,7 +2590,6 @@ static int __do_fault(struct mm_struct *
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
-			SetPageSwapBacked(page);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
diff -puN mm/rmap.c~mm-further-cleanup-page_add_new_anon_rmap mm/rmap.c
--- a/mm/rmap.c~mm-further-cleanup-page_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -47,7 +47,6 @@
 #include <linux/rmap.h>
 #include <linux/rcupdate.h>
 #include <linux/module.h>
-#include <linux/mm_inline.h>
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
@@ -673,10 +672,11 @@ void page_add_new_anon_rmap(struct page 
 	struct vm_area_struct *vma, unsigned long address)
 {
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-	atomic_set(&page->_mapcount, 0); /* elevate count by 1 (starts at -1) */
+	SetPageSwapBacked(page);
+	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
 	__page_set_anon_rmap(page, vma, address);
 	if (page_evictable(page, vma))
-		lru_cache_add_lru(page, LRU_ACTIVE + page_is_file_cache(page));
+		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
 		add_page_to_unevictable_list(page);
 }
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

