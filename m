From: akpm@linux-foundation.org
Subject: + cris-arch-v32-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:09:16 -0800
Message-ID: <201002032209.o13M9G39022042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab0BCWQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:16:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jesper.nilsson@axis.com, oleg@redhat.com, roland@redhat.com, starvik@axis.com


The patch titled
     cris arch-v32: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     cris-arch-v32-use-generic-ptrace_resume-code.patch

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
Subject: cris arch-v32: use generic ptrace_resume code
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

The way breakpoints are disabled is entirely inconsistent currently, I
tried to make some sense of it, but I suspect all of the content of
ptrace_disable should be moved into user_disable_single_step, this
defintively needs some revisting as the current patch changes behaviour in
not quite designed ways.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/kernel/ptrace.c       |  109 +++++----------------
 arch/cris/include/arch-v32/arch/ptrace.h |    1 
 2 files changed, 31 insertions(+), 79 deletions(-)

diff -puN arch/cris/arch-v32/kernel/ptrace.c~cris-arch-v32-use-generic-ptrace_resume-code arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~cris-arch-v32-use-generic-ptrace_resume-code
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -78,6 +78,35 @@ int put_reg(struct task_struct *task, un
 	return 0;
 }
 
+void user_enable_single_step(struct task_struct *child)
+{
+	unsigned long tmp;
+
+	/*
+	 * Set up SPC if not set already (in which case we have no other
+	 * choice but to trust it).
+	 */
+	if (!get_reg(child, PT_SPC)) {
+		/* In case we're stopped in a delay slot. */
+		tmp = get_reg(child, PT_ERP) & ~1;
+		put_reg(child, PT_SPC, tmp);
+	}
+	tmp = get_reg(child, PT_CCS) | SBIT_USER;
+	put_reg(child, PT_CCS, tmp);
+}
+
+void user_disable_single_step(struct task_struct *child)
+{
+	put_reg(child, PT_SPC, 0);
+
+	if (!get_debugreg(child->pid, PT_BP_CTRL)) {
+		unsigned long tmp;
+		/* If no h/w bp configured, disable S bit. */
+		tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
+		put_reg(child, PT_CCS, tmp);
+	}
+}
+
 /*
  * Called by kernel/ptrace.c when detaching.
  *
@@ -89,8 +118,7 @@ ptrace_disable(struct task_struct *child
 	unsigned long tmp;
 
 	/* Deconfigure SPC and S-bit. */
-	tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
-	put_reg(child, PT_CCS, tmp);
+	user_disable_single_step(child);
 	put_reg(child, PT_SPC, 0);
 
 	/* Deconfigure any watchpoints associated with the child. */
@@ -169,83 +197,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-
-			if (!valid_signal(data))
-				break;
-
-			/* Continue means no single-step. */
-			put_reg(child, PT_SPC, 0);
-
-			if (!get_debugreg(child->pid, PT_BP_CTRL)) {
-				unsigned long tmp;
-				/* If no h/w bp configured, disable S bit. */
-				tmp = get_reg(child, PT_CCS) & ~SBIT_USER;
-				put_reg(child, PT_CCS, tmp);
-			}
-
-			if (request == PTRACE_SYSCALL) {
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-			else {
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-
-			child->exit_code = data;
-
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			ret = 0;
-
-			break;
-
-		/* Make the child exit by sending it a sigkill. */
-		case PTRACE_KILL:
-			ret = 0;
-
-			if (child->exit_state == EXIT_ZOMBIE)
-				break;
-
-			child->exit_code = SIGKILL;
-
-			/* Deconfigure single-step and h/w bp. */
-			ptrace_disable(child);
-
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			break;
-
-		/* Set the trap flag. */
-		case PTRACE_SINGLESTEP:	{
-			unsigned long tmp;
-			ret = -EIO;
-
-			/* Set up SPC if not set already (in which case we have
-			   no other choice but to trust it). */
-			if (!get_reg(child, PT_SPC)) {
-				/* In case we're stopped in a delay slot. */
-				tmp = get_reg(child, PT_ERP) & ~1;
-				put_reg(child, PT_SPC, tmp);
-			}
-			tmp = get_reg(child, PT_CCS) | SBIT_USER;
-			put_reg(child, PT_CCS, tmp);
-
-			if (!valid_signal(data))
-				break;
-
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-			/* TODO: set some clever breakpoint mechanism... */
-
-			child->exit_code = data;
-			wake_up_process(child);
-			ret = 0;
-			break;
-
-		}
-
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
 			int i;
diff -puN arch/cris/include/arch-v32/arch/ptrace.h~cris-arch-v32-use-generic-ptrace_resume-code arch/cris/include/arch-v32/arch/ptrace.h
--- a/arch/cris/include/arch-v32/arch/ptrace.h~cris-arch-v32-use-generic-ptrace_resume-code
+++ a/arch/cris/include/arch-v32/arch/ptrace.h
@@ -108,6 +108,7 @@ struct switch_stack {
 
 #ifdef __KERNEL__
 
+#define arch_has_single_step() (1)
 #define user_mode(regs) (((regs)->ccs & (1 << (U_CCS_BITNR + CCS_SHIFT))) != 0)
 #define instruction_pointer(regs) ((regs)->erp)
 extern void show_regs(struct pt_regs *);
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

