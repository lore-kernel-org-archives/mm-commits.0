From: akpm@linux-foundation.org
Subject: + uml-stop-saving-process-fp-state.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:50:20 -0700
Message-ID: <200708061950.l76JoKxw011796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXHFTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: stop saving process FP state
has been added to the -mm tree.  Its filename is
     uml-stop-saving-process-fp-state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: stop saving process FP state
From: Jeff Dike <jdike@addtoit.com>

Throw out a lot of code dealing with saving and restoring floating-point
state.  In skas mode, where processes run in a restoring floating-point state
on kernel entry and exit is pointless.

This eliminates most of arch/um/os-Linux/sys-{i386,x86_64}/registers.c.  Most
of what remained is now arch-indpendent, and can be moved up to
arch/um/os-Linux/registers.c.  Both arches need the jmp_buf accessor
get_thread_reg, and i386 needs {save,restore}_fp_regs because it cheats during
sigreturn by getting the fp state using ptrace rather than copying it out of
the process sigcontext.

After this, it turns out that arch/um/include/skas/mode-skas.h is almost
completely unneeded.  The declarations in it are variables which either don't
exist or which don't have global scope.  The one exception is
kill_off_processes_skas.  If that's removed, this header can be deleted.

This uncovered a bug in user.h, which wasn't correctly making sure that a
size_t definition was available to both userspace and kernelspace files.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h                    |    2 
 arch/um/include/registers.h             |    2 
 arch/um/include/skas/mode-skas.h        |    9 -
 arch/um/include/sysdep-i386/ptrace.h    |   11 --
 arch/um/include/user.h                  |    8 +
 arch/um/os-Linux/Makefile               |    8 -
 arch/um/os-Linux/registers.c            |   54 +++++++++++
 arch/um/os-Linux/skas/mem.c             |    2 
 arch/um/os-Linux/skas/process.c         |    8 -
 arch/um/os-Linux/sys-i386/registers.c   |  108 ----------------------
 arch/um/os-Linux/sys-x86_64/Makefile    |    2 
 arch/um/os-Linux/sys-x86_64/registers.c |   76 ---------------
 12 files changed, 74 insertions(+), 216 deletions(-)

diff -puN arch/um/include/os.h~uml-stop-saving-process-fp-state arch/um/include/os.h
--- a/arch/um/include/os.h~uml-stop-saving-process-fp-state
+++ a/arch/um/include/os.h
@@ -307,6 +307,8 @@ extern int protect(struct mm_id * mm_idp
 extern int is_skas_winch(int pid, int fd, void *data);
 extern int start_userspace(unsigned long stub_stack);
 extern int copy_context_skas0(unsigned long stack, int pid);
+extern void save_registers(int pid, union uml_pt_regs *regs);
+extern void restore_registers(int pid, union uml_pt_regs *regs);
 extern void userspace(union uml_pt_regs *regs);
 extern void map_stub_pages(int fd, unsigned long code,
 			   unsigned long data, unsigned long stack);
diff -puN arch/um/include/registers.h~uml-stop-saving-process-fp-state arch/um/include/registers.h
--- a/arch/um/include/registers.h~uml-stop-saving-process-fp-state
+++ a/arch/um/include/registers.h
@@ -15,7 +15,7 @@ extern int restore_fp_registers(int pid,
 extern void save_registers(int pid, union uml_pt_regs *regs);
 extern void restore_registers(int pid, union uml_pt_regs *regs);
 extern void init_registers(int pid);
-extern void get_safe_registers(unsigned long * regs, unsigned long * fp_regs);
+extern void get_safe_registers(unsigned long *regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
 
 #endif
diff -puN arch/um/include/skas/mode-skas.h~uml-stop-saving-process-fp-state arch/um/include/skas/mode-skas.h
--- a/arch/um/include/skas/mode-skas.h~uml-stop-saving-process-fp-state
+++ a/arch/um/include/skas/mode-skas.h
@@ -1,18 +1,11 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
 #ifndef __MODE_SKAS_H__
 #define __MODE_SKAS_H__
 
-#include <sysdep/ptrace.h>
-
-extern unsigned long exec_regs[];
-extern unsigned long exec_fp_regs[];
-extern unsigned long exec_fpx_regs[];
-extern int have_fpx_regs;
-
 extern void kill_off_processes_skas(void);
 
 #endif
diff -puN arch/um/include/sysdep-i386/ptrace.h~uml-stop-saving-process-fp-state arch/um/include/sysdep-i386/ptrace.h
--- a/arch/um/include/sysdep-i386/ptrace.h~uml-stop-saving-process-fp-state
+++ a/arch/um/include/sysdep-i386/ptrace.h
@@ -219,14 +219,3 @@ struct syscall_args {
         CHOOSE_MODE((&(r)->tt.faultinfo), (&(r)->skas.faultinfo))
 
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
diff -puN arch/um/include/user.h~uml-stop-saving-process-fp-state arch/um/include/user.h
--- a/arch/um/include/user.h~uml-stop-saving-process-fp-state
+++ a/arch/um/include/user.h
@@ -14,10 +14,12 @@
  */
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
-/*
- * This will provide the size_t definition in both kernel and userspace builds
- */
+/* This is to get size_t */
+#ifdef __KERNEL__
 #include <linux/types.h>
+#else
+#include <stddef.h>
+#endif
 
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
diff -puN arch/um/os-Linux/Makefile~uml-stop-saving-process-fp-state arch/um/os-Linux/Makefile
--- a/arch/um/os-Linux/Makefile~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/Makefile
@@ -4,8 +4,8 @@
 #
 
 obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
-	sigio.o signal.o start_up.o time.o trap.o tty.o uaccess.o umid.o tls.o \
-	user_syms.o util.o drivers/ sys-$(SUBARCH)/
+	registers.o sigio.o signal.o start_up.o time.o trap.o tty.o uaccess.o \
+	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/
 
 obj-$(CONFIG_MODE_SKAS) += skas/
 
@@ -16,8 +16,8 @@ obj-$(CONFIG_TTY_LOG) += tty_log.o
 user-objs-$(CONFIG_TTY_LOG) += tty_log.o
 
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
-	main.o mem.o process.o sigio.o signal.o start_up.o time.o trap.o tty.o \
-	tls.o uaccess.o umid.o util.o
+	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
+	trap.o tty.o tls.o uaccess.o umid.o util.o
 
 CFLAGS_user_syms.o += -DSUBARCH_$(SUBARCH)
 
diff -puN /dev/null arch/um/os-Linux/registers.c
--- /dev/null
+++ a/arch/um/os-Linux/registers.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2004 PathScale, Inc
+ * Licensed under the GPL
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <sys/ptrace.h>
+#include "user.h"
+#include "sysdep/ptrace.h"
+
+/* This is set once at boot time and not changed thereafter */
+
+static unsigned long exec_regs[MAX_REG_NR];
+
+void init_thread_registers(union uml_pt_regs *to)
+{
+	memcpy(to->skas.regs, exec_regs, sizeof(to->skas.regs));
+}
+
+void save_registers(int pid, union uml_pt_regs *regs)
+{
+	int err;
+
+	err = ptrace(PTRACE_GETREGS, pid, 0, regs->skas.regs);
+	if(err < 0)
+		panic("save_registers - saving registers failed, errno = %d\n",
+		      errno);
+}
+
+void restore_registers(int pid, union uml_pt_regs *regs)
+{
+	int err;
+
+	err = ptrace(PTRACE_SETREGS, pid, 0, regs->skas.regs);
+	if(err < 0)
+		panic("restore_registers - saving registers failed, "
+		      "errno = %d\n", errno);
+}
+
+void init_registers(int pid)
+{
+	int err;
+
+	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
+	if(err)
+		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
+		      errno);
+}
+
+void get_safe_registers(unsigned long *regs)
+{
+	memcpy(regs, exec_regs, sizeof(exec_regs));
+}
diff -puN arch/um/os-Linux/skas/mem.c~uml-stop-saving-process-fp-state arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/skas/mem.c
@@ -44,7 +44,7 @@ static unsigned long syscall_regs[MAX_RE
 
 static int __init init_syscall_regs(void)
 {
-	get_safe_registers(syscall_regs, NULL);
+	get_safe_registers(syscall_regs);
 	syscall_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
 		((unsigned long) &batch_syscall_stub -
 		 (unsigned long) &__syscall_stub_start);
diff -puN arch/um/os-Linux/skas/process.c~uml-stop-saving-process-fp-state arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/skas/process.c
@@ -357,11 +357,10 @@ void userspace(union uml_pt_regs *regs)
 }
 
 static unsigned long thread_regs[MAX_REG_NR];
-static unsigned long thread_fp_regs[HOST_FP_SIZE];
 
 static int __init init_thread_regs(void)
 {
-	get_safe_registers(thread_regs, thread_fp_regs);
+	get_safe_registers(thread_regs);
 	/* Set parent's instruction pointer to start of clone-stub */
 	thread_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
 				(unsigned long) stub_clone_handler -
@@ -398,11 +397,6 @@ int copy_context_skas0(unsigned long new
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
 		      "pid = %d, errno = %d\n", pid, -err);
 
-	err = ptrace_setfpregs(pid, thread_fp_regs);
-	if(err < 0)
-		panic("copy_context_skas0 : PTRACE_SETFPREGS failed, "
-		      "pid = %d, errno = %d\n", pid, -err);
-
 	/* set a well known return code for detection of child write failure */
 	child_data->err = 12345678;
 
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-stop-saving-process-fp-state arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -4,30 +4,10 @@
  */
 
 #include <errno.h>
-#include <string.h>
-#include "sysdep/ptrace_user.h"
-#include "sysdep/ptrace.h"
-#include "uml-config.h"
-#include "skas_ptregs.h"
-#include "registers.h"
+#include <sysdep/ptrace_user.h>
 #include "longjmp.h"
 #include "user.h"
 
-/* These are set once at boot time and not changed thereafter */
-
-static unsigned long exec_regs[MAX_REG_NR];
-static unsigned long exec_fp_regs[HOST_FP_SIZE];
-static unsigned long exec_fpx_regs[HOST_XFP_SIZE];
-static int have_fpx_regs = 1;
-
-void init_thread_registers(union uml_pt_regs *to)
-{
-	memcpy(to->skas.regs, exec_regs, sizeof(to->skas.regs));
-	memcpy(to->skas.fp, exec_fp_regs, sizeof(to->skas.fp));
-	if(have_fpx_regs)
-		memcpy(to->skas.xfp, exec_fpx_regs, sizeof(to->skas.xfp));
-}
-
 /* XXX These need to use [GS]ETFPXREGS and copy_sc_{to,from}_user_skas needs
  * to pass in a sufficiently large buffer
  */
@@ -45,92 +25,6 @@ int restore_fp_registers(int pid, unsign
 	return 0;
 }
 
-static int move_registers(int pid, int int_op, union uml_pt_regs *regs,
-			  int fp_op, unsigned long *fp_regs)
-{
-	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return -errno;
-
-	if(ptrace(fp_op, pid, 0, fp_regs) < 0)
-		return -errno;
-
-	return 0;
-}
-
-void save_registers(int pid, union uml_pt_regs *regs)
-{
-	unsigned long *fp_regs;
-	int err, fp_op;
-
-	if(have_fpx_regs){
-		fp_op = PTRACE_GETFPXREGS;
-		fp_regs = regs->skas.xfp;
-	}
-	else {
-		fp_op = PTRACE_GETFPREGS;
-		fp_regs = regs->skas.fp;
-	}
-
-	err = move_registers(pid, PTRACE_GETREGS, regs, fp_op, fp_regs);
-	if(err)
-		panic("save_registers - saving registers failed, errno = %d\n",
-		      -err);
-}
-
-void restore_registers(int pid, union uml_pt_regs *regs)
-{
-	unsigned long *fp_regs;
-	int err, fp_op;
-
-	if(have_fpx_regs){
-		fp_op = PTRACE_SETFPXREGS;
-		fp_regs = regs->skas.xfp;
-	}
-	else {
-		fp_op = PTRACE_SETFPREGS;
-		fp_regs = regs->skas.fp;
-	}
-
-	err = move_registers(pid, PTRACE_SETREGS, regs, fp_op, fp_regs);
-	if(err)
-		panic("restore_registers - saving registers failed, "
-		      "errno = %d\n", -err);
-}
-
-void init_registers(int pid)
-{
-	int err;
-
-	memset(exec_regs, 0, sizeof(exec_regs));
-	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
-	if(err)
-		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
-		      errno);
-
-	errno = 0;
-	err = ptrace(PTRACE_GETFPXREGS, pid, 0, exec_fpx_regs);
-	if(!err)
-		return;
-	if(errno != EIO)
-		panic("check_ptrace : PTRACE_GETFPXREGS failed, errno = %d",
-		      errno);
-
-	have_fpx_regs = 0;
-
-	err = ptrace(PTRACE_GETFPREGS, pid, 0, exec_fp_regs);
-	if(err)
-		panic("check_ptrace : PTRACE_GETFPREGS failed, errno = %d",
-		      errno);
-}
-
-void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
-{
-	memcpy(regs, exec_regs, sizeof(exec_regs));
-	if(fp_regs != NULL)
-		memcpy(fp_regs, exec_fp_regs,
-		       HOST_FP_SIZE * sizeof(unsigned long));
-}
-
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
 	switch(reg){
diff -puN arch/um/os-Linux/sys-x86_64/Makefile~uml-stop-saving-process-fp-state arch/um/os-Linux/sys-x86_64/Makefile
--- a/arch/um/os-Linux/sys-x86_64/Makefile~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/sys-x86_64/Makefile
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+# Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
 # Licensed under the GPL
 #
 
diff -puN arch/um/os-Linux/sys-x86_64/registers.c~uml-stop-saving-process-fp-state arch/um/os-Linux/sys-x86_64/registers.c
--- a/arch/um/os-Linux/sys-x86_64/registers.c~uml-stop-saving-process-fp-state
+++ a/arch/um/os-Linux/sys-x86_64/registers.c
@@ -1,83 +1,13 @@
 /*
- * Copyright (C) 2004 PathScale, Inc
+ * Copyright (C) 2006-2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <errno.h>
-#include <string.h>
-#include "ptrace_user.h"
-#include "uml-config.h"
-#include "skas_ptregs.h"
-#include "registers.h"
+#define __FRAME_OFFSETS
+#include <asm/ptrace.h>
 #include "longjmp.h"
 #include "user.h"
 
-/* These are set once at boot time and not changed thereafter */
-
-static unsigned long exec_regs[MAX_REG_NR];
-static unsigned long exec_fp_regs[HOST_FP_SIZE];
-
-void init_thread_registers(union uml_pt_regs *to)
-{
-	memcpy(to->skas.regs, exec_regs, sizeof(to->skas.regs));
-	memcpy(to->skas.fp, exec_fp_regs, sizeof(to->skas.fp));
-}
-
-static int move_registers(int pid, int int_op, int fp_op,
-			  union uml_pt_regs *regs)
-{
-	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return -errno;
-
-	if(ptrace(fp_op, pid, 0, regs->skas.fp) < 0)
-		return -errno;
-
-	return 0;
-}
-
-void save_registers(int pid, union uml_pt_regs *regs)
-{
-	int err;
-
-	err = move_registers(pid, PTRACE_GETREGS, PTRACE_GETFPREGS, regs);
-	if(err)
-		panic("save_registers - saving registers failed, errno = %d\n",
-		      -err);
-}
-
-void restore_registers(int pid, union uml_pt_regs *regs)
-{
-	int err;
-
-	err = move_registers(pid, PTRACE_SETREGS, PTRACE_SETFPREGS, regs);
-	if(err)
-		panic("restore_registers - saving registers failed, "
-		      "errno = %d\n", -err);
-}
-
-void init_registers(int pid)
-{
-	int err;
-
-	err = ptrace(PTRACE_GETREGS, pid, 0, exec_regs);
-	if(err)
-		panic("check_ptrace : PTRACE_GETREGS failed, errno = %d",
-		      errno);
-
-	err = ptrace(PTRACE_GETFPREGS, pid, 0, exec_fp_regs);
-	if(err)
-		panic("check_ptrace : PTRACE_GETFPREGS failed, errno = %d",
-		      errno);
-}
-
-void get_safe_registers(unsigned long *regs, unsigned long *fp_regs)
-{
-	memcpy(regs, exec_regs, sizeof(exec_regs));
-	if(fp_regs != NULL)
-		memcpy(fp_regs, exec_fp_regs,
-		       HOST_FP_SIZE * sizeof(unsigned long));
-}
-
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
 	switch(reg){
_

Patches currently in -mm which might be from jdike@addtoit.com are

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
