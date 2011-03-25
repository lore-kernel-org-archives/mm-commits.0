From: akpm@linux-foundation.org
Subject: [merged] memcg-use-native-word-page-statistics-counters.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:07 -0700
Message-ID: <201103250725.p2P7P192025990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933929Ab1CYHZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: use native word page statistics counters
has been removed from the -mm tree.  Its filename was
     memcg-use-native-word-page-statistics-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use native word page statistics counters
From: Johannes Weiner <hannes@cmpxchg.org>

The statistic counters are in units of pages, there is no reason to make
them 64-bit wide on 32-bit machines.

Make them native words.  Since they are signed, this leaves 31 bit on
32-bit machines, which can represent roughly 8TB assuming a page size of
4k.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   88 ++++++++++++++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 29 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-native-word-page-statistics-counters mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-native-word-page-statistics-counters
+++ a/mm/memcontrol.c
@@ -73,15 +73,6 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
-/*
- * Per memcg event counter is incremented at every pagein/pageout. This counter
- * is used for trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- *
- * These values will be used as !((event) & ((1 <<(thresh)) - 1))
- */
-#define THRESHOLDS_EVENTS_THRESH (7) /* once in 128 */
-#define SOFTLIMIT_EVENTS_THRESH (10) /* once in 1024 */
 
 /*
  * Statistics for memory cgroup.
@@ -105,10 +96,24 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremated by the number of pages. This counter is used for
+ * for trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_NTARGETS,
+};
+#define THRESHOLDS_EVENTS_TARGET (128)
+#define SOFTLIMIT_EVENTS_TARGET (1024)
 
 struct mem_cgroup_stat_cpu {
-	s64 count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
+	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
 /*
@@ -546,11 +551,11 @@ mem_cgroup_largest_soft_limit_node(struc
  * common workload, threashold and synchonization as vmstat[] should be
  * implemented.
  */
-static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
-		enum mem_cgroup_stat_index idx)
+static long mem_cgroup_read_stat(struct mem_cgroup *mem,
+				 enum mem_cgroup_stat_index idx)
 {
+	long val = 0;
 	int cpu;
-	s64 val = 0;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
@@ -564,9 +569,9 @@ static s64 mem_cgroup_read_stat(struct m
 	return val;
 }
 
-static s64 mem_cgroup_local_usage(struct mem_cgroup *mem)
+static long mem_cgroup_local_usage(struct mem_cgroup *mem)
 {
-	s64 ret;
+	long ret;
 
 	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
 	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
@@ -634,13 +639,34 @@ static unsigned long mem_cgroup_get_loca
 	return total;
 }
 
-static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
+static bool __memcg_event_check(struct mem_cgroup *mem, int target)
+{
+	unsigned long val, next;
+
+	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	next = this_cpu_read(mem->stat->targets[target]);
+	/* from time_after() in jiffies.h */
+	return ((long)next - (long)val < 0);
+}
+
+static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
 {
-	unsigned long val;
+	unsigned long val, next;
 
 	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
-	return !(val & ((1 << event_mask_shift) - 1));
+	switch (target) {
+	case MEM_CGROUP_TARGET_THRESH:
+		next = val + THRESHOLDS_EVENTS_TARGET;
+		break;
+	case MEM_CGROUP_TARGET_SOFTLIMIT:
+		next = val + SOFTLIMIT_EVENTS_TARGET;
+		break;
+	default:
+		return;
+	}
+
+	this_cpu_write(mem->stat->targets[target], next);
 }
 
 /*
@@ -650,10 +676,15 @@ static bool __memcg_event_check(struct m
 static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
 {
 	/* threshold event is triggered in finer grain than soft limit */
-	if (unlikely(__memcg_event_check(mem, THRESHOLDS_EVENTS_THRESH))) {
+	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
 		mem_cgroup_threshold(mem);
-		if (unlikely(__memcg_event_check(mem, SOFTLIMIT_EVENTS_THRESH)))
+		__mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
+		if (unlikely(__memcg_event_check(mem,
+			MEM_CGROUP_TARGET_SOFTLIMIT))){
 			mem_cgroup_update_tree(mem, page);
+			__mem_cgroup_target_update(mem,
+				MEM_CGROUP_TARGET_SOFTLIMIT);
+		}
 	}
 }
 
@@ -1787,7 +1818,7 @@ static void mem_cgroup_drain_pcp_counter
 
 	spin_lock(&mem->pcp_counter_lock);
 	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
-		s64 x = per_cpu(mem->stat->count[i], cpu);
+		long x = per_cpu(mem->stat->count[i], cpu);
 
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
@@ -3499,13 +3530,13 @@ static int mem_cgroup_hierarchy_write(st
 }
 
 
-static u64 mem_cgroup_get_recursive_idx_stat(struct mem_cgroup *mem,
-				enum mem_cgroup_stat_index idx)
+static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *mem,
+					       enum mem_cgroup_stat_index idx)
 {
 	struct mem_cgroup *iter;
-	s64 val = 0;
+	long val = 0;
 
-	/* each per cpu's value can be minus.Then, use s64 */
+	/* Per-cpu values can be negative, use a signed accumulator */
 	for_each_mem_cgroup_tree(iter, mem)
 		val += mem_cgroup_read_stat(iter, idx);
 
@@ -3525,12 +3556,11 @@ static inline u64 mem_cgroup_usage(struc
 			return res_counter_read_u64(&mem->memsw, RES_USAGE);
 	}
 
-	val = mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_CACHE);
-	val += mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_RSS);
+	val = mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_CACHE);
+	val += mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_RSS);
 
 	if (swap)
-		val += mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_SWAPOUT);
+		val += mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 
 	return val << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

