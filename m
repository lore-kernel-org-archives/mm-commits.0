From: akpm@linux-foundation.org
Subject: + oom-fold-__out_of_memory-into-out_of_memory.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:29:43 -0700
Message-ID: <201006112029.o5BKThHr017831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760439Ab0FKUjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: fold __out_of_memory into out_of_memory
has been added to the -mm tree.  Its filename is
     oom-fold-__out_of_memory-into-out_of_memory.patch

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
Subject: oom: fold __out_of_memory into out_of_memory
From: David Rientjes <rientjes@google.com>

__out_of_memory() only has a single caller, so fold it into
out_of_memory() and add a comment about locking for its call to
oom_kill_process().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   65 +++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff -puN mm/oom_kill.c~oom-fold-__out_of_memory-into-out_of_memory mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fold-__out_of_memory-into-out_of_memory
+++ a/mm/oom_kill.c
@@ -628,41 +628,6 @@ static void clear_system_oom(void)
 	spin_unlock(&zone_scan_lock);
 }
 
-
-/*
- * Must be called with tasklist_lock held for read.
- */
-static void __out_of_memory(gfp_t gfp_mask, int order, const nodemask_t *mask)
-{
-	struct task_struct *p;
-	unsigned long points;
-
-	if (sysctl_oom_kill_allocating_task)
-		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)"))
-			return;
-retry:
-	/*
-	 * Rambo mode: Shoot down a process and hope it solves whatever
-	 * issues we may have.
-	 */
-	p = select_bad_process(&points, NULL, mask);
-
-	if (PTR_ERR(p) == -1UL)
-		return;
-
-	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!p) {
-		dump_header(NULL, gfp_mask, order, NULL);
-		read_unlock(&tasklist_lock);
-		panic("Out of memory and no killable processes...\n");
-	}
-
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
-			     "Out of memory"))
-		goto retry;
-}
-
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
@@ -678,7 +643,9 @@ retry:
 void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *nodemask)
 {
+	struct task_struct *p;
 	unsigned long freed = 0;
+	unsigned long points;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
@@ -703,10 +670,36 @@ void out_of_memory(struct zonelist *zone
 	if (zonelist)
 		constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	check_panic_on_oom(constraint, gfp_mask, order);
+
 	read_lock(&tasklist_lock);
-	__out_of_memory(gfp_mask, order,
+	if (sysctl_oom_kill_allocating_task) {
+		/*
+		 * oom_kill_process() needs tasklist_lock held.  If it returns
+		 * non-zero, current could not be killed so we must fallback to
+		 * the tasklist scan.
+		 */
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
+				"Out of memory (oom_kill_allocating_task)"))
+			return;
+	}
+
+retry:
+	p = select_bad_process(&points, NULL,
 			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
 								 NULL);
+	if (PTR_ERR(p) == -1UL)
+		return;
+
+	/* Found nothing?!?! Either we hang forever, or we panic. */
+	if (!p) {
+		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
+		panic("Out of memory and no killable processes...\n");
+	}
+
+	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+			     "Out of memory"))
+		goto retry;
 	read_unlock(&tasklist_lock);
 
 	/*
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
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch

