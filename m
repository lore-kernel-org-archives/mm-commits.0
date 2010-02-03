From: akpm@linux-foundation.org
Subject: + avr32-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:08:49 -0800
Message-ID: <201002032208.o13M8nbj022001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab0BCWJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, hskinnemoen@atmel.com, oleg@redhat.com, roland@redhat.com


The patch titled
     avr32: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     avr32-use-generic-ptrace_resume-code.patch

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
-
 	case PTRACE_GETREGS:
 		ret = ptrace_getregs(child, (void __user *)data);
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

