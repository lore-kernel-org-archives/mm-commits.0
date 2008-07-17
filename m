From: akpm@linux-foundation.org
Subject: + task_current_syscall.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:31:16 -0700
Message-ID: <200807170831.m6H8VGgI007021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbYGQIcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     task_current_syscall
has been added to the -mm tree.  Its filename is
     task_current_syscall.patch

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
Subject: task_current_syscall
From: Roland McGrath <roland@redhat.com>

This adds the new function task_current_syscall() on machines where the
asm/syscall.h interface is supported (CONFIG_HAVE_ARCH_TRACEHOOK).  It's
exported for modules to use in the future.  This function safely samples
the state of a blocked thread to collect what system call it is blocked
in, and the six system call argument registers.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    4 ++
 lib/Makefile           |    2 +
 lib/syscall.c          |   75 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff -puN include/linux/ptrace.h~task_current_syscall include/linux/ptrace.h
--- a/include/linux/ptrace.h~task_current_syscall
+++ a/include/linux/ptrace.h
@@ -314,6 +314,10 @@ static inline void user_enable_block_ste
 #define arch_ptrace_stop(code, info)		do { } while (0)
 #endif
 
+extern int task_current_syscall(struct task_struct *target, long *callno,
+				unsigned long args[6], unsigned int maxargs,
+				unsigned long *sp, unsigned long *pc);
+
 #endif
 
 #endif
diff -puN lib/Makefile~task_current_syscall lib/Makefile
--- a/lib/Makefile~task_current_syscall
+++ a/lib/Makefile
@@ -83,6 +83,8 @@ obj-$(CONFIG_HAVE_LMB) += lmb.o
 
 obj-$(CONFIG_TRACE) += trace.o
 
+obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/syscall.c
--- /dev/null
+++ a/lib/syscall.c
@@ -0,0 +1,75 @@
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <asm/syscall.h>
+
+static int collect_syscall(struct task_struct *target, long *callno,
+			   unsigned long args[6], unsigned int maxargs,
+			   unsigned long *sp, unsigned long *pc)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	if (unlikely(!regs))
+		return -EAGAIN;
+
+	*sp = user_stack_pointer(regs);
+	*pc = instruction_pointer(regs);
+
+	*callno = syscall_get_nr(target, regs);
+	if (*callno != -1L && maxargs > 0)
+		syscall_get_arguments(target, regs, 0, maxargs, args);
+
+	return 0;
+}
+
+/**
+ * task_current_syscall - Discover what a blocked task is doing.
+ * @target:		thread to examine
+ * @callno:		filled with system call number or -1
+ * @args:		filled with @maxargs system call arguments
+ * @maxargs:		number of elements in @args to fill
+ * @sp:			filled with user stack pointer
+ * @pc:			filled with user PC
+ *
+ * If @target is blocked in a system call, returns zero with *@callno
+ * set to the the call's number and @args filled in with its arguments.
+ * Registers not used for system call arguments may not be available and
+ * it is not kosher to use &struct user_regset calls while the system
+ * call is still in progress.  Note we may get this result if @target
+ * has finished its system call but not yet returned to user mode, such
+ * as when it's stopped for signal handling or syscall exit tracing.
+ *
+ * If @target is blocked in the kernel during a fault or exception,
+ * returns zero with *@callno set to -1 and does not fill in @args.
+ * If so, it's now safe to examine @target using &struct user_regset
+ * get() calls as long as we're sure @target won't return to user mode.
+ *
+ * Returns -%EAGAIN if @target does not remain blocked.
+ *
+ * Returns -%EINVAL if @maxargs is too large (maximum is six).
+ */
+int task_current_syscall(struct task_struct *target, long *callno,
+			 unsigned long args[6], unsigned int maxargs,
+			 unsigned long *sp, unsigned long *pc)
+{
+	long state;
+	unsigned long ncsw;
+
+	if (unlikely(maxargs > 6))
+		return -EINVAL;
+
+	if (target == current)
+		return collect_syscall(target, callno, args, maxargs, sp, pc);
+
+	state = target->state;
+	if (unlikely(!state))
+		return -EAGAIN;
+
+	ncsw = wait_task_inactive(target, state);
+	if (unlikely(!ncsw) ||
+	    unlikely(collect_syscall(target, callno, args, maxargs, sp, pc)) ||
+	    unlikely(wait_task_inactive(target, state) != ncsw))
+		return -EAGAIN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(task_current_syscall);
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

