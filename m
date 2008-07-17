From: akpm@linux-foundation.org
Subject: + tracehook-tif_notify_resume.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:07 -0700
Message-ID: <200807170831.m6H8V702007009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627AbYGQIcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: TIF_NOTIFY_RESUME
has been added to the -mm tree.  Its filename is
     tracehook-tif_notify_resume.patch

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
Subject: tracehook: TIF_NOTIFY_RESUME
From: Roland McGrath <roland@redhat.com>

This adds tracehook.h inlines to enable a new arch feature in support of
user debugging/tracing.  This is not used yet, but it lays the groundwork
for a debugger to be able to wrangle a task that's possibly running,
without interrupting its syscalls in progress.

Each arch should define TIF_NOTIFY_RESUME, and in their entry.S code treat
it much like TIF_SIGPENDING.  That is, it causes you to take the slow path
when returning to user mode, where you get the full user-mode state
accessible as for signal handling or ptrace.  The arch code should check
TIF_NOTIFY_RESUME after handling TIF_SIGPENDING.  When it's set, clear it
and then call tracehook_notify_resume().

In future, tracing code will call set_notify_resume() when it wants to get
a callback in tracehook_notify_resume().

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN include/linux/tracehook.h~tracehook-tif_notify_resume include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tif_notify_resume
+++ a/include/linux/tracehook.h
@@ -537,4 +537,38 @@ static inline void tracehook_report_deat
 {
 }
 
+#ifdef TIF_NOTIFY_RESUME
+/**
+ * set_notify_resume - cause tracehook_notify_resume() to be called
+ * @task:		task that will call tracehook_notify_resume()
+ *
+ * Calling this arranges that @task will call tracehook_notify_resume()
+ * before returning to user mode.  If it's already running in user mode,
+ * it will enter the kernel and call tracehook_notify_resume() soon.
+ * If it's blocked, it will not be woken.
+ */
+static inline void set_notify_resume(struct task_struct *task)
+{
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
+		kick_process(task);
+}
+
+/**
+ * tracehook_notify_resume - report when about to return to user mode
+ * @regs:		user-mode registers of @current task
+ *
+ * This is called when %TIF_NOTIFY_RESUME has been set.  Now we are
+ * about to return to user mode, and the user state in @regs can be
+ * inspected or adjusted.  The caller in arch code has cleared
+ * %TIF_NOTIFY_RESUME before the call.  If the flag gets set again
+ * asynchronously, this will be called again before we return to
+ * user mode.
+ *
+ * Called without locks.
+ */
+static inline void tracehook_notify_resume(struct pt_regs *regs)
+{
+}
+#endif	/* TIF_NOTIFY_RESUME */
+
 #endif	/* <linux/tracehook.h> */
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

