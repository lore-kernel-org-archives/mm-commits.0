From: akpm@osdl.org
Subject: + xtensa-fix-system-call-interface.patch added to -mm tree
Date: Fri, 08 Dec 2006 17:40:56 -0800
Message-ID: <200612090140.kB91eug0012910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34053 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947637AbWLIBlE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 20:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czankel@tensilica.com, chris@zankel.net


The patch titled
     xtensa: fix system call interface
has been added to the -mm tree.  Its filename is
     xtensa-fix-system-call-interface.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xtensa: fix system call interface
From: Chris Zankel <czankel@tensilica.com>

This is a long outstanding patch to finally fix the syscall interface.  The
constants used for the system calls are those we have provided in our libc
patches.  This patch also fixes the shmbuf and stat structure, and fcntl
definitions.

Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/xtensa/kernel/asm-offsets.c |    5 
 arch/xtensa/kernel/entry.S       |  228 +++++---
 arch/xtensa/kernel/process.c     |   71 +-
 arch/xtensa/kernel/ptrace.c      |   26 
 arch/xtensa/kernel/signal.c      |   12 
 arch/xtensa/kernel/syscall.c     |   95 +++
 arch/xtensa/kernel/syscalls.c    |  288 ----------
 arch/xtensa/kernel/syscalls.h    |  247 ---------
 include/asm-xtensa/fcntl.h       |   98 ++-
 include/asm-xtensa/posix_types.h |    2 
 include/asm-xtensa/shmbuf.h      |   21 
 include/asm-xtensa/stat.h        |  112 +---
 include/asm-xtensa/syscall.h     |   20 
 include/asm-xtensa/unistd.h      |  793 +++++++++++++++++++++--------
 14 files changed, 1052 insertions(+), 966 deletions(-)

diff -puN arch/xtensa/kernel/asm-offsets.c~xtensa-fix-system-call-interface arch/xtensa/kernel/asm-offsets.c
--- a/arch/xtensa/kernel/asm-offsets.c~xtensa-fix-system-call-interface
+++ a/arch/xtensa/kernel/asm-offsets.c
@@ -87,6 +87,11 @@ int main(void)
 	DEFINE(MM_CONTEXT, offsetof (struct mm_struct, context));
 	BLANK();
 	DEFINE(PT_SINGLESTEP_BIT, PT_SINGLESTEP_BIT);
+
+	/* constants */
+	DEFINE(_CLONE_VM, CLONE_VM);
+	DEFINE(_CLONE_UNTRACED, CLONE_UNTRACED);
+
 	return 0;
 }
 
diff -puN arch/xtensa/kernel/entry.S~xtensa-fix-system-call-interface arch/xtensa/kernel/entry.S
--- a/arch/xtensa/kernel/entry.S~xtensa-fix-system-call-interface
+++ a/arch/xtensa/kernel/entry.S
@@ -1004,13 +1004,10 @@ ENTRY(fast_syscall_kernel)
 
 	rsr	a0, DEPC			# get syscall-nr
 	_beqz	a0, fast_syscall_spill_registers
-
-	addi	a0, a0, -__NR_sysxtensa
-	_beqz	a0, fast_syscall_sysxtensa
+	_beqi	a0, __NR_xtensa, fast_syscall_xtensa
 
 	j	kernel_exception
 
-
 ENTRY(fast_syscall_user)
 
 	/* Skip syscall. */
@@ -1024,9 +1021,7 @@ ENTRY(fast_syscall_user)
 
 	rsr	a0, DEPC			# get syscall-nr
 	_beqz	a0, fast_syscall_spill_registers
-
-	addi	a0, a0, -__NR_sysxtensa
-	_beqz	a0, fast_syscall_sysxtensa
+	_beqi	a0, __NR_xtensa, fast_syscall_xtensa
 
 	j	user_exception
 
@@ -1047,18 +1042,19 @@ ENTRY(fast_syscall_unrecoverable)
 /*
  * sysxtensa syscall handler
  *
- * int sysxtensa (XTENSA_ATOMIC_SET, ptr, val, unused);
- * int sysxtensa (XTENSA_ATOMIC_ADD, ptr, val, unused);
- * int sysxtensa (XTENSA_ATOMIC_EXG_ADD, ptr, val, unused);
- * int sysxtensa (XTENSA_ATOMIC_CMP_SWP, ptr, oldval, newval);
- * a2                    a6              a3    a4      a5
+ * int sysxtensa (SYS_XTENSA_ATOMIC_SET,     ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_ADD,     ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_EXG_ADD, ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_CMP_SWP, ptr, oldval, newval);
+ *        a2            a6                   a3    a4      a5
  *
  * Entry condition:
  *
- *   a0:	trashed, original value saved on stack (PT_AREG0)
+ *   a0:	a2 (syscall-nr), original value saved on stack (PT_AREG0)
  *   a1:	a1
- *   a2:	new stack pointer, original in DEPC
- *   a3:	dispatch table
+ *   a2:	new stack pointer, original in a0 and DEPC
+ *   a3:	dispatch table, original in excsave_1
+ *   a4..a15:	unchanged
  *   depc:	a2, original value saved on stack (PT_DEPC)
  *   excsave_1:	a3
  *
@@ -1091,59 +1087,62 @@ ENTRY(fast_syscall_unrecoverable)
 #define CATCH								\
 67:
 
-ENTRY(fast_syscall_sysxtensa)
-
-	_beqz	a6, 1f
-	_blti	a6, SYSXTENSA_COUNT, 2f
-
-1:	j	user_exception
+ENTRY(fast_syscall_xtensa)
 
-2:	xsr	a3, EXCSAVE_1		# restore a3, excsave1
-	s32i	a7, a2, PT_AREG7
+	xsr	a3, EXCSAVE_1		# restore a3, excsave1
 
+	s32i	a7, a2, PT_AREG7	# we need an additional register
 	movi	a7, 4			# sizeof(unsigned int)
-	access_ok a0, a3, a7, a2, .Leac
+	access_ok a3, a7, a0, a2, .Leac	# a0: scratch reg, a2: sp
 
-	_beqi	a6, SYSXTENSA_ATOMIC_SET, .Lset
-	_beqi	a6, SYSXTENSA_ATOMIC_EXG_ADD, .Lexg
-	_beqi	a6, SYSXTENSA_ATOMIC_ADD, .Ladd
+	addi	a6, a6, -1		# assuming SYS_XTENSA_ATOMIC_SET = 1
+	_bgeui	a6, SYS_XTENSA_COUNT - 1, .Lill
+	_bnei	a6, SYS_XTENSA_ATOMIC_CMP_SWP - 1, .Lnswp
 
-	/* Fall through for SYSXTENSA_ATOMIC_CMP_SWP */
+	/* Fall through for ATOMIC_CMP_SWP. */
 
 .Lswp:	/* Atomic compare and swap */
 
-TRY	l32i	a7, a3, 0		# read old value
-	bne	a7, a4, 1f		# same as old value? jump
-	s32i	a5, a3, 0		# different, modify value
-	movi	a7, 1			# and return 1
-	j	.Lret
-
-1:	movi	a7, 0			# same values: return 0
-	j	.Lret
-
-.Ladd:	/* Atomic add */
-.Lexg:	/* Atomic (exchange) add */
+TRY	l32i	a0, a3, 0		# read old value
+	bne	a0, a4, 1f		# same as old value? jump
+TRY	s32i	a5, a3, 0		# different, modify value
+	l32i	a7, a2, PT_AREG7	# restore a7
+	l32i	a0, a2, PT_AREG0	# restore a0
+	movi	a2, 1			# and return 1
+	addi	a6, a6, 1		# restore a6 (really necessary?)
+	rfe
 
-TRY	l32i	a7, a3, 0
-	add	a4, a4, a7
-	s32i	a4, a3, 0
-	j	.Lret
+1:	l32i	a7, a2, PT_AREG7	# restore a7
+	l32i	a0, a2, PT_AREG0	# restore a0
+	movi	a2, 0			# return 0 (note that we cannot set
+	addi	a6, a6, 1		# restore a6 (really necessary?)
+	rfe
 
-.Lset:	/* Atomic set */
+.Lnswp:	/* Atomic set, add, and exg_add. */
 
-TRY	l32i	a7, a3, 0		# read old value as return value
-	s32i	a4, a3, 0		# write new value
+TRY	l32i	a7, a3, 0		# orig
+	add	a0, a4, a7		# + arg
+	moveqz	a0, a4, a6		# set
+TRY	s32i	a0, a3, 0		# write new value
 
-.Lret:	mov	a0, a2
+	mov	a0, a2
 	mov	a2, a7
-	l32i	a7, a0, PT_AREG7
-	l32i	a3, a0, PT_AREG3
-	l32i	a0, a0, PT_AREG0
+	l32i	a7, a0, PT_AREG7	# restore a7
+	l32i	a0, a0, PT_AREG0	# restore a0
+	addi	a6, a6, 1		# restore a6 (really necessary?)
 	rfe
 
 CATCH
-.Leac:	movi	a7, -EFAULT
-	j	.Lret
+.Leac:	l32i	a7, a2, PT_AREG7	# restore a7
+	l32i	a0, a2, PT_AREG0	# restore a0
+	movi	a2, -EFAULT
+	rfe
+
+.Lill:	l32i	a7, a2, PT_AREG0	# restore a7
+	l32i	a0, a2, PT_AREG0	# restore a0
+	movi	a2, -EINVAL
+	rfe
+
 
 
 
