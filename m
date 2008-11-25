From: akpm@linux-foundation.org
Subject: + mm-optimize-get_scan_ratio-for-no-swap.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:59 -0800
Message-ID: <200811252216.mAPMG0Ju005929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbYKYWQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:16:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: optimize get_scan_ratio for no swap
has been added to the -mm tree.  Its filename is
     mm-optimize-get_scan_ratio-for-no-swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
 
@@ -294,6 +293,7 @@ extern struct page *swapin_readahead(swp
 			struct vm_area_struct *vma, unsigned long addr);
 
 /* linux/mm/swapfile.c */
+extern long nr_swap_pages;
 extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
@@ -334,7 +334,8 @@ static inline void disable_swap_token(vo
 
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
@@ -1374,12 +1374,6 @@ static void get_scan_ratio(struct zone *
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
@@ -1387,6 +1381,12 @@ static void get_scan_ratio(struct zone *
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

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

