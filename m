From: akpm@linux-foundation.org
Subject: + uml-get-rid-of-do_longjmp.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:28 -0700
Message-ID: <200708162114.l7GLETMb007101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758306AbXHPVOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: get rid of do_longjmp
has been added to the -mm tree.  Its filename is
     uml-get-rid-of-do_longjmp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: get rid of do_longjmp
From: Jeff Dike <jdike@addtoit.com>

do_longjmp used to be needed when UML didn't have its own implementation of
setjmp and longjmp.  They came from libc, and couldn't be called directly from
kernel code, as the libc jmp_buf couldn't be imported there.  do_longjmp was a
userspace function which served to provide longjmp access to kernel code.

This is gone, and a number of void * pointers can now be jmp_buf *.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h               |    5 ++---
 arch/um/include/um_uaccess.h       |    4 ++++
 arch/um/include/uml_uaccess.h      |   24 ------------------------
 arch/um/kernel/exec.c              |    2 +-
 arch/um/kernel/mem.c               |    2 +-
 arch/um/kernel/trap.c              |    6 +++---
 arch/um/kernel/uaccess.c           |    2 +-
 arch/um/os-Linux/process.c         |    2 +-
 arch/um/os-Linux/trap.c            |    7 -------
 arch/um/os-Linux/uaccess.c         |    2 +-
 include/asm-um/processor-generic.h |    4 ++--
 11 files changed, 16 insertions(+), 44 deletions(-)

diff -puN arch/um/include/os.h~uml-get-rid-of-do_longjmp arch/um/include/os.h
--- a/arch/um/include/os.h~uml-get-rid-of-do_longjmp
+++ a/arch/um/include/os.h
@@ -193,7 +193,7 @@ extern int os_getpid(void);
 extern int os_getpgrp(void);
 
 extern void init_new_thread_signals(void);
-extern int run_kernel_thread(int (*fn)(void *), void *arg, void **jmp_ptr);
+extern int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr);
 
 extern int os_map_memory(void *virt, int fd, unsigned long long off,
 			 unsigned long len, int r, int w, int x);
@@ -206,7 +206,7 @@ extern void os_flush_stdout(void);
 
 /* uaccess.c */
 extern unsigned long __do_user_copy(void *to, const void *from, int n,
-				    void **fault_addr, void **fault_catcher,
+				    void **fault_addr, jmp_buf **fault_catcher,
 				    void (*op)(void *to, const void *from,
 					       int n), int *faulted_out);
 
@@ -240,7 +240,6 @@ extern int set_signals(int enable);
 
 /* trap.c */
 extern void os_fill_handlinfo(struct kern_handlers h);
-extern void do_longjmp(void *p, int val);
 
 /* util.c */
 extern void stack_protections(unsigned long address);
diff -puN arch/um/include/um_uaccess.h~uml-get-rid-of-do_longjmp arch/um/include/um_uaccess.h
--- a/arch/um/include/um_uaccess.h~uml-get-rid-of-do_longjmp
+++ a/arch/um/include/um_uaccess.h
@@ -30,6 +30,10 @@
 extern int copy_from_user(void *to, const void __user *from, int n);
 extern int copy_to_user(void __user *to, const void *from, int n);
 
+extern int __do_copy_to_user(void *to, const void *from, int n,
+			     void **fault_addr, jmp_buf **fault_catcher);
+extern void __do_copy(void *to, const void *from, int n);
+
 /*
  * strncpy_from_user: - Copy a NUL terminated string from userspace.
  * @dst:   Destination address, in kernel space.  This buffer must be at
diff -puN arch/um/include/uml_uaccess.h~uml-get-rid-of-do_longjmp /dev/null
--- a/arch/um/include/uml_uaccess.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __UML_UACCESS_H__
-#define __UML_UACCESS_H__
-
-extern int __do_copy_to_user(void *to, const void *from, int n,
-			     void **fault_addr, void **fault_catcher);
-void __do_copy(void *to, const void *from, int n);
-
-#endif
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
diff -puN arch/um/kernel/exec.c~uml-get-rid-of-do_longjmp arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/kernel/exec.c
@@ -75,7 +75,7 @@ long um_execve(char *file, char __user *
 
 	err = execve1(file, argv, env);
 	if (!err)
-		do_longjmp(current->thread.exec_buf, 1);
+		UML_LONGJMP(current->thread.exec_buf, 1);
 	return err;
 }
 
diff -puN arch/um/kernel/mem.c~uml-get-rid-of-do_longjmp arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/kernel/mem.c
@@ -17,7 +17,7 @@
 #include "as-layout.h"
 #include "kern.h"
 #include "mem_user.h"
-#include "uml_uaccess.h"
+#include "um_uaccess.h"
 #include "os.h"
 #include "linux/types.h"
 #include "linux/string.h"
diff -puN arch/um/kernel/trap.c~uml-get-rid-of-do_longjmp arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/kernel/trap.c
@@ -149,7 +149,7 @@ unsigned long segv(struct faultinfo fi, 
 		   struct uml_pt_regs *regs)
 {
 	struct siginfo si;
-	void *catcher;
+	jmp_buf *catcher;
 	int err;
 	int is_write = FAULT_WRITE(fi);
 	unsigned long address = FAULT_ADDRESS(fi);
@@ -181,7 +181,7 @@ unsigned long segv(struct faultinfo fi, 
 		return 0;
 	else if (catcher != NULL) {
 		current->thread.fault_addr = (void *) address;
-		do_longjmp(catcher, 1);
+		UML_LONGJMP(catcher, 1);
 	}
 	else if (current->thread.fault_addr != NULL)
 		panic("fault_addr set but no fault catcher");
@@ -233,7 +233,7 @@ void relay_signal(int sig, struct uml_pt
 static void bus_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current->thread.fault_catcher != NULL)
-		do_longjmp(current->thread.fault_catcher, 1);
+		UML_LONGJMP(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
 
diff -puN arch/um/kernel/uaccess.c~uml-get-rid-of-do_longjmp arch/um/kernel/uaccess.c
--- a/arch/um/kernel/uaccess.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/kernel/uaccess.c
@@ -18,7 +18,7 @@ void __do_copy(void *to, const void *fro
 
 
 int __do_copy_to_user(void *to, const void *from, int n,
-		      void **fault_addr, void **fault_catcher)
+		      void **fault_addr, jmp_buf **fault_catcher)
 {
 	unsigned long fault;
 	int faulted;
diff -puN arch/um/os-Linux/process.c~uml-get-rid-of-do_longjmp arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/os-Linux/process.c
@@ -249,7 +249,7 @@ void init_new_thread_signals(void)
 	init_irq_signals(1);
 }
 
-int run_kernel_thread(int (*fn)(void *), void *arg, void **jmp_ptr)
+int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
 {
 	jmp_buf buf;
 	int n;
diff -puN arch/um/os-Linux/trap.c~uml-get-rid-of-do_longjmp arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/os-Linux/trap.c
@@ -22,10 +22,3 @@ void os_fill_handlinfo(struct kern_handl
 	sig_info[SIGVTALRM] = h.timer_handler;
 	sig_info[SIGALRM] = h.timer_handler;
 }
-
-void do_longjmp(void *b, int val)
-{
-	jmp_buf *buf = b;
-
-	UML_LONGJMP(buf, val);
-}
diff -puN arch/um/os-Linux/uaccess.c~uml-get-rid-of-do_longjmp arch/um/os-Linux/uaccess.c
--- a/arch/um/os-Linux/uaccess.c~uml-get-rid-of-do_longjmp
+++ a/arch/um/os-Linux/uaccess.c
@@ -8,7 +8,7 @@
 #include "longjmp.h"
 
 unsigned long __do_user_copy(void *to, const void *from, int n,
-			     void **fault_addr, void **fault_catcher,
+			     void **fault_addr, jmp_buf **fault_catcher,
 			     void (*op)(void *to, const void *from,
 					int n), int *faulted_out)
 {
diff -puN include/asm-um/processor-generic.h~uml-get-rid-of-do_longjmp include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-get-rid-of-do_longjmp
+++ a/include/asm-um/processor-generic.h
@@ -30,10 +30,10 @@ struct thread_struct {
 	struct pt_regs regs;
 	int singlestep_syscall;
 	void *fault_addr;
-	void *fault_catcher;
+	jmp_buf *fault_catcher;
 	struct task_struct *prev_sched;
 	unsigned long temp_stack;
-	void *exec_buf;
+	jmp_buf *exec_buf;
 	struct arch_thread arch;
 	jmp_buf switch_buf;
 	int mm_count;
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
