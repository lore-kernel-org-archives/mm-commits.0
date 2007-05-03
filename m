From: akpm@linux-foundation.org
Subject: + wrap-access-to-thread_info.patch added to -mm tree
Date: Wed, 02 May 2007 21:27:30 -0700
Message-ID: <200705030427.l434RUJa004706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767377AbXECE1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org


The patch titled
     wrap access to thread_info
has been added to the -mm tree.  Its filename is
     wrap-access-to-thread_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wrap access to thread_info
From: Roman Zippel <zippel@linux-m68k.org>

Recently a few direct accesses to the thread_info in the task structure snuck
back, so this wraps them with the appropriate wrapper.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/process.c      |    6 +++---
 arch/avr32/kernel/ptrace.c       |    2 +-
 arch/i386/kernel/traps.c         |    2 +-
 arch/mips/kernel/smtc.c          |    2 +-
 arch/x86_64/kernel/irq.c         |    2 +-
 include/asm-i386/thread_info.h   |    2 +-
 include/asm-ia64/thread_info.h   |    2 +-
 include/asm-mips/system.h        |    2 +-
 include/asm-parisc/compat.h      |    2 +-
 include/asm-x86_64/thread_info.h |    2 +-
 kernel/mutex.c                   |    8 ++++----
 11 files changed, 16 insertions(+), 16 deletions(-)