@@ -1907,6 +1906,103 @@ ENTRY(fast_coprocessor)
 #endif /* XCHAL_EXTRA_SA_SIZE */
 
 /*
+ * System Calls.
+ *
+ * void system_call (struct pt_regs* regs, int exccause)
+ *                            a2                 a3
+ */
+
+ENTRY(system_call)
+	entry	a1, 32
+
+	/* regs->syscall = regs->areg[2] */
+
+	l32i	a3, a2, PT_AREG2
+	mov	a6, a2
+	movi	a4, do_syscall_trace_enter
+	s32i	a3, a2, PT_SYSCALL
+	callx4	a4
+
+	/* syscall = sys_call_table[syscall_nr] */
+
+	movi	a4, sys_call_table;
+	movi	a5, __NR_syscall_count
+	movi	a6, -ENOSYS
+	bgeu	a3, a5, 1f
+
+	addx4	a4, a3, a4
+	l32i	a4, a4, 0
+	movi	a5, sys_ni_syscall;
+	beq	a4, a5, 1f
+
+	/* Load args: arg0 - arg5 are passed via regs. */
+
+	l32i	a6, a2, PT_AREG6
+	l32i	a7, a2, PT_AREG3
+	l32i	a8, a2, PT_AREG4
+	l32i	a9, a2, PT_AREG5
+	l32i	a10, a2, PT_AREG8
+	l32i	a11, a2, PT_AREG9
+
+	/* Pass one additional argument to the syscall: pt_regs (on stack) */
+	s32i	a2, a1, 0
+
+	callx4	a4
+
+1:	/* regs->areg[2] = return_value */
+
+	s32i	a6, a2, PT_AREG2
+	movi	a4, do_syscall_trace_leave
+	mov	a6, a2
+	callx4	a4
+	retw
+
+
+/*
+ * Create a kernel thread
+ *
+ * int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+ * a2                    a2                 a3             a4
+ */
+
+ENTRY(kernel_thread)
+	entry	a1, 16
+
+	mov	a5, a2			# preserve fn over syscall
+	mov	a7, a3			# preserve args over syscall
+
+	movi	a3, _CLONE_VM | _CLONE_UNTRACED
+	movi	a2, __NR_clone
+	or	a6, a4, a3		# arg0: flags
+	mov	a3, a1			# arg1: sp
+	syscall
+
+	beq	a3, a1, 1f		# branch if parent
+	mov	a6, a7			# args
+	callx4	a5			# fn(args)
+
+	movi	a2, __NR_exit
+	syscall				# return value of fn(args) still in a6
+
+1:	retw
+
+/*
+ * Do a system call from kernel instead of calling sys_execve, so we end up
+ * with proper pt_regs.
+ *
+ * int kernel_execve(const char *fname, char *const argv[], charg *const envp[])
+ * a2                        a2               a3                  a4
+ */
+
+ENTRY(kernel_execve)
+	entry	a1, 16
+	mov	a6, a2			# arg0 is in a6
+	movi	a2, __NR_execve
+	syscall
+
+	retw
+
+/*
  * Task switch.
  *
  * struct task*  _switch_to (struct task* prev, struct task* next)
@@ -1964,33 +2060,9 @@ ENTRY(ret_from_fork)
 	movi	a4, schedule_tail
 	callx4	a4
 
-	movi	a4, do_syscall_trace
+	movi	a4, do_syscall_trace_leave
+	mov	a6, a1
 	callx4	a4
 
 	j	common_exception_return
 
-
-
-/*
- * Table of syscalls
- */
-
-.data
-.align  4
-.global sys_call_table
-sys_call_table:
-
-#define SYSCALL(call, narg) .word call
-#include "syscalls.h"
-
-/*
- * Number of arguments of each syscall
- */
-
-.global sys_narg_table
-sys_narg_table:
-
-#undef SYSCALL
-#define SYSCALL(call, narg) .byte narg
-#include "syscalls.h"
-
diff -puN arch/xtensa/kernel/process.c~xtensa-fix-system-call-interface arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~xtensa-fix-system-call-interface
+++ a/arch/xtensa/kernel/process.c
@@ -161,36 +161,6 @@ int copy_thread(int nr, unsigned long cl
 
 
 /*
- * Create a kernel thread
- */
-
-int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
-{
-	long retval;
-	__asm__ __volatile__
-		("mov           a5, %4\n\t" /* preserve fn in a5 */
-		 "mov           a6, %3\n\t" /* preserve and setup arg in a6 */
-		 "movi		a2, %1\n\t" /* load __NR_clone for syscall*/
-		 "mov		a3, sp\n\t" /* sp check and sys_clone */
-		 "mov		a4, %5\n\t" /* load flags for syscall */
-		 "syscall\n\t"
-		 "beq		a3, sp, 1f\n\t" /* branch if parent */
-		 "callx4	a5\n\t"     /* call fn */
-		 "movi		a2, %2\n\t" /* load __NR_exit for syscall */
-		 "mov		a3, a6\n\t" /* load fn return value */
-		 "syscall\n"
-		 "1:\n\t"
-		 "mov		%0, a2\n\t" /* parent returns zero */
-		 :"=r" (retval)
-		 :"i" (__NR_clone), "i" (__NR_exit),
-		 "r" (arg), "r" (fn),
-		 "r" (flags | CLONE_VM)
-		 : "a2", "a3", "a4", "a5", "a6" );
-	return retval;
-}
-
-
-/*
  * These bracket the sleeping functions..
  */
 
@@ -452,3 +422,44 @@ int  dump_fpu(struct pt_regs *regs, elf_
 {
 	return dump_task_fpu(regs, current, r);
 }
+
+asmlinkage
+long xtensa_clone(unsigned long clone_flags, unsigned long newsp,
+                  void __user *parent_tid, void *child_tls,
+                  void __user *child_tid, long a5,
+                  struct pt_regs *regs)
+{
+        if (!newsp)
+                newsp = regs->areg[1];
+        return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+}
+
+/*
+ *  * xtensa_execve() executes a new program.
+ *   */
+
+asmlinkage
+long xtensa_execve(char __user *name, char __user * __user *argv,
+                   char __user * __user *envp,
+                   long a3, long a4, long a5,
+                   struct pt_regs *regs)
+{
+	long error;
+	char * filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	// FIXME: release coprocessor??
+	error = do_execve(filename, argv, envp, regs);
+	if (error == 0) {
+		task_lock(current);
+		current->ptrace &= ~PT_DTRACE;
+		task_unlock(current);
+	}
+	putname(filename);
+out:
+	return error;
+}
+
diff -puN arch/xtensa/kernel/ptrace.c~xtensa-fix-system-call-interface arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~xtensa-fix-system-call-interface
+++ a/arch/xtensa/kernel/ptrace.c
@@ -332,12 +332,6 @@ long arch_ptrace(struct task_struct *chi
 
 void do_syscall_trace(void)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-
 	/*
 	 * The 0x80 provides a way for the tracing parent to distinguish
 	 * between a syscall stop and SIGTRAP delivery
@@ -354,3 +348,23 @@ void do_syscall_trace(void)
 		current->exit_code = 0;
 	}
 }
+
+void do_syscall_trace_enter(struct pt_regs *regs)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACE)
+			&& (current->ptrace & PT_PTRACED))
+		do_syscall_trace();
+
+#if 0
+	if (unlikely(current->audit_context))
+		audit_syscall_entry(current, AUDIT_ARCH_XTENSA..);
+#endif
+}
+
+void do_syscall_trace_leave(struct pt_regs *regs)
+{
+	if ((test_thread_flag(TIF_SYSCALL_TRACE))
+			&& (current->ptrace & PT_PTRACED))
+		do_syscall_trace();
+}
+
diff -puN arch/xtensa/kernel/signal.c~xtensa-fix-system-call-interface arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~xtensa-fix-system-call-interface
+++ a/arch/xtensa/kernel/signal.c
@@ -46,7 +46,7 @@ extern struct task_struct *coproc_owners
  * Atomically swap in the new signal mask, and wait for a signal.
  */
 
-int sys_sigsuspend(struct pt_regs *regs)
+int xtensa_sigsuspend(struct pt_regs *regs)
 {
 	old_sigset_t mask = (old_sigset_t) regs->areg[3];
 	sigset_t saveset;
@@ -68,7 +68,7 @@ int sys_sigsuspend(struct pt_regs *regs)
 }
 
 asmlinkage int
-sys_rt_sigsuspend(struct pt_regs *regs)
+xtensa_rt_sigsuspend(struct pt_regs *regs)
 {
 	sigset_t *unewset = (sigset_t *) regs->areg[4];
 	size_t sigsetsize = (size_t) regs->areg[3];
@@ -96,7 +96,7 @@ sys_rt_sigsuspend(struct pt_regs *regs)
 }
 
 asmlinkage int
-sys_sigaction(int sig, const struct old_sigaction *act,
+xtensa_sigaction(int sig, const struct old_sigaction *act,
 	      struct old_sigaction *oact)
 {
 	struct k_sigaction new_ka, old_ka;
@@ -128,7 +128,7 @@ sys_sigaction(int sig, const struct old_
 }
 
 asmlinkage int
-sys_sigaltstack(struct pt_regs *regs)
+xtensa_sigaltstack(struct pt_regs *regs)
 {
 	const stack_t *uss = (stack_t *) regs->areg[4];
 	stack_t *uoss = (stack_t *) regs->areg[3];
@@ -350,7 +350,7 @@ setup_sigcontext(struct sigcontext *sc, 
 	return err;
 }
 
-asmlinkage int sys_sigreturn(struct pt_regs *regs)
+asmlinkage int xtensa_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe *frame = (struct sigframe *)regs->areg[1];
 	sigset_t set;
@@ -382,7 +382,7 @@ badframe:
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
+asmlinkage int xtensa_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe *frame = (struct rt_sigframe *)regs->areg[1];
 	sigset_t set;
diff -puN /dev/null arch/xtensa/kernel/syscall.c
--- /dev/null
+++ a/arch/xtensa/kernel/syscall.c
@@ -0,0 +1,95 @@
+/*
+ * arch/xtensa/kernel/syscall.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ * Copyright (C) 2000 Silicon Graphics, Inc.
+ * Copyright (C) 1995 - 2000 by Ralf Baechle
+ *
+ * Joe Taylor <joe@tensilica.com, joetylr@yahoo.com>
+ * Marc Gauthier <marc@tensilica.com, marc@alumni.uwaterloo.ca>
+ * Chris Zankel <chris@zankel.net>
+ * Kevin Chea
+ *
+ */
+#include <asm/uaccess.h>
+#include <asm/syscalls.h>
+#include <asm/unistd.h>
+#include <linux/linkage.h>
+#include <linux/stringify.h>
+#include <linux/errno.h>
+#include <linux/syscalls.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mman.h>
+#include <linux/shm.h>
+
+typedef void (*syscall_t)(void);
+
+syscall_t sys_call_table[__NR_syscall_count] /* FIXME __cacheline_aligned */= {
+	[0 ... __NR_syscall_count - 1] = (syscall_t)&sys_ni_syscall,
+
+#undef __SYSCALL
+#define __SYSCALL(nr,symbol,nargs) [ nr ] = (syscall_t)symbol,
+#undef _XTENSA_UNISTD_H
+#undef  __KERNEL_SYSCALLS__
+#include <asm/unistd.h>
+};
+
+/*
+ * xtensa_pipe() is the normal C calling standard for creating a pipe. It's not
+ * the way unix traditional does this, though.
+ */
+
+asmlinkage long xtensa_pipe(int __user *userfds)
+{
+	int fd[2];
+	int error;
+
+	error = do_pipe(fd);
+	if (!error) {
+		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
+			error = -EFAULT;
+	}
+	return error;
+}
+
+
+asmlinkage long xtensa_mmap2(unsigned long addr, unsigned long len,
+   			     unsigned long prot, unsigned long flags,
+			     unsigned long fd, unsigned long pgoff)
+{
+	int error = -EBADF;
+	struct file * file = NULL;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
+
+	down_write(&current->mm->mmap_sem);
+	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+out:
+	return error;
+}
+
+asmlinkage long xtensa_shmat(int shmid, char __user *shmaddr, int shmflg)
+{
+	unsigned long ret;
+	long err;
+
+	err = do_shmat(shmid, shmaddr, shmflg, &ret);
+	if (err)
+		return err;
+	return (long)ret;
+}
+
diff -puN arch/xtensa/kernel/syscalls.c~xtensa-fix-system-call-interface /dev/null
--- a/arch/xtensa/kernel/syscalls.c
+++ /dev/null
@@ -1,288 +0,0 @@
-/*
- * arch/xtensa/kernel/syscalls.c
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- * Copyright (C) 2000 Silicon Graphics, Inc.
- * Copyright (C) 1995 - 2000 by Ralf Baechle
- *
- * Joe Taylor <joe@tensilica.com, joetylr@yahoo.com>
- * Marc Gauthier <marc@tensilica.com, marc@alumni.uwaterloo.ca>
- * Chris Zankel <chris@zankel.net>
- * Kevin Chea
- *
- */
-
-#define DEBUG	0
-
-#include <linux/linkage.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/smp_lock.h>
-#include <linux/mman.h>
-#include <linux/sched.h>
-#include <linux/file.h>
-#include <linux/slab.h>
-#include <linux/utsname.h>
-#include <linux/unistd.h>
-#include <linux/stringify.h>
-#include <linux/syscalls.h>
-#include <linux/sem.h>
-#include <linux/msg.h>
-#include <linux/shm.h>
-#include <linux/errno.h>
-#include <asm/ptrace.h>
-#include <asm/signal.h>
-#include <asm/uaccess.h>
-#include <asm/hardirq.h>
-#include <asm/mman.h>
-#include <asm/shmparam.h>
-#include <asm/page.h>
-
-extern void do_syscall_trace(void);
-typedef int (*syscall_t)(void *a0,...);
-extern syscall_t sys_call_table[];
-extern unsigned char sys_narg_table[];
-
-/*
- * sys_pipe() is the normal C calling standard for creating a pipe. It's not
- * the way unix traditional does this, though.
- */
-
-int sys_pipe(int __user *userfds)
-{
-	int fd[2];
-	int error;
-
-	error = do_pipe(fd);
-	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
-			error = -EFAULT;
-	}
-	return error;
-}
-
-/*
- * Common code for old and new mmaps.
- */
-long sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
-	      unsigned long flags, unsigned long fd, unsigned long pgoff)
-{
-	int error = -EBADF;
-	struct file * file = NULL;
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
-	down_write(&current->mm->mmap_sem);
-	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return error;
-}
-
-int sys_clone(struct pt_regs *regs)
-{
-	unsigned long clone_flags;
-	unsigned long newsp;
-	int __user *parent_tidptr, *child_tidptr;
-	clone_flags = regs->areg[4];
-	newsp = regs->areg[3];
-	parent_tidptr = (int __user *)regs->areg[5];
-	child_tidptr = (int __user *)regs->areg[6];
-	if (!newsp)
-		newsp = regs->areg[1];
-	return do_fork(clone_flags,newsp,regs,0,parent_tidptr,child_tidptr);
-}
-
-/*
- * sys_execve() executes a new program.
- */
-
-int sys_execve(struct pt_regs *regs)
-{
-	int error;
-	char * filename;
-
-	filename = getname((char *) (long)regs->areg[5]);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename, (char **) (long)regs->areg[3],
-	                  (char **) (long)regs->areg[4], regs);
-	putname(filename);
-
-out:
-	return error;
-}
-
-int sys_uname(struct old_utsname * name)
-{
-	if (name && !copy_to_user(name, utsname(), sizeof (*name)))
-		return 0;
-	return -EFAULT;
-}
-
-/*
- * Build the string table for the builtin "poor man's strace".
- */
-
-#if DEBUG
-#define SYSCALL(fun, narg) #fun,
-static char *sfnames[] = {
-#include "syscalls.h"
-};
-#undef SYS
-#endif
-
-void system_call (struct pt_regs *regs)
-{
-	syscall_t syscall;
-	unsigned long parm0, parm1, parm2, parm3, parm4, parm5;
-	int nargs, res;
-	unsigned int syscallnr;
-	int ps;
-
-#if DEBUG
-	int i;
-	unsigned long parms[6];
-	char *sysname;
-#endif
-
-	regs->syscall = regs->areg[2];
-
-	do_syscall_trace();
-
-	/* Have to load after syscall_trace because strace
-	 * sometimes changes regs->syscall.
-	 */
-	syscallnr = regs->syscall;
-
-	parm0 = parm1 = parm2 = parm3 = parm4 = parm5 = 0;
-
-	/* Restore interrupt level to syscall invoker's.
-	 * If this were in assembly, we wouldn't disable
-	 * interrupts in the first place:
-	 */
-	local_save_flags (ps);
-	local_irq_restore((ps & ~PS_INTLEVEL_MASK) |
-			  (regs->ps & PS_INTLEVEL_MASK) );
-
-	if (syscallnr > __NR_Linux_syscalls) {
-		regs->areg[2] = -ENOSYS;
-		return;
-	}
-
-	syscall = sys_call_table[syscallnr];
-	nargs = sys_narg_table[syscallnr];
-
-	if (syscall == NULL) {
-		regs->areg[2] = -ENOSYS;
-		return;
-	}
-
-	/* There shouldn't be more than six arguments in the table! */
-
-	if (nargs > 6)
-		panic("Internal error - too many syscall arguments (%d)!\n",
-		      nargs);
-
-	/* Linux takes system-call arguments in registers.  The ABI
-         * and Xtensa software conventions require the system-call
-         * number in a2.  If an argument exists in a2, we move it to
-         * the next available register.  Note that for improved
-         * efficiency, we do NOT shift all parameters down one
-         * register to maintain the original order.
-	 *
-         * At best case (zero arguments), we just write the syscall
-         * number to a2.  At worst case (1 to 6 arguments), we move
-         * the argument in a2 to the next available register, then
-         * write the syscall number to a2.
-	 *
-         * For clarity, the following truth table enumerates all
-         * possibilities.
-	 *
-         * arguments	syscall number	arg0, arg1, arg2, arg3, arg4, arg5
-         * ---------	--------------	----------------------------------
-	 *	0	      a2
-	 *	1	      a2	a3
-	 *	2	      a2	a4,   a3
-	 *	3	      a2	a5,   a3,   a4
-	 *	4	      a2	a6,   a3,   a4,   a5
-	 *	5	      a2	a7,   a3,   a4,   a5,   a6
-	 *	6	      a2	a8,   a3,   a4,   a5,   a6,   a7
-	 */
-	if (nargs) {
-		parm0 = regs->areg[nargs+2];
-		parm1 = regs->areg[3];
-		parm2 = regs->areg[4];
-		parm3 = regs->areg[5];
-		parm4 = regs->areg[6];
-		parm5 = regs->areg[7];
-	} else /* nargs == 0 */
-		parm0 = (unsigned long) regs;
-
-#if DEBUG
-	parms[0] = parm0;
-	parms[1] = parm1;
-	parms[2] = parm2;
-	parms[3] = parm3;
-	parms[4] = parm4;
-	parms[5] = parm5;
-
-	sysname = sfnames[syscallnr];
-	if (strncmp(sysname, "sys_", 4) == 0)
-		sysname = sysname + 4;
-
-	printk("\017SYSCALL:I:%x:%d:%s  %s(", regs->pc, current->pid,
-	       current->comm, sysname);
-	for (i = 0; i < nargs; i++)
-		printk((i>0) ? ", %#lx" : "%#lx", parms[i]);
-	printk(")\n");
-#endif
-
-	res = syscall((void *)parm0, parm1, parm2, parm3, parm4, parm5);
-
-#if DEBUG
-	printk("\017SYSCALL:O:%d:%s  %s(",current->pid, current->comm, sysname);
-	for (i = 0; i < nargs; i++)
-		printk((i>0) ? ", %#lx" : "%#lx", parms[i]);
-	if (res < 4096)
-		printk(") = %d\n", res);
-	else
-		printk(") = %#x\n", res);
-#endif /* DEBUG */
-
-	regs->areg[2] = res;
-	do_syscall_trace();
-}
-
-/*
- * Do a system call from kernel instead of calling sys_execve so we
- * end up with proper pt_regs.
- */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
-{
-	long __res;
-	asm volatile (
-		"  mov   a5, %2 \n"
-		"  mov   a4, %4 \n"
-		"  mov   a3, %3 \n"
-		"  movi  a2, %1 \n"
-		"  syscall      \n"
-		"  mov   %0, a2 \n"
-		: "=a" (__res)
-		: "i" (__NR_execve), "a" (filename), "a" (argv), "a" (envp)
-		: "a2", "a3", "a4", "a5");
-	return __res;
-}
diff -puN arch/xtensa/kernel/syscalls.h~xtensa-fix-system-call-interface /dev/null
--- a/arch/xtensa/kernel/syscalls.h
+++ /dev/null
@@ -1,247 +0,0 @@
-/*
- * arch/xtensa/kernel/syscalls.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1995, 1996, 1997, 1998 by Ralf Baechle
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- *
- * Changes by Joe Taylor <joe@tensilica.com>
- */
-
-/*
- * This file is being included twice - once to build a list of all
- * syscalls and once to build a table of how many arguments each syscall
- * accepts.  Syscalls that receive a pointer to the saved registers are
- * marked as having zero arguments.
- *
- * The binary compatibility calls are in a separate list.
- *
- * Entry '0' used to be system_call.  It's removed to disable indirect
- * system calls for now so user tasks can't recurse.  See mips'
- * sys_syscall for a comparable example.
- */
-
-SYSCALL(0, 0)		                /* 00 */
-SYSCALL(sys_exit, 1)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_read, 3)
-SYSCALL(sys_write, 3)
-SYSCALL(sys_open, 3)			/* 05 */
-SYSCALL(sys_close, 1)
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_creat, 2)
-SYSCALL(sys_link, 2)
-SYSCALL(sys_unlink, 1)			/* 10 */
-SYSCALL(sys_execve, 0)
-SYSCALL(sys_chdir, 1)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_mknod, 3)
-SYSCALL(sys_chmod, 2)			/* 15 */
-SYSCALL(sys_lchown, 3)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_newstat, 2)
-SYSCALL(sys_lseek, 3)
-SYSCALL(sys_getpid, 0)			/* 20 */
-SYSCALL(sys_mount, 5)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_setuid, 1)
-SYSCALL(sys_getuid, 0)
-SYSCALL(sys_ni_syscall, 1)		/* 25 */
-SYSCALL(sys_ptrace, 4)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_newfstat, 2)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_utime, 2)			/* 30 */
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_access, 2)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_ni_syscall, 0)		/* 35 */
-SYSCALL(sys_sync, 0)
-SYSCALL(sys_kill, 2)
-SYSCALL(sys_rename, 2)
-SYSCALL(sys_mkdir, 2)
-SYSCALL(sys_rmdir, 1)			/* 40 */
-SYSCALL(sys_dup, 1)
-SYSCALL(sys_pipe, 1)
-SYSCALL(sys_times, 1)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_brk, 1)			/* 45 */
-SYSCALL(sys_setgid, 1)
-SYSCALL(sys_getgid, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_geteuid, 0)
-SYSCALL(sys_getegid, 0)			/* 50 */
-SYSCALL(sys_acct, 1)
-SYSCALL(sys_umount, 2)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ioctl, 3)
-SYSCALL(sys_fcntl, 3)			/* 55 */
-SYSCALL(sys_ni_syscall, 2)
-SYSCALL(sys_setpgid, 2)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_umask, 1)			/* 60 */
-SYSCALL(sys_chroot, 1)
-SYSCALL(sys_ustat, 2)
-SYSCALL(sys_dup2, 2)
-SYSCALL(sys_getppid, 0)
-SYSCALL(sys_ni_syscall, 0)		/* 65 */
-SYSCALL(sys_setsid, 0)
-SYSCALL(sys_sigaction, 3)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_setreuid, 2)		/* 70 */
-SYSCALL(sys_setregid, 2)
-SYSCALL(sys_sigsuspend, 0)
-SYSCALL(sys_ni_syscall, 1)
-SYSCALL(sys_sethostname, 2)
-SYSCALL(sys_setrlimit, 2)		/* 75 */
-SYSCALL(sys_getrlimit, 2)
-SYSCALL(sys_getrusage, 2)
-SYSCALL(sys_gettimeofday, 2)
-SYSCALL(sys_settimeofday, 2)
-SYSCALL(sys_getgroups, 2)		/* 80 */
-SYSCALL(sys_setgroups, 2)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_symlink, 2)
-SYSCALL(sys_newlstat, 2)
-SYSCALL(sys_readlink, 3)		/* 85 */
-SYSCALL(sys_uselib, 1)
-SYSCALL(sys_swapon, 2)
-SYSCALL(sys_reboot, 3)
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_ni_syscall, 6)		/* 90 */
-SYSCALL(sys_munmap, 2)
-SYSCALL(sys_truncate, 2)
-SYSCALL(sys_ftruncate, 2)
-SYSCALL(sys_fchmod, 2)
-SYSCALL(sys_fchown, 3)			/* 95 */
-SYSCALL(sys_getpriority, 2)
-SYSCALL(sys_setpriority, 3)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_statfs, 2)
-SYSCALL(sys_fstatfs, 2)			/* 100 */
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_ni_syscall, 2)
-SYSCALL(sys_syslog, 3)
-SYSCALL(sys_setitimer, 3)
-SYSCALL(sys_getitimer, 2)		/* 105 */
-SYSCALL(sys_newstat, 2)
-SYSCALL(sys_newlstat, 2)
-SYSCALL(sys_newfstat, 2)
-SYSCALL(sys_uname, 1)
-SYSCALL(sys_ni_syscall, 0)		/* 110 */
-SYSCALL(sys_vhangup, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_wait4, 4)
-SYSCALL(sys_swapoff, 1)			/* 115 */
-SYSCALL(sys_sysinfo, 1)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_fsync, 1)
-SYSCALL(sys_sigreturn, 0)
-SYSCALL(sys_clone, 0)			/* 120 */
-SYSCALL(sys_setdomainname, 2)
-SYSCALL(sys_newuname, 1)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_adjtimex, 1)
-SYSCALL(sys_mprotect, 3)		/* 125 */
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_ni_syscall, 2)
-SYSCALL(sys_init_module, 2)
-SYSCALL(sys_delete_module, 1)
-SYSCALL(sys_ni_syscall, 1)		/* 130 */
-SYSCALL(sys_quotactl, 0)
-SYSCALL(sys_getpgid, 1)
-SYSCALL(sys_fchdir, 1)
-SYSCALL(sys_bdflush, 2)
-SYSCALL(sys_sysfs, 3)			/* 135 */
-SYSCALL(sys_personality, 1)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_setfsuid, 1)
-SYSCALL(sys_setfsgid, 1)
-SYSCALL(sys_llseek, 5)			/* 140 */
-SYSCALL(sys_getdents, 3)
-SYSCALL(sys_select, 5)
-SYSCALL(sys_flock, 2)
-SYSCALL(sys_msync, 3)
-SYSCALL(sys_readv, 3)			/* 145 */
-SYSCALL(sys_writev, 3)
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_ni_syscall, 3)
-SYSCALL(sys_ni_syscall, 4)		/* handled in fast syscall handler. */
-SYSCALL(sys_ni_syscall, 0)		/* 150 */
-SYSCALL(sys_getsid, 1)
-SYSCALL(sys_fdatasync, 1)
-SYSCALL(sys_sysctl, 1)
-SYSCALL(sys_mlock, 2)
-SYSCALL(sys_munlock, 2)			/* 155 */
-SYSCALL(sys_mlockall, 1)
-SYSCALL(sys_munlockall, 0)
-SYSCALL(sys_sched_setparam,2)
-SYSCALL(sys_sched_getparam,2)
-SYSCALL(sys_sched_setscheduler,3)	/* 160 */
-SYSCALL(sys_sched_getscheduler,1)
-SYSCALL(sys_sched_yield,0)
-SYSCALL(sys_sched_get_priority_max,1)
-SYSCALL(sys_sched_get_priority_min,1)
-SYSCALL(sys_sched_rr_get_interval,2)	/* 165 */
-SYSCALL(sys_nanosleep,2)
-SYSCALL(sys_mremap,4)
-SYSCALL(sys_accept, 3)
-SYSCALL(sys_bind, 3)
-SYSCALL(sys_connect, 3)			/* 170 */
-SYSCALL(sys_getpeername, 3)
-SYSCALL(sys_getsockname, 3)
-SYSCALL(sys_getsockopt, 5)
-SYSCALL(sys_listen, 2)
-SYSCALL(sys_recv, 4)			/* 175 */
-SYSCALL(sys_recvfrom, 6)
-SYSCALL(sys_recvmsg, 3)
-SYSCALL(sys_send, 4)
-SYSCALL(sys_sendmsg, 3)
-SYSCALL(sys_sendto, 6)			/* 180 */
-SYSCALL(sys_setsockopt, 5)
-SYSCALL(sys_shutdown, 2)
-SYSCALL(sys_socket, 3)
-SYSCALL(sys_socketpair, 4)
-SYSCALL(sys_setresuid, 3)		/* 185 */
-SYSCALL(sys_getresuid, 3)
-SYSCALL(sys_ni_syscall, 5)
-SYSCALL(sys_poll, 3)
-SYSCALL(sys_nfsservctl, 3)
-SYSCALL(sys_setresgid, 3)		/* 190 */
-SYSCALL(sys_getresgid, 3)
-SYSCALL(sys_prctl, 5)
-SYSCALL(sys_rt_sigreturn, 0)
-SYSCALL(sys_rt_sigaction, 4)
-SYSCALL(sys_rt_sigprocmask, 4)		/* 195 */
-SYSCALL(sys_rt_sigpending, 2)
-SYSCALL(sys_rt_sigtimedwait, 4)
-SYSCALL(sys_rt_sigqueueinfo, 3)
-SYSCALL(sys_rt_sigsuspend, 0)
-SYSCALL(sys_pread64, 5)			/* 200 */
-SYSCALL(sys_pwrite64, 5)
-SYSCALL(sys_chown, 3)
-SYSCALL(sys_getcwd, 2)
-SYSCALL(sys_capget, 2)
-SYSCALL(sys_capset, 2)			/* 205 */
-SYSCALL(sys_sigaltstack, 0)
-SYSCALL(sys_sendfile, 4)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_ni_syscall, 0)
-SYSCALL(sys_mmap, 6)			/* 210 */
-SYSCALL(sys_truncate64, 2)
-SYSCALL(sys_ftruncate64, 2)
-SYSCALL(sys_stat64, 2)
-SYSCALL(sys_lstat64, 2)
-SYSCALL(sys_fstat64, 2)			/* 215 */
-SYSCALL(sys_pivot_root, 2)
-SYSCALL(sys_mincore, 3)
-SYSCALL(sys_madvise, 3)
-SYSCALL(sys_getdents64, 3)
-SYSCALL(sys_ni_syscall, 0)		/* 220 */
diff -puN include/asm-xtensa/fcntl.h~xtensa-fix-system-call-interface include/asm-xtensa/fcntl.h
--- a/include/asm-xtensa/fcntl.h~xtensa-fix-system-call-interface
+++ a/include/asm-xtensa/fcntl.h
@@ -14,48 +14,86 @@
 
 /* open/fcntl - O_SYNC is only implemented on blocks devices and on files
    located on an ext2 file system */
