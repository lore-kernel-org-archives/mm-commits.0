From: akpm@linux-foundation.org
Subject: - ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:39 -0700
Message-ID: <200807182324.m6INOdHg004221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948AbYGRXZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:25:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, jmorris@namei.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     ptrace: do_wait: return security_task_wait() error code in place of -ECHILD
has been removed from the -mm tree.  Its filename was
     ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: do_wait: return security_task_wait() error code in place of -ECHILD
From: Roland McGrath <roland@redhat.com>

This reverts the effect of commit f2cc3eb133baa2e9dc8efd40f417106b2ee520f3
"do_wait: fix security checks".  That change reverted the effect of commit
73243284463a761e04d69d22c7516b2be7de096c.  The rationale for the original
commit still stands.  The inconsistent treatment of children hidden by
ptrace was an unintended omission in the original change and in no way
invalidates its purpose.

This makes do_wait return the error returned by security_task_wait()
(usually -EACCES) in place of -ECHILD when there are some children the
caller would be able to wait for if not for the permission failure.  A
permission error will give the user a clue to look for security policy
problems, rather than for mysterious wait bugs.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild kernel/exit.c
--- a/kernel/exit.c~ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild
+++ a/kernel/exit.c
@@ -1191,14 +1191,10 @@ static int eligible_child(enum pid_type 
 		return 0;
 
 	err = security_task_wait(p);
-	if (likely(!err))
-		return 1;
+	if (err)
+		return err;
 
-	if (type != PIDTYPE_PID)
-		return 0;
-	/* This child was explicitly requested, abort */
-	read_unlock(&tasklist_lock);
-	return err;
+	return 1;
 }
 
 static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
@@ -1528,7 +1524,8 @@ static int wait_task_continued(struct ta
  * -ECHILD should be in *@notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue;
- * then *@notask_error is 0 if @p is an eligible child, or still -ECHILD.
+ * then *@notask_error is 0 if @p is an eligible child,
+ * or another error from security_task_wait(), or still -ECHILD.
  */
 static int wait_consider_task(struct task_struct *parent, int ptrace,
 			      struct task_struct *p, int *notask_error,
@@ -1537,9 +1534,21 @@ static int wait_consider_task(struct tas
 			      int __user *stat_addr, struct rusage __user *ru)
 {
 	int ret = eligible_child(type, pid, options, p);
-	if (ret <= 0)
+	if (!ret)
 		return ret;
 
+	if (unlikely(ret < 0)) {
+		/*
+		 * If we have not yet seen any eligible child,
+		 * then let this error code replace -ECHILD.
+		 * A permission error will give the user a clue
+		 * to look for security policy problems, rather
+		 * than for mysterious wait bugs.
+		 */
+		if (*notask_error)
+			*notask_error = ret;
+	}
+
 	if (likely(!ptrace) && unlikely(p->ptrace)) {
 		/*
 		 * This child is hidden by ptrace.
@@ -1577,7 +1586,8 @@ static int wait_consider_task(struct tas
  * -ECHILD should be in *@notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then
- * *@notask_error is 0 if there were any eligible children, or still -ECHILD.
+ * *@notask_error is 0 if there were any eligible children,
+ * or another error from security_task_wait(), or still -ECHILD.
  */
 static int do_wait_thread(struct task_struct *tsk, int *notask_error,
 			  enum pid_type type, struct pid *pid, int options,
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

