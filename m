From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-move_account-check.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:52 -0700
Message-ID: <20120322201952.8FA34A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:53 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, paulmck@us.ibm.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify move_account() check
has been removed from the -mm tree.  Its filename was
     memcg-simplify-move_account-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: simplify move_account() check

In memcg, for avoiding take-lock-irq-off at accessing page_cgroup, a
logic, flag + rcu_read_lock(), is used.  This works as following

     CPU-A                     CPU-B
                             rcu_read_lock()
    set flag
                             if(flag is set)
                                   take heavy lock
                             do job.
    synchronize_rcu()        rcu_read_unlock()
    take heavy lock.

In recent discussion, it's argued that using per-cpu value for this flag
just complicates the code because 'set flag' is very rare.

This patch changes 'flag' implementation from percpu to atomic_t.  This
will be much simpler.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   70 +++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-move_account-check mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-move_account-check
+++ a/mm/memcontrol.c
@@ -89,7 +89,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
-	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -298,6 +297,10 @@ struct mem_cgroup {
 	 */
 	unsigned long 	move_charge_at_immigrate;
 	/*
+	 * set > 0 if pages under this cgroup are moving to other cgroup.
+	 */
+	atomic_t	moving_account;
+	/*
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu *stat;
@@ -1287,35 +1290,36 @@ int mem_cgroup_swappiness(struct mem_cgr
 	return memcg->swappiness;
 }
 
+/*
+ * memcg->moving_account is used for checking possibility that some thread is
+ * calling move_account(). When a thread on CPU-A starts moving pages under
+ * a memcg, other threads should check memcg->moving_account under
+ * rcu_read_lock(), like this:
+ *
+ *         CPU-A                                    CPU-B
+ *                                              rcu_read_lock()
+ *         memcg->moving_account+1              if (memcg->mocing_account)
+ *                                                   take heavy locks.
+ *         synchronize_rcu()                    update something.
+ *                                              rcu_read_unlock()
+ *         start move here.
+ */
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
-
+	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
 
 static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 {
-	int cpu;
-
-	if (!memcg)
-		return;
-	get_online_cpus();
-	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
-		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
-	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
-	spin_unlock(&memcg->pcp_counter_lock);
-	put_online_cpus();
+	/*
+	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
+	 * We check NULL in callee rather than caller.
+	 */
+	if (memcg)
+		atomic_dec(&memcg->moving_account);
 }
+
 /*
  * 2 routines for checking "mem" is under move_account() or not.
  *
@@ -1331,7 +1335,7 @@ static void mem_cgroup_end_move(struct m
 static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
-	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
+	return atomic_read(&memcg->moving_account) > 0;
 }
 
 static bool mem_cgroup_under_move(struct mem_cgroup *memcg)
@@ -1882,8 +1886,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
  * by flags.
  *
  * Considering "move", this is an only case we see a race. To make the race
- * small, we check MEM_CGROUP_ON_MOVE percpu value and detect there are
- * possibility of race condition. If there is, we take a lock.
+ * small, we check mm->moving_account and detect there are possibility of race
+ * If there is, we take a lock.
  */
 
 void mem_cgroup_update_page_stat(struct page *page,
@@ -2100,17 +2104,6 @@ static void mem_cgroup_drain_pcp_counter
 		per_cpu(memcg->stat->events[i], cpu) = 0;
 		memcg->nocpu_base.events[i] += x;
 	}
-	/* need to clear ON_MOVE value, works as a kind of lock. */
-	per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
-	spin_unlock(&memcg->pcp_counter_lock);
-}
-
-static void synchronize_mem_cgroup_on_move(struct mem_cgroup *memcg, int cpu)
-{
-	int idx = MEM_CGROUP_ON_MOVE;
-
-	spin_lock(&memcg->pcp_counter_lock);
-	per_cpu(memcg->stat->count[idx], cpu) = memcg->nocpu_base.count[idx];
 	spin_unlock(&memcg->pcp_counter_lock);
 }
 
@@ -2122,11 +2115,8 @@ static int __cpuinit memcg_cpu_hotplug_c
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *iter;
 
-	if ((action == CPU_ONLINE)) {
-		for_each_mem_cgroup(iter)
-			synchronize_mem_cgroup_on_move(iter, cpu);
+	if (action == CPU_ONLINE)
 		return NOTIFY_OK;
-	}
 
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

