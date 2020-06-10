From: akpm@linux-foundation.org
Subject: [merged]
 kernel-rename-show_stack_loglvl-=-show_stack.patch removed from -mm tree
Date: Tue, 09 Jun 2020 17:38:37 -0700
Message-ID: <20200610003837.4FG8EAD-X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJAii (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: rename show_stack_loglvl() => show_stack()
has been removed from the -mm tree.  Its filename was
     kernel-rename-show_stack_loglvl-=-show_stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: kernel: rename show_stack_loglvl() => show_stack()

Now the last users of show_stack() got converted to use an explicit log
level, show_stack_loglvl() can drop it's redundant suffix and become once
again well known show_stack().

Link: http://lkml.kernel.org/r/20200418201944.482088-51-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c        |    8 +-------
 arch/arc/kernel/stacktrace.c     |    8 +-------
 arch/arm/kernel/traps.c          |    8 +-------
 arch/arm64/kernel/traps.c        |    8 +-------
 arch/c6x/kernel/traps.c          |    7 +------
 arch/csky/kernel/ptrace.c        |    4 ++--
 arch/csky/kernel/stacktrace.c    |    9 +--------
 arch/h8300/kernel/traps.c        |    8 +-------
 arch/hexagon/kernel/traps.c      |    8 +-------
 arch/ia64/kernel/mca.c           |    2 +-
 arch/ia64/kernel/process.c       |   11 ++---------
 arch/m68k/kernel/traps.c         |   11 +++--------
 arch/microblaze/kernel/traps.c   |    8 +-------
 arch/mips/kernel/traps.c         |    8 +-------
 arch/nds32/kernel/traps.c        |    8 +-------
 arch/nios2/kernel/traps.c        |   12 +++---------
 arch/openrisc/kernel/traps.c     |   10 ++--------
 arch/parisc/kernel/traps.c       |    8 +-------
 arch/powerpc/kernel/process.c    |   11 +++--------
 arch/powerpc/kernel/stacktrace.c |    2 +-
 arch/riscv/kernel/stacktrace.c   |    8 +-------
 arch/s390/kernel/dumpstack.c     |    9 ++-------
 arch/sh/kernel/dumpstack.c       |    8 +-------
 arch/sparc/kernel/process_32.c   |   11 ++---------
 arch/sparc/kernel/process_64.c   |    2 +-
 arch/sparc/kernel/traps_64.c     |    8 +-------
 arch/um/drivers/mconsole_kern.c  |    2 +-
 arch/um/kernel/sysrq.c           |    7 +------
 arch/unicore32/kernel/traps.c    |    7 +------
 arch/x86/kernel/amd_gart_64.c    |    2 +-
 arch/x86/kernel/dumpstack.c      |    7 +------
 arch/xtensa/kernel/traps.c       |   10 ++--------
 drivers/base/power/main.c        |    2 +-
 drivers/tty/sysrq.c              |    2 +-
 include/linux/sched/debug.h      |    5 ++---
 kernel/debug/kdb/kdb_bt.c        |    2 +-
 kernel/locking/rtmutex-debug.c   |    2 +-
 kernel/sched/core.c              |    2 +-
 lib/dump_stack.c                 |    2 +-
 39 files changed, 52 insertions(+), 205 deletions(-)

--- a/arch/alpha/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/alpha/kernel/traps.c
@@ -144,8 +144,7 @@ dik_show_trace(unsigned long *sp, const
 
 static int kstack_depth_to_print = 24;
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-			const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	unsigned long *stack;
 	int i;
@@ -174,11 +173,6 @@ void show_stack_loglvl(struct task_struc
 	dik_show_trace(sp, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
 void
 die_if_kernel(char * str, struct pt_regs *regs, long err, unsigned long *r9_15)
 {
--- a/arch/arc/kernel/stacktrace.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/arc/kernel/stacktrace.c
@@ -228,17 +228,11 @@ noinline void show_stacktrace(struct tas
 EXPORT_SYMBOL(show_stacktrace);
 
 /* Expected by sched Code */
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
-			const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 {
 	show_stacktrace(tsk, NULL, loglvl);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
-{
-	show_stack_loglvl(tsk, sp, KERN_DEFAULT);
-}
-
 /* Another API expected by schedular, shows up in "ps" as Wait Channel
  * Of course just returning schedule( ) would be pointless so unwind until
  * the function is not in schedular code
--- a/arch/arm64/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/arm64/kernel/traps.c
@@ -137,18 +137,12 @@ void dump_backtrace(struct pt_regs *regs
 	put_task_stack(tsk);
 }
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 {
 	dump_backtrace(NULL, tsk, loglvl);
 	barrier();
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
-{
-	show_stack_loglvl(tsk, sp, KERN_DEFAULT);
-}
-
 #ifdef CONFIG_PREEMPT
 #define S_PREEMPT " PREEMPT"
 #elif defined(CONFIG_PREEMPT_RT)
--- a/arch/arm/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/arm/kernel/traps.c
@@ -247,18 +247,12 @@ static void dump_backtrace(struct pt_reg
 }
 #endif
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 {
 	dump_backtrace(NULL, tsk, loglvl);
 	barrier();
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
-{
-	show_stack_loglvl(tsk, sp, KERN_DEFAULT);
-}
-
 #ifdef CONFIG_PREEMPT
 #define S_PREEMPT " PREEMPT"
 #elif defined(CONFIG_PREEMPT_RT)
--- a/arch/c6x/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/c6x/kernel/traps.c
@@ -374,7 +374,7 @@ static void show_trace(unsigned long *st
 	printk("%s\n", loglvl);
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+void show_stack(struct task_struct *task, unsigned long *stack,
 		const char *loglvl)
 {
 	unsigned long *p, *endstack;
@@ -403,11 +403,6 @@ void show_stack_loglvl(struct task_struc
 	show_trace(stack, endstack, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *stack)
-{
-	show_stack_loglvl(task, stack, KERN_DEBUG);
-}
-
 int is_valid_bugaddr(unsigned long addr)
 {
 	return __kernel_text_address(addr);
--- a/arch/csky/kernel/ptrace.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/csky/kernel/ptrace.c
@@ -344,7 +344,7 @@ asmlinkage void syscall_trace_exit(struc
 		trace_sys_exit(regs, syscall_get_return_value(current, regs));
 }
 
-extern void show_stack(struct task_struct *task, unsigned long *stack);
+extern void show_stack(struct task_struct *task, unsigned long *stack, const char *loglvl);
 void show_regs(struct pt_regs *fp)
 {
 	unsigned long   *sp;
@@ -420,6 +420,6 @@ void show_regs(struct pt_regs *fp)
 	}
 	pr_cont("\n");
 
-	show_stack(NULL, (unsigned long *)fp->regs[4]);
+	show_stack(NULL, (unsigned long *)fp->regs[4], KERN_INFO);
 	return;
 }
--- a/arch/csky/kernel/stacktrace.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/csky/kernel/stacktrace.c
@@ -95,19 +95,12 @@ static bool print_trace_address(unsigned
 	return false;
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	pr_cont("Call Trace:\n");
 	walk_stackframe(task, NULL, print_trace_address, (void *)loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	pr_cont("Call Trace:\n");
-	walk_stackframe(task, NULL, print_trace_address, KERN_INFO);
-}
-
 static bool save_wchan(unsigned long pc, void *arg)
 {
 	if (!in_sched_functions(pc)) {
--- a/arch/h8300/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/h8300/kernel/traps.c
@@ -115,8 +115,7 @@ void die(const char *str, struct pt_regs
 
 static int kstack_depth_to_print = 24;
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *esp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *esp, const char *loglvl)
 {
 	unsigned long *stack,  addr;
 	int i;
@@ -158,8 +157,3 @@ void show_stack_loglvl(struct task_struc
 	}
 	printk("%s\n", loglvl);
 }
-
-void show_stack(struct task_struct *task, unsigned long *esp)
-{
-	show_stack_loglvl(task, esp, KERN_INFO);
-}
--- a/arch/hexagon/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/hexagon/kernel/traps.c
@@ -175,18 +175,12 @@ static void do_show_stack(struct task_st
 	}
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *fp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *fp, const char *loglvl)
 {
 	/* Saved link reg is one word above FP */
 	do_show_stack(task, fp, 0, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *fp)
-{
-	show_stack_loglvl(task, fp, 0, KERN_INFO);
-}
-
 int die(const char *str, struct pt_regs *regs, long err)
 {
 	static struct {
--- a/arch/ia64/kernel/mca.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/ia64/kernel/mca.c
@@ -1631,7 +1631,7 @@ default_monarch_init_process(struct noti
 	if (read_trylock(&tasklist_lock)) {
 		do_each_thread (g, t) {
 			printk("\nBacktrace of pid %d (%s)\n", t->pid, t->comm);
-			show_stack(t, NULL);
+			show_stack(t, NULL, KERN_DEFAULT);
 		} while_each_thread (g, t);
 		read_unlock(&tasklist_lock);
 	}
--- a/arch/ia64/kernel/process.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/ia64/kernel/process.c
@@ -85,8 +85,7 @@ ia64_do_show_stack (struct unw_frame_inf
 }
 
 void
-show_stack_loglvl (struct task_struct *task, unsigned long *sp,
-		   const char *loglvl)
+show_stack (struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	if (!task)
 		unw_init_running(ia64_do_show_stack, (void *)loglvl);
@@ -99,12 +98,6 @@ show_stack_loglvl (struct task_struct *t
 }
 
 void
-show_stack (struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
-void
 show_regs (struct pt_regs *regs)
 {
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
@@ -158,7 +151,7 @@ show_regs (struct pt_regs *regs)
 			       ((i == sof - 1) || (i % 3) == 2) ? "\n" : " ");
 		}
 	} else
-		show_stack(NULL, NULL);
+		show_stack(NULL, NULL, KERN_DEFAULT);
 }
 
 /* local support for deprecated console_print */
--- a/arch/m68k/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/m68k/kernel/traps.c
@@ -916,7 +916,7 @@ void show_registers(struct pt_regs *regs
 	default:
 		pr_cont("\n");
 	}
-	show_stack(NULL, (unsigned long *)addr);
+	show_stack(NULL, (unsigned long *)addr, KERN_INFO);
 
 	pr_info("Code:");
 	set_fs(KERNEL_DS);
@@ -935,8 +935,8 @@ void show_registers(struct pt_regs *regs
 	pr_cont("\n");
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *stack,
+		const char *loglvl)
 {
 	unsigned long *p;
 	unsigned long *endstack;
@@ -963,11 +963,6 @@ void show_stack_loglvl(struct task_struc
 	show_trace(stack, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *stack)
-{
-	show_stack_loglvl(task, stack, KERN_INFO);
-}
-
 /*
  * The vector number returned in the frame pointer may also contain
  * the "fs" (Fault Status) bits on ColdFire. These are in the bottom
--- a/arch/microblaze/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/microblaze/kernel/traps.c
@@ -31,8 +31,7 @@ static int __init kstack_setup(char *s)
 }
 __setup("kstack=", kstack_setup);
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	unsigned long words_to_show;
 	u32 fp = (u32) sp;
@@ -77,8 +76,3 @@ void show_stack_loglvl(struct task_struc
 
 	debug_show_held_locks(task);
 }
-
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_INFO);
-}
--- a/arch/mips/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/mips/kernel/traps.c
@@ -198,8 +198,7 @@ static void show_stacktrace(struct task_
 	show_backtrace(task, regs, loglvl);
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	struct pt_regs regs;
 	mm_segment_t old_fs = get_fs();
@@ -227,11 +226,6 @@ void show_stack_loglvl(struct task_struc
 	set_fs(old_fs);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT)
-}
-
 static void show_code(unsigned int __user *pc)
 {
 	long i;
--- a/arch/nds32/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/nds32/kernel/traps.c
@@ -135,8 +135,7 @@ static void __dump(struct task_struct *t
 	printk("%s\n", loglvl);
 }
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 {
 	unsigned long *base_reg;
 
@@ -157,11 +156,6 @@ void show_stack_loglvl(struct task_struc
 	barrier();
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
-{
-	show_stack_loglvl(tsk, sp, KERN_EMERG);
-}
-
 DEFINE_SPINLOCK(die_lock);
 
 /*
--- a/arch/nios2/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/nios2/kernel/traps.c
@@ -52,14 +52,13 @@ void _exception(int signo, struct pt_reg
 }
 
 /*
- * The show_stack(), show_stack_loglvl() are external API
- * which we do not use ourselves.
+ * The show_stack() is external API which we do not use ourselves.
  */
 
 int kstack_depth_to_print = 48;
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *stack,
+		const char *loglvl)
 {
 	unsigned long *endstack, addr;
 	int i;
@@ -106,11 +105,6 @@ void show_stack_loglvl(struct task_struc
 	printk("%s\n", loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *stack)
-{
-	show_stack_loglvl(task, stack, KERN_EMERG);
-}
-
 void __init trap_init(void)
 {
 	/* Nothing to do here */
--- a/arch/openrisc/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/openrisc/kernel/traps.c
@@ -48,8 +48,7 @@ void print_trace(void *data, unsigned lo
 }
 
 /* displays a short stack trace */
-void show_stack_loglvl(struct task_struct *task, unsigned long *esp,
-		const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *esp, const char *loglvl)
 {
 	if (esp == NULL)
 		esp = (unsigned long *)&esp;
@@ -58,11 +57,6 @@ void show_stack_loglvl(struct task_struc
 	unwind_stack((void *)loglvl, esp, print_trace);
 }
 
-void show_stack(struct task_struct *task, unsigned long *esp)
-{
-	show_stack_loglvl(task, esp, KERN_EMERG);
-}
-
 void show_registers(struct pt_regs *regs)
 {
 	int i;
@@ -104,7 +98,7 @@ void show_registers(struct pt_regs *regs
 	if (in_kernel) {
 
 		printk("\nStack: ");
-		show_stack(NULL, (unsigned long *)esp);
+		show_stack(NULL, (unsigned long *)esp, KERN_EMERG);
 
 		printk("\nCode: ");
 		if (regs->pc < PAGE_OFFSET)
--- a/arch/parisc/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/parisc/kernel/traps.c
@@ -198,17 +198,11 @@ static void parisc_show_stack(struct tas
 	do_show_stack(&info, loglvl);
 }
 
-void show_stack_loglvl(struct task_struct *t, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *t, unsigned long *sp, const char *loglvl)
 {
 	parisc_show_stack(t, NULL, loglvl);
 }
 
-void show_stack(struct task_struct *t, unsigned long *sp)
-{
-	show_stack_loglvl(t, sp, KERN_CRIT)
-}
-
 int is_valid_bugaddr(unsigned long iaoq)
 {
 	return 1;
--- a/arch/powerpc/kernel/process.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/powerpc/kernel/process.c
@@ -1456,7 +1456,7 @@ void show_regs(struct pt_regs * regs)
 	printk("NIP ["REG"] %pS\n", regs->nip, (void *)regs->nip);
 	printk("LR ["REG"] %pS\n", regs->link, (void *)regs->link);
 #endif
-	show_stack(current, (unsigned long *) regs->gpr[1]);
+	show_stack(current, (unsigned long *) regs->gpr[1], KERN_DEFAULT);
 	if (!user_mode(regs))
 		show_instructions(regs);
 }
@@ -2063,8 +2063,8 @@ unsigned long get_wchan(struct task_stru
 
 static int kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *stack,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *stack,
+		const char *loglvl)
 {
 	unsigned long sp, ip, lr, newsp;
 	int count = 0;
@@ -2133,11 +2133,6 @@ void show_stack_loglvl(struct task_struc
 	put_task_stack(tsk);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *stack)
-{
-	show_stack_loglvl(tsk, stack, KERN_DEFAULT);
-}
-
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
 void notrace __ppc64_runlatch_on(void)
--- a/arch/powerpc/kernel/stacktrace.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/powerpc/kernel/stacktrace.c
@@ -260,7 +260,7 @@ static void raise_backtrace_ipi(cpumask_
 			pr_cont(" current pointer corrupt? (%px)\n", p->__current);
 
 		pr_warn("Back trace of paca->saved_r1 (0x%016llx) (possibly stale):\n", p->saved_r1);
-		show_stack(p->__current, (unsigned long *)p->saved_r1);
+		show_stack(p->__current, (unsigned long *)p->saved_r1, KERN_WARNING);
 	}
 }
 
--- a/arch/riscv/kernel/stacktrace.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/riscv/kernel/stacktrace.c
@@ -105,18 +105,12 @@ static bool print_trace_address(unsigned
 	return false;
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	pr_cont("Call Trace:\n");
 	walk_stackframe(task, NULL, print_trace_address, (void *)loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
 static bool save_wchan(unsigned long pc, void *arg)
 {
 	if (!in_sched_functions(pc)) {
--- a/arch/s390/kernel/dumpstack.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/s390/kernel/dumpstack.c
@@ -126,7 +126,7 @@ unknown:
 	return -EINVAL;
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+void show_stack(struct task_struct *task, unsigned long *stack,
 		       const char *loglvl)
 {
 	struct unwind_state state;
@@ -139,11 +139,6 @@ void show_stack_loglvl(struct task_struc
 	debug_show_held_locks(task ? : current);
 }
 
-void show_stack(struct task_struct *task, unsigned long *stack)
-{
-	show_stack_loglvl(task, stack, KERN_DEFAULT);
-}
-
 static void show_last_breaking_event(struct pt_regs *regs)
 {
 	printk("Last Breaking-Event-Address:\n");
@@ -181,7 +176,7 @@ void show_regs(struct pt_regs *regs)
 	show_registers(regs);
 	/* Show stack backtrace if pt_regs is from kernel mode */
 	if (!user_mode(regs))
-		show_stack(NULL, (unsigned long *) regs->gprs[15]);
+		show_stack(NULL, (unsigned long *) regs->gprs[15], KERN_DEFAULT);
 	show_last_breaking_event(regs);
 }
 
--- a/arch/sh/kernel/dumpstack.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/sh/kernel/dumpstack.c
@@ -144,8 +144,7 @@ void show_trace(struct task_struct *tsk,
 	debug_show_held_locks(tsk);
 }
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 {
 	unsigned long stack;
 
@@ -161,8 +160,3 @@ void show_stack_loglvl(struct task_struc
 		 (unsigned long)task_stack_page(tsk));
 	show_trace(tsk, sp, NULL, loglvl);
 }
-
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
--- a/arch/sparc/kernel/process_32.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/sparc/kernel/process_32.c
@@ -145,12 +145,10 @@ void show_regs(struct pt_regs *r)
 }
 
 /*
- * The show_stack(), show_stack_loglvl() are external APIs which
- * we do not use ourselves.
+ * The show_stack() is external API which we do not use ourselves.
  * The oops is printed in die_if_kernel.
  */
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *_ksp,
-		       const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *_ksp, const char *loglvl)
 {
 	unsigned long pc, fp;
 	unsigned long task_base;
@@ -179,11 +177,6 @@ void show_stack_loglvl(struct task_struc
 	printk("%s\n", loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
 /*
  * Free current thread data structures etc..
  */
--- a/arch/sparc/kernel/process_64.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/sparc/kernel/process_64.c
@@ -195,7 +195,7 @@ void show_regs(struct pt_regs *regs)
 	       regs->u_regs[15]);
 	printk("RPC: <%pS>\n", (void *) regs->u_regs[15]);
 	show_regwindow(regs);
-	show_stack(current, (unsigned long *) regs->u_regs[UREG_FP]);
+	show_stack(current, (unsigned long *)regs->u_regs[UREG_FP], KERN_DEFAULT);
 }
 
 union global_cpu_snapshot global_cpu_snapshot[NR_CPUS];
--- a/arch/sparc/kernel/traps_64.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/sparc/kernel/traps_64.c
@@ -2453,8 +2453,7 @@ static void user_instruction_dump(unsign
 	printk("\n");
 }
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *_ksp,
-			 const char *loglvl)
+void show_stack(struct task_struct *tsk, unsigned long *_ksp, const char *loglvl)
 {
 	unsigned long fp, ksp;
 	struct thread_info *tp;
@@ -2514,11 +2513,6 @@ void show_stack_loglvl(struct task_struc
 	} while (++count < 16);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *_ksp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
 static inline struct reg_window *kernel_stack_up(struct reg_window *rw)
 {
 	unsigned long fp = rw->ins[6];
--- a/arch/um/drivers/mconsole_kern.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/um/drivers/mconsole_kern.c
@@ -648,7 +648,7 @@ static void stack_proc(void *arg)
 {
 	struct task_struct *task = arg;
 
-	show_stack(task, NULL);
+	show_stack(task, NULL, KERN_INFO);
 }
 
 /*
--- a/arch/um/kernel/sysrq.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/um/kernel/sysrq.c
@@ -27,7 +27,7 @@ static const struct stacktrace_ops stack
 	.address = _print_addr
 };
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+void show_stack(struct task_struct *task, unsigned long *stack,
 		       const char *loglvl)
 {
 	struct pt_regs *segv_regs = current->thread.segv_regs;
@@ -56,8 +56,3 @@ void show_stack_loglvl(struct task_struc
 	dump_trace(current, &stackops, (void *)loglvl);
 	printk("%s\n", loglvl);
 }
-
-void show_stack(struct task_struct *task, unsigned long *stack)
-{
-	show_stack_loglvl(task, stack, KERN_INFO);
-}
--- a/arch/unicore32/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/unicore32/kernel/traps.c
@@ -167,18 +167,13 @@ static void dump_backtrace(struct pt_reg
 		c_backtrace(fp, loglvl);
 }
 
-void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
+void show_stack(struct task_struct *tsk, unsigned long *sp,
 		       const char *loglvl)
 {
 	dump_backtrace(NULL, tsk, loglvl);
 	barrier();
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
-{
-	show_stack_loglvl(tsk, sp, KERN_DEFAULT)
-}
-
 static int __die(const char *str, int err, struct thread_info *thread,
 		struct pt_regs *regs)
 {
--- a/arch/x86/kernel/amd_gart_64.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -159,7 +159,7 @@ static void dump_leak(void)
 		return;
 	dump = 1;
 
-	show_stack_loglvl(NULL, NULL, KERN_ERR);
+	show_stack(NULL, NULL, KERN_ERR);
 	debug_dma_dump_mappings(NULL);
 }
 #endif
--- a/arch/x86/kernel/dumpstack.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/x86/kernel/dumpstack.c
@@ -279,7 +279,7 @@ next:
 	}
 }
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+void show_stack(struct task_struct *task, unsigned long *sp,
 		       const char *loglvl)
 {
 	task = task ? : current;
@@ -294,11 +294,6 @@ void show_stack_loglvl(struct task_struc
 	show_trace_log_lvl(task, NULL, sp, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_DEFAULT);
-}
-
 void show_stack_regs(struct pt_regs *regs)
 {
 	show_trace_log_lvl(current, regs, NULL, KERN_DEFAULT);
--- a/arch/xtensa/kernel/traps.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/arch/xtensa/kernel/traps.c
@@ -501,8 +501,7 @@ static void show_trace(struct task_struc
 #define STACK_DUMP_LINE_SIZE 32
 static size_t kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
-void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-		       const char *loglvl)
+void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
 	size_t len;
 
@@ -519,11 +518,6 @@ void show_stack_loglvl(struct task_struc
 	show_trace(task, sp, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_loglvl(task, sp, KERN_INFO);
-}
-
 DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
@@ -540,7 +534,7 @@ void die(const char * str, struct pt_reg
 	pr_info("%s: sig: %ld [#%d]%s\n", str, err, ++die_counter, pr);
 	show_regs(regs);
 	if (!user_mode(regs))
-		show_stack(NULL, (unsigned long*)regs->areg[1]);
+		show_stack(NULL, (unsigned long *)regs->areg[1], KERN_INFO);
 
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irq(&die_lock);
--- a/drivers/base/power/main.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/drivers/base/power/main.c
@@ -519,7 +519,7 @@ static void dpm_watchdog_handler(struct
 	struct dpm_watchdog *wd = from_timer(wd, t, timer);
 
 	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
-	show_stack_loglvl(wd->tsk, NULL, KERN_EMERG);
+	show_stack(wd->tsk, NULL, KERN_EMERG);
 	panic("%s %s: unrecoverable failure\n",
 		dev_driver_string(wd->dev), dev_name(wd->dev));
 }
--- a/drivers/tty/sysrq.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/drivers/tty/sysrq.c
@@ -235,7 +235,7 @@ static void showacpu(void *dummy)
 
 	raw_spin_lock_irqsave(&show_lock, flags);
 	pr_info("CPU%d:\n", smp_processor_id());
-	show_stack_loglvl(NULL, NULL, KERN_INFO);
+	show_stack(NULL, NULL, KERN_INFO);
 	raw_spin_unlock_irqrestore(&show_lock, flags);
 }
 
--- a/include/linux/sched/debug.h~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/include/linux/sched/debug.h
@@ -30,9 +30,8 @@ extern void show_regs(struct pt_regs *);
  * task), SP is the stack pointer of the first frame that should be shown in the back
  * trace (or NULL if the entire call-chain of the task should be shown).
  */
-extern void show_stack(struct task_struct *task, unsigned long *sp);
-extern void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
-			      const char *loglvl);
+extern void show_stack(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl);
 
 extern void sched_show_task(struct task_struct *p);
 
--- a/kernel/debug/kdb/kdb_bt.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/kernel/debug/kdb/kdb_bt.c
@@ -30,7 +30,7 @@ static void kdb_show_stack(struct task_s
 		kdb_dump_stack_on_cpu(kdb_process_cpu(p));
 		console_loglevel = old_lvl;
 	} else {
-		show_stack_loglvl(p, addr, KERN_EMERG);
+		show_stack(p, addr, KERN_EMERG);
 	}
 
 	kdb_trap_printk--;
--- a/kernel/locking/rtmutex-debug.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/kernel/locking/rtmutex-debug.c
@@ -125,7 +125,7 @@ void debug_rt_mutex_print_deadlock(struc
 
 	printk("\n%s/%d's [blocked] stackdump:\n\n",
 		task->comm, task_pid_nr(task));
-	show_stack_loglvl(task, NULL, KERN_DEFAULT);
+	show_stack(task, NULL, KERN_DEFAULT);
 	printk("\n%s/%d's [current] stackdump:\n\n",
 		current->comm, task_pid_nr(current));
 	dump_stack();
--- a/kernel/sched/core.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/kernel/sched/core.c
@@ -6025,7 +6025,7 @@ void sched_show_task(struct task_struct
 		(unsigned long)task_thread_info(p)->flags);
 
 	print_worker_info(KERN_INFO, p);
-	show_stack_loglvl(p, NULL, KERN_INFO);
+	show_stack(p, NULL, KERN_INFO);
 	put_task_stack(p);
 }
 EXPORT_SYMBOL_GPL(sched_show_task);
--- a/lib/dump_stack.c~kernel-rename-show_stack_loglvl-=-show_stack
+++ a/lib/dump_stack.c
@@ -74,7 +74,7 @@ void show_regs_print_info(const char *lo
 static void __dump_stack(void)
 {
 	dump_stack_print_info(KERN_DEFAULT);
-	show_stack_loglvl(NULL, NULL, KERN_DEFAULT);
+	show_stack(NULL, NULL, KERN_DEFAULT);
 }
 
 /**
_

Patches currently in -mm which might be from dima@arista.com are
