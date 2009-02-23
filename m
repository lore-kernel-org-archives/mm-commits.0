From: akpm@linux-foundation.org
Subject: [to-be-updated] move-exit_ptrace-from-forget_original_parent-to-do_exit.patch removed from -mm tree
Date: Mon, 23 Feb 2009 11:51:31 -0800
Message-ID: <200902231951.n1NJpVFG012328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223AbZBWTx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 14:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     move exit_ptrace() from forget_original_parent() to do_exit()
has been removed from the -mm tree.  Its filename was
     move-exit_ptrace-from-forget_original_parent-to-do_exit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move exit_ptrace() from forget_original_parent() to do_exit()
From: Oleg Nesterov <oleg@redhat.com>

By discussion with Roland.

Call exit_ptrace() from do_exit(), no need to delay this call until
forget_original_parent().

If we ever change exit_ptrace() to do the blocking calls, it makes
sense to move it after exit_signals().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~move-exit_ptrace-from-forget_original_parent-to-do_exit kernel/exit.c
--- a/kernel/exit.c~move-exit_ptrace-from-forget_original_parent-to-do_exit
+++ a/kernel/exit.c
@@ -806,8 +806,6 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
-	exit_ptrace(father);
-
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
@@ -956,6 +954,7 @@ NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	exit_ptrace(tsk);
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
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
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

