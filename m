From: akpm@linux-foundation.org
Subject: + ptrace-remove-pt_dtrace-from-arch-m32r.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:01:53 -0700
Message-ID: <200904240001.n3O01rfF004700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZDXAFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:05:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, takata@linux-m32r.org


The patch titled
     ptrace: remove PT_DTRACE from arch/m32r
has been added to the -mm tree.  Its filename is
     ptrace-remove-pt_dtrace-from-arch-m32r.patch

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
Subject: ptrace: remove PT_DTRACE from arch/m32r
From: Oleg Nesterov <oleg@redhat.com>

m32r: PTRACE_SINGLESTEP sets PT_DTRACE, it is never used except cleared
after do_execve().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
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

slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