-#define O_APPEND	0x0008
-#define O_SYNC		0x0010
-#define O_NONBLOCK	0x0080
-#define O_CREAT         0x0100	/* not fcntl */
-#define O_EXCL		0x0400	/* not fcntl */
-#define O_NOCTTY	0x0800	/* not fcntl */
-#define FASYNC		0x1000	/* fcntl, for BSD compatibility */
-#define O_LARGEFILE	0x2000	/* allow large file opens - currently ignored */
-#define O_DIRECT	0x8000	/* direct disk access hint - currently ignored*/
-#define O_NOATIME	0x100000
-
-#define F_GETLK		14
-#define F_GETLK64       15
+#define O_ACCMODE	   0003
+#define O_RDONLY	     00
+#define O_WRONLY	     01
+#define O_RDWR		     02
+#define O_CREAT		   0100	/* not fcntl */
+#define O_EXCL		   0200	/* not fcntl */
+#define O_NOCTTY	   0400	/* not fcntl */
+#define O_TRUNC		  01000	/* not fcntl */
+#define O_APPEND	  02000
+#define O_NONBLOCK	  04000
+#define O_NDELAY	O_NONBLOCK
+#define O_SYNC		 010000
+#define FASYNC		 020000	/* fcntl, for BSD compatibility */
+#define O_DIRECT	 040000	/* direct disk access hint */
+#define O_LARGEFILE	0100000
+#define O_DIRECTORY	0200000	/* must be a directory */
+#define O_NOFOLLOW	0400000 /* don't follow links */
+#define O_NOATIME	01000000
+
+#define F_DUPFD		0	/* dup */
+#define F_GETFD		1	/* get close_on_exec */
+#define F_SETFD		2	/* set/clear close_on_exec */
+#define F_GETFL		3	/* get file->f_flags */
+#define F_SETFL		4	/* set file->f_flags */
+#define F_GETLK		5
 #define F_SETLK		6
 #define F_SETLKW	7
