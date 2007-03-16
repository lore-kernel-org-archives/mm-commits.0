From: akpm@linux-foundation.org
Subject: + avr32-implement-utrace-support.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:21:50 -0800
Message-ID: <200703160321.l2G3Lo3J001439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXCPDWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, roland@redhat.com


The patch titled
     AVR32: implement utrace support
has been added to the -mm tree.  Its filename is
     avr32-implement-utrace-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AVR32: implement utrace support
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Rip out most of the ptrace code for AVR32 and replace it with the much
nicer utrace stuff.  It builds in all possible combinations of
CONFIG_UTRACE and CONFIG_PTRACE, and it seems to work as far as I've tested
it with strace and some simple debugging with gdb.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/entry-avr32b.S |   10 
 arch/avr32/kernel/process.c      |    2 
 arch/avr32/kernel/ptrace.c       |  322 +++++++----------------------
 include/asm-avr32/tracehook.h    |   69 ++++++
 4 files changed, 164 insertions(+), 239 deletions(-)

diff -puN arch/avr32/kernel/entry-avr32b.S~avr32-implement-utrace-support arch/avr32/kernel/entry-avr32b.S
--- a/arch/avr32/kernel/entry-avr32b.S~avr32-implement-utrace-support
+++ a/arch/avr32/kernel/entry-avr32b.S
@@ -229,15 +229,21 @@ ret_from_fork:
 	rjmp    syscall_exit_cont
 
 syscall_trace_enter:
-	pushm	r8-r12
+	mov	r12, sp		/* regs		*/
+	mov	r11, 0		/* is_exit	*/
 	rcall	syscall_trace
-	popm	r8-r12
+
+	/* syscall_trace may update r8, so reload r8-r12 from regs. */
+	sub	lr, sp, -REG_R12
+	ldm	lr, r8-r12
 	rjmp	syscall_trace_cont
 
 syscall_exit_work:
 	bld	r1, TIF_SYSCALL_TRACE
 	brcc	1f
 	unmask_interrupts
+	mov	r12, sp
+	mov	r11, 1
 	rcall	syscall_trace
 	mask_interrupts
 	ld.w	r1, r0[TI_flags]
diff -puN arch/avr32/kernel/process.c~avr32-implement-utrace-support arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~avr32-implement-utrace-support
+++ a/arch/avr32/kernel/process.c
@@ -229,8 +229,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0)
-		current->ptrace &= ~PT_DTRACE;
 	putname(filename);
 
 out:
diff -puN arch/avr32/kernel/ptrace.c~avr32-implement-utrace-support arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~avr32-implement-utrace-support
+++ a/arch/avr32/kernel/ptrace.c
@@ -5,23 +5,23 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#undef DEBUG
+
+#include <linux/compile.h>
+#include <linux/elf.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp_lock.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/ptrace.h>
-#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/tracehook.h>
 #include <linux/user.h>
-#include <linux/security.h>
-#include <linux/unistd.h>
-#include <linux/notifier.h>
 
-#include <asm/traps.h>
-#include <asm/uaccess.h>
-#include <asm/ocd.h>
-#include <asm/mmu_context.h>
 #include <asm/kdebug.h>
