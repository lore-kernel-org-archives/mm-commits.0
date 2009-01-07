From: akpm@linux-foundation.org
Subject: - swapfile-remove-swp_active-mask.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:15 -0800
Message-ID: <200901072213.n07MDFca013346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264AbZAGWNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     swapfile: remove SWP_ACTIVE mask
has been removed from the -mm tree.  Its filename was
     swapfile-remove-swp_active-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: remove SWP_ACTIVE mask
From: Hugh Dickins <hugh@veritas.com>

Remove the SWP_ACTIVE mask: it just obscures the SWP_WRITEOK flag.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/swapfile.c        |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~swapfile-remove-swp_active-mask include/linux/swap.h
--- a/include/linux/swap.h~swapfile-remove-swp_active-mask
+++ a/include/linux/swap.h
@@ -120,7 +120,6 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_ACTIVE	= (SWP_USED | SWP_WRITEOK),
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
diff -puN mm/swapfile.c~swapfile-remove-swp_active-mask mm/swapfile.c
--- a/mm/swapfile.c~swapfile-remove-swp_active-mask
+++ a/mm/swapfile.c
@@ -1222,7 +1222,7 @@ asmlinkage long sys_swapoff(const char _
 	spin_lock(&swap_lock);
 	for (type = swap_list.head; type >= 0; type = swap_info[type].next) {
 		p = swap_info + type;
-		if ((p->flags & SWP_ACTIVE) == SWP_ACTIVE) {
+		if (p->flags & SWP_WRITEOK) {
 			if (p->swap_file->f_mapping == mapping)
 				break;
 		}
@@ -1674,7 +1674,7 @@ asmlinkage long sys_swapon(const char __
 	else
 		p->prio = --least_priority;
 	p->swap_map = swap_map;
-	p->flags = SWP_ACTIVE;
+	p->flags |= SWP_WRITEOK;
 	nr_swap_pages += nr_good_pages;
 	total_swap_pages += nr_good_pages;
 
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

