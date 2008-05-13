From: akpm@linux-foundation.org
Subject: - uml-tidy-ptrace-interface.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:29 -0700
Message-ID: <200805132132.m4DLWTjL000692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759648AbYEMVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: tidy ptrace interface
has been removed from the -mm tree.  Its filename was
     uml-tidy-ptrace-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: tidy ptrace interface
From: Jeff Dike <jdike@addtoit.com>

Tidy the ptrace interface code.  Removed a bunch of unused macros.
Started converting register sets from arrays of longs to structures.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/ptrace_user.h   |   30 ------------------
 arch/um/include/sysdep-x86_64/ptrace_user.h |   17 ++--------
 arch/um/os-Linux/sys-i386/registers.c       |    5 +--
 arch/um/sys-i386/ptrace.c                   |   30 ++++++++----------
 arch/um/sys-i386/user-offsets.c             |    2 -
 arch/um/sys-x86_64/user-offsets.c           |    1 
 6 files changed, 23 insertions(+), 62 deletions(-)

diff -puN arch/um/include/sysdep-i386/ptrace_user.h~uml-tidy-ptrace-interface arch/um/include/sysdep-i386/ptrace_user.h
--- a/arch/um/include/sysdep-i386/ptrace_user.h~uml-tidy-ptrace-interface
+++ a/arch/um/include/sysdep-i386/ptrace_user.h
@@ -41,38 +41,10 @@
 #define PT_SP_OFFSET PT_OFFSET(UESP)
 #define PT_SP(regs) ((regs)[UESP])
 
-#define FP_SIZE ((HOST_XFP_SIZE > HOST_FP_SIZE) ? HOST_XFP_SIZE : HOST_FP_SIZE)
+#define FP_SIZE ((HOST_FPX_SIZE > HOST_FP_SIZE) ? HOST_FPX_SIZE : HOST_FP_SIZE)
 
 #ifndef FRAME_SIZE
 #define FRAME_SIZE (17)
 #endif
-#define FRAME_SIZE_OFFSET (FRAME_SIZE * sizeof(unsigned long))
-
-#define FP_FRAME_SIZE (27)
-#define FPX_FRAME_SIZE (128)
-
-#ifdef PTRACE_GETREGS
-#define UM_HAVE_GETREGS
-#endif
-
-#ifdef PTRACE_SETREGS
-#define UM_HAVE_SETREGS
-#endif
-
-#ifdef PTRACE_GETFPREGS
-#define UM_HAVE_GETFPREGS
-#endif
-
-#ifdef PTRACE_SETFPREGS
-#define UM_HAVE_SETFPREGS
-#endif
-
-#ifdef PTRACE_GETFPXREGS
-#define UM_HAVE_GETFPXREGS
-#endif
-
-#ifdef PTRACE_SETFPXREGS
-#define UM_HAVE_SETFPXREGS
-#endif
 
 #endif
diff -puN arch/um/include/sysdep-x86_64/ptrace_user.h~uml-tidy-ptrace-interface arch/um/include/sysdep-x86_64/ptrace_user.h
--- a/arch/um/include/sysdep-x86_64/ptrace_user.h~uml-tidy-ptrace-interface
+++ a/arch/um/include/sysdep-x86_64/ptrace_user.h
@@ -48,7 +48,8 @@
 #define PT_ORIG_RAX_OFFSET (ORIG_RAX)
 #define PT_ORIG_RAX(regs) ((regs)[PT_INDEX(ORIG_RAX)])
 
-/* x86_64 FC3 doesn't define this in /usr/include/linux/ptrace.h even though
+/*
+ * x86_64 FC3 doesn't define this in /usr/include/linux/ptrace.h even though
  * it's defined in the kernel's include/linux/ptrace.h. Additionally, use the
  * 2.4 name and value for 2.4 host compatibility.
  */
@@ -56,7 +57,8 @@
 #define PTRACE_OLDSETOPTIONS 21
 #endif
 
-/* These are before the system call, so the system call number is RAX
+/*
+ * These are before the system call, so the system call number is RAX
  * rather than ORIG_RAX, and arg4 is R10 rather than RCX
  */
 #define REGS_SYSCALL_NR PT_INDEX(RAX)
@@ -73,14 +75,3 @@
 #define FP_SIZE (HOST_FP_SIZE)
 
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
diff -puN arch/um/os-Linux/sys-i386/registers.c~uml-tidy-ptrace-interface arch/um/os-Linux/sys-i386/registers.c
--- a/arch/um/os-Linux/sys-i386/registers.c~uml-tidy-ptrace-interface
+++ a/arch/um/os-Linux/sys-i386/registers.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <asm/user.h>
 #include "kern_constants.h"
 #include "longjmp.h"
 #include "user.h"
