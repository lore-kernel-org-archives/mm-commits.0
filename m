From: akpm@linux-foundation.org
Subject: + memcg-memory-cgroup-cpu-hotplug-support-update.patch added to -mm tree
Date: Thu, 16 Sep 2010 13:14:49 -0700
Message-ID: <201009162014.o8GKEnws011358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131Ab0IPUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: memory cgroup cpu hotplug support update
has been added to the -mm tree.  Its filename is
     memcg-memory-cgroup-cpu-hotplug-support-update.patch

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
Subject: memcg: memory cgroup cpu hotplug support update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, memory cgroup uses for_each_possible_cpu() for percpu stat handling. 
It's just because cpu hotplug handler doesn't handle them.  On the other
hand, per-cpu usage counter cache is maintained per cpu and it's cpu
hotplug aware.

This patch adds a cpu hotplug hanlder and replaces for_each_possible_cpu()
with for_each_online_cpu().  And this merges new callbacks with old
callbacks.(IOW, memcg has only one cpu-hotplug handler.)

For this purpose, mem_cgroup_walk_all() is added.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  118 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 98 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~memcg-memory-cgroup-cpu-hotplug-support-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memory-cgroup-cpu-hotplug-support-update
+++ a/mm/memcontrol.c
@@ -89,7 +89,10 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_EVENTS,	/* incremented at every  pagein/pageout */
+	MEM_CGROUP_STAT_DATA,    /* stat above this is for statistics */
+
+	MEM_CGROUP_EVENTS = MEM_CGROUP_STAT_DATA,
+				/* incremented at every  pagein/pageout */
 	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
 
 	MEM_CGROUP_STAT_NSTATS,
@@ -537,7 +540,7 @@ static s64 mem_cgroup_read_stat(struct m
 	int cpu;
 	s64 val = 0;
 
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		val += per_cpu(mem->stat->count[idx], cpu);
 	return val;
 }
@@ -700,6 +703,35 @@ static inline bool mem_cgroup_is_root(st
 	return (mem == root_mem_cgroup);
 }
 
+static int mem_cgroup_walk_all(void *data,
+		int (*func)(struct mem_cgroup *, void *))
+{
+	int found, ret, nextid;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *mem;
+
+	nextid = 1;
+	do {
+		ret = 0;
+		mem = NULL;
+
+		rcu_read_lock();
+		css = css_get_next(&mem_cgroup_subsys, nextid,
+				&root_mem_cgroup->css, &found);
+		if (css && css_tryget(css))
+			mem = container_of(css, struct mem_cgroup, css);
+		rcu_read_unlock();
+
+		if (mem) {
+			ret = (*func)(mem, data);
+			css_put(&mem->css);
+		}
+		nextid = found + 1;
+	} while (!ret && css);
+
+	return ret;
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -1056,11 +1088,12 @@ static void mem_cgroup_start_move(struct
 {
 	int cpu;
 	/* Because this is for moving account, reuse mc.lock */
+	get_online_cpus();
 	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
 	spin_unlock(&mc.lock);
-
+	put_online_cpus();
 	synchronize_rcu();
 }
 
@@ -1070,10 +1103,12 @@ static void mem_cgroup_end_move(struct m
 
 	if (!mem)
 		return;
+	get_online_cpus();
 	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
 	spin_unlock(&mc.lock);
+	put_online_cpus();
 }
 /*
  * 2 routines for checking "mem" is under move_account() or not.
@@ -1673,20 +1708,6 @@ static void drain_all_stock_sync(void)
 	atomic_dec(&memcg_drain_count);
 }
 
-static int __cpuinit memcg_stock_cpu_callback(struct notifier_block *nb,
-					unsigned long action,
-					void *hcpu)
-{
-	int cpu = (unsigned long)hcpu;
-	struct memcg_stock_pcp *stock;
-
-	if (action != CPU_DEAD)
-		return NOTIFY_OK;
-	stock = &per_cpu(memcg_stock, cpu);
-	drain_stock(stock);
-	return NOTIFY_OK;
-}
-
 
 /* See __mem_cgroup_try_charge() for details */
 enum {
@@ -3465,6 +3486,7 @@ static int mem_cgroup_get_local_stat(str
 	s64 val;
 
 	/* per cpu stat */
+	get_online_cpus();
 	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
@@ -3479,6 +3501,7 @@ static int mem_cgroup_get_local_stat(str
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
+	put_online_cpus();
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
@@ -3508,7 +3531,9 @@ static int mem_control_stat_show(struct 
 	int i;
 
 	memset(&mystat, 0, sizeof(mystat));
+	get_online_cpus();
 	mem_cgroup_get_local_stat(mem_cont, &mystat);
+	put_online_cpus();
 
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
@@ -3526,7 +3551,9 @@ static int mem_control_stat_show(struct 
 	}
 
 	memset(&mystat, 0, sizeof(mystat));
+	get_online_cpus();
 	mem_cgroup_get_total_stat(mem_cont, &mystat);
+	put_online_cpus();
 	for (i = 0; i < NR_MCS_STAT; i++) {
 		if (i == MCS_SWAP && !do_swap_account)
 			continue;
@@ -4036,6 +4063,57 @@ static int register_memsw_files(struct c
 }
 #endif
 
+/*
+ * CPU Hotplug handling.
+ */
+static int synchronize_move_stat(struct mem_cgroup *mem, void *data)
+{
+	long cpu = (long)data;
+	s64 x = this_cpu_read(mem->stat->count[MEM_CGROUP_ON_MOVE]);
+	/* All cpus should have the same value */
+	per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) = x;
+	return 0;
+}
+
+static int drain_all_percpu(struct mem_cgroup *mem, void *data)
+{
+	long cpu = (long)(data);
+	int i;
+	/* Drain data from dying cpu and move to local cpu */
+	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+		s64 data = per_cpu(mem->stat->count[i], cpu);
+		per_cpu(mem->stat->count[i], cpu) = 0;
+		this_cpu_add(mem->stat->count[i], data);
+	}
+	/* Reset Move Count */
+	per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
+	return 0;
+}
+
+static int __cpuinit memcg_cpuhotplug_callback(struct notifier_block *nb,
+					unsigned long action,
+					void *hcpu)
+{
+	long cpu = (unsigned long)hcpu;
+	struct memcg_stock_pcp *stock;
+
+	if (action == CPU_ONLINE) {
+		mem_cgroup_walk_all((void *)cpu, synchronize_move_stat);
+		return NOTIFY_OK;
+	}
+	if ((action != CPU_DEAD) || (action != CPU_DEAD_FROZEN))
+		return NOTIFY_OK;
+
+	/* Drain counters...for all memcgs. */
+	mem_cgroup_walk_all((void *)cpu, drain_all_percpu);
+
+	/* Drain Cached resources */
+	stock = &per_cpu(memcg_stock, cpu);
+	drain_stock(stock);
+
+	return NOTIFY_OK;
+}
+
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -4224,7 +4302,7 @@ mem_cgroup_create(struct cgroup_subsys *
 						&per_cpu(memcg_stock, cpu);
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
-		hotcpu_notifier(memcg_stock_cpu_callback, 0);
+		hotcpu_notifier(memcg_cpuhotplug_callback, 0);
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-memory-cgroup-cpu-hotplug-support-update.patch

