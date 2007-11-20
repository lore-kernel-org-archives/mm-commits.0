From: akpm@linux-foundation.org
Subject: + uml-currenth-cleanup.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:22:07 -0800
Message-ID: <200711200022.lAK0M7Au004174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbXKTAWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: current.h cleanup
has been added to the -mm tree.  Its filename is
     uml-currenth-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: current.h cleanup
From: Jeff Dike <jdike@addtoit.com>

Tidy current-related stuff.  There was a comment in current.h saying
that current_thread was obsolete, so this patch turns all instances of
current_thread into current_thread_info().  There's some simplifying
of the result in arch/um/sys-i386/signal.c.

current.h and thread_info also get style cleanups.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c     |    8 ++++----
 arch/um/sys-i386/signal.c    |   18 ++++++++----------
 arch/um/sys-x86_64/signal.c  |    4 ++--
 include/asm-um/current.h     |   23 ++---------------------
 include/asm-um/thread_info.h |    8 ++++----
 5 files changed, 20 insertions(+), 41 deletions(-)

diff -puN arch/um/kernel/process.c~uml-currenth-cleanup arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-currenth-cleanup
+++ a/arch/um/kernel/process.c
@@ -252,7 +252,7 @@ void default_idle(void)
 
 void cpu_idle(void)
 {
-	cpu_tasks[current_thread->cpu].pid = os_getpid();
+	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
 	default_idle();
 }
 
@@ -266,7 +266,7 @@ int user_context(unsigned long sp)
 	unsigned long stack;
 
 	stack = sp & (PAGE_MASK << CONFIG_KERNEL_STACK_ORDER);
-	return stack != (unsigned long) current_thread;
+	return stack != (unsigned long) current_thread_info();
 }
 
 extern exitcall_t __uml_exitcall_begin, __uml_exitcall_end;
@@ -308,7 +308,7 @@ int strlen_user_proc(char __user *str)
 int smp_sigio_handler(void)
 {
 #ifdef CONFIG_SMP
-	int cpu = current_thread->cpu;
+	int cpu = current_thread_info()->cpu;
 	IPI_handler(cpu);
 	if (cpu != 0)
 		return 1;
@@ -318,7 +318,7 @@ int smp_sigio_handler(void)
 
 int cpu(void)
 {
-	return current_thread->cpu;
+	return current_thread_info()->cpu;
 }
 
 static atomic_t using_sysemu = ATOMIC_INIT(0);
diff -puN arch/um/sys-i386/signal.c~uml-currenth-cleanup arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-currenth-cleanup
+++ a/arch/um/sys-i386/signal.c
@@ -168,12 +168,13 @@ static int copy_sc_from_user(struct pt_r
 			     struct sigcontext __user *from)
 {
 	struct sigcontext sc;
-	int err;
+	int err, pid;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
 	if (err)
 		return err;
 
+	pid = userspace_pid[current_thread_info()->cpu];
 	copy_sc(&regs->regs, &sc);
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
@@ -187,8 +188,7 @@ static int copy_sc_from_user(struct pt_r
 		if (err)
 			return 1;
 
-		err = restore_fpx_registers(userspace_pid[current_thread->cpu],
-					    (unsigned long *) &fpx);
+		err = restore_fpx_registers(pid, (unsigned long *) &fpx);
 		if (err < 0) {
 			printk(KERN_ERR "copy_sc_from_user - "
 			       "restore_fpx_registers failed, errno = %d\n",
@@ -204,8 +204,7 @@ static int copy_sc_from_user(struct pt_r
 		if (err)
 			return 1;
 
-		err = restore_fp_registers(userspace_pid[current_thread->cpu],
-					   (unsigned long *) &fp);
+		err = restore_fp_registers(pid, (unsigned long *) &fp);
 		if (err < 0) {
 			printk(KERN_ERR "copy_sc_from_user - "
 			       "restore_fp_registers failed, errno = %d\n",
@@ -223,7 +222,7 @@ static int copy_sc_to_user(struct sigcon
 {
 	struct sigcontext sc;
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
-	int err;
+	int err, pid;
 
 	sc.gs = REGS_GS(regs->regs.gp);
 	sc.fs = REGS_FS(regs->regs.gp);
@@ -249,11 +248,11 @@ static int copy_sc_to_user(struct sigcon
 	to_fp = (to_fp ? to_fp : (struct _fpstate __user *) (to + 1));
 	sc.fpstate = to_fp;
 
+	pid = userspace_pid[current_thread_info()->cpu];
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
-		err = save_fpx_registers(userspace_pid[current_thread->cpu],
-					 (unsigned long *) &fpx);
+		err = save_fpx_registers(pid, (unsigned long *) &fpx);
 		if (err < 0){
 			printk(KERN_ERR "copy_sc_to_user - save_fpx_registers "
 			       "failed, errno = %d\n", err);
@@ -276,8 +275,7 @@ static int copy_sc_to_user(struct sigcon
 	else {
 		struct user_i387_struct fp;
 
-		err = save_fp_registers(userspace_pid[current_thread->cpu],
-					(unsigned long *) &fp);
+		err = save_fp_registers(pid, (unsigned long *) &fp);
 		if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
 			return 1;
 	}
diff -puN arch/um/sys-x86_64/signal.c~uml-currenth-cleanup arch/um/sys-x86_64/signal.c
--- a/arch/um/sys-x86_64/signal.c~uml-currenth-cleanup
+++ a/arch/um/sys-x86_64/signal.c
@@ -81,7 +81,7 @@ static int copy_sc_from_user(struct pt_r
 	if (err)
 		return 1;
 
-	err = restore_fp_registers(userspace_pid[current_thread->cpu],
+	err = restore_fp_registers(userspace_pid[current_thread_info()->cpu],
 				   (unsigned long *) &fp);
 	if (err < 0) {
 		printk(KERN_ERR "copy_sc_from_user - "
@@ -143,7 +143,7 @@ static int copy_sc_to_user(struct sigcon
 	if (err)
 		return 1;
 
-	err = save_fp_registers(userspace_pid[current_thread->cpu],
+	err = save_fp_registers(userspace_pid[current_thread_info()->cpu],
 				(unsigned long *) &fp);
 	if (err < 0) {
 		printk(KERN_ERR "copy_sc_from_user - restore_fp_registers "
diff -puN include/asm-um/current.h~uml-currenth-cleanup include/asm-um/current.h
--- a/include/asm-um/current.h~uml-currenth-cleanup
+++ a/include/asm-um/current.h
@@ -1,32 +1,13 @@
-/* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __UM_CURRENT_H
 #define __UM_CURRENT_H
 
-#ifndef __ASSEMBLY__
-
-#include "asm/page.h"
 #include "linux/thread_info.h"
 
 #define current (current_thread_info()->task)
 
-/*Backward compatibility - it's used inside arch/um.*/
-#define current_thread current_thread_info()
-
-#endif /* __ASSEMBLY__ */
-
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN include/asm-um/thread_info.h~uml-currenth-cleanup include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-currenth-cleanup
+++ a/include/asm-um/thread_info.h
@@ -1,5 +1,5 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -76,8 +76,8 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling 
-					 * TIF_NEED_RESCHED 
+#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling
+					 * TIF_NEED_RESCHED
 					 */
 #define TIF_RESTART_BLOCK 	4
 #define TIF_MEMDIE	 	5
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-clean-up-task-size-calculation.patch
uml-add-virt_to_pte.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
