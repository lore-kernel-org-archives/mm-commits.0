From: akpm@linux-foundation.org
Subject: - h8300-entrys-update.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:35 -0700
Message-ID: <200707162050.l6GKoZ4j001324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759919AbXGPVWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300 entry.S update
has been removed from the -mm tree.  Its filename was
     h8300-entrys-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 entry.S update
From: Yoshinori Sato <ysato@users.sourceforge.jp>

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/Makefile          |    3 
 arch/h8300/kernel/entry.S           |  393 ++++++++++++++++++++++++++
 arch/h8300/kernel/ptrace.c          |    2 
 arch/h8300/kernel/signal.c          |    6 
 arch/h8300/platform/h8300h/Makefile |    2 
 arch/h8300/platform/h8300h/entry.S  |  332 ---------------------
 arch/h8300/platform/h8s/Makefile    |    2 
 arch/h8300/platform/h8s/entry.S     |  331 ---------------------
 include/asm-h8300/thread_info.h     |    2 
 9 files changed, 406 insertions(+), 667 deletions(-)

diff -puN arch/h8300/kernel/Makefile~h8300-entrys-update arch/h8300/kernel/Makefile
--- a/arch/h8300/kernel/Makefile~h8300-entrys-update
+++ a/arch/h8300/kernel/Makefile
@@ -6,6 +6,7 @@ extra-y := vmlinux.lds
 
 obj-y := process.o traps.o ptrace.o irq.o \
 	 sys_h8300.o time.o semaphore.o signal.o \
-         setup.o gpio.o init_task.o syscalls.o
+         setup.o gpio.o init_task.o syscalls.o \
+	 entry.o
 
 obj-$(CONFIG_MODULES) += module.o h8300_ksyms.o 
diff -puN /dev/null arch/h8300/kernel/entry.S
--- /dev/null
+++ a/arch/h8300/kernel/entry.S
@@ -0,0 +1,393 @@
+/* -*- mode: asm -*-
+ *
+ *  linux/arch/h8300/platform/h8300h/entry.S
+ *
+ *  Yoshinori Sato <ysato@users.sourceforge.jp>
+ *  David McCullough <davidm@snapgear.com>
+ *
+ */
+
+/*
+ *  entry.S
+ *  include exception/interrupt gateway
+ *          system call entry
+ */
+
+#include <linux/sys.h>
+#include <asm/unistd.h>
+#include <asm/setup.h>
+#include <asm/segment.h>
+#include <asm/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/errno.h>
+
+#if defined(CONFIG_CPU_H8300H)
+#define USERRET 8
+INTERRUPTS = 64
+	.h8300h
+	.macro	SHLL2 reg
+	shll.l	\reg
+	shll.l	\reg
+	.endm
+	.macro	SHLR2 reg
+	shlr.l	\reg
+	shlr.l	\reg
+	.endm
+	.macro	SAVEREGS
+	mov.l	er0,@-sp
+	mov.l	er1,@-sp
+	mov.l	er2,@-sp
+	mov.l	er3,@-sp
+	.endm
+	.macro	RESTOREREGS
+	mov.l	@sp+,er3
+	mov.l	@sp+,er2
+	.endm
+	.macro	SAVEEXR
+	.endm
+	.macro	RESTOREEXR
+	.endm
+#endif
+#if defined(CONFIG_CPU_H8S)
+#define USERRET 10
+#define USEREXR 8
+INTERRUPTS = 128
+	.h8300s
+	.macro	SHLL2 reg
+	shll.l	#2,\reg
+	.endm
+	.macro	SHLR2 reg
+	shlr.l	#2,\reg
+	.endm
+	.macro	SAVEREGS
+	stm.l	er0-er3,@-sp
+	.endm
+	.macro	RESTOREREGS
+	ldm.l	@sp+,er2-er3
+	.endm
+	.macro	SAVEEXR
+	mov.w	@(USEREXR:16,er0),r1
+	mov.w	r1,@(LEXR-LER3:16,sp)		/* copy EXR */
+	.endm
+	.macro	RESTOREEXR
+	mov.w	@(LEXR-LER1:16,sp),r1		/* restore EXR */
+	mov.b	r1l,r1h
+	mov.w	r1,@(USEREXR:16,er0)
+	.endm
+#endif
+
+
+/* CPU context save/restore macros. */
+
+	.macro	SAVE_ALL
+	mov.l	er0,@-sp
+	stc	ccr,r0l				/* check kernel mode */
+	btst	#4,r0l
+	bne	5f
+
+	/* user mode */
+	mov.l	sp,@SYMBOL_NAME(sw_usp)
+	mov.l	@sp,er0				/* restore saved er0 */
+	orc	#0x10,ccr			/* switch kernel stack */
+	mov.l	@SYMBOL_NAME(sw_ksp),sp
+	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */
+	SAVEREGS
+	mov.l   @SYMBOL_NAME(sw_usp),er0
+	mov.l   @(USERRET:16,er0),er1           /* copy the RET addr */
+	mov.l   er1,@(LRET-LER3:16,sp)
+	SAVEEXR
+
+	mov.l	@(LORIG-LER3:16,sp),er0
+	mov.l	er0,@(LER0-LER3:16,sp)		/* copy ER0 */
+	mov.w	e1,r1				/* e1 highbyte = ccr */
+	and	#0xef,r1h			/* mask mode? flag */
+	bra	6f
+5:
+	/* kernel mode */
+	mov.l	@sp,er0				/* restore saved er0 */
+	subs	#2,sp				/* set dummy ccr */
+	SAVEREGS
+	mov.w	@(LRET-LER3:16,sp),r1		/* copy old ccr */
+6:
+	mov.b	r1h,r1l
+	mov.b	#0,r1h
+	mov.w	r1,@(LCCR-LER3:16,sp)		/* set ccr */
+	mov.l	er6,@-sp			/* syscall arg #6 */
+	mov.l	er5,@-sp			/* syscall arg #5 */
+	mov.l	er4,@-sp			/* syscall arg #4 */
+	.endm					/* r1 = ccr */
+
+	.macro	RESTORE_ALL
+	mov.l	@sp+,er4
+	mov.l	@sp+,er5
+	mov.l	@sp+,er6
+	RESTOREREGS
+	mov.w	@(LCCR-LER1:16,sp),r0		/* check kernel mode */
+	btst	#4,r0l
+	bne	7f
+
+	orc	#0x80,ccr
+	mov.l	@SYMBOL_NAME(sw_usp),er0
+	mov.l	@(LER0-LER1:16,sp),er1		/* restore ER0 */
+	mov.l	er1,@er0
+	RESTOREEXR
+	mov.w	@(LCCR-LER1:16,sp),r1		/* restore the RET addr */
+	mov.b	r1l,r1h
+	mov.b	@(LRET+1-LER1:16,sp),r1l
+	mov.w	r1,e1
+	mov.w	@(LRET+2-LER1:16,sp),r1
+	mov.l	er1,@(USERRET:16,er0)
+
+	mov.l	@sp+,er1
+	add.l	#(LRET-LER1),sp			/* remove LORIG - LRET */
+	mov.l	sp,@SYMBOL_NAME(sw_ksp)
+	andc	#0xef,ccr			/* switch to user mode */
+	mov.l	er0,sp
+	bra	8f
+7:
+	mov.l	@sp+,er1
+	adds	#4,sp
+	adds	#2,sp
+8:
+	mov.l	@sp+,er0
+	adds	#4,sp				/* remove the sw created LVEC */
+	rte
+	.endm
+
+.globl SYMBOL_NAME(system_call)
+.globl SYMBOL_NAME(ret_from_exception)
+.globl SYMBOL_NAME(ret_from_fork)
+.globl SYMBOL_NAME(ret_from_interrupt)
+.globl SYMBOL_NAME(interrupt_redirect_table)
+.globl SYMBOL_NAME(sw_ksp),SYMBOL_NAME(sw_usp)
+.globl SYMBOL_NAME(resume)
+.globl SYMBOL_NAME(interrupt_entry)
+.globl SYMBOL_NAME(trace_break)
+
+#if defined(CONFIG_ROMKERNEL)
+	.section .int_redirect,"ax"
+SYMBOL_NAME_LABEL(interrupt_redirect_table)
+#if defined(CONFIG_CPU_H8300H)
+	.rept	7
+	.long	0
+	.endr
+#endif
+#if defined(CONFIG_CPU_H8S)
+	.rept	5
+	.long	0
+	.endr
+	jmp	@SYMBOL_NAME(trace_break)
+	.long	0
+#endif
+
+	jsr	@SYMBOL_NAME(interrupt_entry)	/* NMI */
+	jmp	@SYMBOL_NAME(system_call)	/* TRAPA #0 (System call) */
+	.long	0
+	.long	0
+	jmp	@SYMBOL_NAME(trace_break)	/* TRAPA #3 (breakpoint) */
+	.rept	INTERRUPTS-12
+	jsr	@SYMBOL_NAME(interrupt_entry)
+	.endr
+#endif
+#if defined(CONFIG_RAMKERNEL)
+.globl SYMBOL_NAME(interrupt_redirect_table)
+	.section .bss
+SYMBOL_NAME_LABEL(interrupt_redirect_table)
+	.space	4
+#endif
+
+	.section .text
+	.align	2
+SYMBOL_NAME_LABEL(interrupt_entry)
+	SAVE_ALL
+	mov.l	sp,er0
+	add.l	#LVEC,er0
+	btst	#4,r1l
+	bne	1f
+	/* user LVEC */
+	mov.l	@SYMBOL_NAME(sw_usp),er0
+	adds	#4,er0
+1:
+	mov.l	@er0,er0			/* LVEC address */
+#if defined(CONFIG_ROMKERNEL)
+	sub.l	#SYMBOL_NAME(interrupt_redirect_table),er0
+#endif
+#if defined(CONFIG_RAMKERNEL)
+	mov.l	@SYMBOL_NAME(interrupt_redirect_table),er1
+	sub.l	er1,er0
+#endif
+	SHLR2	er0
+	dec.l	#1,er0
+	mov.l	sp,er1
+	subs	#4,er1				/* adjust ret_pc */
+	jsr	@SYMBOL_NAME(do_IRQ)
+	jmp	@SYMBOL_NAME(ret_from_interrupt)
+
+SYMBOL_NAME_LABEL(system_call)
+	subs	#4,sp				/* dummy LVEC */
+	SAVE_ALL
+	andc	#0x7f,ccr
+	mov.l	er0,er4
+
+	/* save top of frame */
+	mov.l	sp,er0
+	jsr	@SYMBOL_NAME(set_esp0)
+	mov.l	sp,er2
+	and.w	#0xe000,r2
+	mov.b	@((TI_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
+	btst	#(TIF_SYSCALL_TRACE & 7),r2l
+	beq	1f
+	jsr	@SYMBOL_NAME(do_syscall_trace)
+1:
+	cmp.l	#NR_syscalls,er4
+	bcc	badsys
+	SHLL2	er4
+	mov.l	#SYMBOL_NAME(sys_call_table),er0
+	add.l	er4,er0
+	mov.l	@er0,er4
+	beq	SYMBOL_NAME(ret_from_exception):16
+	mov.l	@(LER1:16,sp),er0
+	mov.l	@(LER2:16,sp),er1
+	mov.l	@(LER3:16,sp),er2
+	jsr	@er4
+	mov.l	er0,@(LER0:16,sp)		/* save the return value */
+	mov.l	sp,er2
+	and.w	#0xe000,r2
+	mov.b	@((TI_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
+	btst	#(TIF_SYSCALL_TRACE & 7),r2l
+	beq	2f
+	jsr	@SYMBOL_NAME(do_syscall_trace)
+2:
+#if defined(CONFIG_SYSCALL_PRINT)
+	jsr	@SYMBOL_NAME(syscall_print)
+#endif
+	orc	#0x80,ccr
+	bra	resume_userspace
+
+badsys:
+	mov.l	#-ENOSYS,er0
+	mov.l	er0,@(LER0:16,sp)
+	bra	resume_userspace
+
+#if !defined(CONFIG_PREEMPT)
+#define resume_kernel restore_all
+#endif
+
+SYMBOL_NAME_LABEL(ret_from_exception)
+#if defined(CONFIG_PREEMPT)
+	orc	#0x80,ccr
+#endif
+SYMBOL_NAME_LABEL(ret_from_interrupt)
+	mov.b	@(LCCR+1:16,sp),r0l
+	btst	#4,r0l
+	bne	resume_kernel:8		/* return from kernel */
+resume_userspace:
+	andc	#0x7f,ccr
+	mov.l	sp,er4
+	and.w	#0xe000,r4		/* er4 <- current thread info */
+	mov.l	@(TI_FLAGS:16,er4),er1
+	and.l	#_TIF_WORK_MASK,er1
+	beq	restore_all:8
+work_pending:
+	btst	#TIF_NEED_RESCHED,r1l
+	bne	work_resched:8
+	/* work notifysig */
+	mov.l	sp,er0
+	subs	#4,er0			/* er0: pt_regs */
+	jsr	@SYMBOL_NAME(do_notify_resume)
+	bra	restore_all:8
+work_resched:
+	mov.l	sp,er0
+	jsr	@SYMBOL_NAME(set_esp0)
+	jsr	@SYMBOL_NAME(schedule)
+	bra	resume_userspace:8
+restore_all:
+	RESTORE_ALL			/* Does RTE */
+
+#if defined(CONFIG_PREEMPT)
+resume_kernel:
+	mov.l	@(TI_PRE_COUNT:16,er4),er0
+	bne	restore_all:8
+need_resched:
+	mov.l	@(TI_FLAGS:16,er4),er0
+	btst	#TIF_NEED_RESCHED,r0l
+	beq	restore_all:8
+	mov.b	@(LCCR+1:16,sp),r0l	/* Interrupt Enabled? */
+	bmi	restore_all:8
+	mov.l	#PREEMPT_ACTIVE,er0
+	mov.l	er0,@(TI_PRE_COUNT:16,er4)
+	andc	#0x7f,ccr
+	mov.l	sp,er0
+	jsr	@SYMBOL_NAME(set_esp0)
+	jsr	@SYMBOL_NAME(schedule)
+	orc	#0x80,ccr
+	bra	need_resched:8
+#endif
+
+SYMBOL_NAME_LABEL(ret_from_fork)
+	mov.l	er2,er0
+	jsr	@SYMBOL_NAME(schedule_tail)
+	jmp	@SYMBOL_NAME(ret_from_exception)
+
+SYMBOL_NAME_LABEL(resume)
+	/*
+	 * Beware - when entering resume, offset of tss is in d1,
+	 * prev (the current task) is in a0, next (the new task)
+	 * is in a1 and d2.b is non-zero if the mm structure is
+	 * shared between the tasks, so don't change these
+	 * registers until their contents are no longer needed.
+	 */
+
+	/* save sr */
+	sub.w	r3,r3
+	stc	ccr,r3l
+	mov.w	r3,@(THREAD_CCR+2:16,er0)
+
+	/* disable interrupts */
+	orc	#0x80,ccr
+	mov.l	@SYMBOL_NAME(sw_usp),er3
+	mov.l	er3,@(THREAD_USP:16,er0)
+	mov.l	sp,@(THREAD_KSP:16,er0)
+
+	/* Skip address space switching if they are the same. */
+	/* FIXME: what did we hack out of here, this does nothing! */
+
+	mov.l	@(THREAD_USP:16,er1),er0
+	mov.l	er0,@SYMBOL_NAME(sw_usp)
+	mov.l	@(THREAD_KSP:16,er1),sp
+
+	/* restore status register */
+	mov.w	@(THREAD_CCR+2:16,er1),r3
+
+	ldc	r3l,ccr
+	rts
+
+SYMBOL_NAME_LABEL(trace_break)
+	subs	#4,sp
+	SAVE_ALL
+	sub.l	er1,er1
+	dec.l	#1,er1
+	mov.l	er1,@(LORIG,sp)
+	mov.l	sp,er0
+	jsr	@SYMBOL_NAME(set_esp0)
+	mov.l	@SYMBOL_NAME(sw_usp),er0
+	mov.l	@er0,er1
+	mov.w	@(-2:16,er1),r2
+	cmp.w	#0x5730,r2
+	beq	1f
+	subs	#2,er1
+	mov.l	er1,@er0
+1:
+	and.w	#0xff,e1
+	mov.l	er1,er0
+	jsr	@SYMBOL_NAME(trace_trap)
+	jmp	@SYMBOL_NAME(ret_from_exception)
+
+	.section	.bss
+SYMBOL_NAME_LABEL(sw_ksp)
+	.space	4
+SYMBOL_NAME_LABEL(sw_usp)
+	.space	4
+
+	.end
diff -puN arch/h8300/kernel/ptrace.c~h8300-entrys-update arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~h8300-entrys-update
+++ a/arch/h8300/kernel/ptrace.c
@@ -219,7 +219,7 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-asmlinkage void syscall_trace(void)
+asmlinkage void do_syscall_trace(void)
 {
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return;
diff -puN arch/h8300/kernel/signal.c~h8300-entrys-update arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~h8300-entrys-update
+++ a/arch/h8300/kernel/signal.c
@@ -547,3 +547,9 @@ asmlinkage int do_signal(struct pt_regs 
 	}
 	return 0;
 }
+
+asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
+{
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+		do_signal(regs, NULL);
+}
diff -puN arch/h8300/platform/h8300h/Makefile~h8300-entrys-update arch/h8300/platform/h8300h/Makefile
--- a/arch/h8300/platform/h8300h/Makefile~h8300-entrys-update
+++ a/arch/h8300/platform/h8300h/Makefile
@@ -4,4 +4,4 @@
 # Reuse any files we can from the H8/300H
 #
 
-obj-y := entry.o irq_pin.o ptrace_h8300h.o
+obj-y := irq_pin.o ptrace_h8300h.o
diff -puN arch/h8300/platform/h8300h/entry.S~h8300-entrys-update /dev/null
--- a/arch/h8300/platform/h8300h/entry.S
+++ /dev/null
@@ -1,332 +0,0 @@
-/* -*- mode: asm -*-
- *
- *  linux/arch/h8300/platform/h8300h/entry.S
- *
- *  Yoshinori Sato <ysato@users.sourceforge.jp>
- *  David McCullough <davidm@snapgear.com>
- *
- */
-
-/*
- *  entry.S
- *  include exception/interrupt gateway
- *          system call entry
- */
-
-#include <linux/sys.h>
-#include <asm/unistd.h>
-#include <asm/setup.h>
-#include <asm/segment.h>
-#include <asm/linkage.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/errno.h>
-
-	.h8300h
-
-/* CPU context save/restore macros. */
-	
-	.macro	SAVE_ALL
-	mov.l	er0,@-sp
-
-	stc	ccr,r0l				/* check kernel mode */
-	btst	#4,r0l
-	bne	5f
-
-	mov.l	sp,@SYMBOL_NAME(sw_usp)		/* user mode */
-	mov.l	@sp,er0
-	orc	#0x10,ccr
-	mov.l	@SYMBOL_NAME(sw_ksp),sp
-	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */ 
-	mov.l	er0,@-sp
-	mov.l	er1,@-sp
-	mov.l   @SYMBOL_NAME(sw_usp),er0
-	mov.l   @(8:16,er0),er1                 /* copy the RET addr */
-	mov.l   er1,@(LRET-LER1:16,sp)
-
-	mov.w	e1,r1				/* e1 highbyte = ccr */
-	and	#0xef,r1h			/* mask mode? flag */
-	sub.w	r0,r0
-	mov.b	r1h,r0l
-	mov.w	r0,@(LCCR-LER1:16,sp)		/* copy ccr */
-	mov.l	@(LORIG-LER1:16,sp),er0
-	mov.l	er0,@(LER0-LER1:16,sp)		/* copy ER0 */
-	bra	6f
-5:
-	mov.l	@sp,er0				/* kernel mode */
-	subs	#2,sp				/* dummy ccr */
-	mov.l	er0,@-sp
-	mov.l	er1,@-sp
-	mov.w	@(LRET-LER1:16,sp),r1		/* copy old ccr */
-	mov.b	r1h,r1l
-	mov.b	#0,r1h
-	mov.w	r1,@(LCCR-LER1:16,sp)		/* set ccr */
-6:
-	mov.l	er2,@-sp
-	mov.l	er3,@-sp
-	mov.l	er6,@-sp			/* syscall arg #6 */
-	mov.l	er5,@-sp			/* syscall arg #5 */
-	mov.l	er4,@-sp			/* syscall arg #4 */
-	.endm
-
-	.macro	RESTORE_ALL
-	mov.l	@sp+,er4
-	mov.l	@sp+,er5
-	mov.l	@sp+,er6
-	mov.l	@sp+,er3
-	mov.l	@sp+,er2
-	mov.w	@(LCCR-LER1:16,sp),r0		/* check kernel mode */
-	btst	#4,r0l
-	bne	7f
-
-	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@(LER0-LER1:16,sp),er1		/* restore ER0 */
-	mov.l	er1,@er0
-	mov.w	@(LCCR-LER1:16,sp),r1		/* restore the RET addr */
-	mov.b	r1l,r1h
-	mov.b	@(LRET+1-LER1:16,sp),r1l
-	mov.w	r1,e1
-	mov.w	@(LRET+2-LER1:16,sp),r1
-	mov.l	er1,@(8:16,er0)
-
-	mov.l	@sp+,er1
-	add.l	#(LRET-LER1),sp			/* remove LORIG - LRET */ 
-	mov.l	sp,@SYMBOL_NAME(sw_ksp)
-	mov.l	er0,sp
-	bra	8f
-7:
-	mov.l	@sp+,er1
-	adds	#4,sp
-	adds	#2,sp
-8:
-	mov.l	@sp+,er0
-	adds	#4,sp				/* remove the sw created LVEC */
-	rte
-	.endm
-	
-.globl SYMBOL_NAME(system_call)
-.globl SYMBOL_NAME(ret_from_exception)
-.globl SYMBOL_NAME(ret_from_fork)
-.globl SYMBOL_NAME(ret_from_interrupt)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-.globl SYMBOL_NAME(sw_ksp),SYMBOL_NAME(sw_usp)
-.globl SYMBOL_NAME(resume)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-.globl SYMBOL_NAME(interrupt_entry)
-.globl SYMBOL_NAME(system_call)
-.globl SYMBOL_NAME(trace_break)
-
-#if defined(CONFIG_ROMKERNEL)
-INTERRUPTS = 64		
-	.section .int_redirect,"ax"
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
-	.rept	7
-	.long	0
-	.endr
-	jsr	@SYMBOL_NAME(interrupt_entry)	/* NMI */
-	jmp	@SYMBOL_NAME(system_call)	/* TRAPA #0 (System call) */
-	.long	0
-	.long	0
-	jmp	@SYMBOL_NAME(trace_break)	/* TRAPA #3 (breakpoint) */
-	.rept	INTERRUPTS-12
-	jsr	@SYMBOL_NAME(interrupt_entry)
-	.endr
-#endif
-#if defined(CONFIG_RAMKERNEL)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-	.section .bss
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
-	.space	4
-#endif
-
-	.section .text
-	.align	2
-SYMBOL_NAME_LABEL(interrupt_entry)
-	SAVE_ALL
-	mov.w	@(LCCR,sp),r0
-	btst	#4,r0l
-	bne	1f
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@(4:16,er0),er0
-	bra	2f
-1:
-	mov.l	@(LVEC,sp),er0
-2:
-#if defined(CONFIG_ROMKERNEL)
-	sub.l	#SYMBOL_NAME(interrupt_redirect_table),er0
-#endif
-#if defined(CONFIG_RAMKERNEL)
-	mov.l	@SYMBOL_NAME(interrupt_redirect_table),er1
-	sub.l	er1,er0
-#endif
-	shlr.l	er0
-	shlr.l	er0
-	dec.l	#1,er0
-	mov.l	sp,er1
-	subs	#4,er1				/* adjust ret_pc */
-	jsr	@SYMBOL_NAME(do_IRQ)
-	mov.l	@SYMBOL_NAME(irq_stat)+CPUSTAT_SOFTIRQ_PENDING,er0
-	beq	1f
-	jsr	@SYMBOL_NAME(do_softirq)
-1:
-	jmp	@SYMBOL_NAME(ret_from_interrupt)
-	
-SYMBOL_NAME_LABEL(system_call)
-	subs	#4,sp				/* dummy LVEC */
-	SAVE_ALL
-	mov.w	@(LCCR:16,sp),r1
-	bset	#4,r1l
-	ldc	r1l,ccr
-	mov.l	er0,er4
-	mov.l	#-ENOSYS,er0
-	mov.l	er0,@(LER0:16,sp)
-
-	/* save top of frame */
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	cmp.l	#NR_syscalls,er4
-	bcc	SYMBOL_NAME(ret_from_exception):16
-	shll.l	er4
-	shll.l	er4
-	mov.l	#SYMBOL_NAME(sys_call_table),er0
-	add.l	er4,er0
-	mov.l	@er0,er4
-	beq	SYMBOL_NAME(ret_from_exception):16	
-	mov.l	sp,er2
-	and.w	#0xe000,r2
-	mov.b	@((TASK_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
-	btst	#(TIF_SYSCALL_TRACE & 7),r2l
-	bne	1f
-	mov.l	@(LER1:16,sp),er0
-	mov.l	@(LER2:16,sp),er1
-	mov.l	@(LER3:16,sp),er2
-	jsr	@er4
-	mov.l	er0,@(LER0:16,sp)		/* save the return value */
-#if defined(CONFIG_SYSCALL_PRINT)
-	jsr	@SYMBOL_NAME(syscall_print)
-#endif
-	bra	SYMBOL_NAME(ret_from_exception):8
-1:
-	jsr	SYMBOL_NAME(syscall_trace)
-	mov.l	@(LER1:16,sp),er0
-	mov.l	@(LER2:16,sp),er1
-	mov.l	@(LER3:16,sp),er2
-	jsr	@er4
-	mov.l	er0,@(LER0:16,sp)		/* save the return value */
-	jsr	@SYMBOL_NAME(syscall_trace)
-	bra	SYMBOL_NAME(ret_from_exception):8
-
-SYMBOL_NAME_LABEL(ret_from_fork)
-	mov.l	er2,er0
-	jsr	@SYMBOL_NAME(schedule_tail)
-	bra	SYMBOL_NAME(ret_from_exception):8
-
-SYMBOL_NAME_LABEL(reschedule)
-	/* save top of frame */
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	jsr	@SYMBOL_NAME(schedule)
-
-SYMBOL_NAME_LABEL(ret_from_exception)
-#if defined(CONFIG_PREEMPT)
-	orc	#0x80,ccr
-#endif
-SYMBOL_NAME_LABEL(ret_from_interrupt)
-	mov.b	@(LCCR+1:16,sp),r0l
-	btst	#4,r0l			/* check if returning to kernel */
-	bne	done:8			/* if so, skip resched, signals */
-	andc	#0x7f,ccr
-	mov.l	sp,er4
-	and.w	#0xe000,r4
-	mov.l	@(TI_FLAGS:16,er4),er1
-	and.l	#_TIF_WORK_MASK,er1
-	beq	done:8
-1:
-	mov.l	@(TI_FLAGS:16,er4),er1
-	btst	#TIF_NEED_RESCHED,r1l
-	bne	SYMBOL_NAME(reschedule):16
-	mov.l	sp,er0
-	subs	#4,er0			/* adjust retpc */
-	mov.l	er2,er1
-	jsr	@SYMBOL_NAME(do_signal)
-#if defined(CONFIG_PREEMPT)
-	bra	done:8			/* userspace thoru */
-3:
-	btst	#4,r0l
-	beq	done:8			/* userspace thoru */
-4:
-	mov.l	@(TI_PRE_COUNT:16,er4),er1
-	bne	done:8
-	mov.l	@(TI_FLAGS:16,er4),er1
-	btst	#TIF_NEED_RESCHED,r1l
-	beq	done:8
-	mov.b	r0l,r0l
-	bpl	done:8			/* interrupt off (exception path?) */
-	mov.l	#PREEMPT_ACTIVE,er1
-	mov.l	er1,@(TI_PRE_COUNT:16,er4)
-	andc	#0x7f,ccr
-	jsr	@SYMBOL_NAME(schedule)
-	sub.l	er1,er1
-	mov.l	er1,@(TI_PRE_COUNT:16,er4)
-	orc	#0x80,ccr
-	bra	4b:8
-#endif
-done:
-	RESTORE_ALL			/* Does RTE */
-
-SYMBOL_NAME_LABEL(resume)
-	/*
-	 * Beware - when entering resume, offset of tss is in d1,
-	 * prev (the current task) is in a0, next (the new task)
-	 * is in a1 and d2.b is non-zero if the mm structure is
-	 * shared between the tasks, so don't change these
-	 * registers until their contents are no longer needed.
-	 */
-
-	/* save sr */
-	sub.w	r3,r3
-	stc	ccr,r3l
-	mov.w	r3,@(THREAD_CCR+2:16,er0)
-
-	/* disable interrupts */
-	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er3
-	mov.l	er3,@(THREAD_USP:16,er0)
-	mov.l	sp,@(THREAD_KSP:16,er0)
-
-	/* Skip address space switching if they are the same. */
-	/* FIXME: what did we hack out of here, this does nothing! */
-
-	mov.l	@(THREAD_USP:16,er1),er0
-	mov.l	er0,@SYMBOL_NAME(sw_usp)
-	mov.l	@(THREAD_KSP:16,er1),sp
-			
-	/* restore status register */
-	mov.w	@(THREAD_CCR+2:16,er1),r3
-
-	ldc	r3l,ccr
-	rts
-	
-SYMBOL_NAME_LABEL(trace_break)
-	subs	#4,sp
-	SAVE_ALL
-	sub.l	er1,er1
-	dec.l	#1,er1
-	mov.l	er1,@(LORIG,sp)	
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@er0,er1
-	subs	#2,er1
-	mov.l	er1,@er0	
-	and.w	#0xff,e1
-	mov.l	er1,er0
-	jsr	@SYMBOL_NAME(trace_trap)
-	jmp	@SYMBOL_NAME(ret_from_exception)	
-
-	.section	.bss
-SYMBOL_NAME_LABEL(sw_ksp)
-	.space	4	
-SYMBOL_NAME_LABEL(sw_usp)
-	.space	4	
diff -puN arch/h8300/platform/h8s/Makefile~h8300-entrys-update arch/h8300/platform/h8s/Makefile
--- a/arch/h8300/platform/h8s/Makefile~h8300-entrys-update
+++ a/arch/h8300/platform/h8s/Makefile
@@ -4,4 +4,4 @@
 # Reuse any files we can from the H8S
 #
 
-obj-y := entry.o ints_h8s.o ptrace_h8s.o
+obj-y := ints_h8s.o ptrace_h8s.o
diff -puN arch/h8300/platform/h8s/entry.S~h8300-entrys-update /dev/null
--- a/arch/h8300/platform/h8s/entry.S
+++ /dev/null
@@ -1,331 +0,0 @@
-/* -*- mode: asm -*-
- *
- *  linux/arch/h8300/platform/h8s/entry.S
- *
- *  Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- *	fairly heavy changes to fix syscall args and signal processing
- *	by David McCullough <davidm@snapgear.com>
- */
-
-/*
- *  entry.S
- *  include exception/interrupt gateway
- *          system call entry
- */
-
-#include <linux/sys.h>
-#include <asm/unistd.h>
-#include <asm/setup.h>
-#include <asm/segment.h>
-#include <asm/linkage.h>
-#include <asm/asm-offsets.h>
-#include <asm/thread_info.h>
-#include <asm/errno.h>
-
-	.h8300s
-
-/* CPU context save/restore macros. */
-	
-	.macro	SAVE_ALL
-	mov.l	er0,@-sp
-
-	stc	ccr,r0l				/* check kernel mode */
-	btst	#4,r0l
-	bne	5f
-
-	/* user mode */
-	mov.l	sp,@SYMBOL_NAME(sw_usp)
-	mov.l	@sp,er0				/* restore saved er0 */
-	orc	#0x10,ccr			/* switch kernel stack */
-	mov.l	@SYMBOL_NAME(sw_ksp),sp
-	sub.l	#(LRET-LORIG),sp		/* allocate LORIG - LRET */ 
-	stm.l	er0-er3,@-sp
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@(10:16,er0),er1		/* copy the RET addr */
-	mov.l	er1,@(LRET-LER3:16,sp)
-	mov.w	@(8:16,er0),r1
-	mov.w	r1,@(LEXR-LER3:16,sp)		/* copy EXR */
-
-	mov.w	e1,r1				/* e1 highbyte = ccr */
-	and	#0xef,r1h			/* mask mode? flag */
-	sub.w	r0,r0
-	mov.b	r1h,r0l
-	mov.w	r0,@(LCCR-LER3:16,sp)		/* copy ccr */
-	mov.l	@(LORIG-LER3:16,sp),er0
-	mov.l	er0,@(LER0-LER3:16,sp)		/* copy ER0 */
-	bra	6f
-5:
-	/* kernel mode */
-	mov.l	@sp,er0				/* restore saved er0 */
-	subs	#2,sp				/* set dummy ccr */
-	stm.l	er0-er3,@-sp
-	mov.w	@(LRET-LER3:16,sp),r1		/* copy old ccr */
-	mov.b	r1h,r1l
-	mov.b	#0,r1h
-	mov.w	r1,@(LCCR-LER3:16,sp)
-6:	
-	mov.l	er6,@-sp			/* syscall arg #6 */
-	mov.l	er5,@-sp			/* syscall arg #5 */
-	mov.l	er4,@-sp			/* syscall arg #4 */
-	.endm
-
-	.macro	RESTORE_ALL
-	mov.l	@sp+,er4
-	mov.l	@sp+,er5
-	mov.l	@sp+,er6
-	ldm.l	@sp+,er2-er3
-	mov.w	@(LCCR-LER1:16,sp),r0		/* check kernel mode */
-	btst	#4,r0l
-	bne	7f
-
-	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@(LER0-LER1:16,sp),er1		/* restore ER0 */
-	mov.l	er1,@er0
-	mov.w	@(LEXR-LER1:16,sp),r1		/* restore EXR */
-	mov.b	r1l,r1h
-	mov.w	r1,@(8:16,er0)
-	mov.w	@(LCCR-LER1:16,sp),r1		/* restore the RET addr */
-	mov.b	r1l,r1h
-	mov.b	@(LRET+1-LER1:16,sp),r1l
-	mov.w	r1,e1
-	mov.w	@(LRET+2-LER1:16,sp),r1
-	mov.l	er1,@(10:16,er0)
-
-	mov.l	@sp+,er1
-	add.l	#(LRET-LER1),sp			/* remove LORIG - LRET */ 
-	mov.l	sp,@SYMBOL_NAME(sw_ksp)
-	andc	#0xef,ccr			/* switch to user mode */
-	mov.l	er0,sp
-	bra	8f
-7:
-	mov.l	@sp+,er1
-	adds	#4,sp
-	adds	#2,sp
-8:
-	mov.l	@sp+,er0
-	adds	#4,sp				/* remove the sw created LVEC */
-	rte
-	.endm
-	
-.globl SYMBOL_NAME(system_call)
-.globl SYMBOL_NAME(ret_from_exception)
-.globl SYMBOL_NAME(ret_from_fork)
-.globl SYMBOL_NAME(ret_from_interrupt)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-.globl SYMBOL_NAME(sw_ksp),SYMBOL_NAME(sw_usp)
-.globl SYMBOL_NAME(resume)
-.globl SYMBOL_NAME(trace_break)
-.globl SYMBOL_NAME(interrupt_entry)
-		
-INTERRUPTS = 128
-#if defined(CONFIG_ROMKERNEL)
-	.section .int_redirect,"ax"
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
-	.rept	7
-	.long	0
-	.endr
-	jsr	@SYMBOL_NAME(interrupt_entry)	/* NMI */
-	jmp	@SYMBOL_NAME(system_call)	/* TRAPA #0 (System call) */
-	.long	0
-	.long	0
-	jmp	@SYMBOL_NAME(trace_break)	/* TRAPA #3 (breakpoint) */
-	.rept	INTERRUPTS-12
-	jsr	@SYMBOL_NAME(interrupt_entry)
-	.endr
-#endif
-#if defined(CONFIG_RAMKERNEL)
-.globl SYMBOL_NAME(interrupt_redirect_table)
-	.section .bss
-SYMBOL_NAME_LABEL(interrupt_redirect_table)
-	.space	4
-#endif
-	
-	.section .text
-	.align	2
-SYMBOL_NAME_LABEL(interrupt_entry)
-	SAVE_ALL
-	mov.w	@(LCCR,sp),r0
-	btst	#4,r0l
-	bne	1f
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@(4:16,er0),er0
-	bra	2f
-1:
-	mov.l	@(LVEC:16,sp),er0
-2:
-#if defined(CONFIG_ROMKERNEL)
-	sub.l	#SYMBOL_NAME(interrupt_redirect_table),er0
-#endif
-#if defined(CONFIG_RAMKERNEL)
-	mov.l	@SYMBOL_NAME(interrupt_redirect_table),er1
-	sub.l	er1,er0
-#endif
-	shlr.l	#2,er0
-	dec.l	#1,er0
-	mov.l	sp,er1
-	subs	#4,er1				/* adjust ret_pc */
-	jsr	@SYMBOL_NAME(process_int)
-	mov.l	@SYMBOL_NAME(irq_stat)+CPUSTAT_SOFTIRQ_PENDING,er0
-	beq	1f
-	jsr	@SYMBOL_NAME(do_softirq)
-1:
-	jmp	@SYMBOL_NAME(ret_from_exception)
-
-SYMBOL_NAME_LABEL(system_call)
-	subs	#4,sp				/* dummy LVEC */
-	SAVE_ALL
-	mov.l	er0,er4
-	mov.l	#-ENOSYS,er0
-	mov.l	er0,@(LER0:16,sp)
-
-	/* save top of frame */
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	cmp.l	#NR_syscalls,er4
-	bcc	SYMBOL_NAME(ret_from_exception):16
-	shll.l	#2,er4
-	mov.l	#SYMBOL_NAME(sys_call_table),er0
-	add.l	er4,er0
-	mov.l	@er0,er0
-	mov.l	er0,er4
-	beq	SYMBOL_NAME(ret_from_exception):16	
-	mov.l	sp,er2
-	and.w	#0xe000,r2
-	mov.b	@((TASK_FLAGS+3-(TIF_SYSCALL_TRACE >> 3)):16,er2),r2l
-	btst	#(TIF_SYSCALL_TRACE & 7),r2l
-	mov.l	@(LER1:16,sp),er0
-	mov.l	@(LER2:16,sp),er1
-	mov.l	@(LER3:16,sp),er2
-	andc	#0x7f,ccr
-	jsr	@er4
-	mov.l	er0,@(LER0:16,sp)			/* save the return value */
-#if defined(CONFIG_SYSCALL_PRINT)
-	jsr	@SYMBOL_NAME(syscall_print)
-#endif
-	bra	SYMBOL_NAME(ret_from_exception):8
-1:
-	jsr	SYMBOL_NAME(syscall_trace)
-	mov.l	@(LER1:16,sp),er0
-	mov.l	@(LER2:16,sp),er1
-	mov.l	@(LER3:16,sp),er2
-	jsr	@er4
-	mov.l	er0,@(LER0:16,sp)		/* save the return value */
-	jsr	@SYMBOL_NAME(syscall_trace)
-	bra	SYMBOL_NAME(ret_from_exception):8
-
-SYMBOL_NAME_LABEL(ret_from_fork)
-	mov.l	er2,er0
-	jsr	@SYMBOL_NAME(schedule_tail)
-	bra	SYMBOL_NAME(ret_from_exception):8
-
-SYMBOL_NAME_LABEL(reschedule)
-	/* save top of frame */
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	jsr	@SYMBOL_NAME(schedule)
-
-SYMBOL_NAME_LABEL(ret_from_exception)
-#if defined(CONFIG_PREEMPT)
-	orc	#0x80,ccr
-#endif
-SYMBOL_NAME_LABEL(ret_from_interrupt)
-	mov.b	@(LCCR+1:16,sp),r0l
-	btst	#4,r0l			/* check if returning to kernel */
-	bne	done:8			/* if so, skip resched, signals */
-	andc	#0x7f,ccr
-	mov.l	sp,er4
-	and.w	#0xe000,r4
-	mov.l	@(TI_FLAGS:16,er4),er1
-	and.l	#_TIF_WORK_MASK,er1
-	beq	done:8
-1:
-	mov.l	@(TI_FLAGS:16,er4),er1
-	btst	#TIF_NEED_RESCHED,r1l
-	bne	SYMBOL_NAME(reschedule):16
-	mov.l	sp,er0
-	subs	#4,er0			/* adjust retpc */
-	mov.l	er2,er1
-	jsr	@SYMBOL_NAME(do_signal)
-#if defined(CONFIG_PREEMPT)
-	bra	done:8			/* userspace thoru */
-3:
-	btst	#4,r0l
-	beq	done:8			/* userspace thoru */
-4:
-	mov.l	@(TI_PRE_COUNT:16,er4),er1
-	bne	done:8
-	mov.l	@(TI_FLAGS:16,er4),er1
-	btst	#TIF_NEED_RESCHED,r1l
-	beq	done:8
-	mov.b	r0l,r0l
-	bpl	done:8			/* interrupt off (exception path?) */
-	mov.l	#PREEMPT_ACTIVE,er1
-	mov.l	er1,@(TI_PRE_COUNT:16,er4)
-	andc	#0x7f,ccr
-	jsr	@SYMBOL_NAME(schedule)
-	sub.l	er1,er1
-	mov.l	er1,@(TI_PRE_COUNT:16,er4)
-	orc	#0x80,ccr
-	bra	4b:8
-#endif
-done:
-	RESTORE_ALL			/* Does RTE */
-
-SYMBOL_NAME_LABEL(resume)
-	/*
-	 *	er0 = prev
-	 *	er1 = next
-	 *	return last in er2
-	 */
-
-	/* save sr */
-	sub.w	r3,r3
-	stc	ccr,r3l
-	stc	exr,r3h
-	mov.w	r3,@(THREAD_CCR+2:16,er0)
-
-	/* disable interrupts */
-	orc	#0x80,ccr
-	mov.l	@SYMBOL_NAME(sw_usp),er3
-	mov.l	er3,@(THREAD_USP:16,er0)
-	mov.l	sp,@(THREAD_KSP:16,er0)
-	
-	/* Skip address space switching if they are the same. */
-	/* FIXME: what did we hack out of here, this does nothing! */
-
-	mov.l	@(THREAD_USP:16,er1),er0
-	mov.l	er0,@SYMBOL_NAME(sw_usp)
-	mov.l	@(THREAD_KSP:16,er1),sp
-			
-	/* restore status register */
-	mov.w	@(THREAD_CCR+2:16,er1),r3
-
-	ldc	r3l,ccr
-	ldc	r3h,exr
-
-	rts
-
-SYMBOL_NAME_LABEL(trace_break)
-	subs	#4,sp			/* dummy LVEC */
-	SAVE_ALL
-	sub.l	er1,er1
-	dec.l	#1,er1
-	mov.l	er1,@(LORIG,sp)	
-	mov.l	sp,er0
-	jsr	@SYMBOL_NAME(set_esp0)
-	mov.l	@SYMBOL_NAME(sw_usp),er0
-	mov.l	@er0,er1
-	subs	#2,er1
-	mov.l	er1,@er0	
-	and.w	#0xff,e1
-	mov.l	er1,er0
-	jsr	@SYMBOL_NAME(trace_trap)
-	jmp	@SYMBOL_NAME(ret_from_exception)	
-
-	.section	.bss
-SYMBOL_NAME_LABEL(sw_ksp)
-	.space	4	
-SYMBOL_NAME_LABEL(sw_usp)
-	.space	4	
diff -puN include/asm-h8300/thread_info.h~h8300-entrys-update include/asm-h8300/thread_info.h
--- a/include/asm-h8300/thread_info.h~h8300-entrys-update
+++ a/include/asm-h8300/thread_info.h
@@ -92,6 +92,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -99,6 +100,7 @@ static inline struct thread_info *curren
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
