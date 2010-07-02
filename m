From: akpm@linux-foundation.org
Subject: + oom-make-oom_unkillable_task-helper-function.patch added to -mm tree
Date: Fri, 02 Jul 2010 14:50:15 -0700
Message-ID: <201007022150.o62LoG6U028700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340Ab0GBVue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 17:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: make oom_unkillable_task() helper function
has been added to the -mm tree.  Its filename is
     oom-make-oom_unkillable_task-helper-function.patch

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
Subject: oom: make oom_unkillable_task() helper function
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently we have the same task check in two places. Unify it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN mm/oom_kill.c~oom-make-oom_unkillable_task-helper-function mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-oom_unkillable_task-helper-function
+++ a/mm/oom_kill.c
@@ -101,6 +101,26 @@ static struct task_struct *find_lock_tas
 	return NULL;
 }
 
+/* return true if the task is not adequate as candidate victim task. */
+static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
+			   const nodemask_t *nodemask)
+{
+	if (is_global_init(p))
+		return true;
+	if (p->flags & PF_KTHREAD)
+		return true;
+
+	/* When mem_cgroup_out_of_memory() and p is not member of the group */
+	if (mem && !task_in_mem_cgroup(p, mem))
+		return true;
+
+	/* p may not have freeable memory in nodemask */
+	if (!has_intersects_mems_allowed(p, nodemask))
+		return true;
+
+	return false;
+}
+
 /**
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
@@ -295,12 +315,7 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned long points;
 
-		/* skip the init task and kthreads */
-		if (is_global_init(p) || (p->flags & PF_KTHREAD))
-			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
-			continue;
-		if (!has_intersects_mems_allowed(p, nodemask))
+		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
 		/*
@@ -467,11 +482,7 @@ static int oom_kill_process(struct task_
 
 			if (child->mm == p->mm)
 				continue;
-			if (child->flags & PF_KTHREAD)
-				continue;
-			if (mem && !task_in_mem_cgroup(child, mem))
-				continue;
-			if (!has_intersects_mems_allowed(child, nodemask))
+			if (oom_unkillable_task(p, mem, nodemask))
 				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
acpi-fix-unused-function-warning.patch
mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority-fix.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
reiser4.patch

