From: akpm@linux-foundation.org
Subject: - x86-tracehook-syscall.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:42 -0700
Message-ID: <200808181940.m7IJegSI008479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759679AbYHRTvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: tracehook syscall
has been removed from the -mm tree.  Its filename was
     x86-tracehook-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: tracehook syscall
From: Roland McGrath <roland@redhat.com>

This changes x86 syscall tracing to use the new tracehook.h entry points. 
There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~x86-tracehook-syscall arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~x86-tracehook-syscall
+++ a/arch/x86/kernel/ptrace.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/regset.h>
+#include <linux/tracehook.h>
 #include <linux/user.h>
 #include <linux/elf.h>
 #include <linux/security.h>
@@ -1375,30 +1376,6 @@ void send_sigtrap(struct task_struct *ts
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-static void syscall_trace(struct pt_regs *regs)
-{
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-
-#if 0
-	printk("trace %s ip %lx sp %lx ax %d origrax %d caller %lx tiflags %x ptrace %x\n",
-	       current->comm,
-	       regs->ip, regs->sp, regs->ax, regs->orig_ax, __builtin_return_address(0),
-	       current_thread_info()->flags, current->ptrace);
-#endif
-
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				? 0x80 : 0));
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
-}
 
 #ifdef CONFIG_X86_32
 # define IS_IA32	1
@@ -1432,8 +1409,9 @@ asmregparm long syscall_trace_enter(stru
 	if (unlikely(test_thread_flag(TIF_SYSCALL_EMU)))
 		ret = -1L;
 
-	if (ret || test_thread_flag(TIF_SYSCALL_TRACE))
-		syscall_trace(regs);
+	if ((ret || test_thread_flag(TIF_SYSCALL_TRACE)) &&
+	    tracehook_report_syscall_entry(regs))
+		ret = -1L;
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1459,7 +1437,7 @@ asmregparm void syscall_trace_leave(stru
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
-		syscall_trace(regs);
+		tracehook_report_syscall_exit(regs, 0);
 
 	/*
 	 * If TIF_SYSCALL_EMU is set, we only get here because of
@@ -1475,6 +1453,6 @@ asmregparm void syscall_trace_leave(stru
 	 * system call instruction.
 	 */
 	if (test_thread_flag(TIF_SINGLESTEP) &&
-	    (current->ptrace & PT_PTRACED))
+	    tracehook_consider_fatal_signal(current, SIGTRAP, SIG_DFL))
 		send_sigtrap(current, regs, 0);
 }
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

