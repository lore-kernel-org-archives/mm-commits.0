From: akpm@linux-foundation.org
Subject: [merged] mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:49 -0700
Message-ID: <20121009181349.DE6EB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39481 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2JISNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:50 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574501yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, numa: reclaim from all nodes within reclaim distance
has been removed from the -mm tree.  Its filename was
     mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, numa: reclaim from all nodes within reclaim distance

RECLAIM_DISTANCE represents the distance between nodes at which it is
deemed too costly to allocate from; it's preferred to try to reclaim from
a local zone before falling back to allocating on a remote node with such
a distance.

To do this, zone_reclaim_mode is set if the distance between any two
nodes on the system is greather than this distance.  This, however, ends
up causing the page allocator to reclaim from every zone regardless of
its affinity.

What we really want is to reclaim only from zones that are closer than
RECLAIM_DISTANCE.  This patch adds a nodemask to each node that
represents the set of nodes that are within this distance.  During the
zone iteration, if the bit for a zone's node is set for the local node,
then reclaim is attempted; otherwise, the zone is skipped.

[akpm@linux-foundation.org: fix CONFIG_NUMA=n build]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |   41 ++++++++++++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mm-numa-reclaim-from-all-nodes-within-reclaim-distance include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-numa-reclaim-from-all-nodes-within-reclaim-distance
+++ a/include/linux/mmzone.h
@@ -709,6 +709,7 @@ typedef struct pglist_data {
 	unsigned long node_spanned_pages; /* total size of physical page
 					     range, including holes */
 	int node_id;
+	nodemask_t reclaim_nodes;	/* Nodes allowed to reclaim from */
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
diff -puN mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance mm/page_alloc.c
--- a/mm/page_alloc.c~mm-numa-reclaim-from-all-nodes-within-reclaim-distance
+++ a/mm/page_alloc.c
@@ -1799,6 +1799,22 @@ static void zlc_clear_zones_full(struct 
 	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 }
 
+static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
+{
+	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
+}
+
+static void __paginginit init_zone_allows_reclaim(int nid)
+{
+	int i;
+
+	for_each_online_node(i)
+		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
+			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+			zone_reclaim_mode = 1;
+		}
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1819,6 +1835,15 @@ static void zlc_mark_zone_full(struct zo
 static void zlc_clear_zones_full(struct zonelist *zonelist)
 {
 }
+
+static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
+{
+	return true;
+}
+
+static inline void init_zone_allows_reclaim(int nid)
+{
+}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -1903,7 +1928,8 @@ zonelist_scan:
 				did_zlc_setup = 1;
 			}
 
-			if (zone_reclaim_mode == 0)
+			if (zone_reclaim_mode == 0 ||
+			    !zone_allows_reclaim(preferred_zone, zone))
 				goto this_zone_full;
 
 			/*
@@ -3364,21 +3390,13 @@ static void build_zonelists(pg_data_t *p
 	j = 0;
 
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
-		int distance = node_distance(local_node, node);
-
-		/*
-		 * If another node is sufficiently far away then it is better
-		 * to reclaim pages in a zone before going off node.
-		 */
-		if (distance > RECLAIM_DISTANCE)
-			zone_reclaim_mode = 1;
-
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (distance != node_distance(local_node, prev_node))
+		if (node_distance(local_node, node) !=
+		    node_distance(local_node, prev_node))
 			node_load[node] = load;
 
 		prev_node = node;
@@ -4552,6 +4570,7 @@ void __paginginit free_area_init_node(in
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
+	init_zone_allows_reclaim(nid);
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

