From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-reclaimable-lru-check-in-memcg.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:42:58 -0700
Message-ID: <201107111842.p6BIgTHR025489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab1GKTmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix reclaimable lru check in memcg
has been removed from the -mm tree.  Its filename was
     memcg-fix-reclaimable-lru-check-in-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix reclaimable lru check in memcg
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, in mem_cgroup_hierarchical_reclaim(), mem_cgroup_local_usage() is
used for checking whether the memcg contains reclaimable pages or not.  If
no pages in it, the routine skips it.

But, mem_cgroup_local_usage() contains Unevictable pages and cannot handle
"noswap" condition correctly.  This doesn't work on a swapless system.

This patch adds test_mem_cgroup_reclaimable() and replaces
mem_cgroup_local_usage().  test_mem_cgroup_reclaimable() see LRU counter
and returns correct answer to the caller.  And this new function has
"noswap" argument and can see only FILE LRU if necessary.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix kerneldoc layout]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  107 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 31 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg
+++ a/mm/memcontrol.c
@@ -577,15 +577,6 @@ static long mem_cgroup_read_stat(struct 
 	return val;
 }
 
-static long mem_cgroup_local_usage(struct mem_cgroup *mem)
-{
-	long ret;
-
-	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
-	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
-	return ret;
-}
-
 static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
 					 bool charge)
 {
@@ -1129,7 +1120,6 @@ unsigned long mem_cgroup_zone_nr_lru_pag
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
-#ifdef CONFIG_NUMA
 static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
 							int nid)
 {
@@ -1141,6 +1131,17 @@ static unsigned long mem_cgroup_node_nr_
 	return ret;
 }
 
+static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	unsigned long ret;
+
+	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
+		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
+	return ret;
+}
+
+#if MAX_NUMNODES > 1
 static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
 {
 	u64 total = 0;
@@ -1152,17 +1153,6 @@ static unsigned long mem_cgroup_nr_file_
 	return total;
 }
 
-static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
-							int nid)
-{
-	unsigned long ret;
-
-	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
-		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
-
-	return ret;
-}
-
 static unsigned long mem_cgroup_nr_anon_lru_pages(struct mem_cgroup *memcg)
 {
 	u64 total = 0;
@@ -1559,6 +1549,28 @@ mem_cgroup_select_victim(struct mem_cgro
 	return ret;
 }
 
+/**
+ * test_mem_cgroup_node_reclaimable
+ * @mem: the target memcg
+ * @nid: the node ID to be checked.
+ * @noswap : specify true here if the user wants flle only information.
+ *
+ * This function returns whether the specified memcg contains any
+ * reclaimable pages on a node. Returns true if there are any reclaimable
+ * pages in the node.
+ */
+static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *mem,
+		int nid, bool noswap)
+{
+	if (mem_cgroup_node_nr_file_lru_pages(mem, nid))
+		return true;
+	if (noswap || !total_swap_pages)
+		return false;
+	if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))
+		return true;
+	return false;
+
+}
 #if MAX_NUMNODES > 1
 
 /*
@@ -1580,15 +1592,8 @@ static void mem_cgroup_may_update_nodema
 
 	for_each_node_mask(nid, node_states[N_HIGH_MEMORY]) {
 
-		if (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_FILE) ||
-		    mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_FILE))
-			continue;
-
-		if (total_swap_pages &&
-		    (mem_cgroup_get_zonestat_node(mem, nid, LRU_INACTIVE_ANON) ||
-		     mem_cgroup_get_zonestat_node(mem, nid, LRU_ACTIVE_ANON)))
-			continue;
-		node_clear(nid, mem->scan_nodes);
+		if (!test_mem_cgroup_node_reclaimable(mem, nid, false))
+			node_clear(nid, mem->scan_nodes);
 	}
 }
 
@@ -1627,11 +1632,51 @@ int mem_cgroup_select_victim_node(struct
 	return node;
 }
 
+/*
+ * Check all nodes whether it contains reclaimable pages or not.
+ * For quick scan, we make use of scan_nodes. This will allow us to skip
+ * unused nodes. But scan_nodes is lazily updated and may not cotain
+ * enough new information. We need to do double check.
+ */
+bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	int nid;
+
+	/*
+	 * quick check...making use of scan_node.
+	 * We can skip unused nodes.
+	 */
+	if (!nodes_empty(mem->scan_nodes)) {
+		for (nid = first_node(mem->scan_nodes);
+		     nid < MAX_NUMNODES;
+		     nid = next_node(nid, mem->scan_nodes)) {
+
+			if (test_mem_cgroup_node_reclaimable(mem, nid, noswap))
+				return true;
+		}
+	}
+	/*
+	 * Check rest of nodes.
+	 */
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		if (node_isset(nid, mem->scan_nodes))
+			continue;
+		if (test_mem_cgroup_node_reclaimable(mem, nid, noswap))
+			return true;
+	}
+	return false;
+}
+
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
 	return 0;
 }
+
+bool mem_cgroup_reclaimable(struct mem_cgroup *mem, bool noswap)
+{
+	return test_mem_cgroup_node_reclaimable(mem, 0, noswap);
+}
 #endif
 
 /*
@@ -1702,7 +1747,7 @@ static int mem_cgroup_hierarchical_recla
 				}
 			}
 		}
-		if (!mem_cgroup_local_usage(victim)) {
+		if (!mem_cgroup_reclaimable(victim, noswap)) {
 			/* this cgroup's local usage == 0 */
 			css_put(&victim->css);
 			continue;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-mempolicyc-make-copy_from_user-provably-correct.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
oom-make-deprecated-use-of-oom_adj-more-verbose.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

