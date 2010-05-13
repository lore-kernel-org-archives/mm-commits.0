From: akpm@linux-foundation.org
Subject: [wrecked] vmscan-remove-may_unmap-scan-control.patch removed from -mm tree
Date: Thu, 13 May 2010 12:40:27 -0700
Message-ID: <201005131940.o4DJeR0V016066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab0EMTlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 15:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: remove may_unmap scan control
has been removed from the -mm tree.  Its filename was
     vmscan-remove-may_unmap-scan-control.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: remove may_unmap scan control
From: Johannes Weiner <hannes@cmpxchg.org>

Every reclaim entry function sets this to the same value.

Make it default behaviour and remove the knob.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/vmscan.c~vmscan-remove-may_unmap-scan-control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-may_unmap-scan-control
+++ a/mm/vmscan.c
@@ -65,9 +65,6 @@ struct scan_control {
 
 	int may_writepage;
 
-	/* Can mapped pages be reclaimed? */
-	int may_unmap;
-
 	/* Can pages be swapped as part of reclaim? */
 	int may_swap;
 
@@ -655,9 +652,6 @@ static unsigned long shrink_page_list(st
 		if (unlikely(!page_evictable(page, NULL)))
 			goto cull_mlocked;
 
-		if (!sc->may_unmap && page_mapped(page))
-			goto keep_locked;
-
 		/* Double the slab pressure for mapped and swapcache pages */
 		if (page_mapped(page) || PageSwapCache(page))
 			sc->nr_scanned++;
@@ -1870,7 +1864,6 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.may_unmap = 1,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
 		.order = order,
@@ -1891,7 +1884,6 @@ unsigned long mem_cgroup_shrink_node_zon
 {
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
-		.may_unmap = 1,
 		.may_swap = !noswap,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1924,7 +1916,6 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
-		.may_unmap = 1,
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
@@ -1998,7 +1989,6 @@ static unsigned long balance_pgdat(pg_da
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.may_unmap = 1,
 		.may_swap = 1,
 		/*
 		 * kswapd doesn't want to be bailed out while reclaim. because
@@ -2381,7 +2371,6 @@ unsigned long shrink_all_memory(unsigned
 	struct scan_control sc = {
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 		.may_swap = 1,
-		.may_unmap = 1,
 		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
@@ -2565,7 +2554,6 @@ static int __zone_reclaim(struct zone *z
 	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = 1,
 		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-document-follow_page.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch

