From: akpm@linux-foundation.org
Subject: + um-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:09:06 -0800
Message-ID: <201002032209.o13M972P022023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab0BCWKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:10:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jdike@addtoit.com, oleg@redhat.com, roland@redhat.com


The patch titled
     um: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     um-use-generic-ptrace_resume-code.patch

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
-
 #ifdef PTRACE_GETREGS
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		if (!access_ok(VERIFY_WRITE, p, MAX_REG_OFFSET)) {
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

