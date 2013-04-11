From: akpm@linux-foundation.org
Subject: + dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:07:39 -0700
Message-ID: <20130411200739.8F94D5A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:57659 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3DKUHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:07:41 -0400
Received: by mail-yh0-f73.google.com with SMTP id 47so179924yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:07:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com


The patch titled
     Subject: dump_stack: consolidate dump_stack() implementations and unify their behaviors
has been added to the -mm tree.  Its filename is
     dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dump_stack: consolidate dump_stack() implementations and unify their behaviors

Both dump_stack() and show_stack() are currently implemented by each
architecture.  show_stack(NULL, NULL) dumps the backtrace for the current
task as does dump_stack().  On some archs, dump_stack() prints extra
information - pid, utsname and so on - in addition to the backtrace while
the two are identical on other archs.

The usages in arch-independent code of the two functions indicate
show_stack(NULL, NULL) should print out bare backtrace while dump_stack()
is used for debugging purposes when something went wrong, so it does make
sense to print additional information on the task which triggered
dump_stack().

There's no reason to require archs to implement two separate but mostly
identical functions.  It leads to unnecessary subtle information.

This patch expands the dummy fallback dump_stack() implementation in
lib/dump_stack.c such that it prints out debug information (taken from
x86) and invokes show_stack(NULL, NULL) and drops arch-specific
dump_stack() implementations in all archs except blackfin.  Blackfin's
dump_stack() does something wonky that I don't understand.

Debug information can be printed separately by calling
dump_stack_print_info() so that arch-specific dump_stack() implementation
can still emit the same debug information.  This is used in blackfin.

This patch brings the following behavior changes.

* On some archs, an extra level in backtrace for show_stack() could be
  printed.  This is because the top frame was determined in
  dump_stack() on those archs while generic dump_stack() can't do that
  reliably.  It can be compensated by inlining dump_stack() but not
  sure whether that'd be necessary.

* Most archs didn't use to print debug info on dump_stack().  They do
  now.

An example WARN dump follows.

 WARNING: at /work/os/work/kernel/workqueue.c:4841 init_workqueues+0x35/0x505()
 Hardware name: empty
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #9
  0000000000000009 ffff88007c861e08 ffffffff81c614dc ffff88007c861e48
  ffffffff8108f50f ffffffff82228240 0000000000000040 ffffffff8234a03c
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c614dc>] dump_stack+0x19/0x1b
  [<ffffffff8108f50f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8108f56a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a071>] init_workqueues+0x35/0x505
  ...

v2: CPU number added to the generic debug info as requested by s390
    folks and dropped the s390 specific dump_stack().  This loses %ksp
    from the debug message which the maintainers think isn't important
    enough to keep the s390-specific dump_stack() implementation.

    dump_stack_print_info() is moved to kernel/printk.c from
    lib/dump_stack.c.  Because linkage is per objecct file,
    dump_stack_print_info() living in the same lib file as generic
    dump_stack() means that archs which implement custom dump_stack()
    - at this point, only blackfin - can't use dump_stack_print_info()
    as that will bring in the generic version of dump_stack() too.  v1
    The v1 patch broke build on blackfin due to this issue.  The build
    breakage was reported by Fengguang Wu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>	[s390 bits]
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c        |    7 -------
 arch/arc/kernel/stacktrace.c     |    7 -------
 arch/arm/kernel/traps.c          |    7 -------
 arch/arm64/kernel/traps.c        |    7 -------
 arch/avr32/kernel/process.c      |    8 --------
 arch/blackfin/kernel/dumpstack.c |    1 +
 arch/c6x/kernel/traps.c          |    9 ---------
 arch/cris/kernel/traps.c         |    7 -------
 arch/frv/kernel/traps.c          |   11 -----------
 arch/h8300/kernel/traps.c        |    7 -------
 arch/hexagon/kernel/traps.c      |    8 --------
 arch/ia64/kernel/process.c       |    8 --------
 arch/m32r/kernel/traps.c         |    9 ---------
 arch/m68k/kernel/traps.c         |   12 ------------
 arch/metag/kernel/traps.c        |    6 ------
 arch/microblaze/kernel/traps.c   |    6 ------
 arch/mips/kernel/traps.c         |   13 -------------
 arch/mn10300/kernel/traps.c      |   11 -----------
 arch/openrisc/kernel/traps.c     |   11 -----------
 arch/parisc/kernel/traps.c       |    8 --------
 arch/powerpc/kernel/process.c    |    6 ------
 arch/s390/kernel/dumpstack.c     |   17 -----------------
 arch/score/kernel/traps.c        |   10 ----------
 arch/sh/kernel/dumpstack.c       |    6 ------
 arch/sparc/kernel/process_32.c   |    7 -------
 arch/sparc/kernel/traps_64.c     |    7 -------
 arch/um/kernel/sysrq.c           |   12 ------------
 arch/unicore32/kernel/traps.c    |    6 ------
 arch/x86/kernel/dumpstack.c      |   18 ------------------
 arch/xtensa/kernel/traps.c       |    8 --------
 include/linux/printk.h           |    5 +++++
 kernel/printk.c                  |   18 ++++++++++++++++++
 lib/dump_stack.c                 |   11 ++++++++---
 33 files changed, 32 insertions(+), 262 deletions(-)

