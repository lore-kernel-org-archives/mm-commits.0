From: akpm@linux-foundation.org
Subject: + tracehook-syscall.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:30:57 -0700
Message-ID: <200807170830.m6H8UvXc006986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbYGQIbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: syscall
has been added to the -mm tree.  Its filename is
     tracehook-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: syscall
From: Roland McGrath <roland@redhat.com>

This adds standard tracehook.h inlines for arch code to call when
TIF_SYSCALL_TRACE has been set.  This replaces having each arch implement
the ptrace guts for its syscall tracing support.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   70 ++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff -puN include/linux/tracehook.h~tracehook-syscall include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-syscall
+++ a/include/linux/tracehook.h
@@ -66,6 +66,76 @@ static inline int tracehook_expect_break
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/*
+ * ptrace report for syscall entry and exit looks identical.
+ */
+static inline void ptrace_report_syscall(struct pt_regs *regs)
+{
+	int ptrace = task_ptrace(current);
+
+	if (!(ptrace & PT_PTRACED))
+		return;
+
+	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+
+/**
+ * tracehook_report_syscall_entry - task is about to attempt a system call
+ * @regs:		user register state of current task
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just entered the kernel for a system call.
+ * Full user register state is available here.  Changing the values
+ * in @regs can affect the system call number and arguments to be tried.
+ * It is safe to block here, preventing the system call from beginning.
+ *
+ * Returns zero normally, or nonzero if the calling arch code should abort
+ * the system call.  That must prevent normal entry so no system call is
+ * made.  If @task ever returns to user mode after this, its register state
+ * is unspecified, but should be something harmless like an %ENOSYS error
+ * return.
+ *
+ * Called without locks, just after entering kernel mode.
+ */
+static inline __must_check int tracehook_report_syscall_entry(
+	struct pt_regs *regs)
+{
+	ptrace_report_syscall(regs);
+	return 0;
+}
+
+/**
+ * tracehook_report_syscall_exit - task has just finished a system call
+ * @regs:		user register state of current task
+ * @step:		nonzero if simulating single-step or block-step
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just finished an attempted system call.  Full
+ * user register state is available here.  It is safe to block here,
+ * preventing signals from being processed.
+ *
+ * If @step is nonzero, this report is also in lieu of the normal
+ * trap that would follow the system call instruction because
+ * user_enable_block_step() or user_enable_single_step() was used.
+ * In this case, %TIF_SYSCALL_TRACE might not be set.
+ *
+ * Called without locks, just before checking for pending signals.
+ */
+static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
+{
+	ptrace_report_syscall(regs);
+}
+
 /**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
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
ptrace-do_wait-reorganization.patch
ptrace-ptrace-children-revamp.patch
ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch
ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch
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

