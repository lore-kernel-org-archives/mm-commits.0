From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:07 -0400
Message-ID: <201003150701.o2F71eQc016788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935792Ab0COHCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, chris@zankel.net, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     xtensa-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use generic ptrace_resume code
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/ptrace.h |    1 
 arch/xtensa/kernel/ptrace.c      |   56 +++++------------------------
 2 files changed, 12 insertions(+), 45 deletions(-)

diff -puN arch/xtensa/include/asm/ptrace.h~xtensa-use-generic-ptrace_resume-code arch/xtensa/include/asm/ptrace.h
--- a/arch/xtensa/include/asm/ptrace.h~xtensa-use-generic-ptrace_resume-code
+++ a/arch/xtensa/include/asm/ptrace.h
@@ -113,6 +113,7 @@ struct pt_regs {
 
 #include <variant/core.h>
 
+# define arch_has_single_step()	(1)
 # define task_pt_regs(tsk) ((struct pt_regs*) \
   (task_stack_page(tsk) + KERNEL_STACK_SIZE - (XCHAL_NUM_AREGS-16)*4) - 1)
 # define user_mode(regs) (((regs)->ps & 0x00000020)!=0)
diff -puN arch/xtensa/kernel/ptrace.c~xtensa-use-generic-ptrace_resume-code arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~xtensa-use-generic-ptrace_resume-code
+++ a/arch/xtensa/kernel/ptrace.c
@@ -30,6 +30,17 @@
 #include <asm/elf.h>
 #include <asm/coprocessor.h>
 
+
+void user_enable_single_step(struct task_struct *child)
+{
+	child->ptrace |= PT_SINGLESTEP;
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	child->ptrace &= ~PT_SINGLESTEP;
+}
+
 /*
  * Called by kernel/ptrace.c when detaching to disable single stepping.
  */
@@ -268,51 +279,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_pokeusr(child, addr, data);
 		break;
 
-	/* continue and stop at next (return from) syscall */
-
-	case PTRACE_SYSCALL:
-	case PTRACE_CONT: /* restart after signal. */
-	{
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* Make sure the single step bit is not set. */
-		child->ptrace &= ~PT_SINGLESTEP;
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		child->ptrace &= ~PT_SINGLESTEP;
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->ptrace |= PT_SINGLESTEP;
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
