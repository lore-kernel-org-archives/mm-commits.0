From: akpm@linux-foundation.org
Subject: [merged] m32r-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:16 -0400
Message-ID: <201003150701.o2F71nSj016817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oleg@redhat.com, roland@redhat.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     m32r-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: use generic ptrace_resume code
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

The old code only disables the breakpoints on PTRACE_KILL, while after
this patch this also happens for PTRACE_CONT and PTRACE_SYSCALL which
matches the behaviour of the other architetures.  I think this is a
bugfixes, but please double verify this is correct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/ptrace.h |    2 
 arch/m32r/kernel/ptrace.c      |   97 +++++++++----------------------
 2 files changed, 31 insertions(+), 68 deletions(-)

diff -puN arch/m32r/include/asm/ptrace.h~m32r-use-generic-ptrace_resume-code arch/m32r/include/asm/ptrace.h
--- a/arch/m32r/include/asm/ptrace.h~m32r-use-generic-ptrace_resume-code
+++ a/arch/m32r/include/asm/ptrace.h
@@ -120,6 +120,8 @@ struct pt_regs {
 
 #include <asm/m32r.h>		/* M32R_PSW_BSM, M32R_PSW_BPM */
 
+#define arch_has_single_step() (1)
+
 struct task_struct;
 extern void init_debug_traps(struct task_struct *);
 #define arch_ptrace_attach(child) \
diff -puN arch/m32r/kernel/ptrace.c~m32r-use-generic-ptrace_resume-code arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-use-generic-ptrace_resume-code
+++ a/arch/m32r/kernel/ptrace.c
@@ -580,6 +580,35 @@ init_debug_traps(struct task_struct *chi
 	}
 }
 
+void user_enable_single_step(struct task_struct *child)
+{
+	unsigned long next_pc;
+	unsigned long pc, insn;
+
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+	/* Compute next pc.  */
+	pc = get_stack_long(child, PT_BPC);
+
+	if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
+	    != sizeof(insn))
+		break;
+
+	compute_next_pc(insn, pc, &next_pc, child);
+	if (next_pc & 0x80000000)
+		break;
+
+	if (embed_debug_trap(child, next_pc))
+		break;
+
+	invalidate_cache();
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	unregister_all_debug_traps(child);
+	invalidate_cache();
+}
 
 /*
  * Called by kernel/ptrace.c when detaching..
@@ -630,74 +659,6 @@ arch_ptrace(struct task_struct *child, l
 		ret = ptrace_write_user(child, addr, data);
 		break;
 
-	/*
-	 * continue/restart and stop at next (return from) syscall
-	 */
-	case PTRACE_SYSCALL:
-	case PTRACE_CONT:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL: {
-		ret = 0;
-		unregister_all_debug_traps(child);
-		invalidate_cache();
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-	}
-
-	/*
-	 * execute single instruction.
-	 */
-	case PTRACE_SINGLESTEP: {
-		unsigned long next_pc;
-		unsigned long pc, insn;
-
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-		/* Compute next pc.  */
-		pc = get_stack_long(child, PT_BPC);
-
-		if (access_process_vm(child, pc&~3, &insn, sizeof(insn), 0)
-		    != sizeof(insn))
-			break;
-
-		compute_next_pc(insn, pc, &next_pc, child);
-		if (next_pc & 0x80000000)
-			break;
-
-		if (embed_debug_trap(child, next_pc))
-			break;
-
-		invalidate_cache();
-		child->exit_code = data;
-
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
