From: akpm@linux-foundation.org
Subject: [merged] vmscan-rename-scmay_swap-to-may_unmap.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:19 -0700
Message-ID: <200904011834.n31IYJAu007146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933540AbZDASjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: rename sc.may_swap to may_unmap
has been removed from the -mm tree.  Its filename was
     vmscan-rename-scmay_swap-to-may_unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: rename sc.may_swap to may_unmap
From: Johannes Weiner <hannes@cmpxchg.org>

sc.may_swap does not only influence reclaiming of anon pages but pages
mapped into pagetables in general, which also includes mapped file pages.

In shrink_page_list():

		if (!sc->may_swap && page_mapped(page))
			goto keep_locked;

For anon pages, this makes sense as they are always mapped and reclaiming
them always requires swapping.

But mapped file pages are skipped here as well and it has nothing to do
with swapping.

The real effect of the knob is whether mapped pages are unmapped and
reclaimed or not.  Rename it to `may_unmap' to have its name match its
actual meaning more precisely.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: MinChan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~vmscan-rename-scmay_swap-to-may_unmap mm/vmscan.c
--- a/mm/vmscan.c~vmscan-rename-scmay_swap-to-may_unmap
+++ a/mm/vmscan.c
@@ -60,8 +60,8 @@ struct scan_control {
 
 	int may_writepage;
 
-	/* Can pages be swapped as part of reclaim? */
-	int may_swap;
+	/* Can mapped pages be reclaimed? */
+	int may_unmap;
 
 	/* This context's SWAP_CLUSTER_MAX. If freeing memory for
 	 * suspend, we effectively ignore SWAP_CLUSTER_MAX.
@@ -606,7 +606,7 @@ static unsigned long shrink_page_list(st
 		if (unlikely(!page_evictable(page, NULL)))
 			goto cull_mlocked;
 
-		if (!sc->may_swap && page_mapped(page))
+		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
 
 		/* Double the slab pressure for mapped and swapcache pages */
@@ -1694,7 +1694,7 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
-		.may_swap = 1,
+		.may_unmap = 1,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -1713,7 +1713,7 @@ unsigned long try_to_free_mem_cgroup_pag
 {
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
-		.may_swap = 1,
+		.may_unmap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1723,7 +1723,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist;
 
 	if (noswap)
-		sc.may_swap = 0;
+		sc.may_unmap = 0;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -1762,7 +1762,7 @@ static unsigned long balance_pgdat(pg_da
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.may_swap = 1,
+		.may_unmap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
@@ -2110,7 +2110,7 @@ unsigned long shrink_all_memory(unsigned
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.may_swap = 0,
+		.may_unmap = 0,
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
@@ -2147,7 +2147,7 @@ unsigned long shrink_all_memory(unsigned
 
 		/* Force reclaiming mapped pages in the passes #3 and #4 */
 		if (pass > 2)
-			sc.may_swap = 1;
+			sc.may_unmap = 1;
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
 			unsigned long nr_to_scan = nr_pages - ret;
@@ -2290,7 +2290,7 @@ static int __zone_reclaim(struct zone *z
 	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