-#define F_SETLK64       16
-#define F_SETLKW64      17
 
-#define F_SETOWN	24	/*  for sockets. */
-#define F_GETOWN	23	/*  for sockets. */
+#define F_SETOWN	8	/*  for sockets. */
+#define F_GETOWN	9	/*  for sockets. */
+#define F_SETSIG	10	/*  for sockets. */
+#define F_GETSIG	11	/*  for sockets. */
+
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+
+/* for F_[GET|SET]FL */
+#define FD_CLOEXEC	1	/* actually anything with low bit set goes */
+
+/* for posix fcntl() and lockf() */
+#define F_RDLCK		0
+#define F_WRLCK		1
+#define F_UNLCK		2
+
+/* for old implementation of bsd flock () */
+#define F_EXLCK		4	/* or 3 */
+#define F_SHLCK		8	/* or 4 */
+
+/* for leases */
+#define F_INPROGRESS	16
+
+/* operations for bsd flock(), also used by the kernel implementation */
+#define LOCK_SH		1	/* shared lock */
+#define LOCK_EX		2	/* exclusive lock */
+#define LOCK_NB		4	/* or'd with one of the above to prevent
+				   blocking */
+#define LOCK_UN		8	/* remove lock */
+
+#define LOCK_MAND	32	/* This is a mandatory flock */
+#define LOCK_READ	64	/* ... Which allows concurrent read operations */
+#define LOCK_WRITE	128	/* ... Which allows concurrent write operations */
+#define LOCK_RW		192	/* ... Which allows concurrent read & write ops */
 
