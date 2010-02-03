From: akpm@linux-foundation.org
Subject: + arm-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:08:46 -0800
Message-ID: <201002032208.o13M8lWC021998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606Ab0BCWJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, oleg@redhat.com, rmk@arm.linux.org.uk, roland@redhat.com


The patch titled
     arm: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     arm-use-generic-ptrace_resume-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -736,53 +747,6 @@ long arch_ptrace(struct task_struct *chi
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
-
-/*
  * Send SIGTRAP if we're single-stepping
  */
 static inline void single_step_trap(struct task_struct *task)
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
add-generic-sys_old_select.patch
add-generic-sys_old_select-fix.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch
ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch
alpha-use-generic-ptrace_resume-code.patch
arm-use-generic-ptrace_resume-code.patch
avr32-use-generic-ptrace_resume-code.patch
blackfin-use-generic-ptrace_resume-code.patch
h8300-use-generic-ptrace_resume-code.patch
m68knommu-use-generic-ptrace_resume-code.patch
microblaze-use-generic-ptrace_resume-code.patch
mips-use-generic-ptrace_resume-code.patch
um-use-generic-ptrace_resume-code.patch
xtensa-use-generic-ptrace_resume-code.patch
cris-arch-v10-use-generic-ptrace_resume-code.patch
cris-arch-v32-use-generic-ptrace_resume-code.patch
m32r-use-generic-ptrace_resume-code.patch

