From: akpm@linux-foundation.org
Subject: + oom-kill-remove-boost_dying_task_prio.patch added to -mm tree
Date: Mon, 11 Apr 2011 15:05:21 -0700
Message-ID: <201104112205.p3BM5LTA004019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab1DKWF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 18:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, lclaudio@uudg.org, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     oom-kill: remove boost_dying_task_prio()
has been added to the -mm tree.  Its filename is
     oom-kill-remove-boost_dying_task_prio.patch

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
Subject: oom-kill: remove boost_dying_task_prio()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This is an almost-revert of commit 93b43fa ("oom: give the dying task a
higher priority").

That commit dramatically improved oom killer logic when a fork-bomb
occurs.  But I've found that it has nasty corner case.  Now cpu cgroup has
strange default RT runtime.  It's 0!  That said, if a process under cpu
cgroup promote RT scheduling class, the process never run at all.

Eventually, kernel may hang up when oom kill occur.  I and Luis who
original author agreed to disable this logic at once.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
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

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

