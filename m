From: akpm@linux-foundation.org
Subject: + memcg-cpu-hotplug-aware-percpu-count-updates.patch added to -mm tree
Date: Tue, 21 Sep 2010 12:36:40 -0700
Message-ID: <201009211936.o8LJaeig030099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab0IUThU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 15:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: cpu hotplug aware percpu count updates
has been added to the -mm tree.  Its filename is
     memcg-cpu-hotplug-aware-percpu-count-updates.patch

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
Subject: memcg: cpu hotplug aware percpu count updates
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, memcgroup's per cpu coutner uses for_each_possible_cpu() to get the
value.  It's better to use for_each_online_cpu() and a cpu hotplug
handler.

This patch only handles statistics counter.  MEM_CGROUP_ON_MOVE will be
handled in another patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   80 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-cpu-hotplug-aware-percpu-count-updates mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cpu-hotplug-aware-percpu-count-updates
+++ a/mm/memcontrol.c
@@ -89,7 +89,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
+	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
+	/* incremented at every  pagein/pageout */
+	MEM_CGROUP_EVENTS = MEM_CGROUP_STAT_DATA,
 	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
 
 	MEM_CGROUP_STAT_NSTATS,
@@ -255,6 +257,12 @@ struct mem_cgroup {
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu *stat;
+	/*
+	 * used when a cpu is offlined or other synchronizations
+	 * See mem_cgroup_read_stat().
+	 */
+	struct mem_cgroup_stat_cpu nocpu_base;
+	spinlock_t pcp_counter_lock;
 };
 
 /* Stuffs for move charges at task migration. */
@@ -531,14 +539,40 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+/*
+ * Implementation Note: reading percpu statistics for memcg.
+ *
+ * Both of vmstat[] and percpu_counter has threshold and do periodic
+ * synchronization to implement "quick" read. There are trade-off between
+ * reading cost and precision of value. Then, we may have a chance to implement
+ * a periodic synchronizion of counter in memcg's counter.
+ *
+ * But this _read() function is used for user interface now. The user accounts
+ * memory usage by memory cgroup and he _always_ requires exact value because
+ * he accounts memory. Even if we provide quick-and-fuzzy read, we always
+ * have to visit all online cpus and make sum. So, for now, unnecessary
+ * synchronization is not implemented. (just implemented for cpu hotplug)
+ *
+ * If there are kernel internal actions which can make use of some not-exact
+ * value, and reading all cpu value can be performance bottleneck in some
+ * common workload, threashold and synchonization as vmstat[] should be
+ * implemented.
+ */
 static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
 		enum mem_cgroup_stat_index idx)
 {
 	int cpu;
 	s64 val = 0;
 
-	for_each_possible_cpu(cpu)
+	get_online_cpus();
+	for_each_online_cpu(cpu)
 		val += per_cpu(mem->stat->count[idx], cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+	spin_lock(&mem->pcp_counter_lock);
+	val += mem->nocpu_base.count[idx];
+	spin_unlock(&mem->pcp_counter_lock);
+#endif
+	put_online_cpus();
 	return val;
 }
 
@@ -665,6 +699,9 @@ static struct mem_cgroup *mem_cgroup_sta
 {
 	if (mem && css_tryget(&mem->css))
 		return mem;
+	if (!mem)
+		return root_mem_cgroup; /*css_put/get against root is ignored*/
+
 	return NULL;
 }
 
@@ -680,9 +717,13 @@ static struct mem_cgroup *mem_cgroup_get
 	hierarchy_used = iter->use_hierarchy;
 
 	css_put(&iter->css);
-	if (!cond || !hierarchy_used)
+	/* If no ROOT, walk all, ignore hierarchy */
+	if (!cond || (root && !hierarchy_used))
 		return NULL;
 
+	if (!root)
+		root = root_mem_cgroup;
+
 	do {
 		iter = NULL;
 		rcu_read_lock();
@@ -711,6 +752,9 @@ static struct mem_cgroup *mem_cgroup_get
 #define for_each_mem_cgroup_tree(iter, root) \
 	for_each_mem_cgroup_tree_cond(iter, root, true)
 
+#define for_each_mem_cgroup_all(iter) \
+	for_each_mem_cgroup_tree_cond(iter, NULL, true)
+
 
 static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
 {
@@ -1676,15 +1720,38 @@ static void drain_all_stock_sync(void)
 	atomic_dec(&memcg_drain_count);
 }
 
-static int __cpuinit memcg_stock_cpu_callback(struct notifier_block *nb,
+/*
+ * This function drains percpu counter value from DEAD cpu and
+ * move it to local cpu. Note that this function can be preempted.
+ */
+static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *mem, int cpu)
+{
+	int i;
+
+	spin_lock(&mem->pcp_counter_lock);
+	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+		s64 x = per_cpu(mem->stat->count[i], cpu);
+
+		per_cpu(mem->stat->count[i], cpu) = 0;
+		mem->nocpu_base.count[i] += x;
+	}
+	spin_unlock(&mem->pcp_counter_lock);
+}
+
+static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
 					unsigned long action,
 					void *hcpu)
 {
 	int cpu = (unsigned long)hcpu;
 	struct memcg_stock_pcp *stock;
+	struct mem_cgroup *iter;
 
-	if (action != CPU_DEAD)
+	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
+
+	for_each_mem_cgroup_all(iter)
+		mem_cgroup_drain_pcp_counter(iter, cpu);
+
 	stock = &per_cpu(memcg_stock, cpu);
 	drain_stock(stock);
 	return NOTIFY_OK;
@@ -4094,6 +4161,7 @@ static struct mem_cgroup *mem_cgroup_all
 			vfree(mem);
 		mem = NULL;
 	}
+	spin_lock_init(&mem->pcp_counter_lock);
 	return mem;
 }
 
@@ -4220,7 +4288,7 @@ mem_cgroup_create(struct cgroup_subsys *
 						&per_cpu(memcg_stock, cpu);
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
-		hotcpu_notifier(memcg_stock_cpu_callback, 0);
+		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-fix.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-use-for_each_mem_cgroup.patch
memcg-cpu-hotplug-aware-percpu-count-updates.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch

