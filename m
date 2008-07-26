From: akpm@linux-foundation.org
Subject: + x86-tracehook-syscall.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:09:09 -0700
Message-ID: <200807260709.m6Q799B3021412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYGZHKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: tracehook syscall
has been added to the -mm tree.  Its filename is
     x86-tracehook-syscall.patch

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

origin.patch
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
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

