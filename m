From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-reclaim-memory-from-nodes-in-round-robin.patch removed from -mm tree
Date: Wed, 04 May 2011 14:16:42 -0700
Message-ID: <201105042116.p44LGgLu014761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab1EDVQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 17:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: reclaim memory from nodes in round robin order
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-memory-from-nodes-in-round-robin.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: reclaim memory from nodes in round robin order
From: Ying Han <yinghan@google.com>

Presently, memory cgroup's direct reclaim frees memory from the current
node.  But this has some troubles.  In usual, when a set of threads works
in cooperative way, they are tend to on the same node.  So, if they hit
limits under memcg, it will reclaim memory from themselves, it may be
active working set.

For example, assume 2 node system which has Node 0 and Node 1 and a memcg
which has 1G limit.  After some work, file cacne remains and and usages
are

   Node 0:  1M
   Node 1:  998M.

and run an application on Node 0, it will eats its foot before freeing
unnecessary file caches.

This patch adds round-robin for NUMA and adds equal pressure to each node.
 When using cpuset's spread memory feature, this will work very well.

But yes, better algorithm is appreciated.

Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   25 +++++++++++++++++++++++++
 mm/vmscan.c                |   12 ++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-reclaim-memory-from-nodes-in-round-robin include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-reclaim-memory-from-nodes-in-round-robin
+++ a/include/linux/memcontrol.h
@@ -108,6 +108,7 @@ extern void mem_cgroup_end_migration(str
  */
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin
+++ a/mm/memcontrol.c
@@ -241,6 +241,7 @@ struct mem_cgroup {
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
+	int last_scanned_node;
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
@@ -1492,6 +1493,29 @@ mem_cgroup_select_victim(struct mem_cgro
 }
 
 /*
+ * Selecting a node where we start reclaim from. Because what we need is just
+ * reducing usage counter, start from anywhere is O,K. When considering
+ * memory reclaim from current node, there are pros. and cons.
+ * Freeing memory from current node means freeing memory from a node which
+ * we'll use or we've used. So, it may make LRU bad. And if several threads
+ * hit limits, it will see a contention on a node. But freeing from remote
+ * node mean more costs for memory reclaim because of memory latency.
+ *
+ * Now, we use round-robin. Better algorithm is welcomed.
+ */
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+{
+	int node;
+
+	node = next_node(mem->last_scanned_node, node_states[N_HIGH_MEMORY]);
+	if (node == MAX_NUMNODES)
+		node = first_node(node_states[N_HIGH_MEMORY]);
+
+	mem->last_scanned_node = node;
+	return node;
+}
+
+/*
  * Scan the hierarchy if needed to reclaim memory. We remember the last child
  * we reclaimed from, so that we don't end up penalizing one child extensively
  * based on its position in the children list.
@@ -4708,6 +4732,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
+	mem->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
diff -puN mm/vmscan.c~memcg-reclaim-memory-from-nodes-in-round-robin mm/vmscan.c
--- a/mm/vmscan.c~memcg-reclaim-memory-from-nodes-in-round-robin
+++ a/mm/vmscan.c
@@ -2216,6 +2216,7 @@ unsigned long try_to_free_mem_cgroup_pag
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
+	int nid;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -2224,7 +2225,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
-		.nodemask = NULL, /* we don't care the placement */
+		.nodemask = NULL, /* we don't care about placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 	};
@@ -2232,7 +2233,14 @@ unsigned long try_to_free_mem_cgroup_pag
 		.gfp_mask = sc.gfp_mask,
 	};
 
-	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
+	/*
+	 * Unlike direct reclaim via allo_pages(), memcg's reclaim
+	 * don't take care from where we get free resouce. So, the node where
+	 * we need to start scan is not need to be current node.
+	 */
+	nid = mem_cgroup_select_victim_node(mem_cont);
+
+	zonelist = NODE_DATA(nid)->node_zonelists;
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
_

Patches currently in -mm which might be from yinghan@google.com are

mm-check-pageunevictable-in-lru_deactivate_fn.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch

