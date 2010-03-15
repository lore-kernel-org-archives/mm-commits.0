From: akpm@linux-foundation.org
Subject: [merged] arm-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:36 -0400
Message-ID: <201003150701.o2F7195x016688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oleg@redhat.com, rmk@arm.linux.org.uk, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     arm: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     arm-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
arch_has_single_step in <asm/ptrace.h> and implementing the
user_enable_single_step and user_disable_single_step functions, which also
causes the breakpoint information to be cleared on fork, which could be
considered a bug fix.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't and the single stepping disable only happens if the
tracee process isn't a zombie yet, which is consistent with all
architectures using the modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/ptrace.h |    2 +
 arch/arm/kernel/ptrace.c      |   60 ++++++--------------------------
 arch/arm/kernel/ptrace.h      |   14 -------
 3 files changed, 14 insertions(+), 62 deletions(-)

diff -puN arch/arm/include/asm/ptrace.h~arm-use-generic-ptrace_resume-code arch/arm/include/asm/ptrace.h
--- a/arch/arm/include/asm/ptrace.h~arm-use-generic-ptrace_resume-code
+++ a/arch/arm/include/asm/ptrace.h
@@ -128,6 +128,8 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step()	(1)
+
 #define user_mode(regs)	\
 	(((regs)->ARM_cpsr & 0xf) == 0)
 
diff -puN arch/arm/kernel/ptrace.c~arm-use-generic-ptrace_resume-code arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~arm-use-generic-ptrace_resume-code
+++ a/arch/arm/kernel/ptrace.c
@@ -452,12 +452,23 @@ void ptrace_cancel_bpt(struct task_struc
 		clear_breakpoint(child, &child->thread.debug.bp[i]);
 }
 
+void user_disable_single_step(struct task_struct *task)
+{
+	task->ptrace &= ~PT_SINGLESTEP;
+	ptrace_cancel_bpt(task);
+}
+
+void user_enable_single_step(struct task_struct *task)
+{
+	task->ptrace |= PT_SINGLESTEP;
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  */
 void ptrace_disable(struct task_struct *child)
 {
-	single_step_disable(child);
+	user_disable_single_step(child);
 }
 
 /*
@@ -753,53 +764,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = ptrace_write_user(child, addr, data);
 			break;
 
-		/*
-		 * continue/restart and stop at next (return from) syscall
-		 */
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			single_step_disable(child);
-			wake_up_process(child);
-			ret = 0;
-			break;
-
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill.
-		 * perhaps it should be put in the status that it wants to
-		 * exit.
-		 */
-		case PTRACE_KILL:
-			single_step_disable(child);
-			if (child->exit_state != EXIT_ZOMBIE) {
-				child->exit_code = SIGKILL;
-				wake_up_process(child);
-			}
-			ret = 0;
-			break;
-
-		/*
-		 * execute single instruction.
-		 */
-		case PTRACE_SINGLESTEP:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			single_step_enable(child);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			/* give it a chance to run. */
-			wake_up_process(child);
-			ret = 0;
-			break;
-
 		case PTRACE_GETREGS:
 			ret = ptrace_getregs(child, (void __user *)data);
 			break;
diff -puN arch/arm/kernel/ptrace.h~arm-use-generic-ptrace_resume-code arch/arm/kernel/ptrace.h
--- a/arch/arm/kernel/ptrace.h~arm-use-generic-ptrace_resume-code
+++ a/arch/arm/kernel/ptrace.h
@@ -14,20 +14,6 @@ extern void ptrace_set_bpt(struct task_s
 extern void ptrace_break(struct task_struct *, struct pt_regs *);
 
 /*
- * make sure single-step breakpoint is gone.
- */
-static inline void single_step_disable(struct task_struct *task)
-{
-	task->ptrace &= ~PT_SINGLESTEP;
-	ptrace_cancel_bpt(task);
-}
-
-static inline void single_step_enable(struct task_struct *task)
-{
-	task->ptrace |= PT_SINGLESTEP;
-}
