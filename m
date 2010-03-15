From: akpm@linux-foundation.org
Subject: [merged] microblaze-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:56 -0400
Message-ID: <201003150701.o2F71TWl016776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870Ab0COHBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, john.williams@petalogix.com, monstr@monstr.eu, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     microblaze: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     microblaze-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: microblaze: use generic ptrace_resume code
From: Christoph Hellwig <hch@lst.de>

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT and
PTRACE_KILL.  This also makes PTRACE_SINGLESTEP return -EIO while it
previously succeeded despite not actually causing any kind of single
stepping.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL which
it previously wasn't which is consistent with all architectures using the
modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Cc: John Williams <john.williams@petalogix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/ptrace.c |   37 ------------------------------
 1 file changed, 37 deletions(-)

diff -puN arch/microblaze/kernel/ptrace.c~microblaze-use-generic-ptrace_resume-code arch/microblaze/kernel/ptrace.c
--- a/arch/microblaze/kernel/ptrace.c~microblaze-use-generic-ptrace_resume-code
+++ a/arch/microblaze/kernel/ptrace.c
@@ -110,43 +110,6 @@ long arch_ptrace(struct task_struct *chi
 		if (rval == 0 && request == PTRACE_PEEKUSR)
 			rval = put_user(val, (unsigned long *)data);
 		break;
-	/* Continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-		pr_debug("PTRACE_SYSCALL\n");
-	case PTRACE_SINGLESTEP:
-		pr_debug("PTRACE_SINGLESTEP\n");
-	/* Restart after a signal.  */
-	case PTRACE_CONT:
-		pr_debug("PTRACE_CONT\n");
-		rval = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-		child->exit_code = data;
-		pr_debug("wakeup_process\n");
-		wake_up_process(child);
-		rval = 0;
-		break;
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		pr_debug("PTRACE_KILL\n");
-		rval = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
