From: akpm@linux-foundation.org
Subject: - ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:41 -0700
Message-ID: <200807182324.m6INOfvF004224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbYGRX2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     ptrace: fix dangling zombie when new parent ignores children
has been removed from the -mm tree.  Its filename was
     ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: fix dangling zombie when new parent ignores children
From: Roland McGrath <roland@redhat.com>

This fixes an arcane bug that we think was a regression introduced by
commit b2b2cbc4b2a2f389442549399a993a8306420baf.  When a parent ignores
SIGCHLD (or uses SA_NOCLDWAIT), its children would self-reap but they
don't if it's using ptrace on them.  When the parent thread later exits
and ceases to ptrace a child but leaves other live threads in the parent's
thread group, any zombie children are left dangling.  The fix makes them
self-reap then, as they would have done earlier if ptrace had not been in
use.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN kernel/exit.c~ptrace-fix-dangling-zombie-when-new-parent-ignores-children kernel/exit.c
--- a/kernel/exit.c~ptrace-fix-dangling-zombie-when-new-parent-ignores-children
+++ a/kernel/exit.c
@@ -698,6 +698,23 @@ static void exit_mm(struct task_struct *
 }
 
 /*
+ * Return nonzero if @parent's children should reap themselves.
+ *
+ * Called with write_lock_irq(&tasklist_lock) held.
+ */
+static int ignoring_children(struct task_struct *parent)
+{
+	int ret;
+	struct sighand_struct *psig = parent->sighand;
+	unsigned long flags;
+	spin_lock_irqsave(&psig->siglock, flags);
+	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
+	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
+	spin_unlock_irqrestore(&psig->siglock, flags);
+	return ret;
+}
+
+/*
  * Detach all tasks we were using ptrace on.
  * Any that need to be release_task'd are put on the @dead list.
  *
@@ -706,6 +723,7 @@ static void exit_mm(struct task_struct *
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
+	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -721,10 +739,18 @@ static void ptrace_exit(struct task_stru
 		 * release_task() here because we already hold tasklist_lock.
 		 *
 		 * If it's our own child, there is no notification to do.
+		 * But if our normal children self-reap, then this child
+		 * was prevented by ptrace and we must reap it now.
 		 */
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
+			else {
+				if (ign < 0)
+					ign = ignoring_children(parent);
+				if (ign)
+					p->exit_signal = -1;
+			}
 		}
 
 		if (task_detached(p)) {
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
markers-fix-duplicate-modpost-entry.patch
linux-next.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

