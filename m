From: akpm@linux-foundation.org
Subject: [nacked] vmscan-remove-may_swap-scan-control.patch removed from -mm tree
Date: Thu, 13 May 2010 12:12:19 -0700
Message-ID: <201005131912.o4DJCJ4s014664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341Ab0EMTNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 15:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: remove may_swap scan control
has been removed from the -mm tree.  Its filename was
     vmscan-remove-may_swap-scan-control.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: remove may_swap scan control
From: Johannes Weiner <hannes@cmpxchg.org>

The may_swap scan control flag can be naturally merged into the swappiness
parameter: swap only if swappiness is non-zero.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/memcontrol.c      |   13 +++++++++----
 mm/vmscan.c          |   27 +++++++++------------------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff -puN include/linux/swap.h~vmscan-remove-may_swap-scan-control include/linux/swap.h
--- a/include/linux/swap.h~vmscan-remove-may_swap-scan-control
+++ a/include/linux/swap.h
@@ -248,10 +248,10 @@ static inline void lru_cache_add_active_
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-						  gfp_t gfp_mask, bool noswap,
+						  gfp_t gfp_mask,
 						  unsigned int swappiness);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
+						gfp_t gfp_mask,
 						unsigned int swappiness,
 						struct zone *zone,
 						int nid);
diff -puN mm/memcontrol.c~vmscan-remove-may_swap-scan-control mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-remove-may_swap-scan-control
+++ a/mm/memcontrol.c
@@ -1205,6 +1205,8 @@ static int mem_cgroup_hierarchical_recla
 		noswap = true;
 
 	while (1) {
+		unsigned int swappiness;
+
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
@@ -1239,13 +1241,16 @@ static int mem_cgroup_hierarchical_recla
 			continue;
 		}
 		/* we use swappiness of local cgroup */
+		if (noswap)
+			swappiness = 0;
+		else
+			swappiness = get_swappiness(victim);
 		if (check_soft)
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				zone->zone_pgdat->node_id);
+				swappiness, zone, zone->zone_pgdat->node_id);
 		else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
-						noswap, get_swappiness(victim));
+							swappiness);
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -2869,7 +2874,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false, get_swappiness(mem));
+							get_swappiness(mem));
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
diff -puN mm/vmscan.c~vmscan-remove-may_swap-scan-control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-may_swap-scan-control
+++ a/mm/vmscan.c
@@ -65,9 +65,6 @@ struct scan_control {
 
 	int may_writepage;
 
-	/* Can pages be swapped as part of reclaim? */
-	int may_swap;
-
 	int swappiness;
 
 	int order;
@@ -1545,7 +1542,7 @@ static void get_scan_count(struct zone *
 	int noswap = 0;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+	if (!sc->swappiness || (nr_swap_pages <= 0)) {
 		noswap = 1;
 		fraction[0] = 0;
 		fraction[1] = 1;
@@ -1872,7 +1869,6 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.may_swap = 1,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -1885,13 +1881,11 @@ unsigned long try_to_free_pages(struct z
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
-						struct zone *zone, int nid)
+					gfp_t gfp_mask, unsigned int swappiness,
+					struct zone *zone, int nid)
 {
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
-		.may_swap = !noswap,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
@@ -1915,14 +1909,11 @@ unsigned long mem_cgroup_shrink_node_zon
 }
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
-					   gfp_t gfp_mask,
-					   bool noswap,
-					   unsigned int swappiness)
+					gfp_t gfp_mask, unsigned int swappiness)
 {
 	struct zonelist *zonelist;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
-		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1994,7 +1985,6 @@ static unsigned long balance_pgdat(pg_da
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.may_swap = 1,
 		/*
 		 * kswapd doesn't want to be bailed out while reclaim. because
 		 * we want to put equal scanning pressure on each zone.
@@ -2374,7 +2364,6 @@ unsigned long shrink_all_memory(unsigned
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
-		.may_swap = 1,
 		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
@@ -2556,16 +2545,18 @@ static int __zone_reclaim(struct zone *z
 	struct reclaim_state reclaim_state;
 	int priority;
 	struct scan_control sc = {
-		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
-		.swappiness = vm_swappiness,
 		.order = order,
 	};
 	unsigned long slab_reclaimable;
 
+	if (zone_reclaim_mode & RECLAIM_WRITE)
+		sc.may_writepage = 1;
+	if (zone_reclaim_mode & RECLAIM_SWAP)
+		sc.swappiness = vm_swappiness;
+
 	disable_swap_token();
 	cond_resched();
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-document-follow_page.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
vmscan-remove-may_swap-scan-control.patch