-typedef struct flock {
+struct flock {
 	short l_type;
 	short l_whence;
-	__kernel_off_t l_start;
-	__kernel_off_t l_len;
-	long  l_sysid;
-	__kernel_pid_t l_pid;
-	long  pad[4];
-} flock_t;
+	off_t l_start;
+	off_t l_len;
+	pid_t l_pid;
+};
 
 struct flock64 {
 	short  l_type;
 	short  l_whence;
-	__kernel_off_t l_start;
-	__kernel_off_t l_len;
+	loff_t l_start;
+	loff_t l_len;
 	pid_t  l_pid;
 };
 
-#define HAVE_ARCH_STRUCT_FLOCK
-#define HAVE_ARCH_STRUCT_FLOCK64
-
-#include <asm-generic/fcntl.h>
+#define F_LINUX_SPECIFIC_BASE	1024
 
 #endif /* _XTENSA_FCNTL_H */
diff -puN include/asm-xtensa/io.h~xtensa-fix-system-call-interface include/asm-xtensa/io.h
diff -puN include/asm-xtensa/mmu_context.h~xtensa-fix-system-call-interface include/asm-xtensa/mmu_context.h
diff -puN include/asm-xtensa/posix_types.h~xtensa-fix-system-call-interface include/asm-xtensa/posix_types.h
--- a/include/asm-xtensa/posix_types.h~xtensa-fix-system-call-interface
+++ a/include/asm-xtensa/posix_types.h
@@ -21,7 +21,7 @@
 
 typedef unsigned long	__kernel_ino_t;
 typedef unsigned int	__kernel_mode_t;
-typedef unsigned short	__kernel_nlink_t;
+typedef unsigned long	__kernel_nlink_t;
 typedef long		__kernel_off_t;
 typedef int		__kernel_pid_t;
 typedef unsigned short	__kernel_ipc_pid_t;
diff -puN include/asm-xtensa/shmbuf.h~xtensa-fix-system-call-interface include/asm-xtensa/shmbuf.h
--- a/include/asm-xtensa/shmbuf.h~xtensa-fix-system-call-interface
+++ a/include/asm-xtensa/shmbuf.h
@@ -19,6 +19,7 @@
 #ifndef _XTENSA_SHMBUF_H
 #define _XTENSA_SHMBUF_H
 
+#if defined (__XTENSA_EL__)
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
 	size_t			shm_segsz;	/* size of segment (bytes) */
@@ -34,6 +35,26 @@ struct shmid64_ds {
 	unsigned long		__unused4;
 	unsigned long		__unused5;
 };
+#elif defined (__XTENSA_EB__)
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm;	/* operation perms */
+	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_time_t		shm_atime;	/* last attach time */
+	unsigned long		__unused1;
+	__kernel_time_t		shm_dtime;	/* last detach time */
+	unsigned long		__unused2;
+	__kernel_time_t		shm_ctime;	/* last change time */
+	unsigned long		__unused3;
+	__kernel_pid_t		shm_cpid;	/* pid of creator */
+	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+	unsigned long		shm_nattch;	/* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+#else
+# error endian order not defined
+#endif
+
 
 struct shminfo64 {
 	unsigned long	shmmax;
diff -puN include/asm-xtensa/stat.h~xtensa-fix-system-call-interface include/asm-xtensa/stat.h
--- a/include/asm-xtensa/stat.h~xtensa-fix-system-call-interface
+++ a/include/asm-xtensa/stat.h
@@ -13,93 +13,57 @@
 
 #include <linux/types.h>
 
-struct __old_kernel_stat {
-	unsigned short st_dev;
-	unsigned short st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-	unsigned short st_rdev;
-	unsigned long  st_size;
-	unsigned long  st_atime;
-	unsigned long  st_mtime;
-	unsigned long  st_ctime;
-};
-
 #define STAT_HAVE_NSEC 1
 
 struct stat {
-	unsigned short st_dev;
-	unsigned short __pad1;
-	unsigned long st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-	unsigned short st_rdev;
-	unsigned short __pad2;
-	unsigned long  st_size;
-	unsigned long  st_blksize;
-	unsigned long  st_blocks;
-	unsigned long  st_atime;
-	unsigned long  st_atime_nsec;
-	unsigned long  st_mtime;
-	unsigned long  st_mtime_nsec;
-	unsigned long  st_ctime;
-	unsigned long  st_ctime_nsec;
-	unsigned long  __unused4;
-	unsigned long  __unused5;
+	unsigned long	st_dev;
+	ino_t		st_ino;
+	mode_t		st_mode;
+	nlink_t		st_nlink;
+	uid_t		st_uid;
+	gid_t		st_gid;
+	unsigned int	st_rdev;
+	off_t		st_size;
+	unsigned long	st_blksize;
+	unsigned long	st_blocks;
+	unsigned long	st_atime;
+	unsigned long	st_atime_nsec;
+	unsigned long	st_mtime;
+	unsigned long	st_mtime_nsec;
+	unsigned long	st_ctime;
+	unsigned long	st_ctime_nsec;
+	unsigned long	__unused4;
+	unsigned long	__unused5;
 };
 
-/* This matches struct stat64 in glibc-2.2.3. */
+/* This matches struct stat64 in glibc-2.3 */
 
 struct stat64  {
-#ifdef __XTENSA_EL__
-	unsigned short	st_dev;		/* Device */
-	unsigned char	__pad0[10];
-#else
-	unsigned char	__pad0[6];
-	unsigned short	st_dev;
-	unsigned char	__pad1[2];
-#endif
-
-#define STAT64_HAS_BROKEN_ST_INO	1
-	unsigned long __st_ino;		/* 32bit file serial number. */
-
+	unsigned long long st_dev;	/* Device */
+	unsigned long long st_ino;	/* File serial number */
 	unsigned int  st_mode;		/* File mode. */
 	unsigned int  st_nlink;		/* Link count. */
 	unsigned int  st_uid;		/* User ID of the file's owner. */
 	unsigned int  st_gid;		/* Group ID of the file's group. */
-
-#ifdef __XTENSA_EL__
-	unsigned short	st_rdev;	/* Device number, if device. */
-	unsigned char	__pad3[10];
-#else
-	unsigned char	__pad2[6];
-	unsigned short	st_rdev;
-	unsigned char	__pad3[2];
-#endif
-
-	long long int  st_size;		/* Size of file, in bytes. */
-	long int st_blksize;		/* Optimal block size for I/O. */
-
-#ifdef __XTENSA_EL__
-	unsigned long  st_blocks;	/* Number 512-byte blocks allocated. */
-	unsigned long  __pad4;
+	unsigned long long st_rdev;	/* Device number, if device. */
+	long long st_size;		/* Size of file, in bytes. */
+	long st_blksize;		/* Optimal block size for I/O. */
+	unsigned long __unused2;
+#ifdef __XTENSA_EB__
+	unsigned long __unused3;
+	long st_blocks;			/* Number 512-byte blocks allocated. */
 #else
-	unsigned long  __pad4;
-	unsigned long  st_blocks;
+	long st_blocks;			/* Number 512-byte blocks allocated. */
+	unsigned long __unused3;
 #endif
-
-	unsigned long  __pad5;
-	long int st_atime;		/* Time of last access. */
-	unsigned long  st_atime_nsec;
-	long int st_mtime;		/* Time of last modification. */
-	unsigned long  st_mtime_nsec;
-	long int  st_ctime;		/* Time of last status change. */
-	unsigned long  st_ctime_nsec;
-	unsigned long long int st_ino;	/* File serial number. */
+	long st_atime;			/* Time of last access. */
+	unsigned long st_atime_nsec;
+	long st_mtime;			/* Time of last modification. */
+	unsigned long st_mtime_nsec;
+	long st_ctime;			/* Time of last status change. */
+	unsigned long st_ctime_nsec;
+	unsigned long __unused4;
+	unsigned long __unused5;
 };
 
 #endif	/* _XTENSA_STAT_H */
diff -puN /dev/null include/asm-xtensa/syscall.h
--- /dev/null
+++ a/include/asm-xtensa/syscall.h
@@ -0,0 +1,20 @@
+struct pt_regs;
+struct sigaction;
+asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
+asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
+asmlinkage long xtensa_pipe(int __user *);
+asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
+    			     unsigned long, unsigned long, unsigned long);
+asmlinkage long xtensa_ptrace(long, long, long, long);
+asmlinkage long xtensa_sigreturn(struct pt_regs*);
+asmlinkage long xtensa_rt_sigreturn(struct pt_regs*);
+asmlinkage long xtensa_sigsuspend(struct pt_regs*);
+asmlinkage long xtensa_rt_sigsuspend(struct pt_regs*);
+asmlinkage long xtensa_sigaction(int, const struct old_sigaction*,
+				 struct old_sigaction*);
+asmlinkage long xtensa_sigaltstack(struct pt_regs *regs);
+asmlinkage long sys_rt_sigaction(int,
+				 const struct sigaction __user *,
+				 struct sigaction __user *,
+				 size_t);
+asmlinkage long xtensa_shmat(int shmid, char __user *shmaddr, int shmflg);
diff -puN include/asm-xtensa/unistd.h~xtensa-fix-system-call-interface include/asm-xtensa/unistd.h
--- a/include/asm-xtensa/unistd.h~xtensa-fix-system-call-interface
+++ a/include/asm-xtensa/unistd.h
@@ -11,212 +11,591 @@
 #ifndef _XTENSA_UNISTD_H
 #define _XTENSA_UNISTD_H
 
