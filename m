From: akpm@linux-foundation.org
Subject: [merged] cris-arch-v32-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:13 -0400
Message-ID: <201003150701.o2F71kN6016814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935846Ab0COHCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jesper.nilsson@axis.com, oleg@redhat.com, roland@redhat.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris arch-v32: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     cris-arch-v32-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