diff -puN arch/alpha/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/alpha/kernel/traps.c
@@ -169,13 +169,6 @@ void show_stack(struct task_struct *task
 	dik_show_trace(sp);
 }
 
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void
 die_if_kernel(char * str, struct pt_regs *regs, long err, unsigned long *r9_15)
 {
diff -puN arch/arc/kernel/stacktrace.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/arc/kernel/stacktrace.c
--- a/arch/arc/kernel/stacktrace.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/arc/kernel/stacktrace.c
@@ -220,13 +220,6 @@ void show_stack(struct task_struct *tsk,
 	show_stacktrace(tsk, NULL);
 }
 
-/* Expected by Rest of kernel code */
-void dump_stack(void)
-{
-	show_stacktrace(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 /* Another API expected by schedular, shows up in "ps" as Wait Channel
  * Ofcourse just returning schedule( ) would be pointless so unwind until
  * the function is not in schedular code
diff -puN arch/arm/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/arm/kernel/traps.c
@@ -204,13 +204,6 @@ static void dump_backtrace(struct pt_reg
 }
 #endif
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff -puN arch/arm64/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/arm64/kernel/traps.c
--- a/arch/arm64/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/arm64/kernel/traps.c
@@ -167,13 +167,6 @@ static void dump_backtrace(struct pt_reg
 	}
 }
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff -puN arch/avr32/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/avr32/kernel/process.c
@@ -204,14 +204,6 @@ void show_stack(struct task_struct *tsk,
 	show_stack_log_lvl(tsk, (unsigned long)stack, NULL, "");
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace_log_lvl(current, &stack, NULL, "");
-}
-EXPORT_SYMBOL(dump_stack);
-
 static const char *cpu_modes[] = {
 	"Application", "Supervisor", "Interrupt level 0", "Interrupt level 1",
 	"Interrupt level 2", "Interrupt level 3", "Exception", "NMI"
diff -puN arch/blackfin/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/blackfin/kernel/dumpstack.c
--- a/arch/blackfin/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/blackfin/kernel/dumpstack.c
@@ -168,6 +168,7 @@ void dump_stack(void)
 #endif
 	trace_buffer_save(tflags);
 	dump_bfin_trace_buffer();
+	dump_stack_print_info(KERN_DEFAULT);
 	show_stack(current, &stack);
 	trace_buffer_restore(tflags);
 }
diff -puN arch/c6x/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/c6x/kernel/traps.c
--- a/arch/c6x/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/c6x/kernel/traps.c
@@ -67,15 +67,6 @@ void show_regs(struct pt_regs *regs)
 	pr_err("A31: %08lx  B31: %08lx\n", regs->a31, regs->b31);
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
-
 void die(char *str, struct pt_regs *fp, int nr)
 {
 	console_verbose();
diff -puN arch/cris/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/cris/kernel/traps.c
--- a/arch/cris/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/cris/kernel/traps.c
@@ -147,13 +147,6 @@ show_stack(void)
 #endif
 
 void
-dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
-void
 set_nmi_handler(void (*handler)(struct pt_regs *))
 {
 	nmi_handler = handler;
diff -puN arch/frv/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/frv/kernel/traps.c
@@ -466,17 +466,6 @@ asmlinkage void compound_exception(unsig
 	BUG();
 } /* end compound_exception() */
 
-/*****************************************************************************/
-/*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
 }
diff -puN arch/h8300/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/h8300/kernel/traps.c
--- a/arch/h8300/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/h8300/kernel/traps.c
@@ -164,10 +164,3 @@ void show_trace_task(struct task_struct
 {
 	show_stack(tsk,(unsigned long *)tsk->thread.esp0);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL,NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
diff -puN arch/hexagon/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/hexagon/kernel/traps.c
--- a/arch/hexagon/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/hexagon/kernel/traps.c
@@ -195,14 +195,6 @@ void show_stack(struct task_struct *task
 	do_show_stack(task, fp, 0);
 }
 
-void dump_stack(void)
-{
-	unsigned long *fp;
-	asm("%0 = r30" : "=r" (fp));
-	show_stack(current, fp);
-}
-EXPORT_SYMBOL(dump_stack);
-
 int die(const char *str, struct pt_regs *regs, long err)
 {
 	static struct {
diff -puN arch/ia64/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/ia64/kernel/process.c
@@ -96,14 +96,6 @@ show_stack (struct task_struct *task, un
 }
 
 void
-dump_stack (void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-void
 show_regs (struct pt_regs *regs)
 {
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
diff -puN arch/m32r/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/m32r/kernel/traps.c
@@ -169,15 +169,6 @@ void show_stack(struct task_struct *task
 	show_trace(task, sp);
 }
 
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(current, &stack);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void show_registers(struct pt_regs *regs)
 {
 	int i = 0;
diff -puN arch/m68k/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/m68k/kernel/traps.c
--- a/arch/m68k/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/m68k/kernel/traps.c
@@ -992,18 +992,6 @@ void show_stack(struct task_struct *task
 }
 
 /*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(&stack);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-/*
  * The vector number returned in the frame pointer may also contain
  * the "fs" (Fault Status) bits on ColdFire. These are in the bottom
  * 2 bits, and upper 2 bits. So we need to mask out the real vector
diff -puN arch/metag/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/metag/kernel/traps.c
--- a/arch/metag/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/metag/kernel/traps.c
@@ -987,9 +987,3 @@ void show_stack(struct task_struct *tsk,
 
 	show_trace(tsk, sp, NULL);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff -puN arch/microblaze/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/microblaze/kernel/traps.c
--- a/arch/microblaze/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/microblaze/kernel/traps.c
@@ -75,9 +75,3 @@ void show_stack(struct task_struct *task
 
 	debug_show_held_locks(task);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff -puN arch/mips/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/mips/kernel/traps.c
@@ -206,19 +206,6 @@ void show_stack(struct task_struct *task
 	show_stacktrace(task, &regs);
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	struct pt_regs regs;
-
-	prepare_frametrace(&regs);
-	show_backtrace(current, &regs);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void show_code(unsigned int __user *pc)
 {
 	long i;
diff -puN arch/mn10300/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/mn10300/kernel/traps.c
--- a/arch/mn10300/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/mn10300/kernel/traps.c
@@ -294,17 +294,6 @@ void show_stack(struct task_struct *task
 }
 
 /*
- * the architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
-/*
  * dump the register file in the specified exception frame
  */
 void show_registers_only(struct pt_regs *regs)
diff -puN arch/openrisc/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/openrisc/kernel/traps.c
--- a/arch/openrisc/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/openrisc/kernel/traps.c
@@ -105,17 +105,6 @@ void show_trace_task(struct task_struct
 	 */
 }
 
-/*
- * The architecture-independent backtrace generator
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_stack(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void show_registers(struct pt_regs *regs)
 {
 	int i;
diff -puN arch/parisc/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/parisc/kernel/traps.c
@@ -158,14 +158,6 @@ void show_regs(struct pt_regs *regs)
 	}
 }
 
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static void do_show_stack(struct unwind_frame_info *info)
 {
 	int i = 1;
diff -puN arch/powerpc/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/powerpc/kernel/process.c
@@ -1362,12 +1362,6 @@ void show_stack(struct task_struct *tsk,
 	} while (count++ < kstack_depth_to_print);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
 void __ppc64_runlatch_on(void)
diff -puN arch/s390/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/s390/kernel/dumpstack.c
--- a/arch/s390/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/s390/kernel/dumpstack.c
@@ -129,23 +129,6 @@ static void show_last_breaking_event(str
 #endif
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	printk("CPU: %d %s %s %.*s\n",
-	       task_thread_info(current)->cpu, print_tainted(),
-	       init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
-	printk("Process %s (pid: %d, task: %p, ksp: %p)\n",
-	       current->comm, current->pid, current,
-	       (void *) current->thread.ksp);
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 static inline int mask_bits(struct pt_regs *regs, unsigned long bits)
 {
 	return (regs->psw.mask & bits) / ((~bits + 1) & bits);
diff -puN arch/score/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/score/kernel/traps.c
--- a/arch/score/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/score/kernel/traps.c
@@ -149,16 +149,6 @@ static void show_registers(struct pt_reg
 	printk(KERN_NOTICE "\n");
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	show_stack(current_thread_info()->task,
-		   (long *) get_irq_regs()->regs[0]);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void __die(const char *str, struct pt_regs *regs, const char *file,
 	const char *func, unsigned long line)
 {
diff -puN arch/sh/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/sh/kernel/dumpstack.c
--- a/arch/sh/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/sh/kernel/dumpstack.c
@@ -158,9 +158,3 @@ void show_stack(struct task_struct *tsk,
 		 (unsigned long)task_stack_page(tsk));
 	show_trace(tsk, sp, NULL);
 }
-
-void dump_stack(void)
-{
-	show_stack(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
diff -puN arch/sparc/kernel/process_32.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/sparc/kernel/process_32.c
@@ -175,13 +175,6 @@ void show_stack(struct task_struct *tsk,
 	printk("\n");
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 /*
  * Note: sparc64 has a pretty intricated thread_saved_pc, check it out.
  */
diff -puN arch/sparc/kernel/traps_64.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/sparc/kernel/traps_64.c
--- a/arch/sparc/kernel/traps_64.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/sparc/kernel/traps_64.c
@@ -2350,13 +2350,6 @@ void show_stack(struct task_struct *tsk,
 	} while (++count < 16);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
 static inline struct reg_window *kernel_stack_up(struct reg_window *rw)
 {
 	unsigned long fp = rw->ins[6];
diff -puN arch/um/kernel/sysrq.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/um/kernel/sysrq.c
--- a/arch/um/kernel/sysrq.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/um/kernel/sysrq.c
@@ -35,18 +35,6 @@ void show_trace(struct task_struct *task
 }
 #endif
 
-/*
- * stack dumps generator - this is used by arch-independent code.
- * And this is identical to i386 currently.
- */
-void dump_stack(void)
-{
-	unsigned long stack;
-
-	show_trace(current, &stack);
-}
-EXPORT_SYMBOL(dump_stack);
-
 /*Stolen from arch/i386/kernel/traps.c */
 static const int kstack_depth_to_print = 24;
 
diff -puN arch/unicore32/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/unicore32/kernel/traps.c
--- a/arch/unicore32/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/unicore32/kernel/traps.c
@@ -170,12 +170,6 @@ static void dump_backtrace(struct pt_reg
 		c_backtrace(fp, mode);
 }
 
-void dump_stack(void)
-{
-	dump_backtrace(NULL, NULL);
-}
-EXPORT_SYMBOL(dump_stack);
-
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
 	dump_backtrace(NULL, tsk);
diff -puN arch/x86/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/x86/kernel/dumpstack.c
@@ -191,24 +191,6 @@ void show_stack(struct task_struct *task
 	show_stack_log_lvl(task, NULL, sp, bp, "");
 }
 
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp;
-	unsigned long stack;
-
-	bp = stack_frame(current, NULL);
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-EXPORT_SYMBOL(dump_stack);
-
 static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
diff -puN arch/xtensa/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/arch/xtensa/kernel/traps.c
@@ -481,14 +481,6 @@ void show_stack(struct task_struct *task
 	show_trace(task, stack);
 }
 
-void dump_stack(void)
-{
-	show_stack(current, NULL);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-
 void show_code(unsigned int *pc)
 {
 	long i;
diff -puN include/linux/printk.h~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors include/linux/printk.h
--- a/include/linux/printk.h~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/include/linux/printk.h
@@ -138,6 +138,7 @@ extern void wake_up_klogd(void);
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+void dump_stack_print_info(const char *log_lvl);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -175,6 +176,10 @@ static inline void log_buf_kexec_setup(v
 static inline void setup_log_buf(int early)
 {
 }
+
+static inline void dump_stack_print_info(const char *log_lvl)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff -puN kernel/printk.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors kernel/printk.c
--- a/kernel/printk.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/kernel/printk.c
@@ -43,6 +43,7 @@
 #include <linux/rculist.h>
 #include <linux/poll.h>
 #include <linux/irq_work.h>
+#include <linux/utsname.h>
 
 #include <asm/uaccess.h>
 
@@ -2833,4 +2834,21 @@ void kmsg_dump_rewind(struct kmsg_dumper
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
+
+/**
+ * dump_stack_print_info - print generic debug info for dump_stack()
+ * @log_lvl: log level
+ *
+ * Arch-specific dump_stack() implementations can use this function to
+ * print out the same debug information as the generic dump_stack().
+ */
+void dump_stack_print_info(const char *log_lvl)
+{
+	printk("%sCPU: %d PID: %d Comm: %.20s %s %s %.*s\n",
+	       log_lvl, raw_smp_processor_id(), current->pid, current->comm,
+	       print_tainted(), init_utsname()->release,
+	       (int)strcspn(init_utsname()->version, " "),
+	       init_utsname()->version);
+}
+
 #endif
diff -puN lib/dump_stack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors lib/dump_stack.c
--- a/lib/dump_stack.c~dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors
+++ a/lib/dump_stack.c
@@ -5,11 +5,16 @@
 
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/sched.h>
 
+/**
+ * dump_stack - dump the current task information and its stack trace
+ *
+ * Architectures can override this implementation by implementing its own.
+ */
 void dump_stack(void)
 {
-	printk(KERN_NOTICE
-		"This architecture does not implement dump_stack()\n");
+	dump_stack_print_info(KERN_DEFAULT);
+	show_stack(NULL, NULL);
 }
-
 EXPORT_SYMBOL(dump_stack);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

