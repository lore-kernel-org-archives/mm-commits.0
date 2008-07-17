From: akpm@linux-foundation.org
Subject: + proc-pid-syscall.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:18 -0700
Message-ID: <200807170831.m6H8VIdZ007024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbYGQIcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     /proc/PID/syscall
has been added to the -mm tree.  Its filename is
     proc-pid-syscall.patch

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
Subject: /proc/PID/syscall
From: Roland McGrath <roland@redhat.com>

This adds /proc/PID/syscall and /proc/PID/task/TID/syscall magic files. 
These use task_current_syscall() to show the task's current system call
number and argument registers, stack pointer and PC.  For a task blocked
but not in a syscall, the file shows "-1" in place of the syscall number,
followed by only the SP and PC.  For a task that's not blocked, it shows
"running".

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/proc/base.c~proc-pid-syscall fs/proc/base.c
--- a/fs/proc/base.c~proc-pid-syscall
+++ a/fs/proc/base.c
@@ -509,6 +509,26 @@ static int proc_pid_limits(struct task_s
 	return count;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+static int proc_pid_syscall(struct task_struct *task, char *buffer)
+{
+	long nr;
+	unsigned long args[6], sp, pc;
+
+	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
+		return sprintf(buffer, "running\n");
+
+	if (nr < 0)
+		return sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+
+	return sprintf(buffer,
+		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+		       nr,
+		       args[0], args[1], args[2], args[3], args[4], args[5],
+		       sp, pc);
+}
+#endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2478,6 +2498,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",    S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
 	ONE("statm",      S_IRUGO, pid_statm),
@@ -2810,6 +2833,9 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",   S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
 	ONE("statm",     S_IRUGO, pid_statm),
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