+#include <asm/mmu_context.h>
+#include <asm/ocd.h>
+
+#ifdef CONFIG_UTRACE
 
 static struct pt_regs *get_user_regs(struct task_struct *tsk)
 {
@@ -29,261 +29,113 @@ static struct pt_regs *get_user_regs(str
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
-static void ptrace_single_step(struct task_struct *tsk)
-{
-	pr_debug("ptrace_single_step: pid=%u, SR=0x%08lx\n",
-		 tsk->pid, tsk->thread.cpu_context.sr);
-	if (!(tsk->thread.cpu_context.sr & SR_D)) {
-		/*
-		 * Set a breakpoint at the current pc to force the
-		 * process into debug mode.  The syscall/exception
-		 * exit code will set a breakpoint at the return
-		 * address when this flag is set.
-		 */
-		pr_debug("ptrace_single_step: Setting TIF_BREAKPOINT\n");
-		set_tsk_thread_flag(tsk, TIF_BREAKPOINT);
-	}
-
-	/* The monitor code will do the actual step for us */
-	set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
-}
-
-/*
- * Called by kernel/ptrace.c when detaching
- *
- * Make sure any single step bits, etc. are not set
- */
-void ptrace_disable(struct task_struct *child)
-{
-	clear_tsk_thread_flag(child, TIF_SINGLE_STEP);
-}
-
-/*
- * Handle hitting a breakpoint
- */
-static void ptrace_break(struct task_struct *tsk, struct pt_regs *regs)
-{
-	siginfo_t info;
-
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code  = TRAP_BRKPT;
-	info.si_addr  = (void __user *)instruction_pointer(regs);
-
-	pr_debug("ptrace_break: Sending SIGTRAP to PID %u (pc = 0x%p)\n",
-		 tsk->pid, info.si_addr);
-	force_sig_info(SIGTRAP, &info, tsk);
-}
-
-/*
- * Read the word at offset "offset" into the task's "struct user". We
- * actually access the pt_regs struct stored on the kernel stack.
- */
-static int ptrace_read_user(struct task_struct *tsk, unsigned long offset,
-			    unsigned long __user *data)
-{
-	unsigned long *regs;
-	unsigned long value;
-
-	pr_debug("ptrace_read_user(%p, %#lx, %p)\n",
-		 tsk, offset, data);
-
-	if (offset & 3 || offset >= sizeof(struct user)) {
-		printk("ptrace_read_user: invalid offset 0x%08lx\n", offset);
-		return -EIO;
-	}
-
-	regs = (unsigned long *)get_user_regs(tsk);
-
-	value = 0;
-	if (offset < sizeof(struct pt_regs))
-		value = regs[offset / sizeof(regs[0])];
-
-	return put_user(value, data);
-}
-
-/*
- * Write the word "value" to offset "offset" into the task's "struct
- * user". We actually access the pt_regs struct stored on the kernel
- * stack.
- */
-static int ptrace_write_user(struct task_struct *tsk, unsigned long offset,
-			     unsigned long value)
+static int genregs_get(struct task_struct *target,
+		       const struct utrace_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
 {
-	unsigned long *regs;
-
-	if (offset & 3 || offset >= sizeof(struct user)) {
-		printk("ptrace_write_user: invalid offset 0x%08lx\n", offset);
-		return -EIO;
-	}
-
-	if (offset >= sizeof(struct pt_regs))
-		return 0;
+	struct pt_regs *regs = get_user_regs(target);
 
-	regs = (unsigned long *)get_user_regs(tsk);
-	regs[offset / sizeof(regs[0])] = value;
-
-	return 0;
+	return utrace_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				     regs, 0, -1);
 }
 
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
+static int genregs_set(struct task_struct *target,
+		       const struct utrace_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
 {
-	struct pt_regs *regs = get_user_regs(tsk);
+	struct pt_regs *regs = get_user_regs(target);
 
-	return copy_to_user(uregs, regs, sizeof(*regs)) ? -EFAULT : 0;
+	return utrace_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				    regs, 0, -1);
 }
 
-static int ptrace_setregs(struct task_struct *tsk, const void __user *uregs)
-{
-	struct pt_regs newregs;
-	int ret;
-
-	ret = -EFAULT;
-	if (copy_from_user(&newregs, uregs, sizeof(newregs)) == 0) {
-		struct pt_regs *regs = get_user_regs(tsk);
-
-		ret = -EINVAL;
-		if (valid_user_regs(&newregs)) {
-			*regs = newregs;
-			ret = 0;
-		}
-	}
-
-	return ret;
-}
+static const struct utrace_regset native_regsets[] = {
+	{
+		.n	= ELF_NGREG,
+		.size	= sizeof(long),
+		.align	= sizeof(long),
+		.get	= genregs_get,
+		.set	= genregs_set,
+	},
+	/*
+	 * Other register sets that probably would make sense:
+	 *   - Coprocessor registers (8 coprocs with 16 registers each)
+	 *   - TLS stuff
+	 */
+};
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+const struct utrace_regset_view utrace_avr32_native_view = {
+	.name		= UTS_MACHINE,
+	.e_machine	= ELF_ARCH,
+	.regsets	= native_regsets,
+	.n		= ARRAY_SIZE(native_regsets),
+};
+EXPORT_SYMBOL_GPL(utrace_avr32_native_view);
+
+#ifdef CONFIG_PTRACE
+
+static const struct ptrace_layout_segment avr32_uarea[] = {
+	{ 0, ELF_NGREG * sizeof(long), 0, 0 },
+	{ 0, 0, -1, 0 },
+};
+
+int arch_ptrace(long *request, struct task_struct *child,
+		struct utrace_attached_engine *engine,
+		unsigned long addr, unsigned long data, long *val)
 {
-	unsigned long tmp;
-	int ret;
-
 	pr_debug("arch_ptrace(%ld, %d, %#lx, %#lx)\n",
-		 request, child->pid, addr, data);
+		 *request, child->pid, addr, data);
 
 	pr_debug("ptrace: Enabling monitor mode...\n");
 	__mtdr(DBGREG_DC, __mfdr(DBGREG_DC) | DC_MM | DC_DBE);
 
-	switch (request) {
-	/* Read the word at location addr in the child process */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		if (ret == sizeof(tmp))
-			ret = put_user(tmp, (unsigned long __user *)data);
-		else
-			ret = -EIO;
-		break;
-
+	switch (*request) {
 	case PTRACE_PEEKUSR:
-		ret = ptrace_read_user(child, addr,
-				       (unsigned long __user *)data);
-		break;
-
-	/* Write the word in data at location addr */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		ret = access_process_vm(child, addr, &data, sizeof(data), 1);
-		if (ret == sizeof(data))
-			ret = 0;
-		else
-			ret = -EIO;
-		break;
+		return ptrace_peekusr(child, engine, avr32_uarea, addr, data);
 
 	case PTRACE_POKEUSR:
-		ret = ptrace_write_user(child, addr, data);
-		break;
-
-	/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-	/* restart after signal */
-	case PTRACE_CONT:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		/* XXX: Are we sure no breakpoints are active here? */
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/*
-	 * Make the child exit. Best I can do is send it a
-	 * SIGKILL. Perhaps it should be put in the status that it
-	 * wants to exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-
-	/*
-	 * execute single instruction.
-	 */
-	case PTRACE_SINGLESTEP:
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_single_step(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	/* Detach a process that was attached */
-	case PTRACE_DETACH:
-		ret = ptrace_detach(child, data);
+		return ptrace_pokeusr(child, engine, avr32_uarea, addr, data);
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		return ptrace_whole_regset(child, engine, data, 0, 0);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (const void __user *)data);
-		break;
-
-	default:
-		ret = ptrace_request(child, request, addr, data);
+		return ptrace_whole_regset(child, engine, data, 0, 1);
 		break;
 	}
 
-	pr_debug("sys_ptrace returning %d (DC = 0x%08lx)\n", ret, __mfdr(DBGREG_DC));
-	return ret;
+	return -ENOSYS;
 }
+#endif /* CONFIG_PTRACE */
+#endif /* CONFIG_UTRACE */
 
-asmlinkage void syscall_trace(void)
+asmlinkage void syscall_trace(struct pt_regs *regs, int is_exit)
 {
-	pr_debug("syscall_trace called\n");
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
-	if (!(current->ptrace & PT_PTRACED))
-		return;
 
-	pr_debug("syscall_trace: notifying parent\n");
-	/* The 0x80 provides a way for the tracing parent to
-	 * distinguish between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
+	tracehook_report_syscall(regs, is_exit);
+}
 
-	/*
-	 * this isn't the same as continuing with a signal, but it
-	 * will do for normal use.  strace only continues with a
-	 * signal if the stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		pr_debug("syscall_trace: sending signal %d to PID %u\n",
-			 current->exit_code, current->pid);
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+/*
+ * Handle hitting a breakpoint
+ */
+static void do_breakpoint(struct task_struct *tsk, struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	info.si_signo = SIGTRAP;
+	info.si_errno = 0;
+	info.si_code  = TRAP_BRKPT;
+	info.si_addr  = (void __user *)instruction_pointer(regs);
+
+	pr_debug("ptrace_break: Sending SIGTRAP to PID %u (pc = 0x%p)\n",
+		 tsk->pid, info.si_addr);
+	force_sig_info(SIGTRAP, &info, tsk);
 }
 
 asmlinkage void do_debug_priv(struct pt_regs *regs)
@@ -362,10 +214,10 @@ asmlinkage void do_debug(struct pt_regs 
 			__mtdr(DBGREG_DC, dc);
 
 			clear_thread_flag(TIF_SINGLE_STEP);
-			ptrace_break(current, regs);
+			do_breakpoint(current, regs);
 		}
 	} else {
 		/* regular breakpoint */
-		ptrace_break(current, regs);
+		do_breakpoint(current, regs);
 	}
 }
diff -puN /dev/null include/asm-avr32/tracehook.h
--- /dev/null
+++ a/include/asm-avr32/tracehook.h
@@ -0,0 +1,69 @@
+/*
+ * Tracing hooks for AVR32
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_AVR32_TRACEHOOK_H
+#define _ASM_AVR32_TRACEHOOK_H
+
+#include <linux/sched.h>
+
+#define ARCH_HAS_SINGLE_STEP	1
+
+static inline void tracehook_enable_single_step(struct task_struct *tsk)
+{
+	/*
+	 * If the process is stopped in debug mode, simply set
+	 * TIF_SINGLE_STEP to tell the monitor code to set the single
+	 * step bit in DC before returning.
+	 *
+	 * Otherwise, we need to set a breakpoint at the return
+	 * address before returning to userspace. TIF_BREAKPOINT will
+	 * tell the syscall/exception exit code to do this.
+	 */
+	if (!(tsk->thread.cpu_context.sr & SR_D))
+		set_tsk_thread_flag(tsk, TIF_BREAKPOINT);
+
+	set_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
+}
+
+static inline void tracehook_disable_single_step(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_BREAKPOINT);
+	clear_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
+}
+
+static inline int tracehook_single_step_enabled(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_SINGLE_STEP);
+}
+
+static inline void tracehook_enable_syscall_trace(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_disable_syscall_trace(struct task_struct *tsk)
+{
+	clear_tsk_thread_flag(tsk, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_abort_syscall(struct pt_regs *regs)
+{
+	/* Invalid system call number => return -ENOSYS */
+	regs->r8 = -1;
+}
+
+extern const struct utrace_regset_view utrace_avr32_native_view;
+
+static inline const struct utrace_regset_view *
+utrace_native_view(struct task_struct *tsk)
+{
+	return &utrace_avr32_native_view;
+}
+
+#endif /* _ASM_AVR32_TRACEHOOK_H */
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
gpio_direction_output-needs-an-initial-value.patch
git-avr32.patch
avr32-implement-utrace-support.patch
