From: akpm@linux-foundation.org
Subject: + oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:41:16 -0700
Message-ID: <201006092141.o59LfGoM023295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758418Ab0FIVmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     oom: sacrifice child with highest badness score for parent fix
has been added to the -mm tree.  Its filename is
     oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch

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
Subject: oom: sacrifice child with highest badness score for parent fix
From: David Rientjes <rientjes@google.com>

Elaborate on the comment in oom_kill_process() so it's clear why a
killable child with a different mm is sacrificied for its parent.

At the same time, rename auto variable `c' to "child" and move "cpoints"
inside the list_for_each_entry() loop with a more descriptive name as akpm
suggests.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN mm/oom_kill.c~oom-sacrifice-child-with-highest-badness-score-for-parent-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-sacrifice-child-with-highest-badness-score-for-parent-fix
+++ a/mm/oom_kill.c
@@ -437,7 +437,7 @@ static int oom_kill_process(struct task_
 			    const char *message)
 {
 	struct task_struct *victim = p;
-	struct task_struct *c;
+	struct task_struct *child;
 	struct task_struct *t = p;
 	unsigned long victim_points = 0;
 	struct timespec uptime;
@@ -459,22 +459,27 @@ static int oom_kill_process(struct task_
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
-	/* Try to sacrifice the worst child first */
+	/*
+	 * If any of p's children has a different mm and is eligible for kill,
+	 * the one with the highest badness() score is sacrificed for its
+	 * parent.  This attempts to lose the minimal amount of work done while
+	 * still freeing memory.
+	 */
 	do_posix_clock_monotonic_gettime(&uptime);
 	do {
-		unsigned long cpoints;
+		list_for_each_entry(child, &t->children, sibling) {
+			unsigned long child_points;
 
-		list_for_each_entry(c, &t->children, sibling) {
-			if (c->mm == p->mm)
+			if (child->mm == p->mm)
 				continue;
-			if (mem && !task_in_mem_cgroup(c, mem))
+			if (mem && !task_in_mem_cgroup(child, mem))
 				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
-			cpoints = badness(c, uptime.tv_sec);
-			if (cpoints > victim_points) {
-				victim = c;
-				victim_points = cpoints;
+			child_points = badness(child, uptime.tv_sec);
+			if (child_points > victim_points) {
+				victim = child;
+				victim_points = child_points;
 			}
 		}
 	} while_each_thread(p, t);
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

