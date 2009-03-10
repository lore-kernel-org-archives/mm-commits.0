From: akpm@linux-foundation.org
Subject: [merged] copy_process-fix-clone_parent-parent_exec_id-interaction.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:33 -0700
Message-ID: <200903101826.n2AIQXD5022642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbZCJS2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:28:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_process: fix CLONE_PARENT && parent_exec_id interaction
has been removed from the -mm tree.  Its filename was
     copy_process-fix-clone_parent-parent_exec_id-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_process: fix CLONE_PARENT && parent_exec_id interaction
From: Oleg Nesterov <oleg@redhat.com>

CLONE_PARENT can fool the ->self_exec_id/parent_exec_id logic.  If we
re-use the old parent, we must also re-use ->parent_exec_id to make
sure exit_notify() sees the right ->xxx_exec_id's when the
CLONE_PARENT'ed task exits.

Also, move down the "p->parent_exec_id = p->self_exec_id" thing, to
place two different cases together.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~copy_process-fix-clone_parent-parent_exec_id-interaction kernel/fork.c
--- a/kernel/fork.c~copy_process-fix-clone_parent-parent_exec_id-interaction
+++ a/kernel/fork.c
@@ -1182,10 +1182,6 @@ static struct task_struct *copy_process(
 #endif
 	clear_all_latency_tracing(p);
 
-	/* Our parent execution domain becomes current domain
-	   These must match for thread signalling to apply */
-	p->parent_exec_id = p->self_exec_id;
-
 	/* ok, now we should be set up.. */
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
@@ -1223,10 +1219,13 @@ static struct task_struct *copy_process(
 		set_task_cpu(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
-	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
+	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
-	else
+		p->parent_exec_id = current->parent_exec_id;
+	} else {
 		p->real_parent = current;
+		p->parent_exec_id = current->self_exec_id;
+	}
 
 	spin_lock(&current->sighand->siglock);
 
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
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