-#define __NR_spill		  0
-#define __NR_exit		  1
-#define __NR_read		  3
-#define __NR_write		  4
-#define __NR_open		  5
-#define __NR_close		  6
-#define __NR_creat		  8
-#define __NR_link		  9
-#define __NR_unlink		 10
-#define __NR_execve		 11
-#define __NR_chdir		 12
-#define __NR_mknod		 14
-#define __NR_chmod		 15
-#define __NR_lchown		 16
-#define __NR_break		 17
-#define __NR_lseek		 19
-#define __NR_getpid		 20
-#define __NR_mount		 21
-#define __NR_setuid		 23
-#define __NR_getuid		 24
-#define __NR_ptrace		 26
-#define __NR_utime		 30
-#define __NR_stty		 31
-#define __NR_gtty		 32
-#define __NR_access		 33
-#define __NR_ftime		 35
-#define __NR_sync		 36
-#define __NR_kill		 37
-#define __NR_rename		 38
-#define __NR_mkdir		 39
-#define __NR_rmdir		 40
-#define __NR_dup		 41
-#define __NR_pipe		 42
-#define __NR_times		 43
-#define __NR_prof		 44
-#define __NR_brk		 45
-#define __NR_setgid		 46
-#define __NR_getgid		 47
-#define __NR_signal		 48
-#define __NR_geteuid		 49
-#define __NR_getegid		 50
-#define __NR_acct		 51
-#define __NR_lock		 53
-#define __NR_ioctl		 54
-#define __NR_fcntl		 55
-#define __NR_setpgid		 57
-#define __NR_ulimit		 58
-#define __NR_umask		 60
-#define __NR_chroot		 61
-#define __NR_ustat		 62
-#define __NR_dup2		 63
-#define __NR_getppid		 64
-#define __NR_setsid		 66
-#define __NR_sigaction		 67
-#define __NR_setreuid		 70
-#define __NR_setregid		 71
-#define __NR_sigsuspend		 72
-#define __NR_sigpending		 73
-#define __NR_sethostname	 74
-#define __NR_setrlimit		 75
-#define __NR_getrlimit	 	 76	/* Back compatible 2Gig limited rlimit */
-#define __NR_getrusage		 77
-#define __NR_gettimeofday	 78
-#define __NR_settimeofday	 79
-#define __NR_getgroups		 80
-#define __NR_setgroups		 81
-#define __NR_select		 82
-#define __NR_symlink		 83
-#define __NR_readlink		 85
-#define __NR_uselib		 86
-#define __NR_swapon		 87
-#define __NR_reboot		 88
-#define __NR_munmap		 91
-#define __NR_truncate		 92
-#define __NR_ftruncate		 93
-#define __NR_fchmod		 94
-#define __NR_fchown		 95
-#define __NR_getpriority	 96
-#define __NR_setpriority	 97
-#define __NR_profil		 98
-#define __NR_statfs		 99
-#define __NR_fstatfs		100
-#define __NR_ioperm		101
-#define __NR_syslog		103
-#define __NR_setitimer		104
-#define __NR_getitimer		105
-#define __NR_stat		106
-#define __NR_lstat		107
-#define __NR_fstat		108
-#define __NR_iopl		110
-#define __NR_vhangup		111
-#define __NR_idle		112
-#define __NR_wait4		114
-#define __NR_swapoff		115
-#define __NR_sysinfo		116
-#define __NR_fsync		118
-#define __NR_sigreturn		119
-#define __NR_clone		120
-#define __NR_setdomainname	121
-#define __NR_uname		122
-#define __NR_modify_ldt		123
-#define __NR_adjtimex		124
-#define __NR_mprotect		125
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_quotactl		131
-#define __NR_getpgid		132
-#define __NR_fchdir		133
-#define __NR_bdflush		134
-#define __NR_sysfs		135
-#define __NR_personality	136
-#define __NR_setfsuid		138
-#define __NR_setfsgid		139
-#define __NR__llseek		140
-#define __NR_getdents		141
-#define __NR__newselect		142
-#define __NR_flock		143
-#define __NR_msync		144
-#define __NR_readv		145
-#define __NR_writev		146
-#define __NR_cacheflush         147
-#define __NR_cachectl           148
-#define __NR_sysxtensa          149
-#define __NR_sysdummy           150
-#define __NR_getsid		151
-#define __NR_fdatasync		152
-#define __NR__sysctl		153
-#define __NR_mlock		154
-#define __NR_munlock		155
-#define __NR_mlockall		156
-#define __NR_munlockall		157
-#define __NR_sched_setparam		158
-#define __NR_sched_getparam		159
-#define __NR_sched_setscheduler		160
-#define __NR_sched_getscheduler		161
-#define __NR_sched_yield		162
-#define __NR_sched_get_priority_max	163
-#define __NR_sched_get_priority_min	164
-#define __NR_sched_rr_get_interval	165
-#define __NR_nanosleep		166
-#define __NR_mremap		167
-#define __NR_accept             168
-#define __NR_bind               169
-#define __NR_connect            170
-#define __NR_getpeername        171
-#define __NR_getsockname        172
-#define __NR_getsockopt         173
-#define __NR_listen             174
-#define __NR_recv               175
-#define __NR_recvfrom           176
-#define __NR_recvmsg            177
-#define __NR_send               178
-#define __NR_sendmsg            179
-#define __NR_sendto             180
-#define __NR_setsockopt         181
-#define __NR_shutdown           182
-#define __NR_socket             183
-#define __NR_socketpair         184
-#define __NR_setresuid		185
-#define __NR_getresuid		186
-#define __NR_query_module	187
-#define __NR_poll		188
-#define __NR_nfsservctl		189
-#define __NR_setresgid		190
-#define __NR_getresgid		191
-#define __NR_prctl              192
-#define __NR_rt_sigreturn	193
-#define __NR_rt_sigaction	194
-#define __NR_rt_sigprocmask	195
-#define __NR_rt_sigpending	196
-#define __NR_rt_sigtimedwait	197
-#define __NR_rt_sigqueueinfo	198
-#define __NR_rt_sigsuspend	199
-#define __NR_pread		200
-#define __NR_pwrite		201
-#define __NR_chown		202
-#define __NR_getcwd		203
-#define __NR_capget		204
-#define __NR_capset		205
-#define __NR_sigaltstack	206
-#define __NR_sendfile		207
-#define __NR_mmap2		210
-#define __NR_truncate64		211
-#define __NR_ftruncate64	212
-#define __NR_stat64		213
-#define __NR_lstat64		214
-#define __NR_fstat64		215
-#define __NR_pivot_root		216
-#define __NR_mincore		217
-#define __NR_madvise		218
-#define __NR_getdents64		219
-
-/* Keep this last; should always equal the last valid call number. */
-#define __NR_Linux_syscalls     220
-
-/* user-visible error numbers are in the range -1 - -125: see
- * <asm-xtensa/errno.h> */
-
-#define SYSXTENSA_RESERVED	   0	/* don't use this */
-#define SYSXTENSA_ATOMIC_SET	   1	/* set variable */
-#define SYSXTENSA_ATOMIC_EXG_ADD   2	/* exchange memory and add */
-#define SYSXTENSA_ATOMIC_ADD	   3	/* add to memory */
-#define SYSXTENSA_ATOMIC_CMP_SWP   4	/* compare and swap */
+#ifndef __SYSCALL
+# define __SYSCALL(nr,func,nargs)
+#endif
 
