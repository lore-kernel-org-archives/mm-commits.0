From: akpm@linux-foundation.org
Subject: [merged] alpha-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:32 -0400
Message-ID: <201003150701.o2F715cN016683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ink@jurassic.park.msu.ru, mattst88@gmail.com, oleg@redhat.com, roland@redhat.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     alpha-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
arch_has_single_step in <asm/ptrace.h> and implementing the
user_enable_single_step and user_disable_single_step functions, which also
causes the breakpoint information to be cleared on fork, which could be
considered a bug fix.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't, which is consistent with all architectures using the
modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Matt Turner <mattst88@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/ptrace.h |    1 
 arch/alpha/kernel/ptrace.c      |   59 ++++++------------------------
 2 files changed, 13 insertions(+), 47 deletions(-)

diff -puN arch/alpha/include/asm/ptrace.h~alpha-use-generic-ptrace_resume-code arch/alpha/include/asm/ptrace.h
--- a/arch/alpha/include/asm/ptrace.h~alpha-use-generic-ptrace_resume-code
+++ a/arch/alpha/include/asm/ptrace.h
@@ -68,6 +68,7 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step()		(1)
 #define user_mode(regs) (((regs)->ps & 8) != 0)
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
diff -puN arch/alpha/kernel/ptrace.c~alpha-use-generic-ptrace_resume-code arch/alpha/kernel/ptrace.c
--- a/arch/alpha/kernel/ptrace.c~alpha-use-generic-ptrace_resume-code
+++ a/arch/alpha/kernel/ptrace.c
@@ -249,6 +249,17 @@ ptrace_cancel_bpt(struct task_struct * c
 	return (nsaved != 0);
 }
 
+void user_enable_single_step(struct task_struct *child)
+{
+	/* Mark single stepping.  */
+	task_thread_info(child)->bpt_nsaved = -1;
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	ptrace_cancel_bpt(child);
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -256,7 +267,7 @@ ptrace_cancel_bpt(struct task_struct * c
  */
 void ptrace_disable(struct task_struct *child)
 { 
-	ptrace_cancel_bpt(child);
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -295,52 +306,6 @@ long arch_ptrace(struct task_struct *chi
 		DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
 		ret = put_reg(child, addr, data);
 		break;
-
-	case PTRACE_SYSCALL:
-		/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:    /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* make sure single-step breakpoint is gone. */
-		ptrace_cancel_bpt(child);
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * Make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)
-			break;
-		child->exit_code = SIGKILL;
-		/* make sure single-step breakpoint is gone. */
-		ptrace_cancel_bpt(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:  /* execute single instruction. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		/* Mark single stepping.  */
-		task_thread_info(child)->bpt_nsaved = -1;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		wake_up_process(child);
-		/* give it a chance to run. */
-		ret = 0;
-		break;
