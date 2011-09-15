From: akpm@linux-foundation.org
Subject: [merged] um-clean-arch_ptrace-up-a-bit.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:59 -0700
Message-ID: <201109151935.p8FJZxht029637@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab1IOTgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: clean arch_ptrace() up a bit
has been removed from the -mm tree.  Its filename was
     um-clean-arch_ptrace-up-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: clean arch_ptrace() up a bit
From: Al Viro <viro@ftp.linux.org.uk>

1) take subarch-specific stuff to subarch_ptrace()
2) PTRACE_{PEEK,POKE}{TEXT,DATA} is handled by ptrace_request() just fine...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/ptrace-generic.h |    4 ---
 arch/um/kernel/ptrace.c              |   28 -------------------------
 arch/um/sys-i386/asm/ptrace.h        |    5 ----
 arch/um/sys-i386/ptrace.c            |   18 ++++++++++------
 arch/um/sys-x86_64/ptrace.c          |   22 ++++++++++++++++---
 5 files changed, 31 insertions(+), 46 deletions(-)

diff -puN arch/um/include/asm/ptrace-generic.h~um-clean-arch_ptrace-up-a-bit arch/um/include/asm/ptrace-generic.h
--- a/arch/um/include/asm/ptrace-generic.h~um-clean-arch_ptrace-up-a-bit
+++ a/arch/um/include/asm/ptrace-generic.h
@@ -42,10 +42,6 @@ extern long subarch_ptrace(struct task_s
 	unsigned long addr, unsigned long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
-extern int get_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *child);
-extern int set_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *child);
 
 extern int arch_copy_tls(struct task_struct *new);
 extern void clear_flushed_tls(struct task_struct *task);
diff -puN arch/um/kernel/ptrace.c~um-clean-arch_ptrace-up-a-bit arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~um-clean-arch_ptrace-up-a-bit
+++ a/arch/um/kernel/ptrace.c
@@ -50,23 +50,11 @@ long arch_ptrace(struct task_struct *chi
 	void __user *vp = p;
 
 	switch (request) {
-	/* read word at location addr. */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = peek_user(child, addr, data);
 		break;
 
-	/* write the word at location addr. */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = poke_user(child, addr, data);
@@ -107,16 +95,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 #endif
-#ifdef PTRACE_GETFPREGS
-	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs(vp, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPREGS
-	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-		ret = set_fpregs(vp, child);
-		break;
-#endif
 	case PTRACE_GET_THREAD_AREA:
 		ret = ptrace_get_thread_area(child, addr, vp);
 		break;
@@ -154,12 +132,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 #endif
-#ifdef PTRACE_ARCH_PRCTL
-	case PTRACE_ARCH_PRCTL:
-		/* XXX Calls ptrace on the host - needs some SMP thinking */
-		ret = arch_prctl(child, data, (void __user *) addr);
-		break;
-#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		if (ret == -EIO)
diff -puN arch/um/sys-i386/asm/ptrace.h~um-clean-arch_ptrace-up-a-bit arch/um/sys-i386/asm/ptrace.h
--- a/arch/um/sys-i386/asm/ptrace.h~um-clean-arch_ptrace-up-a-bit
+++ a/arch/um/sys-i386/asm/ptrace.h
@@ -42,11 +42,6 @@
  */
 struct user_desc;
 
-extern int get_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *child);
-extern int set_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *tsk);
-
 extern int ptrace_get_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
diff -puN arch/um/sys-i386/ptrace.c~um-clean-arch_ptrace-up-a-bit arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~um-clean-arch_ptrace-up-a-bit
+++ a/arch/um/sys-i386/ptrace.c
@@ -145,7 +145,7 @@ int peek_user(struct task_struct *child,
 	return put_user(tmp, (unsigned long __user *) data);
 }
 
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_i387_struct fpregs;
@@ -161,7 +161,7 @@ int get_fpregs(struct user_i387_struct _
 	return n;
 }
 
-int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_i387_struct fpregs;
@@ -174,7 +174,7 @@ int set_fpregs(struct user_i387_struct _
 				    (unsigned long *) &fpregs);
 }
 
-int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
+static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_fxsr_struct fpregs;
@@ -190,7 +190,7 @@ int get_fpxregs(struct user_fxsr_struct 
 	return n;
 }
 
-int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
+static int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_fxsr_struct fpregs;
@@ -208,15 +208,21 @@ long subarch_ptrace(struct task_struct *
 {
 	int ret = -EIO;
 	void __user *datap = (void __user *) data;
-
 	switch (request) {
+	case PTRACE_GETFPREGS: /* Get the child FPU state. */
+		ret = get_fpregs(datap, child);
+		break;
+	case PTRACE_SETFPREGS: /* Set the child FPU state. */
+		ret = set_fpregs(datap, child);
+		break;
 	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
 		ret = get_fpxregs(datap, child);
 		break;
 	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
 		ret = set_fpxregs(datap, child);
 		break;
+	default:
+		ret = -EIO;
 	}
-
 	return ret;
 }
diff -puN arch/um/sys-x86_64/ptrace.c~um-clean-arch_ptrace-up-a-bit arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~um-clean-arch_ptrace-up-a-bit
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -145,7 +145,7 @@ int is_syscall(unsigned long addr)
 	return instr == 0x050f;
 }
 
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	long fpregs[HOST_FP_SIZE];
@@ -162,7 +162,7 @@ int get_fpregs(struct user_i387_struct _
 	return n;
 }
 
-int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	long fpregs[HOST_FP_SIZE];
@@ -178,5 +178,21 @@ int set_fpregs(struct user_i387_struct _
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	return -EIO;
+	int ret = -EIO;
+	void __user *datap = (void __user *) data;
+
+	switch (request) {
+	case PTRACE_GETFPREGS: /* Get the child FPU state. */
+		ret = get_fpregs(datap, child);
+		break;
+	case PTRACE_SETFPREGS: /* Set the child FPU state. */
+		ret = set_fpregs(datap, child);
+		break;
+	case PTRACE_ARCH_PRCTL:
+		/* XXX Calls ptrace on the host - needs some SMP thinking */
+		ret = arch_prctl(child, data, (void __user *) addr);
+		break;
+	}
+
+	return ret;
 }
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
slab-leaks3-default-y.patch

