From: akpm@linux-foundation.org
Subject: + alpha-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:08:42 -0800
Message-ID: <201002032208.o13M8hen021995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab0BCWJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, ink@jurassic.park.msu.ru, mattst88@gmail.com, oleg@redhat.com, roland@redhat.com, rth@twiddle.net


The patch titled
     alpha: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     alpha-use-generic-ptrace_resume-code.patch

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
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
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

