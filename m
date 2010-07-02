From: akpm@linux-foundation.org
Subject: + oom-multi-threaded-process-coredump-dont-make-deadlock.patch added to -mm tree
Date: Fri, 02 Jul 2010 14:51:00 -0700
Message-ID: <201007022151.o62Lp0im028741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757831Ab0GBVvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 17:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: multi threaded process coredump don't make deadlock
has been added to the -mm tree.  Its filename is
     oom-multi-threaded-process-coredump-dont-make-deadlock.patch

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
Subject: oom: multi threaded process coredump don't make deadlock
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Oleg pointed out current PF_EXITING check is wrong. Because PF_EXITING
is per-thread flag, not per-process flag. He said,

   Two threads, group-leader L and its sub-thread T. T dumps the code.
   In this case both threads have ->mm != NULL, L has PF_EXITING.

   The first problem is, select_bad_process() always return -1 in this
   case (even if the caller is T, this doesn't matter).

   The second problem is that we should add TIF_MEMDIE to T, not L.

I think we can remove this dubious PF_EXITING check. but as first step,
This patch add the protection of multi threaded issue.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-multi-threaded-process-coredump-dont-make-deadlock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-multi-threaded-process-coredump-dont-make-deadlock
+++ a/mm/oom_kill.c
@@ -342,7 +342,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
+		if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
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
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
reiser4.patch

