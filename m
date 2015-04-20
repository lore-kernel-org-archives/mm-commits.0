From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-fix-the-tif_forced_tf-logic-in-handle_signal.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:21:16 -0700
Message-ID: <553551ac.sQ8rnEKpGnU+6YS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbDTTOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andres@anarazel.de, eteran@alum.rit.edu, hpa@zytor.com, mingo@elte.hu, palves@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace/x86: fix the TIF_FORCED_TF logic in handle_signal()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-fix-the-tif_forced_tf-logic-in-handle_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/x86: fix the TIF_FORCED_TF logic in handle_signal()

When the TIF_SINGLESTEP tracee dequeues a signal, handle_signal() clears
TIF_FORCED_TF and X86_EFLAGS_TF but leaves TIF_SINGLESTEP set.

If the tracer does PTRACE_SINGLESTEP again, enable_single_step() sets
X86_EFLAGS_TF but not TIF_FORCED_TF.  This means that the subsequent
PTRACE_CONT doesn't not clear X86_EFLAGS_TF, and the tracee gets the wrong
SIGTRAP.

Test-case (needs -O2 to avoid prologue insns in signal handler):

	#include <unistd.h>
	#include <stdio.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <sys/user.h>
	#include <assert.h>
	#include <stddef.h>

	void handler(int n)
	{
		asm("nop");
	}

	int child(void)
	{
		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
		signal(SIGALRM, handler);
		kill(getpid(), SIGALRM);
		return 0x23;
	}

	void *getip(int pid)
	{
		return (void*)ptrace(PTRACE_PEEKUSER, pid,
					offsetof(struct user, regs.rip), 0);
	}

	int main(void)
	{
		int pid, status;

		pid = fork();
		if (!pid)
			return child();

		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGALRM);

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert((getip(pid) - (void*)handler) == 0);

		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
		assert(wait(&status) == pid);
		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
		assert((getip(pid) - (void*)handler) == 1);

		assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
		assert(wait(&status) == pid);
		assert(WIFEXITED(status) && WEXITSTATUS(status) == 0x23);

		return 0;
	}

The last assert() fails because PTRACE_CONT wrongly triggers another
single-step and X86_EFLAGS_TF can't be cleared by debugger until the
tracee does sys_rt_sigreturn().

Change handle_signal() to do user_disable_single_step() if stepping, we do
not need to preserve TIF_SINGLESTEP because we are going to do
ptrace_notify(), and it is simply wrong to leak this bit.

While at it, change the comment to explain why we also need to clear TF
unconditionally after setup_rt_frame().

Note: in the longer term we should probably change setup_sigcontext() to
use get_flags() and then just remove this user_disable_single_step(). 
And, the state of TIF_FORCED_TF can be wrong after restore_sigcontext()
which can set/clear TF, this needs another fix.

Reported-by: Evan Teran <eteran@alum.rit.edu>
Reported-by: Pedro Alves <palves@redhat.com>
Tested-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/signal.c~ptrace-x86-fix-the-tif_forced_tf-logic-in-handle_signal arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~ptrace-x86-fix-the-tif_forced_tf-logic-in-handle_signal
+++ a/arch/x86/kernel/signal.c
@@ -616,7 +616,8 @@ setup_rt_frame(struct ksignal *ksig, str
 static void
 handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
-	bool failed;
+	bool stepping, failed;
+
 	/* Are we from a system call? */
 	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
@@ -640,12 +641,13 @@ handle_signal(struct ksignal *ksig, stru
 	}
 
 	/*
-	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
-	 * flag so that register information in the sigcontext is correct.
+	 * If TF is set due to a debugger (TIF_FORCED_TF), clear TF now
+	 * so that register information in the sigcontext is correct and
+	 * then notify the tracer before entering the signal handler.
 	 */
-	if (unlikely(regs->flags & X86_EFLAGS_TF) &&
-	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
-		regs->flags &= ~X86_EFLAGS_TF;
+	stepping = test_thread_flag(TIF_SINGLESTEP);
+	if (stepping)
+		user_disable_single_step(current);
 
 	failed = (setup_rt_frame(ksig, regs) < 0);
 	if (!failed) {
@@ -656,10 +658,8 @@ handle_signal(struct ksignal *ksig, stru
 		 * it might disable possible debug exception from the
 		 * signal handler.
 		 *
-		 * Clear TF when entering the signal handler, but
-		 * notify any tracer that was single-stepping it.
-		 * The tracer may want to single-step inside the
-		 * handler too.
+		 * Clear TF for the case when it wasn't set by debugger to
+		 * avoid the recursive send_sigtrap() in SIGTRAP handler.
 		 */
 		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
 		/*
@@ -668,7 +668,7 @@ handle_signal(struct ksignal *ksig, stru
 		if (used_math())
 			fpu_reset_state(current);
 	}
-	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(failed, ksig, stepping);
 }
 
 #ifdef CONFIG_X86_32
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

