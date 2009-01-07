From: akpm@linux-foundation.org
Subject: - mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:59 -0800
Message-ID: <200901072214.n07MEx5a014827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761940AbZAGWPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, npiggin@suse.de, wassim.dagash@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: stop kswapd's infinite loop at high order allocation
has been removed from the -mm tree.  Its filename was
     mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: stop kswapd's infinite loop at high order allocation
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Wassim Dagash reported following kswapd infinite loop problem.

  kswapd runs in some infinite loop trying to swap until order 10 of zone
  highmem is OK.... kswapd will continue to try to balance order 10 of zone
  highmem forever (or until someone release a very large chunk of highmem).

For non order-0 allocations, the system may never be balanced due to
fragmentation but kswapd should not infinitely loop as a result.

Instead, recheck all watermarks at order-0 as they are the most important.
If watermarks are ok, kswapd will go back to sleep.

[akpm@linux-foundation.org: fix comment]
Reported-by: wassim dagash <wassim.dagash@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN mm/vmscan.c~mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2 mm/vmscan.c
--- a/mm/vmscan.c~mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2
+++ a/mm/vmscan.c
@@ -1867,6 +1867,23 @@ out:
 
 		try_to_freeze();
 
+		/*
+		 * Fragmentation may mean that the system cannot be
+		 * rebalanced for high-order allocations in all zones.
+		 * At this point, if nr_reclaimed < SWAP_CLUSTER_MAX,
+		 * it means the zones have been fully scanned and are still
+		 * not balanced. For high-order allocations, there is
+		 * little point trying all over again as kswapd may
+		 * infinite loop.
+		 *
+		 * Instead, recheck all watermarks at order-0 as they
+		 * are the most important. If watermarks are ok, kswapd will go
+		 * back to sleep. High-order users can still perform direct
+		 * reclaim if they wish.
+		 */
+		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
+			order = sc.order = 0;
+
 		goto loop_again;
 	}
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
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
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