diff -puN arch/avr32/kernel/process.c~wrap-access-to-thread_info arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~wrap-access-to-thread_info
+++ a/arch/avr32/kernel/process.c
@@ -330,13 +330,13 @@ int copy_thread(int nr, unsigned long cl
 {
 	struct pt_regs *childregs;
 
-	childregs = ((struct pt_regs *)(THREAD_SIZE + (unsigned long)p->thread_info)) - 1;
+	childregs = ((struct pt_regs *)(THREAD_SIZE + (unsigned long)task_stack_page(p))) - 1;
 	*childregs = *regs;
 
 	if (user_mode(regs))
 		childregs->sp = usp;
 	else
-		childregs->sp = (unsigned long)p->thread_info + THREAD_SIZE;
+		childregs->sp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
 
 	childregs->r12 = 0; /* Set return value for child */
 
@@ -403,7 +403,7 @@ unsigned long get_wchan(struct task_stru
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 
-	stack_page = (unsigned long)p->thread_info;
+	stack_page = (unsigned long)task_stack_page(p);
 	BUG_ON(!stack_page);
 
 	/*
diff -puN arch/avr32/kernel/ptrace.c~wrap-access-to-thread_info arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~wrap-access-to-thread_info
+++ a/arch/avr32/kernel/ptrace.c
@@ -24,7 +24,7 @@
 
 static struct pt_regs *get_user_regs(struct task_struct *tsk)
 {
-	return (struct pt_regs *)((unsigned long) tsk->thread_info +
+	return (struct pt_regs *)((unsigned long)task_stack_page(tsk) +
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
diff -puN arch/i386/kernel/traps.c~wrap-access-to-thread_info arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~wrap-access-to-thread_info
+++ a/arch/i386/kernel/traps.c
@@ -373,7 +373,7 @@ void show_registers(struct pt_regs *regs
 	       regs->xds & 0xffff, regs->xes & 0xffff, regs->xfs & 0xffff, gs, ss);
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, current->pid,
-		current_thread_info(), current, current->thread_info);
+		current_thread_info(), current, task_thread_info(current));
 	/*
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
diff -puN arch/mips/kernel/smtc.c~wrap-access-to-thread_info arch/mips/kernel/smtc.c
--- a/arch/mips/kernel/smtc.c~wrap-access-to-thread_info
+++ a/arch/mips/kernel/smtc.c
@@ -560,7 +560,7 @@ void smtc_boot_secondary(int cpu, struct
 	write_tc_gpr_sp(__KSTK_TOS(idle));
 
 	/* global pointer */
-	write_tc_gpr_gp((unsigned long)idle->thread_info);
+	write_tc_gpr_gp((unsigned long)task_thread_info(idle));
 
 	smtc_status |= SMTC_MTC_ACTIVE;
 	write_tc_c0_tchalt(0);
diff -puN arch/x86_64/kernel/irq.c~wrap-access-to-thread_info arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~wrap-access-to-thread_info
+++ a/arch/x86_64/kernel/irq.c
@@ -32,7 +32,7 @@ atomic_t irq_err_count;
  */
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
-	u64 curbase = (u64) current->thread_info;
+	u64 curbase = (u64)task_stack_page(current);
 	static unsigned long warned = -60*HZ;
 
 	if (regs->rsp >= curbase && regs->rsp <= curbase + THREAD_SIZE &&
diff -puN include/asm-i386/thread_info.h~wrap-access-to-thread_info include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~wrap-access-to-thread_info
+++ a/include/asm-i386/thread_info.h
@@ -170,7 +170,7 @@ static inline struct thread_info *curren
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 #define TS_POLLING		0x0002	/* True if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* __KERNEL__ */
 
diff -puN include/asm-ia64/thread_info.h~wrap-access-to-thread_info include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~wrap-access-to-thread_info
+++ a/include/asm-ia64/thread_info.h
@@ -108,6 +108,6 @@ struct thread_info {
 
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* _ASM_IA64_THREAD_INFO_H */
diff -puN include/asm-mips/system.h~wrap-access-to-thread_info include/asm-mips/system.h
--- a/include/asm-mips/system.h~wrap-access-to-thread_info
+++ a/include/asm-mips/system.h
@@ -55,7 +55,7 @@ do {									\
 	if (cpu_has_dsp)						\
 		__save_dsp(prev);					\
 	next->thread.emulated_fp = 0;					\
-	(last) = resume(prev, next, next->thread_info);			\
+	(last) = resume(prev, next, task_thread_info(next));		\
 	if (cpu_has_dsp)						\
 		__restore_dsp(current);					\
 } while(0)
diff -puN include/asm-parisc/compat.h~wrap-access-to-thread_info include/asm-parisc/compat.h
--- a/include/asm-parisc/compat.h~wrap-access-to-thread_info
+++ a/include/asm-parisc/compat.h
@@ -152,7 +152,7 @@ static __inline__ void __user *compat_al
 
 static inline int __is_compat_task(struct task_struct *t)
 {
-	return test_ti_thread_flag(t->thread_info, TIF_32BIT);
+	return test_ti_thread_flag(task_thread_info(t), TIF_32BIT);
 }
 
 static inline int is_compat_task(void)
diff -puN include/asm-x86_64/thread_info.h~wrap-access-to-thread_info include/asm-x86_64/thread_info.h
--- a/include/asm-x86_64/thread_info.h~wrap-access-to-thread_info
+++ a/include/asm-x86_64/thread_info.h
@@ -160,7 +160,7 @@ static inline struct thread_info *stack_
 #define TS_COMPAT		0x0002	/* 32bit syscall active */
 #define TS_POLLING		0x0004	/* true if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* __KERNEL__ */
 
diff -puN kernel/mutex.c~wrap-access-to-thread_info kernel/mutex.c
--- a/kernel/mutex.c~wrap-access-to-thread_info
+++ a/kernel/mutex.c
@@ -133,7 +133,7 @@ __mutex_lock_common(struct mutex *lock, 
 
 	debug_mutex_lock_common(lock, &waiter);
 	mutex_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	debug_mutex_add_waiter(lock, &waiter, task->thread_info);
+	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
@@ -159,7 +159,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 */
 		if (unlikely(state == TASK_INTERRUPTIBLE &&
 						signal_pending(task))) {
-			mutex_remove_waiter(lock, &waiter, task->thread_info);
+			mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, _RET_IP_);
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
@@ -175,8 +175,8 @@ __mutex_lock_common(struct mutex *lock, 
 	}
 
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task->thread_info);
-	debug_mutex_set_owner(lock, task->thread_info);
+	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	debug_mutex_set_owner(lock, task_thread_info(task));
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
introduce-config_has_dma.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
git-kbuild.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
is_power_of_2-in-fs-hfs.patch
optimize-timespec_trunc.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
wrap-access-to-thread_info.patch
rename-thread_info-to-stack.patch
