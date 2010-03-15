From: akpm@linux-foundation.org
Subject: [merged] h8300-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:42 -0400
Message-ID: <201003150701.o2F71FWs016769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759694Ab0COHBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oleg@redhat.com, roland@redhat.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     h8300-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: use generic ptrace_resume code
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/ptrace.h            |    2 
 arch/h8300/kernel/ptrace.c                 |   52 ++-----------------
 arch/h8300/platform/h8300h/ptrace_h8300h.c |    6 +-
 arch/h8300/platform/h8s/ptrace_h8s.c       |    4 -
 4 files changed, 13 insertions(+), 51 deletions(-)

diff -puN arch/h8300/include/asm/ptrace.h~h8300-use-generic-ptrace_resume-code arch/h8300/include/asm/ptrace.h
--- a/arch/h8300/include/asm/ptrace.h~h8300-use-generic-ptrace_resume-code
+++ a/arch/h8300/include/asm/ptrace.h
@@ -55,6 +55,8 @@ struct pt_regs {
 /* Find the stack offset for a register, relative to thread.esp0. */
 #define PT_REG(reg)	((long)&((struct pt_regs *)0)->reg)
 
+#define arch_has_single_step()	(1)
+
 #define user_mode(regs) (!((regs)->ccr & PS_S))
 #define instruction_pointer(regs) ((regs)->pc)
 #define profile_pc(regs) instruction_pointer(regs)
diff -puN arch/h8300/kernel/ptrace.c~h8300-use-generic-ptrace_resume-code arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~h8300-use-generic-ptrace_resume-code
+++ a/arch/h8300/kernel/ptrace.c
@@ -34,8 +34,11 @@
 /* cpu depend functions */
 extern long h8300_get_reg(struct task_struct *task, int regno);
 extern int  h8300_put_reg(struct task_struct *task, int regno, unsigned long data);
-extern void h8300_disable_trace(struct task_struct *child);
-extern void h8300_enable_trace(struct task_struct *child);
+
+
+void user_disable_single_step(struct task_struct *child)
+{
+}
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -44,7 +47,7 @@ extern void h8300_enable_trace(struct ta
 
 void ptrace_disable(struct task_struct *child)
 {
-	h8300_disable_trace(child);
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -107,49 +110,6 @@ long arch_ptrace(struct task_struct *chi
 			}
 			ret = -EIO;
 			break ;
-		case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-		case PTRACE_CONT: { /* restart after signal. */
-			ret = -EIO;
-			if (!valid_signal(data))
-				break ;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			wake_up_process(child);
-			/* make sure the single step bit is not set. */
-			h8300_disable_trace(child);
-			ret = 0;
-		}
-
-/*
- * make the child exit.  Best I can do is send it a sigkill. 
- * perhaps it should be put in the status that it wants to 
- * exit.
- */
-		case PTRACE_KILL: {
-
-			ret = 0;
-			if (child->exit_state == EXIT_ZOMBIE) /* already dead */
-				break;
-			child->exit_code = SIGKILL;
-			h8300_disable_trace(child);
-			wake_up_process(child);
-			break;
-		}
-
-		case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			h8300_enable_trace(child);
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
 
 		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		  	int i;
diff -puN arch/h8300/platform/h8300h/ptrace_h8300h.c~h8300-use-generic-ptrace_resume-code arch/h8300/platform/h8300h/ptrace_h8300h.c
--- a/arch/h8300/platform/h8300h/ptrace_h8300h.c~h8300-use-generic-ptrace_resume-code
+++ a/arch/h8300/platform/h8300h/ptrace_h8300h.c
@@ -60,7 +60,7 @@ int h8300_put_reg(struct task_struct *ta
 }
 
 /* disable singlestep */
-void h8300_disable_trace(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	if((long)child->thread.breakinfo.addr != -1L) {
 		*child->thread.breakinfo.addr = child->thread.breakinfo.inst;
@@ -264,7 +264,7 @@ static unsigned short *getnextpc(struct 
 
 /* Set breakpoint(s) to simulate a single step from the current PC.  */
 
-void h8300_enable_trace(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	unsigned short *nextpc;
 	nextpc = getnextpc(child,(unsigned short *)h8300_get_reg(child, PT_PC));
@@ -276,7 +276,7 @@ void h8300_enable_trace(struct task_stru
 asmlinkage void trace_trap(unsigned long bp)
 {
 	if ((unsigned long)current->thread.breakinfo.addr == bp) {
-		h8300_disable_trace(current);
+		user_disable_single_step(current);
 		force_sig(SIGTRAP,current);
 	} else
 	        force_sig(SIGILL,current);
diff -puN arch/h8300/platform/h8s/ptrace_h8s.c~h8300-use-generic-ptrace_resume-code arch/h8300/platform/h8s/ptrace_h8s.c
--- a/arch/h8300/platform/h8s/ptrace_h8s.c~h8300-use-generic-ptrace_resume-code
+++ a/arch/h8300/platform/h8s/ptrace_h8s.c
@@ -65,13 +65,13 @@ int h8300_put_reg(struct task_struct *ta
 }
 
 /* disable singlestep */
-void h8300_disable_trace(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	*(unsigned short *)(child->thread.esp0 + h8300_register_offset[PT_EXR]) &= ~EXR_TRACE;
 }
 
 /* enable singlestep */
-void h8300_enable_trace(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	*(unsigned short *)(child->thread.esp0 + h8300_register_offset[PT_EXR]) |= EXR_TRACE;
 }
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch

