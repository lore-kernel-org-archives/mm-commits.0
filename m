From: akpm@linux-foundation.org
Subject: + frv-utrace-implement-tracehooks.patch added to -mm tree
Date: Mon, 27 Apr 2009 12:54:50 -0700
Message-ID: <200904271954.n3RJsou3028809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756833AbZD0T5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 15:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, roland@redhat.com


The patch titled
     frv: utrace: implement tracehooks
has been added to the -mm tree.  Its filename is
     frv-utrace-implement-tracehooks.patch

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
Subject: frv: utrace: implement tracehooks
From: David Howells <dhowells@redhat.com>

Implement the tracehooks stuff for ptrace on FRV.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig               |    1 
 arch/frv/include/asm/elf.h     |    1 
 arch/frv/include/asm/ptrace.h  |   11 
 arch/frv/include/asm/syscall.h |  123 ++++++++++
 arch/frv/kernel/entry.S        |   12 
 arch/frv/kernel/ptrace.c       |  378 ++++++++++++++++++-------------
 arch/frv/kernel/signal.c       |    5 
 7 files changed, 367 insertions(+), 164 deletions(-)

diff -puN arch/frv/Kconfig~frv-utrace-implement-tracehooks arch/frv/Kconfig
--- a/arch/frv/Kconfig~frv-utrace-implement-tracehooks
+++ a/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_ARCH_TRACEHOOK
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/include/asm/elf.h~frv-utrace-implement-tracehooks arch/frv/include/asm/elf.h
--- a/arch/frv/include/asm/elf.h~frv-utrace-implement-tracehooks
+++ a/arch/frv/include/asm/elf.h
@@ -116,6 +116,7 @@ do {											\
 } while(0)
 
 #define USE_ELF_CORE_DUMP
+#define CORE_DUMP_USE_REGSET
 #define ELF_FDPIC_CORE_EFLAGS	EF_FRV_FDPIC
 #define ELF_EXEC_PAGESIZE	16384
 
diff -puN arch/frv/include/asm/ptrace.h~frv-utrace-implement-tracehooks arch/frv/include/asm/ptrace.h
--- a/arch/frv/include/asm/ptrace.h~frv-utrace-implement-tracehooks
+++ a/arch/frv/include/asm/ptrace.h
@@ -65,6 +65,8 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
+struct task_struct;
+
 /*
  * we dedicate GR28 to keeping a pointer to the current exception frame
  * - gr28 is destroyed on entry to the kernel from userspace
@@ -73,11 +75,18 @@ register struct pt_regs *__frame asm("gr
 
 #define user_mode(regs)			(!((regs)->psr & PSR_S))
 #define instruction_pointer(regs)	((regs)->pc)
+#define user_stack_pointer(regs)	((regs)->sp)
 
 extern unsigned long user_stack(const struct pt_regs *);
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
-#endif
+
+#define task_pt_regs(task) (task->thread.frame0)
+
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
 
 #endif /* !__ASSEMBLY__ */
+#endif /* __KERNEL__ */
 #endif /* _ASM_PTRACE_H */
diff -puN /dev/null arch/frv/include/asm/syscall.h
--- /dev/null
+++ a/arch/frv/include/asm/syscall.h
@@ -0,0 +1,123 @@
+/* syscall parameter access functions
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SYSCALL_H
+#define _ASM_SYSCALL_H
+
+#include <linux/err.h>
+#include <asm/ptrace.h>
+
+/*
+ * Get the system call number or -1
+ */
+static inline long syscall_get_nr(struct task_struct *task,
+				  struct pt_regs *regs)
+{
+	return regs->syscallno;
+}
+
+/*
+ * Restore the clobbered GR8 register
+ * (1st syscall arg was overwritten with syscall return or error)
+ */
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->gr8 = regs->orig_gr8;
+}
+
+/*
+ * See if the syscall return value is an error, returning it if it is and 0 if
+ * not
+ */
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return IS_ERR_VALUE(regs->gr8) ? regs->gr8 : 0;
+}
+
+/*
+ * Get the syscall return value
+ */
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->gr8;
+}
+
+/*
+ * Set the syscall return value
+ */
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	if (error)
+		regs->gr8 = -error;
+	else
+		regs->gr8 = val;
+}
+
+/*
+ * Retrieve the system call arguments
+ */
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	/*
+	 * Do this simply for now. If we need to start supporting
+	 * fetching arguments from arbitrary indices, this will need some
+	 * extra logic. Presently there are no in-tree users that depend
+	 * on this behaviour.
+	 */
+	BUG_ON(i);
+
+	/* Argument pattern is: GR8, GR9, GR10, GR11, GR12, GR13 */
+	switch (n) {
+	case 6: args[5] = regs->gr13;
+	case 5: args[4] = regs->gr12;
+	case 4: args[3] = regs->gr11;
+	case 3: args[2] = regs->gr10;
+	case 2: args[1] = regs->gr9;
+	case 1:	args[0] = regs->gr8;
+		break;
+	default:
+		BUG();
+	}
+}
+
+/*
+ * Alter the system call arguments
+ */
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	/* Same note as above applies */
+	BUG_ON(i);
+
+	switch (n) {
+	case 6: regs->gr13 = args[5];
+	case 5: regs->gr12 = args[4];
+	case 4: regs->gr11 = args[3];
+	case 3: regs->gr10 = args[2];
+	case 2: regs->gr9  = args[1];
+	case 1: regs->gr8  = args[0];
+		break;
+	default:
+		BUG();
+	}
+}
+
+#endif /* _ASM_SYSCALL_H */
diff -puN arch/frv/kernel/entry.S~frv-utrace-implement-tracehooks arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-utrace-implement-tracehooks
+++ a/arch/frv/kernel/entry.S
@@ -1149,11 +1149,10 @@ __entry_work_notifysig:
 	# perform syscall entry tracing
 __syscall_trace_entry:
 	LEDS		0x6320
-	setlos.p	#0,gr8
-	call		do_syscall_trace
+	call		syscall_trace_entry
 
-	ldi		@(gr28,#REG_SYSCALLNO),gr7
-	lddi		@(gr28,#REG_GR(8)) ,gr8
+	lddi.p		@(gr28,#REG_GR(8)) ,gr8
+	ori		gr8,#0,gr7		; syscall_trace_entry() returned new syscallno
 	lddi		@(gr28,#REG_GR(10)),gr10
 	lddi.p		@(gr28,#REG_GR(12)),gr12
 
@@ -1168,11 +1167,10 @@ __syscall_exit_work:
 	beq		icc0,#1,__entry_work_pending
 
 	movsg		psr,gr23
-	andi		gr23,#~PSR_PIL,gr23	; could let do_syscall_trace() call schedule()
+	andi		gr23,#~PSR_PIL,gr23	; could let syscall_trace_exit() call schedule()
 	movgs		gr23,psr
 
-	setlos.p	#1,gr8
-	call		do_syscall_trace
+	call		syscall_trace_exit
 	bra		__entry_resume_userspace
 
 __syscall_badsys:
diff -puN arch/frv/kernel/ptrace.c~frv-utrace-implement-tracehooks arch/frv/kernel/ptrace.c
--- a/arch/frv/kernel/ptrace.c~frv-utrace-implement-tracehooks
+++ a/arch/frv/kernel/ptrace.c
@@ -19,6 +19,9 @@
 #include <linux/user.h>
 #include <linux/security.h>
 #include <linux/signal.h>
+#include <linux/regset.h>
+#include <linux/elf.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -33,6 +36,169 @@
  */
 
 /*
+ * retrieve the contents of FRV userspace general registers
+ */
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	const struct user_int_regs *iregs = &target->thread.user->i;
+	int ret;
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  iregs, 0, sizeof(*iregs));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					sizeof(*iregs), -1);
+}
+
+/*
+ * update the contents of the FRV userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	struct user_int_regs *iregs = &target->thread.user->i;
+	unsigned int offs_gr0, offs_gr1;
+	int ret;
+
+	/* not allowed to set PSR or __status */
+	if (pos < offsetof(struct user_int_regs, psr) + sizeof(long) &&
+	    pos + count > offsetof(struct user_int_regs, psr))
+		return -EIO;
+
+	if (pos < offsetof(struct user_int_regs, __status) + sizeof(long) &&
+	    pos + count > offsetof(struct user_int_regs, __status))
+		return -EIO;
+
+	/* set the control regs */
+	offs_gr0 = offsetof(struct user_int_regs, gr[0]);
+	offs_gr1 = offsetof(struct user_int_regs, gr[1]);
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 iregs, 0, offs_gr0);
+	if (ret < 0)
+		return ret;
+
+	/* skip GR0/TBR */
+	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					offs_gr0, offs_gr1);
+	if (ret < 0)
+		return ret;
+
+	/* set the general regs */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 iregs, offs_gr1, sizeof(*iregs));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					sizeof(*iregs), -1);
+}
+
+/*
+ * retrieve the contents of FRV userspace FP/Media registers
+ */
+static int fpmregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	const struct user_fpmedia_regs *fpregs = &target->thread.user->f;
+	int ret;
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  fpregs, 0, sizeof(*fpregs));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					sizeof(*fpregs), -1);
+}
+
+/*
+ * update the contents of the FRV userspace FP/Media registers
+ */
+static int fpmregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	struct user_fpmedia_regs *fpregs = &target->thread.user->f;
+	int ret;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 fpregs, 0, sizeof(*fpregs));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					sizeof(*fpregs), -1);
+}
+
+/*
+ * determine if the FP/Media registers have actually been used
+ */
+static int fpmregs_active(struct task_struct *target,
+			  const struct user_regset *regset)
+{
+	return tsk_used_math(target) ? regset->n : 0;
+}
+
+/*
+ * Define the register sets available on the FRV under Linux
+ */
+enum frv_regset {
+	REGSET_GENERAL,
+	REGSET_FPMEDIA,
+};
+
+static const struct user_regset frv_regsets[] = {
+	/*
+	 * General register format is:
+	 *	PSR, ISR, CCR, CCCR, LR, LCR, PC, (STATUS), SYSCALLNO, ORIG_G8
+	 *	GNER0-1, IACC0, TBR, GR1-63
+	 */
+	[REGSET_GENERAL] = {
+		.core_note_type	= NT_PRSTATUS,
+		.n		= ELF_NGREG,
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= genregs_get,
+		.set		= genregs_set,
+	},
+	/*
+	 * FPU/Media register format is:
+	 *	FR0-63, FNER0-1, MSR0-1, ACC0-7, ACCG0-8, FSR
+	 */
+	[REGSET_FPMEDIA] = {
+		.core_note_type	= NT_PRFPREG,
+		.n		= sizeof(struct user_fpmedia_regs) / sizeof(long),
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= fpmregs_get,
+		.set		= fpmregs_set,
+		.active		= fpmregs_active,
+	},
+};
+
+static const struct user_regset_view user_frv_native_view = {
+	.name		= "frv",
+	.e_machine	= EM_FRV,
+	.regsets	= frv_regsets,
+	.n		= ARRAY_SIZE(frv_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_frv_native_view;
+}
+
+/*
  * Get contents of register REGNO in task TASK.
  */
 static inline long get_reg(struct task_struct *task, int regno)
@@ -69,40 +235,23 @@ static inline int put_reg(struct task_st
 }
 
 /*
- * check that an address falls within the bounds of the target process's memory
- * mappings
- */
-static inline int is_user_addr_valid(struct task_struct *child,
-				     unsigned long start, unsigned long len)
-{
-#ifdef CONFIG_MMU
-	if (start >= PAGE_OFFSET || len > PAGE_OFFSET - start)
-		return -EIO;
-	return 0;
-#else
-	struct vm_area_struct *vma;
-
-	vma = find_vma(child->mm, start);
-	if (vma && start >= vma->vm_start && start + len <= vma->vm_end)
-		return 0;
-
-	return -EIO;
-#endif
-}
-
-/*
  * Called by kernel/ptrace.c when detaching..
  *
  * Control h/w single stepping
  */
-void ptrace_disable(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
+{
+	child->thread.frame0->__status |= REG__STATUS_STEP;
+}
+
+void user_disable_single_step(struct task_struct *child)
 {
 	child->thread.frame0->__status &= ~REG__STATUS_STEP;
 }
 
-void ptrace_enable(struct task_struct *child)
+void ptrace_disable(struct task_struct *child)
 {
-	child->thread.frame0->__status |= REG__STATUS_STEP;
+	user_disable_single_step(child);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -111,15 +260,6 @@ long arch_ptrace(struct task_struct *chi
 	int ret;
 
 	switch (request) {
-		/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = -EIO;
-		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
-			break;
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 		/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
 		tmp = 0;
@@ -163,15 +303,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 
-		/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = -EIO;
-		if (is_user_addr_valid(child, addr, sizeof(tmp)) < 0)
-			break;
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
 		if ((addr & 3) || addr < 0)
@@ -179,7 +310,7 @@ long arch_ptrace(struct task_struct *chi
 
 		ret = 0;
 		switch (addr >> 2) {
-		case 0 ... PT__END-1:
+		case 0 ... PT__END - 1:
 			ret = put_reg(child, addr >> 2, data);
 			break;
 
@@ -189,95 +320,29 @@ long arch_ptrace(struct task_struct *chi
 		}
 		break;
 
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		ptrace_disable(child);
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-		/* make the child exit.  Best I can do is send it a sigkill.
-		 * perhaps it should be put in the status that it wants to
-		 * exit.
-		 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
-		ptrace_disable(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP:  /* set the trap flag. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_enable(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-	case PTRACE_DETACH:	/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
-	case PTRACE_GETREGS: { /* Get all integer regs from the child. */
-		int i;
-		for (i = 0; i < PT__GPEND; i++) {
-			tmp = get_reg(child, i);
-			if (put_user(tmp, (unsigned long *) data)) {
-				ret = -EFAULT;
-				break;
-			}
-			data += sizeof(long);
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all integer regs in the child. */
-		int i;
-		for (i = 0; i < PT__GPEND; i++) {
-			if (get_user(tmp, (unsigned long *) data)) {
-				ret = -EFAULT;
-				break;
-			}
-			put_reg(child, i, tmp);
-			data += sizeof(long);
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_GETFPREGS: { /* Get the child FP/Media state. */
-		ret = 0;
-		if (copy_to_user((void *) data,
-				 &child->thread.user->f,
-				 sizeof(child->thread.user->f)))
-			ret = -EFAULT;
-		break;
-	}
-
-	case PTRACE_SETFPREGS: { /* Set the child FP/Media state. */
-		ret = 0;
-		if (copy_from_user(&child->thread.user->f,
-				   (void *) data,
-				   sizeof(child->thread.user->f)))
-			ret = -EFAULT;
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all integer regs from the child. */
+		return copy_regset_to_user(child, &user_frv_native_view,
+					   REGSET_GENERAL,
+					   0, sizeof(child->thread.user->i),
+					   (void __user *)data);
+
+	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
+		return copy_regset_from_user(child, &user_frv_native_view,
+					     REGSET_GENERAL,
+					     0, sizeof(child->thread.user->i),
+					     (const void __user *)data);
+
+	case PTRACE_GETFPREGS:	/* Get the child FP/Media state. */
+		return copy_regset_to_user(child, &user_frv_native_view,
+					   REGSET_FPMEDIA,
+					   0, sizeof(child->thread.user->f),
+					   (void __user *)data);
+
+	case PTRACE_SETFPREGS:	/* Set the child FP/Media state. */
+		return copy_regset_from_user(child, &user_frv_native_view,
+					     REGSET_FPMEDIA,
+					     0, sizeof(child->thread.user->f),
+					     (const void __user *)data);
 
 	case PTRACE_GETFDPIC:
 		tmp = 0;
@@ -300,35 +365,36 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	default:
-		ret = -EIO;
+		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
 	return ret;
 }
 
-asmlinkage void do_syscall_trace(int leaving)
+/*
+ * handle tracing of system call entry
+ * - return the revised system call number or ULONG_MAX to cause ENOSYS
+ */
+asmlinkage unsigned long syscall_trace_entry(void)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-
-	if (!(current->ptrace & PT_PTRACED))
-		return;
-
-	/* we need to indicate entry or exit to strace */
-	if (leaving)
-		__frame->__status |= REG__STATUS_SYSC_EXIT;
-	else
-		__frame->__status |= REG__STATUS_SYSC_ENTRY;
+	__frame->__status |= REG__STATUS_SYSC_ENTRY;
+	if (tracehook_report_syscall_entry(__frame)) {
+		/* tracing decided this syscall should not happen, so
+		 * We'll return a bogus call number to get an ENOSYS
+		 * error, but leave the original number in
+		 * __frame->syscallno
+		 */
+		return ULONG_MAX;
+	}
 
-	ptrace_notify(SIGTRAP);
+	return __frame->syscallno;
+}
 
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+/*
+ * handle tracing of system call exit
+ */
+asmlinkage void syscall_trace_exit(void)
+{
+	__frame->__status |= REG__STATUS_SYSC_EXIT;
+	tracehook_report_syscall_exit(__frame, 0);
 }
diff -puN arch/frv/kernel/signal.c~frv-utrace-implement-tracehooks arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~frv-utrace-implement-tracehooks
+++ a/arch/frv/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/tracehook.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -516,6 +517,9 @@ static void do_signal(void)
 			 * clear the TIF_RESTORE_SIGMASK flag */
 			if (test_thread_flag(TIF_RESTORE_SIGMASK))
 				clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+			tracehook_signal_handler(signr, &info, &ka, __frame,
+						 test_thread_flag(TIF_SINGLESTEP));
 		}
 
 		return;
@@ -567,6 +571,7 @@ asmlinkage void do_notify_resume(__u32 t
 	/* deal with notification on about to resume userspace execution */
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(__frame);
 	}
 
 } /* end do_notify_resume() */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-utrace-remove-in-kernel-strace-code.patch
frv-utrace-implement-tif_notify_resume.patch
frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch
frv-utrace-implement-tracehooks.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
mutex-subsystem-synchro-test-module.patch

