From: akpm@linux-foundation.org
Subject: + memcg-fix-reclaimable-lru-check-in-memcg.patch added to -mm tree
Date: Tue, 28 Jun 2011 17:15:36 -0700
Message-ID: <201106290015.p5T0FaCP016717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab1F2APz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 20:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg: fix reclaimable lru check in memcg
has been added to the -mm tree.  Its filename is
     memcg-fix-reclaimable-lru-check-in-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   83 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 19 deletions(-)

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
@@ -1559,6 +1550,27 @@ mem_cgroup_select_victim(struct mem_cgro
 	return ret;
 }
 
+/** test_mem_cgroup_node_reclaimable
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
+        if (noswap || !total_swap_pages)
+                return false;
+        if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))
+                return true;
+        return false;
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
+ 	 * Check rest of nodes.
+ 	 */
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

memcg-fix-reclaimable-lru-check-in-memcg.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

