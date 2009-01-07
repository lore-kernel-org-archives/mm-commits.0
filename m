From: akpm@linux-foundation.org
Subject: - mm-optimize-get_scan_ratio-for-no-swap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:55 -0800
Message-ID: <200901072212.n07MCt0u013047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757954AbZAGWNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: optimize get_scan_ratio for no swap
has been removed from the -mm tree.  Its filename was
     mm-optimize-get_scan_ratio-for-no-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: optimize get_scan_ratio for no swap
From: Hugh Dickins <hugh@veritas.com>

Rik suggests a simplified get_scan_ratio() for !CONFIG_SWAP.  Yes, the gcc
optimizer gives us that, when nr_swap_pages is #defined as 0L.  Move usual
declaration to swapfile.c: it never belonged in page_alloc.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/page_alloc.c      |    1 -
 mm/swapfile.c        |    1 +
 mm/vmscan.c          |   12 ++++++------
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~mm-optimize-get_scan_ratio-for-no-swap include/linux/swap.h
--- a/include/linux/swap.h~mm-optimize-get_scan_ratio-for-no-swap
+++ a/include/linux/swap.h
@@ -163,7 +163,6 @@ struct swap_list_t {
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
-extern long nr_swap_pages;
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
@@ -291,6 +290,7 @@ extern struct page *swapin_readahead(swp
 			struct vm_area_struct *vma, unsigned long addr);
 
 /* linux/mm/swapfile.c */
+extern long nr_swap_pages;
 extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
@@ -331,7 +331,8 @@ static inline void disable_swap_token(vo
 
 #else /* CONFIG_SWAP */
 
-#define total_swap_pages			0
+#define nr_swap_pages				0L
+#define total_swap_pages			0L
 #define total_swapcache_pages			0UL
 
 #define si_swapinfo(val) \
diff -puN mm/page_alloc.c~mm-optimize-get_scan_ratio-for-no-swap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-optimize-get_scan_ratio-for-no-swap
+++ a/mm/page_alloc.c
@@ -69,7 +69,6 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
-long nr_swap_pages;
 int percpu_pagelist_fraction;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
diff -puN mm/swapfile.c~mm-optimize-get_scan_ratio-for-no-swap mm/swapfile.c
--- a/mm/swapfile.c~mm-optimize-get_scan_ratio-for-no-swap
+++ a/mm/swapfile.c
@@ -35,6 +35,7 @@
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
+long nr_swap_pages;
 long total_swap_pages;
 static int swap_overflow;
 static int least_priority;
diff -puN mm/vmscan.c~mm-optimize-get_scan_ratio-for-no-swap mm/vmscan.c
--- a/mm/vmscan.c~mm-optimize-get_scan_ratio-for-no-swap
+++ a/mm/vmscan.c
@@ -1327,12 +1327,6 @@ static void get_scan_ratio(struct zone *
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
 
-	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
-		zone_page_state(zone, NR_INACTIVE_ANON);
-	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
-		zone_page_state(zone, NR_INACTIVE_FILE);
-	free  = zone_page_state(zone, NR_FREE_PAGES);
-
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (nr_swap_pages <= 0) {
 		percent[0] = 0;
@@ -1340,6 +1334,12 @@ static void get_scan_ratio(struct zone *
 		return;
 	}
 
+	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
+		zone_page_state(zone, NR_INACTIVE_ANON);
+	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
+		zone_page_state(zone, NR_INACTIVE_FILE);
+	free  = zone_page_state(zone, NR_FREE_PAGES);
+
 	/* If we have very few page cache pages, force-scan anon pages. */
 	if (unlikely(file + free <= zone->pages_high)) {
 		percent[0] = 100;
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