@@ -74,10 +75,10 @@ int put_fp_registers(int pid, unsigned l
 
 void arch_init_registers(int pid)
 {
-	unsigned long fpx_regs[HOST_XFP_SIZE];
+	struct user_fxsr_struct fpx_regs;
 	int err;
 
-	err = ptrace(PTRACE_GETFPXREGS, pid, 0, fpx_regs);
+	err = ptrace(PTRACE_GETFPXREGS, pid, 0, &fpx_regs);
 	if (!err)
 		return;
 
diff -puN arch/um/sys-i386/ptrace.c~uml-tidy-ptrace-interface arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-tidy-ptrace-interface
+++ a/arch/um/sys-i386/ptrace.c
@@ -148,14 +148,13 @@ int peek_user(struct task_struct *child,
 int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
-	long fpregs[HOST_FP_SIZE];
+	struct user_i387_struct fpregs;
 
-	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	err = save_fp_registers(userspace_pid[cpu], fpregs);
+	err = save_fp_registers(userspace_pid[cpu], (unsigned long *) &fpregs);
 	if (err)
 		return err;
 
-	n = copy_to_user(buf, fpregs, sizeof(fpregs));
+	n = copy_to_user(buf, &fpregs, sizeof(fpregs));
 	if(n > 0)
 		return -EFAULT;
 
@@ -165,27 +164,26 @@ int get_fpregs(struct user_i387_struct _
 int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
-	long fpregs[HOST_FP_SIZE];
+	struct user_i387_struct fpregs;
 
-	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	n = copy_from_user(fpregs, buf, sizeof(fpregs));
+	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
 	if (n > 0)
 		return -EFAULT;
 
-	return restore_fp_registers(userspace_pid[cpu], fpregs);
+	return restore_fp_registers(userspace_pid[cpu],
+				    (unsigned long *) &fpregs);
 }
 
 int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
-	long fpregs[HOST_XFP_SIZE];
+	struct user_fxsr_struct fpregs;
 
-	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	err = save_fpx_registers(userspace_pid[cpu], fpregs);
+	err = save_fpx_registers(userspace_pid[cpu], (unsigned long *) &fpregs);
 	if (err)
 		return err;
 
-	n = copy_to_user(buf, fpregs, sizeof(fpregs));
+	n = copy_to_user(buf, &fpregs, sizeof(fpregs));
 	if(n > 0)
 		return -EFAULT;
 
@@ -195,14 +193,14 @@ int get_fpxregs(struct user_fxsr_struct 
 int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
-	long fpregs[HOST_XFP_SIZE];
+	struct user_fxsr_struct fpregs;
 
-	BUG_ON(sizeof(*buf) != sizeof(fpregs));
-	n = copy_from_user(fpregs, buf, sizeof(fpregs));
+	n = copy_from_user(&fpregs, buf, sizeof(fpregs));
 	if (n > 0)
 		return -EFAULT;
 
-	return restore_fpx_registers(userspace_pid[cpu], fpregs);
+	return restore_fpx_registers(userspace_pid[cpu],
+				     (unsigned long *) &fpregs);
 }
 
 long subarch_ptrace(struct task_struct *child, long request, long addr,
diff -puN arch/um/sys-i386/user-offsets.c~uml-tidy-ptrace-interface arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-tidy-ptrace-interface
+++ a/arch/um/sys-i386/user-offsets.c
@@ -22,7 +22,7 @@ void foo(void)
 	OFFSET(HOST_SC_CR2, sigcontext, cr2);
 
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
-	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
+	DEFINE_LONGS(HOST_FPX_SIZE, sizeof(struct user_fpxregs_struct));
 
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
diff -puN arch/um/sys-x86_64/user-offsets.c~uml-tidy-ptrace-interface arch/um/sys-x86_64/user-offsets.c
--- a/arch/um/sys-x86_64/user-offsets.c~uml-tidy-ptrace-interface
+++ a/arch/um/sys-x86_64/user-offsets.c
@@ -24,7 +24,6 @@ void foo(void)
 	OFFSET(HOST_SC_TRAPNO, sigcontext, trapno);
 
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
-	DEFINE(HOST_XFP_SIZE, 0);
 	DEFINE_LONGS(HOST_RBX, RBX);
 	DEFINE_LONGS(HOST_RCX, RCX);
 	DEFINE_LONGS(HOST_RDI, RDI);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

