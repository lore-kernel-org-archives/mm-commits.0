From: akpm@linux-foundation.org
Subject: + memcg-cpu-hotplug-aware-quick-acount_move-detection.patch added to -mm tree
Date: Tue, 21 Sep 2010 12:36:42 -0700
Message-ID: <201009211936.o8LJagKI030102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756676Ab0IUThW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 15:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: cpu hotplug aware quick acount_move detection
has been added to the -mm tree.  Its filename is
     memcg-cpu-hotplug-aware-quick-acount_move-detection.patch

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
Subject: memcg: cpu hotplug aware quick acount_move detection
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

An event counter MEM_CGROUP_ON_MOVE is used for quick check whether file
stat update can be done in async manner or not.  Now, it use percpu
counter and for_each_possible_cpu to update.

This patch replaces for_each_possible_cpu to for_each_online_cpu and adds
necessary synchronization logic at CPU HOTPLUG.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-cpu-hotplug-aware-quick-acount_move-detection mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cpu-hotplug-aware-quick-acount_move-detection
+++ a/mm/memcontrol.c
@@ -1116,11 +1116,14 @@ static unsigned int get_swappiness(struc
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
 {
 	int cpu;
-	/* Because this is for moving account, reuse mc.lock */
-	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+
+	get_online_cpus();
+	spin_lock(&mem->pcp_counter_lock);
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
-	spin_unlock(&mc.lock);
+	mem->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
+	spin_unlock(&mem->pcp_counter_lock);
+	put_online_cpus();
 
 	synchronize_rcu();
 }
@@ -1131,10 +1134,13 @@ static void mem_cgroup_end_move(struct m
 
 	if (!mem)
 		return;
-	spin_lock(&mc.lock);
-	for_each_possible_cpu(cpu)
+	get_online_cpus();
+	spin_lock(&mem->pcp_counter_lock);
+	for_each_online_cpu(cpu)
 		per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) -= 1;
-	spin_unlock(&mc.lock);
+	mem->nocpu_base.count[MEM_CGROUP_ON_MOVE] -= 1;
+	spin_unlock(&mem->pcp_counter_lock);
+	put_online_cpus();
 }
 /*
  * 2 routines for checking "mem" is under move_account() or not.
@@ -1735,6 +1741,17 @@ static void mem_cgroup_drain_pcp_counter
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
 	}
+	/* need to clear ON_MOVE value, works as a kind of lock. */
+	per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE],cpu) = 0;
+	spin_unlock(&mem->pcp_counter_lock);
+}
+
+static void synchronize_mem_cgroup_on_move(struct mem_cgroup *mem, int cpu)
+{
+	int idx = MEM_CGROUP_ON_MOVE;
+
+	spin_lock(&mem->pcp_counter_lock);
+	per_cpu(mem->stat->count[idx],cpu) = mem->nocpu_base.count[idx];
 	spin_unlock(&mem->pcp_counter_lock);
 }
 
@@ -1746,6 +1763,12 @@ static int __cpuinit memcg_cpu_hotplug_c
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *iter;
 
+	if ((action == CPU_ONLINE)) {
+		for_each_mem_cgroup_all(iter)
+			synchronize_mem_cgroup_on_move(iter, cpu);
+		return NOTIFY_OK;
+	}
+
 	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
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

