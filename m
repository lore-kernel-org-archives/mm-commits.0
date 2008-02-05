From: akpm@linux-foundation.org
Subject: - uml-currenth-cleanup.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:35 -0800
Message-ID: <200802052236.m15MaGZT012701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761007AbYBEWmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: current.h cleanup
has been removed from the -mm tree.  Its filename was
     uml-currenth-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -251,7 +251,7 @@ void default_idle(void)
 
 void cpu_idle(void)
 {
-	cpu_tasks[current_thread->cpu].pid = os_getpid();
+	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
 	default_idle();
 }
 
@@ -269,7 +269,7 @@ int user_context(unsigned long sp)
 	unsigned long stack;
 
 	stack = sp & (PAGE_MASK << CONFIG_KERNEL_STACK_ORDER);
-	return stack != (unsigned long) current_thread;
+	return stack != (unsigned long) current_thread_info();
 }
 
 extern exitcall_t __uml_exitcall_begin, __uml_exitcall_end;
@@ -311,7 +311,7 @@ int strlen_user_proc(char __user *str)
 int smp_sigio_handler(void)
 {
 #ifdef CONFIG_SMP
-	int cpu = current_thread->cpu;
+	int cpu = current_thread_info()->cpu;
 	IPI_handler(cpu);
 	if (cpu != 0)
 		return 1;
@@ -321,7 +321,7 @@ int smp_sigio_handler(void)
 
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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
