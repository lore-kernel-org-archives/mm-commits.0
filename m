From: akpm@linux-foundation.org
Subject: [merged] oom-kill-remove-boost_dying_task_prio.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:01 -0700
Message-ID: <201104181759.p3IHxCER016127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab1DRR7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 13:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, lclaudio@uudg.org, minchan.kim@gmail.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom-kill: remove boost_dying_task_prio()
has been removed from the -mm tree.  Its filename was
     oom-kill-remove-boost_dying_task_prio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-kill: remove boost_dying_task_prio()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This is an almost-revert of commit 93b43fa ("oom: give the dying task a
higher priority").

That commit dramatically improved oom killer logic when a fork-bomb
occurs.  But I've found that it has nasty corner case.  Now cpu cgroup has
strange default RT runtime.  It's 0!  That said, if a process under cpu
cgroup promote RT scheduling class, the process never run at all.

If an admin inserts a !RT process into a cpu cgroup by setting
rtruntime=0, usually it runs perfectly because a !RT task isn't affected
by the rtruntime knob.  But if it promotes an RT task via an explicit
setscheduler() syscall or an OOM, the task can't run at all.  In short,
the oom killer doesn't work at all if admins are using cpu cgroup and don't
touch the rtruntime knob.

Eventually, kernel may hang up when oom kill occur.  I and the original
author Luis agreed to disable this logic.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN mm/oom_kill.c~oom-kill-remove-boost_dying_task_prio mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-remove-boost_dying_task_prio
+++ a/mm/oom_kill.c
@@ -84,24 +84,6 @@ static bool has_intersects_mems_allowed(
 #endif /* CONFIG_NUMA */
 
 /*
- * If this is a system OOM (not a memcg OOM) and the task selected to be
- * killed is not already running at high (RT) priorities, speed up the
- * recovery by boosting the dying task to the lowest FIFO priority.
- * That helps with the recovery and avoids interfering with RT tasks.
- */
-static void boost_dying_task_prio(struct task_struct *p,
-				  struct mem_cgroup *mem)
-{
-	struct sched_param param = { .sched_priority = 1 };
-
-	if (mem)
-		return;
-
-	if (!rt_task(p))
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-}
-
-/*
  * The process p may have detached its own ->mm while exiting or through
  * use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
@@ -452,13 +434,6 @@ static int oom_kill_task(struct task_str
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
 
-	/*
-	 * We give our sacrificial lamb high priority and access to
-	 * all the memory it needs. That way it should be able to
-	 * exit() and clear out its resources quickly...
-	 */
-	boost_dying_task_prio(p, mem);
-
 	return 0;
 }
 #undef K
@@ -482,7 +457,6 @@ static int oom_kill_process(struct task_
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
-		boost_dying_task_prio(p, mem);
 		return 0;
 	}
 
@@ -556,7 +530,6 @@ void mem_cgroup_out_of_memory(struct mem
 	 */
 	if (fatal_signal_pending(current)) {
 		set_thread_flag(TIF_MEMDIE);
-		boost_dying_task_prio(current, NULL);
 		return;
 	}
 
@@ -712,7 +685,6 @@ void out_of_memory(struct zonelist *zone
 	 */
 	if (fatal_signal_pending(current)) {
 		set_thread_flag(TIF_MEMDIE);
-		boost_dying_task_prio(current, NULL);
 		return;
 	}
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

