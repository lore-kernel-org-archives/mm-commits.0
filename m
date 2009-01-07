From: akpm@linux-foundation.org
Subject: - mm-wp-lock-page-before-deciding-cow.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:36 -0800
Message-ID: <200901072212.n07MCaHl012764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226AbZAGWM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: wp lock page before deciding cow
has been removed from the -mm tree.  Its filename was
     mm-wp-lock-page-before-deciding-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: wp lock page before deciding cow
From: Hugh Dickins <hugh@veritas.com>

An application may rely on get_user_pages() to give it pages writable from
userspace and shared with a driver, GUP breaking COW if necessary.  It may
mprotect() the pages' writability, off and on, from time to time.

Normally this works fine (so long as the app does not fork); but just
occasionally, under memory pressure, a readonly pte in a newly writable
area is COWed unnecessarily, breaking the link with the driver: because
do_wp_page() does trylock_page, and falls back to COW whenever that fails.

For reliable behaviour in the unshared case, when the trylock_page fails,
now unlock pagetable, lock page and relock pagetable, before deciding
whether Copy-On-Write is really necessary.

Reported-by: Zhou Yingchao
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-wp-lock-page-before-deciding-cow mm/memory.c
--- a/mm/memory.c~mm-wp-lock-page-before-deciding-cow
+++ a/mm/memory.c
@@ -1848,10 +1848,21 @@ static int do_wp_page(struct mm_struct *
 	 * not dirty accountable.
 	 */
 	if (PageAnon(old_page)) {
-		if (trylock_page(old_page)) {
-			reuse = can_share_swap_page(old_page);
-			unlock_page(old_page);
+		if (!trylock_page(old_page)) {
+			page_cache_get(old_page);
+			pte_unmap_unlock(page_table, ptl);
+			lock_page(old_page);
+			page_table = pte_offset_map_lock(mm, pmd, address,
+							 &ptl);
+			if (!pte_same(*page_table, orig_pte)) {
+				unlock_page(old_page);
+				page_cache_release(old_page);
+				goto unlock;
+			}
+			page_cache_release(old_page);
 		}
+		reuse = can_share_swap_page(old_page);
+		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
 		/*
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

