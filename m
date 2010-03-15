From: akpm@linux-foundation.org
Subject: [merged] mips-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:00 -0400
Message-ID: <201003150701.o2F71XoX016780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935792Ab0COHB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, oleg@redhat.com, ralf@linux-mips.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mips: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     mips-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT and
PTRACE_KILL.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't which is consistent with all architectures using the
modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/ptrace.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff -puN arch/mips/kernel/ptrace.c~mips-use-generic-ptrace_resume-code arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~mips-use-generic-ptrace_resume-code
+++ a/arch/mips/kernel/ptrace.c
@@ -493,36 +493,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_setfpregs(child, (__u32 __user *) data);
 		break;
 
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: { /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		child->exit_code = data;
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
-		wake_up_process(child);
-		break;
