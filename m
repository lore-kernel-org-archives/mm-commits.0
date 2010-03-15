From: akpm@linux-foundation.org
Subject: [merged] m68knommu-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:46 -0400
Message-ID: <201003150701.o2F71Jj3016773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870Ab0COHBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, gerg@uclinux.org, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     m68knommu-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
