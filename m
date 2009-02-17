From: akpm@linux-foundation.org
Subject: + ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch added to -mm tree
Date: Tue, 17 Feb 2009 14:13:31 -0800
Message-ID: <200902172213.n1HMDVOC017877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZBQWWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com


The patch titled
     ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic
has been added to the -mm tree.  Its filename is
     ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch

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
Subject: ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic
From: Oleg Nesterov <oleg@redhat.com>

Another ancient bug. Consider this trivial test-case,

	int main(void)
	{
		int pid = fork();

		if (pid) {
			ptrace(PTRACE_ATTACH, pid, NULL, NULL);
			wait(NULL);
			ptrace(PTRACE_DETACH, pid, NULL, NULL);
		} else {
			pause();
			printf("WE HAVE A KERNEL BUG!!!\n");
		}

		return 0;
	}

the child must not "escape" for sys_pause(), but it can and this was seen
in practice.

This is because ptrace_detach does:

	if (!child->exit_state)
		wake_up_process(child);

this wakeup can happen after this child has already restarted sys_pause(),
because it gets another wakeup from ptrace_untrace().

With or without this patch, perhaps sys_pause() needs a fix.  But this
wakeup also breaks the SIGNAL_STOP_STOPPED logic in ptrace_untrace().

Remove this wakeup.  The caller saw this task in TASK_TRACED state, and
unless it was SIGKILL'ed in between __ptrace_unlink()->ptrace_untrace()
should handle this case correctly.  If it was SIGKILL'ed, we don't need to
wakup the dying tracee too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/ptrace.c~ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic
+++ a/kernel/ptrace.c
@@ -301,11 +301,7 @@ int ptrace_detach(struct task_struct *ch
 	 */
 	if (child->ptrace) {
 		child->exit_code = data;
-
 		dead = __ptrace_detach(current, child);
-
-		if (!child->exit_state)
-			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
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