-#define SYSXTENSA_COUNT		   5	/* count of syscall0 functions*/
+#define __NR_spill				  0
+__SYSCALL(  0, sys_ni_syscall, 0)
+#define __NR_xtensa				  1
+__SYSCALL(  1, sys_ni_syscall, 0)
+#define __NR_available4				  2
+__SYSCALL(  2, sys_ni_syscall, 0)
+#define __NR_available5				  3
+__SYSCALL(  3, sys_ni_syscall, 0)
+#define __NR_available6				  4
+__SYSCALL(  4, sys_ni_syscall, 0)
+#define __NR_available7				  5
+__SYSCALL(  5, sys_ni_syscall, 0)
+#define __NR_available8				  6
+__SYSCALL(  6, sys_ni_syscall, 0)
+#define __NR_available9				  7
+__SYSCALL(  7, sys_ni_syscall, 0)
+
+/* File Operations */
+
+#define __NR_open 				  8
+__SYSCALL(  8, sys_open, 3)
+#define __NR_close 				  9
+__SYSCALL(  9, sys_close, 1)
+#define __NR_dup 				 10
+__SYSCALL( 10, sys_dup, 1)
+#define __NR_dup2 				 11
+__SYSCALL( 11, sys_dup2, 2)
+#define __NR_read 				 12
+__SYSCALL( 12, sys_read, 3)
+#define __NR_write 				 13
+__SYSCALL( 13, sys_write, 3)
+#define __NR_select 				 14
+__SYSCALL( 14, sys_select, 5)
+#define __NR_lseek 				 15
+__SYSCALL( 15, sys_lseek, 3)
+#define __NR_poll 				 16
+__SYSCALL( 16, sys_poll, 3)
+#define __NR__llseek				 17
+__SYSCALL( 17, sys_llseek, 5)
+#define __NR_epoll_wait 			 18
+__SYSCALL( 18, sys_epoll_wait, 4)
+#define __NR_epoll_ctl 				 19
+__SYSCALL( 19, sys_epoll_ctl, 4)
+#define __NR_epoll_create 			 20
+__SYSCALL( 20, sys_epoll_create, 1)
+#define __NR_creat 				 21
+__SYSCALL( 21, sys_creat, 2)
+#define __NR_truncate 				 22
+__SYSCALL( 22, sys_truncate, 2)
+#define __NR_ftruncate 				 23
+__SYSCALL( 23, sys_ftruncate, 2)
+#define __NR_readv 				 24
+__SYSCALL( 24, sys_readv, 3)
+#define __NR_writev 				 25
+__SYSCALL( 25, sys_writev, 3)
+#define __NR_fsync 				 26
+__SYSCALL( 26, sys_fsync, 1)
+#define __NR_fdatasync 				 27
+__SYSCALL( 27, sys_fdatasync, 1)
+#define __NR_truncate64 			 28
+__SYSCALL( 28, sys_truncate64, 2)
+#define __NR_ftruncate64 			 29
+__SYSCALL( 29, sys_ftruncate64, 2)
+#define __NR_pread64 				 30
+__SYSCALL( 30, sys_pread64, 6)
+#define __NR_pwrite64 				 31
+__SYSCALL( 31, sys_pwrite64, 6)
+
+#define __NR_link 				 32
+__SYSCALL( 32, sys_link, 2)
+#define __NR_rename 				 33
+__SYSCALL( 33, sys_rename, 2)
+#define __NR_symlink 				 34
+__SYSCALL( 34, sys_symlink, 2)
+#define __NR_readlink 				 35
+__SYSCALL( 35, sys_readlink, 3)
+#define __NR_mknod 				 36
+__SYSCALL( 36, sys_mknod, 3)
+#define __NR_pipe 				 37
+__SYSCALL( 37, xtensa_pipe, 1)
+#define __NR_unlink 				 38
+__SYSCALL( 38, sys_unlink, 1)
+#define __NR_rmdir 				 39
+__SYSCALL( 39, sys_rmdir, 1)
+
+#define __NR_mkdir 				 40
+__SYSCALL( 40, sys_mkdir, 2)
+#define __NR_chdir 				 41
+__SYSCALL( 41, sys_chdir, 1)
+#define __NR_fchdir 				 42
+__SYSCALL( 42, sys_fchdir, 1)
+#define __NR_getcwd 				 43
+__SYSCALL( 43, sys_getcwd, 2)
+
+#define __NR_chmod 				 44
+__SYSCALL( 44, sys_chmod, 2)
+#define __NR_chown 				 45
+__SYSCALL( 45, sys_chown, 3)
+#define __NR_stat 				 46
+__SYSCALL( 46, sys_newstat, 2)
+#define __NR_stat64 				 47
+__SYSCALL( 47, sys_stat64, 2)
+
+#define __NR_lchown 				 48
+__SYSCALL( 48, sys_lchown, 3)
+#define __NR_lstat 				 49
+__SYSCALL( 49, sys_newlstat, 2)
+#define __NR_lstat64 				 50
+__SYSCALL( 50, sys_lstat64, 2)
+#define __NR_available51			 51
+__SYSCALL( 51, sys_ni_syscall, 0)
+
+#define __NR_fchmod 				 52
+__SYSCALL( 52, sys_fchmod, 2)
+#define __NR_fchown 				 53
+__SYSCALL( 53, sys_fchown, 3)
+#define __NR_fstat 				 54
+__SYSCALL( 54, sys_newfstat, 2)
+#define __NR_fstat64 				 55
+__SYSCALL( 55, sys_fstat64, 2)
+
+#define __NR_flock 				 56
+__SYSCALL( 56, sys_flock, 2)
+#define __NR_access 				 57
+__SYSCALL( 57, sys_access, 2)
+#define __NR_umask 				 58
+__SYSCALL( 58, sys_umask, 1)
+#define __NR_getdents 				 59
+__SYSCALL( 59, sys_getdents, 3)
+#define __NR_getdents64 			 60
+__SYSCALL( 60, sys_getdents64, 3)
+#define __NR_fcntl64 				 61
+__SYSCALL( 61, sys_fcntl64, 3)
+#define __NR_available62			 62
+__SYSCALL( 62, sys_ni_syscall, 0)
+#define __NR_fadvise64_64 			 63
+__SYSCALL( 63, sys_fadvise64_64, 6)
+#define __NR_utime				 64	/* glibc 2.3.3 ?? */
+__SYSCALL( 64, sys_utime, 2)
+#define __NR_utimes 				 65
+__SYSCALL( 65, sys_utimes, 2)
+#define __NR_ioctl 				 66
+__SYSCALL( 66, sys_ioctl, 3)
+#define __NR_fcntl 				 67
+__SYSCALL( 67, sys_fcntl, 3)
+
+#define __NR_setxattr 				 68
+__SYSCALL( 68, sys_setxattr, 5)
+#define __NR_getxattr 				 69
+__SYSCALL( 69, sys_getxattr, 4)
+#define __NR_listxattr 				 70
+__SYSCALL( 70, sys_listxattr, 3)
+#define __NR_removexattr 			 71
+__SYSCALL( 71, sys_removexattr, 2)
+#define __NR_lsetxattr 				 72
+__SYSCALL( 72, sys_lsetxattr, 5)
+#define __NR_lgetxattr 				 73
+__SYSCALL( 73, sys_lgetxattr, 4)
+#define __NR_llistxattr 			 74
+__SYSCALL( 74, sys_llistxattr, 3)
+#define __NR_lremovexattr 			 75
+__SYSCALL( 75, sys_lremovexattr, 2)
+#define __NR_fsetxattr 				 76
+__SYSCALL( 76, sys_fsetxattr, 5)
+#define __NR_fgetxattr 				 77
+__SYSCALL( 77, sys_fgetxattr, 4)
+#define __NR_flistxattr 			 78
+__SYSCALL( 78, sys_flistxattr, 3)
+#define __NR_fremovexattr 			 79
+__SYSCALL( 79, sys_fremovexattr, 2)
+
+/* File Map / Shared Memory Operations */
+
+#define __NR_mmap2 				 80
+__SYSCALL( 80, xtensa_mmap2, 6)
+#define __NR_munmap 				 81
+__SYSCALL( 81, sys_munmap, 2)
+#define __NR_mprotect 				 82
+__SYSCALL( 82, sys_mprotect, 3)
+#define __NR_brk 				 83
+__SYSCALL( 83, sys_brk, 1)
+#define __NR_mlock 				 84
+__SYSCALL( 84, sys_mlock, 2)
+#define __NR_munlock 				 85
+__SYSCALL( 85, sys_munlock, 2)
+#define __NR_mlockall 				 86
+__SYSCALL( 86, sys_mlockall, 1)
+#define __NR_munlockall 			 87
+__SYSCALL( 87, sys_munlockall, 0)
+#define __NR_mremap 				 88
+__SYSCALL( 88, sys_mremap, 4)
+#define __NR_msync 				 89
+__SYSCALL( 89, sys_msync, 3)
+#define __NR_mincore 				 90
+__SYSCALL( 90, sys_mincore, 3)
+#define __NR_madvise 				 91
+__SYSCALL( 91, sys_madvise, 3)
+#define __NR_shmget				 92
+__SYSCALL( 92, sys_shmget, 4)
+#define __NR_shmat				 93
+__SYSCALL( 93, xtensa_shmat, 4)
+#define __NR_shmctl				 94
+__SYSCALL( 94, sys_shmctl, 4)
+#define __NR_shmdt				 95
+__SYSCALL( 95, sys_shmdt, 4)
+
+/* Socket Operations */
+
+#define __NR_socket 				 96
+__SYSCALL( 96, sys_socket, 3)
+#define __NR_setsockopt 			 97
+__SYSCALL( 97, sys_setsockopt, 5)
+#define __NR_getsockopt 			 98
+__SYSCALL( 98, sys_getsockopt, 5)
+#define __NR_shutdown 				 99
+__SYSCALL( 99, sys_shutdown, 2)
+
+#define __NR_bind 				100
+__SYSCALL(100, sys_bind, 3)
+#define __NR_connect 				101
+__SYSCALL(101, sys_connect, 3)
+#define __NR_listen 				102
+__SYSCALL(102, sys_listen, 2)
+#define __NR_accept 				103
+__SYSCALL(103, sys_accept, 3)
+
+#define __NR_getsockname 			104
+__SYSCALL(104, sys_getsockname, 3)
+#define __NR_getpeername 			105
+__SYSCALL(105, sys_getpeername, 3)
+#define __NR_sendmsg 				106
+__SYSCALL(106, sys_sendmsg, 3)
+#define __NR_recvmsg 				107
+__SYSCALL(107, sys_recvmsg, 3)
+#define __NR_send 				108
+__SYSCALL(108, sys_send, 4)
+#define __NR_recv 				109
+__SYSCALL(109, sys_recv, 4)
+#define __NR_sendto 				110
+__SYSCALL(110, sys_sendto, 6)
+#define __NR_recvfrom 				111
+__SYSCALL(111, sys_recvfrom, 6)
+
+#define __NR_socketpair 			112
+__SYSCALL(112, sys_socketpair, 4)
+#define __NR_sendfile 				113
+__SYSCALL(113, sys_sendfile, 4)
+#define __NR_sendfile64 			114
+__SYSCALL(114, sys_sendfile64, 4)
+#define __NR_available115			115
+__SYSCALL(115, sys_ni_syscall, 0)
+
+/* Process Operations */
+
+#define __NR_clone 				116
+__SYSCALL(116, xtensa_clone, 5)
+#define __NR_execve 				117
+__SYSCALL(117, xtensa_execve, 3)
+#define __NR_exit 				118
+__SYSCALL(118, sys_exit, 1)
+#define __NR_exit_group 			119
+__SYSCALL(119, sys_exit_group, 1)
+#define __NR_getpid 				120
+__SYSCALL(120, sys_getpid, 0)
+#define __NR_wait4 				121
+__SYSCALL(121, sys_wait4, 4)
+#define __NR_waitid 				122
+__SYSCALL(122, sys_waitid, 5)
+#define __NR_kill 				123
+__SYSCALL(123, sys_kill, 2)
+#define __NR_tkill 				124
+__SYSCALL(124, sys_tkill, 2)
+#define __NR_tgkill 				125
+__SYSCALL(125, sys_tgkill, 3)
+#define __NR_set_tid_address 			126
+__SYSCALL(126, sys_set_tid_address, 1)
+#define __NR_gettid 				127
+__SYSCALL(127, sys_gettid, 0)
+#define __NR_setsid 				128
+__SYSCALL(128, sys_setsid, 0)
+#define __NR_getsid 				129
+__SYSCALL(129, sys_getsid, 1)
+#define __NR_prctl 				130
+__SYSCALL(130, sys_prctl, 5)
+#define __NR_personality 			131
+__SYSCALL(131, sys_personality, 1)
+#define __NR_getpriority 			132
+__SYSCALL(132, sys_getpriority, 2)
+#define __NR_setpriority 			133
+__SYSCALL(133, sys_setpriority, 3)
+#define __NR_setitimer 				134
+__SYSCALL(134, sys_setitimer, 3)
+#define __NR_getitimer 				135
+__SYSCALL(135, sys_getitimer, 2)
+#define __NR_setuid 				136
+__SYSCALL(136, sys_setuid, 1)
+#define __NR_getuid 				137
+__SYSCALL(137, sys_getuid, 0)
+#define __NR_setgid 				138
+__SYSCALL(138, sys_setgid, 1)
+#define __NR_getgid 				139
+__SYSCALL(139, sys_getgid, 0)
+#define __NR_geteuid 				140
+__SYSCALL(140, sys_geteuid, 0)
+#define __NR_getegid 				141
+__SYSCALL(141, sys_getegid, 0)
+#define __NR_setreuid 				142
+__SYSCALL(142, sys_setreuid, 2)
+#define __NR_setregid 				143
+__SYSCALL(143, sys_setregid, 2)
+#define __NR_setresuid 				144
+__SYSCALL(144, sys_setresuid, 3)
+#define __NR_getresuid 				145
+__SYSCALL(145, sys_getresuid, 3)
+#define __NR_setresgid 				146
+__SYSCALL(146, sys_setresgid, 3)
+#define __NR_getresgid 				147
+__SYSCALL(147, sys_getresgid, 3)
+#define __NR_setpgid 				148
+__SYSCALL(148, sys_setpgid, 2)
+#define __NR_getpgid 				149
+__SYSCALL(149, sys_getpgid, 1)
+#define __NR_getppid 				150
+__SYSCALL(150, sys_getppid, 0)
+#define __NR_available151			151
+__SYSCALL(151, sys_ni_syscall, 0)
+
+#define __NR_reserved152 			152	/* set_thread_area */
+__SYSCALL(152, sys_ni_syscall, 0)
+#define __NR_reserved153 			153	/* get_thread_area */
+__SYSCALL(153, sys_ni_syscall, 0)
+#define __NR_times 				154
+__SYSCALL(154, sys_times, 1)
+#define __NR_acct 				155
+__SYSCALL(155, sys_acct, 1)
+#define __NR_sched_setaffinity 			156
+__SYSCALL(156, sys_sched_setaffinity, 3)
+#define __NR_sched_getaffinity 			157
+__SYSCALL(157, sys_sched_getaffinity, 3)
+#define __NR_capget 				158
+__SYSCALL(158, sys_capget, 2)
+#define __NR_capset 				159
+__SYSCALL(159, sys_capset, 2)
+#define __NR_ptrace 				160
+__SYSCALL(160, sys_ptrace, 4)
+#define __NR_semtimedop				161
+__SYSCALL(161, sys_semtimedop, 5)
+#define __NR_semget				162
+__SYSCALL(162, sys_semget, 4)
+#define __NR_semop				163
+__SYSCALL(163, sys_semop, 4)
+#define __NR_semctl				164
+__SYSCALL(164, sys_semctl, 4)
+#define __NR_available165			165
+__SYSCALL(165, sys_ni_syscall, 0)
+#define __NR_msgget				166
+__SYSCALL(166, sys_msgget, 4)
+#define __NR_msgsnd				167
+__SYSCALL(167, sys_msgsnd, 4)
+#define __NR_msgrcv				168
+__SYSCALL(168, sys_msgrcv, 4)
+#define __NR_msgctl				169
+__SYSCALL(169, sys_msgctl, 4)
+#define __NR_available170			170
+__SYSCALL(170, sys_ni_syscall, 0)
+#define __NR_available171			171
+__SYSCALL(171, sys_ni_syscall, 0)
+
+/* File System */
+
+#define __NR_mount 				172
+__SYSCALL(172, sys_mount, 5)
+#define __NR_swapon 				173
+__SYSCALL(173, sys_swapon, 2)
+#define __NR_chroot 				174
+__SYSCALL(174, sys_chroot, 1)
+#define __NR_pivot_root 			175
+__SYSCALL(175, sys_pivot_root, 2)
+#define __NR_umount 				176
+__SYSCALL(176, sys_umount, 2)
+#define __NR_swapoff 				177
+__SYSCALL(177, sys_swapoff, 1)
+#define __NR_sync 				178
+__SYSCALL(178, sys_sync, 0)
+#define __NR_available179			179
+__SYSCALL(179, sys_ni_syscall, 0)
+#define __NR_setfsuid 				180
+__SYSCALL(180, sys_setfsuid, 1)
+#define __NR_setfsgid 				181
+__SYSCALL(181, sys_setfsgid, 1)
+#define __NR_sysfs 				182
+__SYSCALL(182, sys_sysfs, 3)
+#define __NR_ustat 				183
+__SYSCALL(183, sys_ustat, 2)
+#define __NR_statfs 				184
+__SYSCALL(184, sys_statfs, 2)
+#define __NR_fstatfs 				185
+__SYSCALL(185, sys_fstatfs, 2)
+#define __NR_statfs64 				186
+__SYSCALL(186, sys_statfs64, 3)
+#define __NR_fstatfs64 				187
+__SYSCALL(187, sys_fstatfs64, 3)
+
+/* System */
+
+#define __NR_setrlimit 				188
+__SYSCALL(188, sys_setrlimit, 2)
+#define __NR_getrlimit 				189
+__SYSCALL(189, sys_getrlimit, 2)
+#define __NR_getrusage 				190
+__SYSCALL(190, sys_getrusage, 2)
+#define __NR_futex				191
+__SYSCALL(191, sys_futex, 5)
+#define __NR_gettimeofday 			192
+__SYSCALL(192, sys_gettimeofday, 2)
+#define __NR_settimeofday 			193
+__SYSCALL(193, sys_settimeofday, 2)
+#define __NR_adjtimex 				194
+__SYSCALL(194, sys_adjtimex, 1)
+#define __NR_nanosleep	 			195
+__SYSCALL(195, sys_nanosleep, 2)
+#define __NR_getgroups 				196
+__SYSCALL(196, sys_getgroups, 2)
+#define __NR_setgroups 				197
+__SYSCALL(197, sys_setgroups, 2)
+#define __NR_sethostname 			198
+__SYSCALL(198, sys_sethostname, 2)
+#define __NR_setdomainname 			199
+__SYSCALL(199, sys_setdomainname, 2)
+#define __NR_syslog 				200
+__SYSCALL(200, sys_syslog, 3)
+#define __NR_vhangup 				201
+__SYSCALL(201, sys_vhangup, 0)
+#define __NR_uselib 				202
+__SYSCALL(202, sys_uselib, 1)
+#define __NR_reboot 				203
+__SYSCALL(203, sys_reboot, 3)
+#define __NR_quotactl 				204
+__SYSCALL(204, sys_quotactl, 4)
+#define __NR_nfsservctl 			205
+__SYSCALL(205, sys_nfsservctl, 3)
+#define __NR__sysctl 				206
+__SYSCALL(206, sys_sysctl, 1)
+#define __NR_bdflush 				207
+__SYSCALL(207, sys_bdflush, 2)
+#define __NR_uname 				208
+__SYSCALL(208, sys_newuname, 1)
+#define __NR_sysinfo 				209
+__SYSCALL(209, sys_sysinfo, 1)
+#define __NR_init_module 			210
+__SYSCALL(210, sys_init_module, 2)
+#define __NR_delete_module 			211
+__SYSCALL(211, sys_delete_module, 1)
+
+#define __NR_sched_setparam 			212
+__SYSCALL(212, sys_sched_setparam, 2)
+#define __NR_sched_getparam 			213
+__SYSCALL(213, sys_sched_getparam, 2)
+#define __NR_sched_setscheduler 		214
+__SYSCALL(214, sys_sched_setscheduler, 3)
+#define __NR_sched_getscheduler 		215
+__SYSCALL(215, sys_sched_getscheduler, 1)
+#define __NR_sched_get_priority_max 		216
+__SYSCALL(216, sys_sched_get_priority_max, 1)
+#define __NR_sched_get_priority_min 		217
+__SYSCALL(217, sys_sched_get_priority_min, 1)
+#define __NR_sched_rr_get_interval 		218
+__SYSCALL(218, sys_sched_rr_get_interval, 2)
+#define __NR_sched_yield 			219
+__SYSCALL(219, sys_sched_yield, 0)
+#define __NR_sigreturn	 			222
+__SYSCALL(222, xtensa_sigreturn, 0)
+
+/* Signal Handling */
+
+#define __NR_restart_syscall 			223
+__SYSCALL(223, sys_restart_syscall, 0)
+#define __NR_sigaltstack 			224
+__SYSCALL(224, xtensa_sigaltstack, 2)
+#define __NR_rt_sigreturn 			225
+__SYSCALL(225, xtensa_rt_sigreturn, 1)
+#define __NR_rt_sigaction 			226
+__SYSCALL(226, sys_rt_sigaction, 4)
+#define __NR_rt_sigprocmask 			227
+__SYSCALL(227, sys_rt_sigprocmask, 4)
+#define __NR_rt_sigpending 			228
+__SYSCALL(228, sys_rt_sigpending, 2)
+#define __NR_rt_sigtimedwait 			229
+__SYSCALL(229, sys_rt_sigtimedwait, 4)
+#define __NR_rt_sigqueueinfo 			230
+__SYSCALL(230, sys_rt_sigqueueinfo, 3)
+#define __NR_rt_sigsuspend 			231
+__SYSCALL(231, xtensa_rt_sigsuspend, 2)
+
+/* Message */
+
+#define __NR_mq_open 				232
+__SYSCALL(232, sys_mq_open, 4)
+#define __NR_mq_unlink 				233
+__SYSCALL(233, sys_mq_unlink, 1)
+#define __NR_mq_timedsend 			234
+__SYSCALL(234, sys_mq_timedsend, 5)
+#define __NR_mq_timedreceive 			235
+__SYSCALL(235, sys_mq_timedreceive, 5)
+#define __NR_mq_notify 				236
+__SYSCALL(236, sys_mq_notify, 2)
+#define __NR_mq_getsetattr 			237
+__SYSCALL(237, sys_mq_getsetattr, 3)
+#define __NR_available238			238
+__SYSCALL(238, sys_ni_syscall, 0)
+
+/* IO */
+
+#define __NR_io_setup 				239
+__SYSCALL(239, sys_io_setup, 2)
+#define __NR_io_destroy 			240
+__SYSCALL(240, sys_io_destroy, 1)
+#define __NR_io_submit 				241
+__SYSCALL(241, sys_io_submit, 3)
+#define __NR_io_getevents 			242
+__SYSCALL(242, sys_io_getevents, 5)
+#define __NR_io_cancel 				243
+__SYSCALL(243, sys_io_cancel, 3)
+#define __NR_clock_settime 			244
+__SYSCALL(244, sys_clock_settime, 2)
+#define __NR_clock_gettime 			245
+__SYSCALL(245, sys_clock_gettime, 2)
+#define __NR_clock_getres 			246
+__SYSCALL(246, sys_clock_getres, 2)
+#define __NR_clock_nanosleep 			247
+__SYSCALL(247, sys_clock_nanosleep, 4)
+
+/* Timer */
+
+#define __NR_timer_create 			248
+__SYSCALL(248, sys_timer_create, 3)
+#define __NR_timer_delete 			249
+__SYSCALL(249, sys_timer_delete, 1)
+#define __NR_timer_settime 			250
+__SYSCALL(250, sys_timer_settime, 4)
+#define __NR_timer_gettime 			251
+__SYSCALL(251, sys_timer_gettime, 2)
+#define __NR_timer_getoverrun 			252
+__SYSCALL(252, sys_timer_getoverrun, 1)
+
+/* System */
+
+#define __NR_reserved244 			253
+__SYSCALL(253, sys_ni_syscall, 0)
+#define __NR_lookup_dcookie 			254
+__SYSCALL(254, sys_lookup_dcookie, 4)
+#define __NR_available255			255
+__SYSCALL(255, sys_ni_syscall, 0)
+#define __NR_add_key 				256
+__SYSCALL(256, sys_add_key, 5)
+#define __NR_request_key 			257
+__SYSCALL(257, sys_request_key, 5)
+#define __NR_keyctl 				258
+__SYSCALL(258, sys_keyctl, 5)
+#define __NR_available259			259
+__SYSCALL(259, sys_ni_syscall, 0)
+
+#define __NR_syscall_count			261
+
+/*
+ * sysxtensa syscall handler
+ *
+ * int sysxtensa (SYS_XTENSA_ATOMIC_SET,     ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_ADD,     ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_EXG_ADD, ptr, val,    unused);
+ * int sysxtensa (SYS_XTENSA_ATOMIC_CMP_SWP, ptr, oldval, newval);
+ *        a2            a6                   a3    a4      a5
+ */
+
+#define SYS_XTENSA_RESERVED               0     /* don't use this */
+#define SYS_XTENSA_ATOMIC_SET             1     /* set variable */
+#define SYS_XTENSA_ATOMIC_EXG_ADD         2     /* exchange memory and add */
+#define SYS_XTENSA_ATOMIC_ADD             3     /* add to memory */
+#define SYS_XTENSA_ATOMIC_CMP_SWP         4     /* compare and swap */
+
+#define SYS_XTENSA_COUNT                  5     /* count */
 
 #ifdef __KERNEL__
 
@@ -232,7 +611,9 @@
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
-#endif /* __KERNEL__ */
+#endif	/* __KERNEL__ */
 
 #endif	/* _XTENSA_UNISTD_H */
+
_

Patches currently in -mm which might be from czankel@tensilica.com are

xtensa-fix-irq-and-misc-fixes.patch
xtensa-remove-extra-header-files.patch
xtensa-fix-system-call-interface.patch

