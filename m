From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:43:01 -0700
Message-ID: <201107111842.p6BIgWgh025497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125Ab1GKTm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix numa scan information update to be triggered by memory event
has been removed from the -mm tree.  Its filename was
     memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix numa scan information update to be triggered by memory event
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 889976dbcb12 ("memcg: reclaim memory from nodes in round-robin
order") adds an numa node round-robin for memcg.  But the information is
updated once per 10sec.

This patch changes the update trigger from jiffies to memcg's event count.
 After this patch, numa scan information will be updated when we see 1024
events of pagein/pageout under a memcg.

[akpm@linux-foundation.org: attempt to repair code layout]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event
+++ a/mm/memcontrol.c
@@ -108,10 +108,12 @@ enum mem_cgroup_events_index {
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
 	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
 #define THRESHOLDS_EVENTS_TARGET (128)
 #define SOFTLIMIT_EVENTS_TARGET (1024)
+#define NUMAINFO_EVENTS_TARGET	(1024)
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -237,7 +239,8 @@ struct mem_cgroup {
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
 	nodemask_t	scan_nodes;
-	unsigned long   next_scan_node_update;
+	atomic_t	numainfo_events;
+	atomic_t	numainfo_updating;
 #endif
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
@@ -680,6 +683,9 @@ static void __mem_cgroup_target_update(s
 	case MEM_CGROUP_TARGET_SOFTLIMIT:
 		next = val + SOFTLIMIT_EVENTS_TARGET;
 		break;
+	case MEM_CGROUP_TARGET_NUMAINFO:
+		next = val + NUMAINFO_EVENTS_TARGET;
+		break;
 	default:
 		return;
 	}
@@ -698,11 +704,19 @@ static void memcg_check_events(struct me
 		mem_cgroup_threshold(mem);
 		__mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
 		if (unlikely(__memcg_event_check(mem,
-			MEM_CGROUP_TARGET_SOFTLIMIT))){
+			     MEM_CGROUP_TARGET_SOFTLIMIT))) {
 			mem_cgroup_update_tree(mem, page);
 			__mem_cgroup_target_update(mem,
-				MEM_CGROUP_TARGET_SOFTLIMIT);
+						   MEM_CGROUP_TARGET_SOFTLIMIT);
+		}
+#if MAX_NUMNODES > 1
+		if (unlikely(__memcg_event_check(mem,
+			MEM_CGROUP_TARGET_NUMAINFO))) {
+			atomic_inc(&mem->numainfo_events);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_NUMAINFO);
 		}
+#endif
 	}
 }
 
@@ -1582,11 +1596,15 @@ static bool test_mem_cgroup_node_reclaim
 static void mem_cgroup_may_update_nodemask(struct mem_cgroup *mem)
 {
 	int nid;
-
-	if (time_after(mem->next_scan_node_update, jiffies))
+	/*
+	 * numainfo_events > 0 means there was at least NUMAINFO_EVENTS_TARGET
+	 * pagein/pageout changes since the last update.
+	 */
+	if (!atomic_read(&mem->numainfo_events))
+		return;
+	if (atomic_inc_return(&mem->numainfo_updating) > 1)
 		return;
 
-	mem->next_scan_node_update = jiffies + 10*HZ;
 	/* make a nodemask where this memcg uses memory from */
 	mem->scan_nodes = node_states[N_HIGH_MEMORY];
 
@@ -1595,6 +1613,9 @@ static void mem_cgroup_may_update_nodema
 		if (!test_mem_cgroup_node_reclaimable(mem, nid, false))
 			node_clear(nid, mem->scan_nodes);
 	}
+
+	atomic_set(&mem->numainfo_events, 0);
+	atomic_set(&mem->numainfo_updating, 0);
 }
 
 /*
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

