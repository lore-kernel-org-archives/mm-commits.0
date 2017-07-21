From: akpm@linux-foundation.org
Subject: + mm-page_alloc-simplify-zonelist-initialization.patch added to
 -mm tree
Date: Fri, 21 Jul 2017 12:12:15 -0700
Message-ID: <5972520f.gUnfxkA2kU9JllDD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdGUTMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 15:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, shaohua.li@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: simplify zonelist initialization
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-zonelist-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-zonelist-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-zonelist-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, page_alloc: simplify zonelist initialization

build_zonelists gradually builds zonelists from the nearest to the most
distant node.  As we do not know how many populated zones we will have in
each node we rely on the _zoneref to terminate initialized part of the
zonelist by a NULL zone.  While this is functionally correct it is quite
suboptimal because we cannot allow updaters to race with zonelists users
because they could see an empty zonelist and fail the allocation or hit
the OOM killer in the worst case.

We can do much better, though.  We can store the node ordering into an
already existing node_order array and then give this array to
build_zonelists_in_node_order and do the whole initialization at once. 
zonelists consumers still might see halfway initialized state but that
should be much more tolerateable because the list will not be empty and
they would either see some zone twice or skip over some zone(s) in the
worst case which shouldn't lead to immediate failures.

While at it let's simplify build_zonelists_node which is rather confusing
now.  It gets an index into the zoneref array and returns the updated
index for the next iteration.  Let's rename the function to
build_zonerefs_node to better reflect its purpose and give it zoneref
array to update.  The function doesn't the index anymore.  It just returns
the number of added zones so that the caller can advance the zonered array
start for the next update.

This patch alone doesn't introduce any functional change yet, though, it
is merely a preparatory work for later changes.

Link: http://lkml.kernel.org/r/20170721143915.14161-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   81 +++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-simplify-zonelist-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-simplify-zonelist-initialization
+++ a/mm/page_alloc.c
@@ -4772,18 +4772,17 @@ static void zoneref_set_zone(struct zone
  *
  * Add all populated zones of a node to the zonelist.
  */
-static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
-				int nr_zones)
+static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
 {
 	struct zone *zone;
 	enum zone_type zone_type = MAX_NR_ZONES;
+	int nr_zones = 0;
 
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
 		if (managed_zone(zone)) {
-			zoneref_set_zone(zone,
-				&zonelist->_zonerefs[nr_zones++]);
+			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
 	} while (zone_type);
@@ -4913,17 +4912,24 @@ static int find_next_best_node(int node,
  * This results in maximum locality--normal zone overflows into local
  * DMA zone, if any--but risks exhausting DMA zone.
  */
-static void build_zonelists_in_node_order(pg_data_t *pgdat, int node)
+static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
+		unsigned nr_nodes)
 {
-	int j;
-	struct zonelist *zonelist;
+	struct zoneref *zonerefs;
+	int i;
 
-	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
-	for (j = 0; zonelist->_zonerefs[j].zone != NULL; j++)
-		;
-	j = build_zonelists_node(NODE_DATA(node), zonelist, j);
-	zonelist->_zonerefs[j].zone = NULL;
-	zonelist->_zonerefs[j].zone_idx = 0;
+	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
+
+	for (i = 0; i < nr_nodes; i++) {
+		int nr_zones;
+
+		pg_data_t *node = NODE_DATA(node_order[i]);
+
+		nr_zones = build_zonerefs_node(node, zonerefs);
+		zonerefs += nr_zones;
+	}
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
 }
 
 /*
@@ -4931,13 +4937,14 @@ static void build_zonelists_in_node_orde
  */
 static void build_thisnode_zonelists(pg_data_t *pgdat)
 {
-	int j;
-	struct zonelist *zonelist;
+	struct zoneref *zonerefs;
+	int nr_zones;
 
-	zonelist = &pgdat->node_zonelists[ZONELIST_NOFALLBACK];
-	j = build_zonelists_node(pgdat, zonelist, 0);
-	zonelist->_zonerefs[j].zone = NULL;
-	zonelist->_zonerefs[j].zone_idx = 0;
+	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
+	nr_zones = build_zonerefs_node(pgdat, zonerefs);
+	zonerefs += nr_zones;
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
 }
 
 /*
@@ -4946,21 +4953,13 @@ static void build_thisnode_zonelists(pg_
  * exhausted, but results in overflowing to remote node while memory
  * may still exist in local DMA zone.
  */
-static int node_order[MAX_NUMNODES];
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int i, node, load;
+	static int node_order[MAX_NUMNODES];
+	int node, load, nr_nodes = 0;
 	nodemask_t used_mask;
 	int local_node, prev_node;
-	struct zonelist *zonelist;
-
-	/* initialize zonelists */
-	for (i = 0; i < MAX_ZONELISTS; i++) {
-		zonelist = pgdat->node_zonelists + i;
-		zonelist->_zonerefs[0].zone = NULL;
-		zonelist->_zonerefs[0].zone_idx = 0;
-	}
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
@@ -4969,8 +4968,6 @@ static void build_zonelists(pg_data_t *p
 	nodes_clear(used_mask);
 
 	memset(node_order, 0, sizeof(node_order));
-	i = 0;
-
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
@@ -4981,11 +4978,12 @@ static void build_zonelists(pg_data_t *p
 		    node_distance(local_node, prev_node))
 			node_load[node] = load;
 
+		node_order[nr_nodes++] = node;
 		prev_node = node;
 		load--;
-		build_zonelists_in_node_order(pgdat, node);
 	}
 
+	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
 	build_thisnode_zonelists(pgdat);
 }
 
@@ -5014,13 +5012,14 @@ static void setup_min_slab_ratio(void);
 static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
-	enum zone_type j;
-	struct zonelist *zonelist;
+	struct zoneref *zonerefs;
+	int nr_zones;
 
 	local_node = pgdat->node_id;
 
-	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
-	j = build_zonelists_node(pgdat, zonelist, 0);
+	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
+	nr_zones = build_zonerefs_node(pgdat, zonerefs);
+	zonerefs += nr_zones;
 
 	/*
 	 * Now we build the zonelist so that it contains the zones
@@ -5033,16 +5032,18 @@ static void build_zonelists(pg_data_t *p
 	for (node = local_node + 1; node < MAX_NUMNODES; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
+		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
+		zonerefs += nr_zones;
 	}
 	for (node = 0; node < local_node; node++) {
 		if (!node_online(node))
 			continue;
-		j = build_zonelists_node(NODE_DATA(node), zonelist, j);
+		nr_zones = build_zonerefs_node(NODE_DATA(node), zonerefs);
+		zonerefs += nr_zones;
 	}
 
-	zonelist->_zonerefs[j].zone = NULL;
-	zonelist->_zonerefs[j].zone_idx = 0;
+	zonerefs->zone = NULL;
+	zonerefs->zone_idx = 0;
 }
 
 #endif	/* CONFIG_NUMA */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch

