From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-do-not-cache-reclaim-distances.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:45 -0700
Message-ID: <5390c9d9.j70TLxAYLJTyN2CH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mhocko@suse.cz, hannes@cmpxchg.org, cl@linux.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-do-not-cache-reclaim-distances.patch removed from -mm tree
To: mgorman@suse.de,cl@linux.com,hannes@cmpxchg.org,mhocko@suse.cz,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:45 -0700


The patch titled
     Subject: mm: page_alloc: do not cache reclaim distances
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-cache-reclaim-distances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: do not cache reclaim distances

pgdat->reclaim_nodes tracks if a remote node is allowed to be reclaimed by
zone_reclaim due to its distance. As it is expected that zone_reclaim_mode
will be rarely enabled it is unreasonable for all machines to take a penalty.
Fortunately, the zone_reclaim_mode() path is already slow and it is the path
that takes the hit.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/page_alloc.c        |   17 ++---------------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-do-not-cache-reclaim-distances include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-do-not-cache-reclaim-distances
+++ a/include/linux/mmzone.h
@@ -763,7 +763,6 @@ typedef struct pglist_data {
 	unsigned long node_spanned_pages; /* total size of physical page
 					     range, including holes */
 	int node_id;
-	nodemask_t reclaim_nodes;	/* Nodes allowed to reclaim from */
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
diff -puN mm/page_alloc.c~mm-page_alloc-do-not-cache-reclaim-distances mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-cache-reclaim-distances
+++ a/mm/page_alloc.c
@@ -1850,16 +1850,8 @@ static bool zone_local(struct zone *loca
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
-	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
-}
-
-static void __paginginit init_zone_allows_reclaim(int nid)
-{
-	int i;
-
-	for_each_node_state(i, N_MEMORY)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
-			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <
+				RECLAIM_DISTANCE;
 }
 
 #else	/* CONFIG_NUMA */
@@ -1893,9 +1885,6 @@ static bool zone_allows_reclaim(struct z
 	return true;
 }
 
-static inline void init_zone_allows_reclaim(int nid)
-{
-}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -4933,8 +4922,6 @@ void __paginginit free_area_init_node(in
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	if (node_state(nid, N_MEMORY))
-		init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

