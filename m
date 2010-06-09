From: akpm@linux-foundation.org
Subject: + oom-improve-commentary-in-dump_tasks.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:41:09 -0700
Message-ID: <201006092141.o59Lf92B023283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758418Ab0FIVmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, akpm@linux-foundation.org, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     oom: improve commentary in dump_tasks()
has been added to the -mm tree.  Its filename is
     oom-improve-commentary-in-dump_tasks.patch

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
Subject: oom: improve commentary in dump_tasks()
From: David Rientjes <rientjes@google.com>

The comments in dump_tasks() should be updated to be more clear about why
tasks are filtered and how they are filtered by its argument.

An unnecessary comment concerning a check for is_global_init() is removed
since it isn't of importance.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-improve-commentary-in-dump_tasks mm/oom_kill.c
--- a/mm/oom_kill.c~oom-improve-commentary-in-dump_tasks
+++ a/mm/oom_kill.c
@@ -323,7 +323,7 @@ static struct task_struct *select_bad_pr
 
 /**
  * dump_tasks - dump current memory state of all system tasks
- * @mem: target memory controller
+ * @mem: current's memory controller, if constrained
  *
  * Dumps the current memory state of all system tasks, excluding kernel threads.
  * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
@@ -342,11 +342,6 @@ static void dump_tasks(const struct mem_
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
 	for_each_process(p) {
-		/*
-		 * We don't have is_global_init() check here, because the old
-		 * code do that. printing init process is not big matter. But
-		 * we don't hope to make unnecessary compatibility breaking.
-		 */
 		if (p->flags & PF_KTHREAD)
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
@@ -355,8 +350,8 @@ static void dump_tasks(const struct mem_
 		task = find_lock_task_mm(p);
 		if (!task) {
 			/*
-			 * Probably oom vs task-exiting race was happen and ->mm
-			 * have been detached. thus there's no need to report
+			 * This is a kthread or all of p's threads have already
+			 * detached their mm's.  There's no need to report
 			 * them; they can't be oom killed anyway.
 			 */
 			continue;
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
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
oom-remove-unnecessary-code-and-cleanup.patch

