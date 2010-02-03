From: akpm@linux-foundation.org
Subject: + xtensa-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:09:09 -0800
Message-ID: <201002032209.o13M9A8i022027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab0BCWJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, chris@zankel.net, oleg@redhat.com, roland@redhat.com


The patch titled
     xtensa: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     xtensa-use-generic-ptrace_resume-code.patch

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
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *) data);
 		break;
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

