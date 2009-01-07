From: akpm@linux-foundation.org
Subject: - mm-remove-gfp_mask-from-add_to_swap.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:51 -0800
Message-ID: <200901072212.n07MCpkW013009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759150AbZAGWOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove gfp_mask from add_to_swap
has been removed from the -mm tree.  Its filename was
     mm-remove-gfp_mask-from-add_to_swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove gfp_mask from add_to_swap
From: Hugh Dickins <hugh@veritas.com>

Remove gfp_mask argument from add_to_swap(): it's misleading because its
only caller, shrink_page_list(), is not atomic at that point; and in due
course (implementing discard) we'll sometimes want to allocate some memory
with GFP_NOIO (as is used in swap_writepage) when allocating swap.

No change to the gfp_mask passed down to add_to_swap_cache(): still use
__GFP_HIGH without __GFP_WAIT (with nomemalloc and nowarn as before):
though it's not obvious if that's the best combination to ask for here.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap_state.c      |    4 ++--
 mm/vmscan.c          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-remove-gfp_mask-from-add_to_swap include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-gfp_mask-from-add_to_swap
+++ a/include/linux/swap.h
@@ -278,7 +278,7 @@ extern void end_swap_bio_read(struct bio
 extern struct address_space swapper_space;
 #define total_swapcache_pages  swapper_space.nrpages
 extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *, gfp_t);
+extern int add_to_swap(struct page *);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
diff -puN mm/swap_state.c~mm-remove-gfp_mask-from-add_to_swap mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-gfp_mask-from-add_to_swap
+++ a/mm/swap_state.c
@@ -128,7 +128,7 @@ void __delete_from_swap_cache(struct pag
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
  */
-int add_to_swap(struct page * page, gfp_t gfp_mask)
+int add_to_swap(struct page *page)
 {
 	swp_entry_t entry;
 	int err;
@@ -153,7 +153,7 @@ int add_to_swap(struct page * page, gfp_
 		 * Add it to the swap cache and mark it dirty
 		 */
 		err = add_to_swap_cache(page, entry,
-				gfp_mask|__GFP_NOMEMALLOC|__GFP_NOWARN);
+				__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
 
 		switch (err) {
 		case 0:				/* Success */
diff -puN mm/vmscan.c~mm-remove-gfp_mask-from-add_to_swap mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-gfp_mask-from-add_to_swap
+++ a/mm/vmscan.c
@@ -625,7 +625,7 @@ static unsigned long shrink_page_list(st
 		if (PageAnon(page) && !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			if (!add_to_swap(page, GFP_ATOMIC))
+			if (!add_to_swap(page))
 				goto activate_locked;
 			may_enter_fs = 1;
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

