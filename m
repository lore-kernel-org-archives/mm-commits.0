From: akpm@linux-foundation.org
Subject: [merged] memcg-reclaim-memory-from-nodes-in-round-robin-order.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:10 -0700
Message-ID: <201105271956.p4RJuFhB017535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051Ab1E0T5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: reclaim memory from nodes in round-robin order
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-memory-from-nodes-in-round-robin-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: reclaim memory from nodes in round-robin order
From: Ying Han <yinghan@google.com>

Presently, memory cgroup's direct reclaim frees memory from the current
node.  But this has some troubles.  Usually when a set of threads works in
a cooperative way, they tend to operate on the same node.  So if they hit
limits under memcg they will reclaim memory from themselves, damaging the
active working set.

For example, assume 2 node system which has Node 0 and Node 1 and a memcg
which has 1G limit.  After some work, file cache remains and the usages
are

   Node 0:  1M
   Node 1:  998M.

and run an application on Node 0, it will eat its foot before freeing
unnecessary file caches.

This patch adds round-robin for NUMA and adds equal pressure to each node.
When using cpuset's spread memory feature, this will work very well.

But yes, a better algorithm is needed.

[akpm@linux-foundation.org: comment editing]
[kamezawa.hiroyu@jp.fujitsu.com: fix time comparisons]
Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol.c            |  102 ++++++++++++++++++++++++++++++++---
 mm/vmscan.c                |   10 +++
 3 files changed, 106 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-reclaim-memory-from-nodes-in-round-robin-order include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-reclaim-memory-from-nodes-in-round-robin-order
+++ a/include/linux/memcontrol.h
@@ -106,6 +106,7 @@ extern void mem_cgroup_end_migration(str
  */
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order
+++ a/mm/memcontrol.c
@@ -231,6 +231,11 @@ struct mem_cgroup {
 	 * reclaimed from.
 	 */
 	int last_scanned_child;
+	int last_scanned_node;
+#if MAX_NUMNODES > 1
+	nodemask_t	scan_nodes;
+	unsigned long   next_scan_node_update;
+#endif
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
@@ -624,18 +629,27 @@ static void mem_cgroup_charge_statistics
 	preempt_enable();
 }
 
+static unsigned long
+mem_cgroup_get_zonestat_node(struct mem_cgroup *mem, int nid, enum lru_list idx)
+{
+	struct mem_cgroup_per_zone *mz;
+	u64 total = 0;
+	int zid;
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		mz = mem_cgroup_zoneinfo(mem, nid, zid);
+		total += MEM_CGROUP_ZSTAT(mz, idx);
+	}
+	return total;
+}
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
 					enum lru_list idx)
 {
-	int nid, zid;
-	struct mem_cgroup_per_zone *mz;
+	int nid;
 	u64 total = 0;
 
 	for_each_online_node(nid)
-		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-			mz = mem_cgroup_zoneinfo(mem, nid, zid);
-			total += MEM_CGROUP_ZSTAT(mz, idx);
-		}
+		total += mem_cgroup_get_zonestat_node(mem, nid, idx);
 	return total;
 }
 
@@ -1418,6 +1432,81 @@ mem_cgroup_select_victim(struct mem_cgro
 	return ret;
 }
 
+#if MAX_NUMNODES > 1
+
+/*
+ * Always updating the nodemask is not very good - even if we have an empty
+ * list or the wrong list here, we can start from some node and traverse all
+ * nodes based on the zonelist. So update the list loosely once per 10 secs.
+ *
+ */
+static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
+{
+	int nid;
+
+	if (time_after(mem->next_scan_node_update, jiffies))
+		return;
+
+	mem->next_scan_node_update = jiffies + 10*HZ;
+	/* make a nodemask where this memcg uses memory from */
+	mem->scan_nodes = node_states[N_HIGH_MEMORY];
+
+	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
+
+		if (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE) ||
+		    mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE))
+			continue;
+
+		if (total_swap_pages &&
+		    (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON) ||
+		     mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON)))
+			continue;
+		node_clear(nid, mem->scan_nodes);
+	}
+}
+
+/*
+ * Selecting a node where we start reclaim from. Because what we need is just
+ * reducing usage counter, start from anywhere is O,K. Considering
+ * memory reclaim from current node, there are pros. and cons.
+ *
+ * Freeing memory from current node means freeing memory from a node which
+ * we'll use or we've used. So, it may make LRU bad. And if several threads
+ * hit limits, it will see a contention on a node. But freeing from remote
+ * node means more costs for memory reclaim because of memory latency.
+ *
+ * Now, we use round-robin. Better algorithm is welcomed.
+ */
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+{
+	int node;
+
+	mem_cgroup_may_update_nodemask(mem);
+	node = mem->last_scanned_node;
+
+	node = next_node(node, mem->scan_nodes);
+	if (node == MAX_NUMNODES)
+		node = first_node(mem->scan_nodes);
+	/*
+	 * We call this when we hit limit, not when pages are added to LRU.
+	 * No LRU may hold pages because all pages are UNEVICTABLE or
+	 * memcg is too small and all pages are not on LRU. In that case,
+	 * we use curret node.
+	 */
+	if (unlikely(node == MAX_NUMNODES))
+		node = numa_node_id();
+
+	mem->last_scanned_node = node;
+	return node;
+}
+
+#else
+int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
+{
+	return 0;
+}
+#endif
+
 /*
  * Scan the hierarchy if needed to reclaim memory. We remember the last child
  * we reclaimed from, so that we don't end up penalizing one child extensively
@@ -4606,6 +4695,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
+	mem->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
diff -puN mm/vmscan.c~memcg-reclaim-memory-from-nodes-in-round-robin-order mm/vmscan.c
--- a/mm/vmscan.c~memcg-reclaim-memory-from-nodes-in-round-robin-order
+++ a/mm/vmscan.c
@@ -2226,6 +2226,7 @@ unsigned long try_to_free_mem_cgroup_pag
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
+	int nid;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -2242,7 +2243,14 @@ unsigned long try_to_free_mem_cgroup_pag
 		.gfp_mask = sc.gfp_mask,
 	};
 
-	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
+	/*
+	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
+	 * take care of from where we get pages. So the node where we start the
+	 * scan does not need to be the current node.
+	 */
+	nid = mem_cgroup_select_victim_node(mem_cont);
+
+	zonelist = NODE_DATA(nid)->node_zonelists;
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

