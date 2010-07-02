From: akpm@linux-foundation.org
Subject: + oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch added to -mm tree
Date: Fri, 02 Jul 2010 14:50:19 -0700
Message-ID: <201007022150.o62LoJV6028708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726Ab0GBVug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 17:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: /proc/<pid>/oom_score treat kernel thread honestly
has been added to the -mm tree.  Its filename is
     oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch

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
Subject: oom: /proc/<pid>/oom_score treat kernel thread honestly
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If a kernel thread is using use_mm(), badness() returns a positive value. 
This is not a big issue because caller take care of it correctly.  But
there is one exception, /proc/<pid>/oom_score calls badness() directly and
doesn't care that the task is a regular process.

Another example, /proc/1/oom_score return !0 value.  But it's unkillable. 
This incorrectness makes administration a little confusing.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +++--
 mm/oom_kill.c  |   13 +++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~oom-proc-pid-oom_score-treat-kernel-thread-honestly fs/proc/base.c
--- a/fs/proc/base.c~oom-proc-pid-oom_score-treat-kernel-thread-honestly
+++ a/fs/proc/base.c
@@ -428,7 +428,8 @@ static const struct file_operations proc
 #endif
 
 /* The badness from the OOM killer */
-unsigned long badness(struct task_struct *p, unsigned long uptime);
+unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
+		      nodemask_t *nodemask, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points = 0;
@@ -437,7 +438,7 @@ static int proc_oom_score(struct task_st
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
-		points = badness(task, uptime.tv_sec);
+		points = badness(task, NULL, NULL, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff -puN mm/oom_kill.c~oom-proc-pid-oom_score-treat-kernel-thread-honestly mm/oom_kill.c
--- a/mm/oom_kill.c~oom-proc-pid-oom_score-treat-kernel-thread-honestly
+++ a/mm/oom_kill.c
@@ -139,8 +139,8 @@ static bool oom_unkillable_task(struct t
  *    algorithm has been meticulously tuned to meet the principle
  *    of least surprise ... (be careful when you change it)
  */
-
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
+		      const nodemask_t *nodemask, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct task_struct *child;
@@ -150,6 +150,8 @@ unsigned long badness(struct task_struct
 	unsigned long utime;
 	unsigned long stime;
 
+	if (oom_unkillable_task(p, mem, nodemask))
+		return 0;
 	if (oom_adj == OOM_DISABLE)
 		return 0;
 
@@ -351,7 +353,7 @@ static struct task_struct *select_bad_pr
 		if (p->signal->oom_adj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec);
+		points = badness(p, mem, nodemask, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -482,11 +484,10 @@ static int oom_kill_process(struct task_
 
 			if (child->mm == p->mm)
 				continue;
-			if (oom_unkillable_task(p, mem, nodemask))
-				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
-			child_points = badness(child, uptime.tv_sec);
+			child_points = badness(child, mem, nodemask,
+					       uptime.tv_sec);
 			if (child_points > victim_points) {
 				victim = child;
 				victim_points = child_points;
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

