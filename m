From: akpm@linux-foundation.org
Subject: + ptrace_untrace-fix-the-signal_stop_stopped-check.patch added to -mm tree
Date: Tue, 17 Feb 2009 14:13:34 -0800
Message-ID: <200902172213.n1HMDYei017979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbZBQWVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
has been added to the -mm tree.  Its filename is
     ptrace_untrace-fix-the-signal_stop_stopped-check.patch

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
Subject: ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
From: Oleg Nesterov <oleg@redhat.com>

This bug is ancient too. ptrace_untrace() must not resume the task
if the group stop in progress, we should set TASK_STOPPED instead.

Unfortunately, we still have problems here:

	- if the process/thread was traced, SIGNAL_STOP_STOPPED
	  does not necessary means this thread group is stopped.

	- ptrace breaks the bookkeeping of ->group_stop_count.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/ptrace.c~ptrace_untrace-fix-the-signal_stop_stopped-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_untrace-fix-the-signal_stop_stopped-check
+++ a/kernel/ptrace.c
@@ -60,11 +60,15 @@ static void ptrace_untrace(struct task_s
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
-		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
+		/*
+		 * If the group stop is completed or in progress,
+		 * this thread was already counted as stopped.
+		 */
+		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
+		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
-		} else {
+		else
 			signal_wake_up(child, 1);
-		}
 	}
 	spin_unlock(&child->sighand->siglock);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

