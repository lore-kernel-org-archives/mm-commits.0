From: akpm@linux-foundation.org
Subject: - mm-add-add_to_swap-stub.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:53 -0800
Message-ID: <200901072212.n07MCrvA013044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760273AbZAGWOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add add_to_swap stub
has been removed from the -mm tree.  Its filename was
     mm-add-add_to_swap-stub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add add_to_swap stub
From: Hugh Dickins <hugh@veritas.com>

If we add a failing stub for add_to_swap(), then we can remove the #ifdef
CONFIG_SWAP from mm/vmscan.c.

This was intended as a source cleanup, but looking more closely, it turns
out that the !CONFIG_SWAP case was going to keep_locked for an anonymous
page, whereas now it goes to the more suitable activate_locked, like the
CONFIG_SWAP nr_swap_pages 0 case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/vmscan.c          |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-add-add_to_swap-stub include/linux/swap.h
--- a/include/linux/swap.h~mm-add-add_to_swap-stub
+++ a/include/linux/swap.h
@@ -371,6 +371,11 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
+static inline int add_to_swap(struct page *page)
+{
+	return 0;
+}
+
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 							gfp_t gfp_mask)
 {
diff -puN mm/vmscan.c~mm-add-add_to_swap-stub mm/vmscan.c
--- a/mm/vmscan.c~mm-add-add_to_swap-stub
+++ a/mm/vmscan.c
@@ -617,7 +617,6 @@ static unsigned long shrink_page_list(st
 					referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
-#ifdef CONFIG_SWAP
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
@@ -629,7 +628,6 @@ static unsigned long shrink_page_list(st
 				goto activate_locked;
 			may_enter_fs = 1;
 		}
-#endif /* CONFIG_SWAP */
 
 		mapping = page_mapping(page);
 
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

