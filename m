From: akpm@linux-foundation.org
Subject: [merged] avr32-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:39 -0400
Message-ID: <201003150701.o2F71CsC016764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935787Ab0COHBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hskinnemoen@atmel.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     avr32: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     avr32-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: avr32: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
PTRACE_KILL and PTRACE_SINGLESTEP.  This implies defining
arch_has_single_step in <asm/ptrace.h> and implementing the
user_enable_single_step and user_disable_single_step functions, which also
causes the breakpoint information to be cleared on fork, which could be
considered a bug fix.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't which is consistent with all architectures using the
modern ptrace code.

Currently avr32 doesn't implement any code to disable single stepping when
one of the non-syscall requests is called which seems wrong, but I've left
it as-is for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/ptrace.h |    2 +
 arch/avr32/kernel/ptrace.c      |   53 +++---------------------------
 2 files changed, 9 insertions(+), 46 deletions(-)

diff -puN arch/avr32/include/asm/ptrace.h~avr32-use-generic-ptrace_resume-code arch/avr32/include/asm/ptrace.h
--- a/arch/avr32/include/asm/ptrace.h~avr32-use-generic-ptrace_resume-code
+++ a/arch/avr32/include/asm/ptrace.h
@@ -124,6 +124,8 @@ struct pt_regs {
 
 #include <asm/ocd.h>
 
+#define arch_has_single_step()		(1)
+
 #define arch_ptrace_attach(child)       ocd_enable(child)
 
 #define user_mode(regs)                 (((regs)->sr & MODE_MASK) == MODE_USER)
diff -puN arch/avr32/kernel/ptrace.c~avr32-use-generic-ptrace_resume-code arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~avr32-use-generic-ptrace_resume-code
+++ a/arch/avr32/kernel/ptrace.c
@@ -28,9 +28,9 @@ static struct pt_regs *get_user_regs(str
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
-static void ptrace_single_step(struct task_struct *tsk)
+static void user_enable_single_step(struct task_struct *tsk)
 {
-	pr_debug("ptrace_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
+	pr_debug("user_enable_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
 		 tsk->pid, task_pt_regs(tsk)->pc, task_pt_regs(tsk)->sr);
 
 	/*
@@ -49,6 +49,11 @@ static void ptrace_single_step(struct ta
 	set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
 }
 
+void user_disable_single_step(struct task_struct *child)
+{
+	/* XXX(hch): a no-op here seems wrong.. */
+}
+
 /*
  * Called by kernel/ptrace.c when detaching
  *
@@ -167,50 +172,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_write_user(child, addr, data);
 		break;
 
-	/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-	/* restart after signal */
-	case PTRACE_CONT:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* XXX: Are we sure no breakpoints are active here? */
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * Make the child exit. Best I can do is send it a
-	 * SIGKILL. Perhaps it should be put in the status that it
-	 * wants to exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-
-	/*
-	 * execute single instruction.
-	 */
-	case PTRACE_SINGLESTEP:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_single_step(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
