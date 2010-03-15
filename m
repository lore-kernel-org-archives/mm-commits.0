From: akpm@linux-foundation.org
Subject: [merged] cris-arch-v10-use-generic-ptrace_resume-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:10 -0400
Message-ID: <201003150701.o2F71hKd016811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935814Ab0COHCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jesper.nilsson@axis.com, oleg@redhat.com, roland@redhat.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris arch-v10: use generic ptrace_resume code
has been removed from the -mm tree.  Its filename was
     cris-arch-v10-use-generic-ptrace_resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris arch-v10: use generic ptrace_resume code
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
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/ptrace.c |   51 ---------------------------
 1 file changed, 51 deletions(-)

diff -puN arch/cris/arch-v10/kernel/ptrace.c~cris-arch-v10-use-generic-ptrace_resume-code arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~cris-arch-v10-use-generic-ptrace_resume-code
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -127,57 +127,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-			
-			if (!valid_signal(data))
-				break;
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
- 		/* Make the child exit by sending it a sigkill. */
-		case PTRACE_KILL:
-			ret = 0;
-			
-			if (child->exit_state == EXIT_ZOMBIE)
-				break;
-			
-			child->exit_code = SIGKILL;
-			
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			break;
-
-		/* Set the trap flag. */
-		case PTRACE_SINGLESTEP:
-			ret = -EIO;
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
