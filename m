From: akpm@linux-foundation.org
Subject: + x86-32-ptrace-generic-resume.patch added to -mm tree
Date: Tue, 27 Nov 2007 00:47:50 -0800
Message-ID: <200711270847.lAR8logT003291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbXK0Isc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 03:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     From: Roland McGrath <roland@redhat.com>
has been added to the -mm tree.  Its filename is
     x86-32-ptrace-generic-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Roland McGrath <roland@redhat.com>


This removes the handling for PTRACE_CONT et al from the 32-bit
ptrace code, so it uses the new generic code via ptrace_request.

Signed-off-by: Roland McGrath <roland@redhat.com>
---

index a493017..50882b3 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace_32.c |   57 ----------------------------------
 1 file changed, 57 deletions(-)

diff -puN arch/x86/kernel/ptrace_32.c~x86-32-ptrace-generic-resume arch/x86/kernel/ptrace_32.c
--- a/arch/x86/kernel/ptrace_32.c~x86-32-ptrace-generic-resume
+++ a/arch/x86/kernel/ptrace_32.c
@@ -277,63 +277,6 @@ long arch_ptrace(struct task_struct *chi
 		  }
 		  break;
 
-	case PTRACE_SYSEMU: /* continue and stop at next syscall, which will not be executed */
-	case PTRACE_SYSCALL:	/* continue and stop at next (return from) syscall */
-	case PTRACE_CONT:	/* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSEMU) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		} else if (request == PTRACE_SYSCALL) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-		} else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		child->exit_code = data;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-/*
- * make the child exit.  Best I can do is send it a sigkill. 
- * perhaps it should be put in the status that it wants to 
- * exit.
- */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		/* make sure the single step bit is not set. */
-		user_disable_single_step(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SYSEMU_SINGLESTEP: /* Same as SYSEMU, but singlestep if not syscall */
-	case PTRACE_SINGLESTEP:	/* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		if (request == PTRACE_SYSEMU_SINGLESTEP)
-			set_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
-
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		user_enable_single_step(child);
-		child->exit_code = data;
-		/* give it a chance to run. */
-		wake_up_process(child);
-		ret = 0;
-		break;
-
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 	  	if (!access_ok(VERIFY_WRITE, datap, FRAME_SIZE*sizeof(long))) {
 			ret = -EIO;
_

Patches currently in -mm which might be from roland@redhat.com are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-x86.patch
wait_task_stopped-pass-correct-exit_code-to.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
use-__set_task_state-for-traced-stopped-tasks.patch
do_wait-remove-one-else-if-branch.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
ptrace-arch_has_single_step.patch
x86-segment-selector-macros.patch
x86-remove-trap_flag.patch
x86-arch_has_single_step.patch
x86-single_step-moved.patch
x86-single_step-segment-macros.patch
x86-single_step-0xf0.patch
x86-single_step-share-code.patch
x86-single_step-tif_forced_tf.patch
ptrace-generic-resume.patch
x86-64-ptrace-generic-resume.patch
x86-32-ptrace-generic-resume.patch
powerpc-arch_has_single_step.patch
powerpc-ptrace-generic-resume.patch
x86-32-ptrace-use-task_pt_regs.patch
x86-64-ptrace-use-task_pt_regs.patch
x86-64-ptrace-debugreg-cleanup.patch
x86-64-ia32-ptrace-debugreg-cleanup.patch
x86-32-ptrace-debugreg-cleanup.patch
ptrace-arch_has_block_step.patch
ptrace-generic-ptrace_singleblock.patch
x86-debugctlmsr-constants.patch
x86-debugctlmsr-kconfig.patch
x86-debugctlmsr-context-switch.patch
x86-debugctlmsr-arch_has_block_step.patch
x86-debugctlmsr-kprobes.patch
x86-ptrace_singleblock.patch
