From: akpm@linux-foundation.org
Subject: [folded] signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:34:31 -0700
Message-ID: <200909232234.n8NMYVmY027249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbZIWWek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_signal_stop: do not call tracehook_notify_jctl() in TASK_STOPPED state
has been removed from the -mm tree.  Its filename was
     signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch

This patch was dropped because it was folded into signals-tracehook_notify_jctl-change.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_signal_stop: do not call tracehook_notify_jctl() in TASK_STOPPED state
From: Oleg Nesterov <oleg@redhat.com>

do_signal_stop() can call tracehook_notify_jctl() before decrementing
->group_stop_count and setting TASK_STOPPED/SIGNAL_STOP_STOPPED.

This way the tracing hooks can drop and reacquire the siglock freely and
do any blocking hooks without potential SIGCONT races.

With this patch TASK_STOPPED/SIGNAL_STOP_STOPPED is set only when we know
for sure we are going to schedule() after unlock(siglock).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff -puN kernel/signal.c~signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state kernel/signal.c
--- a/kernel/signal.c~signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state
+++ a/kernel/signal.c
@@ -1664,16 +1664,9 @@ void ptrace_notify(int exit_code)
 static int do_signal_stop(int signr)
 {
 	struct signal_struct *sig = current->signal;
-	int stop_count;
 	int notify;
 
-	if (sig->group_stop_count > 0) {
-		/*
-		 * There is a group stop in progress.  We don't need to
-		 * start another one.
-		 */
-		stop_count = --sig->group_stop_count;
-	} else {
+	if (!sig->group_stop_count) {
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
@@ -1685,7 +1678,7 @@ static int do_signal_stop(int signr)
 		 */
 		sig->group_exit_code = signr;
 
-		stop_count = 0;
+		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current; t = next_thread(t))
 			/*
 			 * Setting state to TASK_STOPPED for a group
@@ -1694,25 +1687,28 @@ static int do_signal_stop(int signr)
 			 */
 			if (!(t->flags & PF_EXITING) &&
 			    !task_is_stopped_or_traced(t)) {
-				stop_count++;
+				sig->group_stop_count++;
 				signal_wake_up(t, 0);
 			}
-		sig->group_stop_count = stop_count;
 	}
-
-	if (stop_count == 0)
-		sig->flags = SIGNAL_STOP_STOPPED;
-	current->exit_code = sig->group_exit_code;
-	__set_current_state(TASK_STOPPED);
-
 	/*
 	 * If there are no other threads in the group, or if there is
-	 * a group stop in progress and we are the last to stop,
-	 * report to the parent.  When ptraced, every thread reports itself.
+	 * a group stop in progress and we are the last to stop, report
+	 * to the parent.  When ptraced, every thread reports itself.
 	 */
-	notify = tracehook_notify_jctl(stop_count == 0 ? CLD_STOPPED : 0,
-				       CLD_STOPPED);
-
+	notify = sig->group_stop_count == 1 ? CLD_STOPPED : 0;
+	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
+	/*
+	 * tracehook_notify_jctl() can drop and reacquire siglock, so
+	 * we keep ->group_stop_count != 0 before the call. If SIGCONT
+	 * or SIGKILL comes in between ->group_stop_count == 0.
+	 */
+	if (sig->group_stop_count) {
+		if (!--sig->group_stop_count)
+			sig->flags = SIGNAL_STOP_STOPPED;
+		current->exit_code = sig->group_exit_code;
+		__set_current_state(TASK_STOPPED);
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 
 	if (notify) {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

