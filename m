From: akpm@linux-foundation.org
Subject: + memcg-use-native-word-page-statistics-counters.patch added to -mm tree
Date: Mon, 08 Nov 2010 15:29:19 -0800
Message-ID: <201011082329.oA8NTJG8016159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab0KHXaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 18:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: use native word page statistics counters
has been added to the -mm tree.  Its filename is
     memcg-use-native-word-page-statistics-counters.patch

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
Subject: memcg: use native word page statistics counters
From: Johannes Weiner <hannes@cmpxchg.org>

The statistic counters are in units of pages, there is no reason to make
them 64-bit wide on 32-bit machines.

Make them native words.  Since they are signed, this leaves 31 bit on
32-bit machines, which can represent roughly 8TB assuming a page size of
4k.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 mm/memcontrol.c            |   43 +++++++++++++++++------------------
 mm/page-writeback.c        |    4 +--
 3 files changed, 24 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-native-word-page-statistics-counters include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-native-word-page-statistics-counters
+++ a/include/linux/memcontrol.h
@@ -157,7 +157,7 @@ static inline void mem_cgroup_dec_page_s
 bool mem_cgroup_has_dirty_limit(void);
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct dirty_info *info);
-s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
+long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
diff -puN mm/memcontrol.c~memcg-use-native-word-page-statistics-counters mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-native-word-page-statistics-counters
+++ a/mm/memcontrol.c
@@ -110,7 +110,7 @@ enum {
 };
 
 struct mem_cgroup_stat_cpu {
-	s64 count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
 };
 
@@ -583,11 +583,11 @@ mem_cgroup_largest_soft_limit_node(struc
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
 
 	for_each_online_cpu(cpu)
 		val += per_cpu(mem->stat->count[idx], cpu);
@@ -599,9 +599,9 @@ static s64 mem_cgroup_read_stat(struct m
 	return val;
 }
 
-static s64 mem_cgroup_local_usage(struct mem_cgroup *mem)
+static long mem_cgroup_local_usage(struct mem_cgroup *mem)
 {
-	s64 ret;
+	long ret;
 
 	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
 	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
@@ -1244,7 +1244,7 @@ bool mem_cgroup_dirty_info(unsigned long
 	struct vm_dirty_param dirty_param;
 	unsigned long available_mem;
 	struct mem_cgroup *memcg;
-	s64 value;
+	long value;
 
 	if (mem_cgroup_disabled())
 		return false;
@@ -1301,10 +1301,10 @@ static inline bool mem_cgroup_can_swap(s
 		(res_counter_read_u64(&memcg->memsw, RES_LIMIT) > 0);
 }
 
-static s64 mem_cgroup_local_page_stat(struct mem_cgroup *mem,
-				      enum mem_cgroup_nr_pages_item item)
+static long mem_cgroup_local_page_stat(struct mem_cgroup *mem,
+				       enum mem_cgroup_nr_pages_item item)
 {
-	s64 ret;
+	long ret;
 
 	switch (item) {
 	case MEMCG_NR_DIRTYABLE_PAGES:
@@ -1365,11 +1365,11 @@ memcg_hierarchical_free_pages(struct mem
  * Return the accounted statistic value or negative value if current task is
  * root cgroup.
  */
-s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
 {
-	struct mem_cgroup *mem;
 	struct mem_cgroup *iter;
-	s64 value;
+	struct mem_cgroup *mem;
+	long value;
 
 	get_online_cpus();
 	rcu_read_lock();
@@ -2069,7 +2069,7 @@ static void mem_cgroup_drain_pcp_counter
 
 	spin_lock(&mem->pcp_counter_lock);
 	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
-		s64 x = per_cpu(mem->stat->count[i], cpu);
+		long x = per_cpu(mem->stat->count[i], cpu);
 
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
@@ -3660,13 +3660,13 @@ static int mem_cgroup_hierarchy_write(st
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
 
@@ -3686,12 +3686,11 @@ static inline u64 mem_cgroup_usage(struc
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
diff -puN mm/page-writeback.c~memcg-use-native-word-page-statistics-counters mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-use-native-word-page-statistics-counters
+++ a/mm/page-writeback.c
@@ -133,10 +133,10 @@ static struct prop_descriptor vm_dirties
 
 static unsigned long dirty_writeback_pages(void)
 {
-	s64 ret;
+	unsigned long ret;
 
 	ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
-	if (ret < 0)
+	if ((long)ret < 0)
 		ret = global_page_state(NR_UNSTABLE_NFS) +
 			global_page_state(NR_WRITEBACK);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch

