From: akpm@linux-foundation.org
Subject: [merged] um-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:03 -0400
Message-ID: <201003150701.o2F71aAK016783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935814Ab0COHCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jdike@addtoit.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     um: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     um-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: use generic ptrace_resume code
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

XXX: I'm not sure arch_has_single_step() is placed in the exactly correct
location, please verify in which of the ptrace headers it should really
be.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/ptrace-generic.h |    2 
 arch/um/kernel/ptrace.c              |   70 +++++--------------------
 2 files changed, 18 insertions(+), 54 deletions(-)

diff -puN arch/um/include/asm/ptrace-generic.h~um-use-generic-ptrace_resume-code arch/um/include/asm/ptrace-generic.h
--- a/arch/um/include/asm/ptrace-generic.h~um-use-generic-ptrace_resume-code
+++ a/arch/um/include/asm/ptrace-generic.h
@@ -16,6 +16,8 @@ struct pt_regs {
 	struct uml_pt_regs regs;
 };
 
+#define arch_has_single_step()	(1)
+
 #define EMPTY_REGS { .regs = EMPTY_UML_PT_REGS }
 
 #define PT_REGS_IP(r) UPT_IP(&(r)->regs)
diff -puN arch/um/kernel/ptrace.c~um-use-generic-ptrace_resume-code arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~um-use-generic-ptrace_resume-code
+++ a/arch/um/kernel/ptrace.c
@@ -12,16 +12,25 @@
 #endif
 #include "skas_ptrace.h"
 
-static inline void set_singlestepping(struct task_struct *child, int on)
+
+
+void user_enable_single_step(struct task_struct *child)
 {
-	if (on)
-		child->ptrace |= PT_DTRACE;
-	else
-		child->ptrace &= ~PT_DTRACE;
+	child->ptrace |= PT_DTRACE;
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
-	SUBARCH_SET_SINGLESTEPPING(child, on);
+	SUBARCH_SET_SINGLESTEPPING(child, 1);
+#endif
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	child->ptrace &= ~PT_DTRACE;
+	child->thread.singlestep_syscall = 0;
+
+#ifdef SUBARCH_SET_SINGLESTEPPING
+	SUBARCH_SET_SINGLESTEPPING(child, 0);
 #endif
 }
 
@@ -30,7 +39,7 @@ static inline void set_singlestepping(st
  */
 void ptrace_disable(struct task_struct *child)
 {
-	set_singlestepping(child,0);
+	user_disable_single_step(child);
 }
 
 extern int peek_user(struct task_struct * child, long addr, long data);
@@ -69,53 +78,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = -EIO;
 		break;
 
-	/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-	/* restart after signal. */
-	case PTRACE_CONT: {
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		set_singlestepping(child, 0);
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
-/*
- * make the child exit.  Best I can do is send it a sigkill.
- * perhaps it should be put in the status that it wants to
- * exit.
- */
-	case PTRACE_KILL: {
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-
-		set_singlestepping(child, 0);
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-	}
-
-	case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		set_singlestepping(child, 1);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
