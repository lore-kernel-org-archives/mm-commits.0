From: akpm@linux-foundation.org
Subject: [merged] ptrace-remove-pt_dtrace-from-arch-m32r.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:25 -0700
Message-ID: <200906182246.n5IMkPYj005433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758993AbZFRWrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     ptrace: remove PT_DTRACE from arch/m32r
has been removed from the -mm tree.  Its filename was
     ptrace-remove-pt_dtrace-from-arch-m32r.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: remove PT_DTRACE from arch/m32r
From: Oleg Nesterov <oleg@redhat.com>

m32r: PTRACE_SINGLESTEP sets PT_DTRACE, it is never used except cleared
after do_execve().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hirokazu Takata <takata@linux-m32r.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/process.c |    5 -----
 arch/m32r/kernel/ptrace.c  |    4 ----
 2 files changed, 9 deletions(-)

diff -puN arch/m32r/kernel/process.c~ptrace-remove-pt_dtrace-from-arch-m32r arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~ptrace-remove-pt_dtrace-from-arch-m32r
+++ a/arch/m32r/kernel/process.c
@@ -302,11 +302,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, &regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
diff -puN arch/m32r/kernel/ptrace.c~ptrace-remove-pt_dtrace-from-arch-m32r arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~ptrace-remove-pt_dtrace-from-arch-m32r
+++ a/arch/m32r/kernel/ptrace.c
@@ -676,10 +676,6 @@ arch_ptrace(struct task_struct *child, l
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		if ((child->ptrace & PT_DTRACE) == 0) {
-			/* Spurious delayed TF traps may occur */
-			child->ptrace |= PT_DTRACE;
-		}
 
 		/* Compute next pc.  */
 		pc = get_stack_long(child, PT_BPC);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

