From: akpm@linux-foundation.org
Subject: + mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:03:12 -0700
Message-ID: <20120918210313.250E8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:35313 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2IRVDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:03:16 -0400
Received: by wibhr14 with SMTP id hr14so12657wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:03:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org


The patch titled
     Subject: mm, numa: reclaim from all nodes within reclaim distance
has been added to the -mm tree.  Its filename is
     mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   31 ++++++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mm-numa-reclaim-from-all-nodes-within-reclaim-distance include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-numa-reclaim-from-all-nodes-within-reclaim-distance
+++ a/include/linux/mmzone.h
@@ -704,6 +704,7 @@ typedef struct pglist_data {
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
@@ -1810,6 +1810,11 @@ static void zlc_clear_zones_full(struct 
 	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 }
 
+static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
+{
+	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
+}
+
 #else	/* CONFIG_NUMA */
 
 static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
@@ -1830,6 +1835,11 @@ static void zlc_mark_zone_full(struct zo
 static void zlc_clear_zones_full(struct zonelist *zonelist)
 {
 }
+
+static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
+{
+	return true;
+}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -1914,7 +1924,8 @@ zonelist_scan:
 				did_zlc_setup = 1;
 			}
 
-			if (zone_reclaim_mode == 0)
+			if (zone_reclaim_mode == 0 ||
+			    !zone_allows_reclaim(preferred_zone, zone))
 				goto this_zone_full;
 
 			/*
@@ -3362,21 +3373,13 @@ static void build_zonelists(pg_data_t *p
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
@@ -4549,12 +4552,18 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
+	int i;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
+	for_each_online_node(i)
+		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
+			node_set(i, pgdat->reclaim_nodes);
+			zone_reclaim_mode = 1;
+		}
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
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
oom-remove-deprecated-oom_adj.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-up-zone-present-pages.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch

