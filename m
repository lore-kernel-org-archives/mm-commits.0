From: akpm@linux-foundation.org
Subject: + tracehook-get_signal_to_deliver.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:30:59 -0700
Message-ID: <200807170830.m6H8Ux4L006989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbYGQIjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: get_signal_to_deliver
has been added to the -mm tree.  Its filename is
     tracehook-get_signal_to_deliver.patch

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
Subject: tracehook: get_signal_to_deliver
From: Roland McGrath <roland@redhat.com>

This defines the tracehook_get_signal() hook to allow tracing code to slip
in before normal signal dequeuing.  This lays the groundwork for new
tracing features that can inject synthetic signals outside the normal
queue or control the disposition of delivered signals.  The calling
convention lets tracehook_get_signal() decide both exactly what will
happen and what signal number to report in the handler/exit.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   29 +++++++++++++++++++++++++++
 kernel/signal.c           |   38 +++++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 11 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-get_signal_to_deliver include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-get_signal_to_deliver
+++ a/include/linux/tracehook.h
@@ -422,4 +422,33 @@ static inline int tracehook_consider_fat
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/**
+ * tracehook_get_signal - deliver synthetic signal to traced task
+ * @task:		@current
+ * @regs:		task_pt_regs(@current)
+ * @info:		details of synthetic signal
+ * @return_ka:		sigaction for synthetic signal
+ *
+ * Return zero to check for a real pending signal normally.
+ * Return -1 after releasing the siglock to repeat the check.
+ * Return a signal number to induce an artifical signal delivery,
+ * setting *@info and *@return_ka to specify its details and behavior.
+ *
+ * The @return_ka->sa_handler value controls the disposition of the
+ * signal, no matter the signal number.  For %SIG_DFL, the return value
+ * is a representative signal to indicate the behavior (e.g. %SIGTERM
+ * for death, %SIGQUIT for core dump, %SIGSTOP for job control stop,
+ * %SIGTSTP for stop unless in an orphaned pgrp), but the signal number
+ * reported will be @info->si_signo instead.
+ *
+ * Called with @task->sighand->siglock held, before dequeuing pending signals.
+ */
+static inline int tracehook_get_signal(struct task_struct *task,
+				       struct pt_regs *regs,
+				       siginfo_t *info,
+				       struct k_sigaction *return_ka)
+{
+	return 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-get_signal_to_deliver kernel/signal.c
--- a/kernel/signal.c~tracehook-get_signal_to_deliver
+++ a/kernel/signal.c
@@ -1754,17 +1754,33 @@ relock:
 		    do_signal_stop(0))
 			goto relock;
 
-		signr = dequeue_signal(current, &current->blocked, info);
-		if (!signr)
-			break; /* will return 0 */
+		/*
+		 * Tracing can induce an artifical signal and choose sigaction.
+		 * The return value in @signr determines the default action,
+		 * but @info->si_signo is the signal number we will report.
+		 */
+		signr = tracehook_get_signal(current, regs, info, return_ka);
+		if (unlikely(signr < 0))
+			goto relock;
+		if (unlikely(signr != 0))
+			ka = return_ka;
+		else {
+			signr = dequeue_signal(current, &current->blocked,
+					       info);
 
-		if (signr != SIGKILL) {
-			signr = ptrace_signal(signr, info, regs, cookie);
 			if (!signr)
-				continue;
+				break; /* will return 0 */
+
+			if (signr != SIGKILL) {
+				signr = ptrace_signal(signr, info,
+						      regs, cookie);
+				if (!signr)
+					continue;
+			}
+
+			ka = &sighand->action[signr-1];
 		}
 
-		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1812,7 +1828,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(signr))) {
+			if (likely(do_signal_stop(info->si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -1833,7 +1849,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(regs, signr);
+				print_fatal_signal(regs, info->si_signo);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
@@ -1842,13 +1858,13 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump((long)signr, signr, regs);
+			do_coredump(info->si_signo, info->si_signo, regs);
 		}
 
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(signr);
+		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
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

