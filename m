From: akpm@linux-foundation.org
Subject: [alternative-merged] blackfin-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Thu, 11 Feb 2010 12:40:53 -0800
Message-ID: <201002112040.o1BKesNE027337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757080Ab0BKUlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:41:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, cooloney@kernel.org, oleg@redhat.com, roland@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     blackfin-use-generic-ptrace_resume-code.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: use generic ptrace_resume code
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
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/ptrace.h |    2 
 arch/blackfin/kernel/ptrace.c      |   59 ++++-----------------------
 2 files changed, 12 insertions(+), 49 deletions(-)

diff -puN arch/blackfin/include/asm/ptrace.h~blackfin-use-generic-ptrace_resume-code arch/blackfin/include/asm/ptrace.h
--- a/arch/blackfin/include/asm/ptrace.h~blackfin-use-generic-ptrace_resume-code
+++ a/arch/blackfin/include/asm/ptrace.h
@@ -97,6 +97,8 @@ struct pt_regs {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step()	(1)
+
 /* user_mode returns true if only one bit is set in IPEND, other than the
    master interrupt enable.  */
 #define user_mode(regs) (!(((regs)->ipend & ~0x10) & (((regs)->ipend & ~0x10) - 1)))
diff -puN arch/blackfin/kernel/ptrace.c~blackfin-use-generic-ptrace_resume-code arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~blackfin-use-generic-ptrace_resume-code
+++ a/arch/blackfin/kernel/ptrace.c
@@ -160,7 +160,15 @@ static inline int is_user_addr_valid(str
 	return -EIO;
 }
 
-void ptrace_enable(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
+{
+	unsigned long tmp;
+	/* make sure the single step bit is not set. */
+	tmp = get_reg(child, PT_SYSCFG) & ~TRACE_BITS;
+	put_reg(child, PT_SYSCFG, tmp);
+}
+
+void user_enable_single_step(struct task_struct *child)
 {
 	unsigned long tmp;
 	tmp = get_reg(child, PT_SYSCFG) | (TRACE_BITS);
@@ -174,10 +182,7 @@ void ptrace_enable(struct task_struct *c
  */
 void ptrace_disable(struct task_struct *child)
 {
-	unsigned long tmp;
-	/* make sure the single step bit is not set. */
-	tmp = get_reg(child, PT_SYSCFG) & ~TRACE_BITS;
-	put_reg(child, PT_SYSCFG, tmp);
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -354,50 +359,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = put_reg(child, addr, data);
 		break;
 
-	case PTRACE_SYSCALL:	/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:	/* restart after signal. */
-		pr_debug("ptrace: syscall/cont\n");
-
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		ptrace_disable(child);
-		pr_debug("ptrace: before wake_up_process\n");
-		wake_up_process(child);
-		ret = 0;
-		break;
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
-		ptrace_disable(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:	/* set the trap flag. */
-		pr_debug("ptrace: single step\n");
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_enable(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS:
 		/* Get all gp regs from the child. */
 		ret = ptrace_getregs(child, datap);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
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

