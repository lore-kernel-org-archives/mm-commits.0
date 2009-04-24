From: akpm@linux-foundation.org
Subject: + ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:01:47 -0700
Message-ID: <200904240001.n3O01lkL004690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZDXAJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, chris@zankel.net, dhowells@redhat.com, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, kyle@mcmartin.ca, lethal@linux-sh.org, matthew@wil.cx, roland@redhat.com, schwidefsky@de.ibm.com


The patch titled
     ptrace: remove PT_DTRACE from avr32, mn10300, parisc, s390, sh, xtensa
has been added to the -mm tree.  Its filename is
     ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch

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
Subject: ptrace: remove PT_DTRACE from avr32, mn10300, parisc, s390, sh, xtensa
From: Oleg Nesterov <oleg@redhat.com>

avr32, mn10300, parisc, s390, sh, xtensa:

They never set PT_DTRACE, but clear it after do_execve().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christian Zankel <chris@zankel.net>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/process.c       |    2 --
 arch/mn10300/kernel/process.c     |    3 ---
 arch/parisc/hpux/fs.c             |    5 -----
 arch/parisc/kernel/process.c      |    5 -----
 arch/parisc/kernel/sys_parisc32.c |    5 -----
 arch/s390/kernel/compat_linux.c   |    3 ---
 arch/s390/kernel/process.c        |    3 ---
 arch/sh/kernel/process_32.c       |    5 -----
 arch/sh/kernel/process_64.c       |    5 -----
 arch/xtensa/kernel/process.c      |    5 -----
 10 files changed, 41 deletions(-)

diff -puN arch/avr32/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/avr32/kernel/process.c
@@ -394,8 +394,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0)
-		current->ptrace &= ~PT_DTRACE;
 	putname(filename);
 
 out:
diff -puN arch/mn10300/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/mn10300/kernel/process.c
@@ -281,9 +281,6 @@ asmlinkage long sys_execve(char __user *
 	error = PTR_ERR(filename);
 	if (!IS_ERR(filename)) {
 		error = do_execve(filename, argv, envp, __frame);
-		if (error == 0)
-			current->ptrace &= ~PT_DTRACE;
-
 		putname(filename);
 	}
 
diff -puN arch/parisc/hpux/fs.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/parisc/hpux/fs.c
--- a/arch/parisc/hpux/fs.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/parisc/hpux/fs.c
@@ -44,11 +44,6 @@ int hpux_execve(struct pt_regs *regs)
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
 
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 
 out:
diff -puN arch/parisc/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/parisc/kernel/process.c
--- a/arch/parisc/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/parisc/kernel/process.c
@@ -349,11 +349,6 @@ asmlinkage int sys_execve(struct pt_regs
 		goto out;
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
diff -puN arch/parisc/kernel/sys_parisc32.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/parisc/kernel/sys_parisc32.c
--- a/arch/parisc/kernel/sys_parisc32.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/parisc/kernel/sys_parisc32.c
@@ -77,11 +77,6 @@ asmlinkage int sys32_execve(struct pt_re
 		goto out;
 	error = compat_do_execve(filename, compat_ptr(regs->gr[25]),
 				 compat_ptr(regs->gr[24]), regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
diff -puN arch/s390/kernel/compat_linux.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/s390/kernel/compat_linux.c
@@ -461,9 +461,6 @@ asmlinkage long sys32_execve(void)
 		result = rc;
 		goto out_putname;
 	}
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc=0;
 	asm volatile("sfpc %0,0" : : "d" (0));
 	result = regs->gprs[2];
diff -puN arch/s390/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/s390/kernel/process.c
--- a/arch/s390/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/s390/kernel/process.c
@@ -265,9 +265,6 @@ SYSCALL_DEFINE0(vfork)
 
 asmlinkage void execve_tail(void)
 {
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc = 0;
 	if (MACHINE_HAS_IEEE)
 		asm volatile("sfpc %0,%0" : : "d" (0));
diff -puN arch/sh/kernel/process_32.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/sh/kernel/process_32.c
@@ -366,11 +366,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
diff -puN arch/sh/kernel/process_64.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/sh/kernel/process_64.c
@@ -529,11 +529,6 @@ asmlinkage int sys_execve(char *ufilenam
 			  (char __user * __user *)uargv,
 			  (char __user * __user *)uenvp,
 			  pregs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
diff -puN arch/xtensa/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa
+++ a/arch/xtensa/kernel/process.c
@@ -331,11 +331,6 @@ long xtensa_execve(char __user *name, ch
 	if (IS_ERR(filename))
 		goto out;
 	error = do_execve(filename, argv, envp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
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

