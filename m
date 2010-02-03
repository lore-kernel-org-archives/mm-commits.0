From: akpm@linux-foundation.org
Subject: + m68knommu-use-generic-ptrace_resume-code.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:08:55 -0800
Message-ID: <201002032208.o13M8tQ3022011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282Ab0BCWJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, gerg@uclinux.org, oleg@redhat.com, roland@redhat.com


The patch titled
     m68knommu: use generic ptrace_resume code
has been added to the -mm tree.  Its filename is
     m68knommu-use-generic-ptrace_resume-code.patch

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
Subject: m68knommu: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT,
PTRACE_KILL and PTRACE_SINGLESTEP.  m68knommu already defines the
nessecary user_enable_single_step and user_disable_single_step functions
for this.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't which is consistent with all architectures using the
modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/ptrace.c |   56 -------------------------------
 1 file changed, 56 deletions(-)

diff -puN arch/m68knommu/kernel/ptrace.c~m68knommu-use-generic-ptrace_resume-code arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~m68knommu-use-generic-ptrace_resume-code
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -190,62 +190,6 @@ long arch_ptrace(struct task_struct *chi
 			}
 			break;
 
-		case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-		case PTRACE_CONT: { /* restart after signal. */
-			long tmp;
-
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			/* make sure the single step bit is not set. */
-			tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
-
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill. 
-		 * perhaps it should be put in the status that it wants to 
-		 * exit.
-		 */
-		case PTRACE_KILL: {
-			long tmp;
-
-			ret = 0;
-			if (child->exit_state == EXIT_ZOMBIE) /* already dead */
-				break;
-			child->exit_code = SIGKILL;
-			/* make sure the single step bit is not set. */
-			tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-			wake_up_process(child);
-			break;
-		}
-
-		case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-			long tmp;
-
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			tmp = get_reg(child, PT_SR) | (TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-
-			child->exit_code = data;
-			/* give it a chance to run. */
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
-
 		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		  	int i;
 			unsigned long tmp;
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

