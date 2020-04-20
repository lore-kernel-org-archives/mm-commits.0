From: akpm@linux-foundation.org
Subject: + mips-add-show_stack_loglvl.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:11:29 -0700
Message-ID: <20200420231129.SBN3IK1Z_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgDTXLb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, jhogan@kernel.org, mm-commits@vger.kernel.org, paulburton@kernel.org, ralf@linux-mips.org


The patch titled
     Subject: mips: add show_stack_loglvl()
has been added to the -mm tree.  Its filename is
     mips-add-show_stack_loglvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-add-show_stack_loglvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-add-show_stack_loglvl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mips: add show_stack_loglvl()

Currently, the log-level of show_stack() depends on a platform
realization.  It creates situations where the headers are printed with
lower log level or higher than the stacktrace (depending on a platform or
user).

Furthermore, it forces the logic decision from user to an architecture
side.  In result, some users as sysrq/kdb/etc are doing tricks with
temporary rising console_loglevel while printing their messages.  And in
result it not only may print unwanted messages from other CPUs, but also
omit printing at all in the unlucky case where the printk() was deferred.

Introducing log-level parameter and KERN_UNSUPPRESSED [1] seems an easier
approach than introducing more printk buffers.  Also, it will consolidate
printings with headers.

Introduce show_stack_loglvl(), that eventually will substitute
show_stack().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-22-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/traps.c |   41 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

--- a/arch/mips/kernel/traps.c~mips-add-show_stack_loglvl
+++ a/arch/mips/kernel/traps.c
@@ -106,26 +106,26 @@ void (*board_bind_eic_interrupt)(int irq
 void (*board_ebase_setup)(void);
 void(*board_cache_error_setup)(void);
 
-static void show_raw_backtrace(unsigned long reg29)
+static void show_raw_backtrace(unsigned long reg29, const char *loglvl)
 {
 	unsigned long *sp = (unsigned long *)(reg29 & ~3);
 	unsigned long addr;
 
-	printk("Call Trace:");
+	printk("%sCall Trace:", loglvl);
 #ifdef CONFIG_KALLSYMS
-	printk("\n");
+	printk("%s\n", loglvl);
 #endif
 	while (!kstack_end(sp)) {
 		unsigned long __user *p =
 			(unsigned long __user *)(unsigned long)sp++;
 		if (__get_user(addr, p)) {
-			printk(" (Bad stack address)");
+			printk("%s (Bad stack address)", loglvl);
 			break;
 		}
 		if (__kernel_text_address(addr))
-			print_ip_sym(KERN_DEFAULT, addr);
+			print_ip_sym(loglvl, addr);
 	}
-	printk("\n");
+	printk("%s\n", loglvl);
 }
 
 #ifdef CONFIG_KALLSYMS
@@ -138,7 +138,8 @@ static int __init set_raw_show_trace(cha
 __setup("raw_show_trace", set_raw_show_trace);
 #endif
 
-static void show_backtrace(struct task_struct *task, const struct pt_regs *regs)
+static void show_backtrace(struct task_struct *task, const struct pt_regs *regs,
+			   const char *loglvl)
 {
 	unsigned long sp = regs->regs[29];
 	unsigned long ra = regs->regs[31];
@@ -148,12 +149,12 @@ static void show_backtrace(struct task_s
 		task = current;
 
 	if (raw_show_trace || user_mode(regs) || !__kernel_text_address(pc)) {
-		show_raw_backtrace(sp);
+		show_raw_backtrace(sp, loglvl);
 		return;
 	}
-	printk("Call Trace:\n");
+	printk("%sCall Trace:\n", loglvl);
 	do {
-		print_ip_sym(KERN_DEFAULT, pc);
+		print_ip_sym(loglvl, pc);
 		pc = unwind_stack(task, &sp, pc, &ra);
 	} while (pc);
 	pr_cont("\n");
@@ -164,19 +165,19 @@ static void show_backtrace(struct task_s
  * with at least a bit of error checking ...
  */
 static void show_stacktrace(struct task_struct *task,
-	const struct pt_regs *regs)
+	const struct pt_regs *regs, const char *loglvl)
 {
 	const int field = 2 * sizeof(unsigned long);
 	long stackdata;
 	int i;
 	unsigned long __user *sp = (unsigned long __user *)regs->regs[29];
 
-	printk("Stack :");
+	printk("%sStack :", loglvl);
 	i = 0;
 	while ((unsigned long) sp & (PAGE_SIZE - 1)) {
 		if (i && ((i % (64 / field)) == 0)) {
 			pr_cont("\n");
-			printk("       ");
+			printk("%s       ", loglvl);
 		}
 		if (i > 39) {
 			pr_cont(" ...");
@@ -192,10 +193,11 @@ static void show_stacktrace(struct task_
 		i++;
 	}
 	pr_cont("\n");
-	show_backtrace(task, regs);
+	show_backtrace(task, regs, loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	struct pt_regs regs;
 	mm_segment_t old_fs = get_fs();
@@ -219,10 +221,15 @@ void show_stack(struct task_struct *task
 	 * the stack in the kernel (not user) address space.
 	 */
 	set_fs(KERNEL_DS);
-	show_stacktrace(task, &regs);
+	show_stacktrace(task, &regs, loglvl);
 	set_fs(old_fs);
 }
 
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT)
+}
+
 static void show_code(unsigned int __user *pc)
 {
 	long i;
@@ -371,7 +378,7 @@ void show_registers(struct pt_regs *regs
 	if (!user_mode(regs))
 		/* Necessary for getting the correct stack content */
 		set_fs(KERNEL_DS);
-	show_stacktrace(current, regs);
+	show_stacktrace(current, regs, KERN_DEFAULT);
 	show_code((unsigned int __user *) regs->cp0_epc);
 	printk("\n");
 	set_fs(old_fs);
_

Patches currently in -mm which might be from dima@arista.com are

kallsyms-printk-add-loglvl-to-print_ip_sym.patch
alpha-add-show_stack_loglvl.patch
arc-add-show_stack_loglvl.patch
arm-asm-add-loglvl-to-c_backtrace.patch
arm-add-loglvl-to-unwind_backtrace.patch
arm-add-loglvl-to-dump_backtrace.patch
arm-wire-up-dump_backtrace_entrystm.patch
arm-add-show_stack_loglvl.patch
arm64-add-loglvl-to-dump_backtrace.patch
arm64-add-show_stack_loglvl.patch
c6x-add-show_stack_loglvl.patch
csky-add-show_stack_loglvl.patch
h8300-add-show_stack_loglvl.patch
hexagon-add-show_stack_loglvl.patch
ia64-pass-log-level-as-arg-into-ia64_do_show_stack.patch
ia64-add-show_stack_loglvl.patch
m68k-add-show_stack_loglvl.patch
microblaze-add-loglvl-to-microblaze_unwind_inner.patch
microblaze-add-loglvl-to-microblaze_unwind.patch
microblaze-add-show_stack_loglvl.patch
mips-add-show_stack_loglvl.patch
nds32-add-show_stack_loglvl.patch
nios2-add-show_stack_loglvl.patch
openrisc-add-show_stack_loglvl.patch
parisc-add-show_stack_loglvl.patch
powerpc-add-show_stack_loglvl.patch
riscv-add-show_stack_loglvl.patch
s390-add-show_stack_loglvl.patch
sh-add-loglvl-to-dump_mem.patch
sh-remove-needless-printk.patch
sh-add-loglvl-to-printk_address.patch
sh-add-loglvl-to-show_trace.patch
sh-add-show_stack_loglvl.patch
sparc-add-show_stack_loglvl.patch
um-sysrq-remove-needless-variable-sp.patch
um-add-show_stack_loglvl.patch
unicore32-remove-unused-pmode-argument-in-c_backtrace.patch
unicore32-add-loglvl-to-c_backtrace.patch
unicore32-add-show_stack_loglvl.patch
x86-add-missing-const-qualifiers-for-log_lvl.patch
x86-add-show_stack_loglvl.patch
xtensa-add-loglvl-to-show_trace.patch
xtensa-add-show_stack_loglvl.patch
sysrq-use-show_stack_loglvl.patch
x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err.patch
power-use-show_stack_loglvl.patch
kdb-dont-play-with-console_loglevel.patch
sched-print-stack-trace-with-kern_info.patch
kernel-use-show_stack_loglvl.patch
kernel-rename-show_stack_loglvl-=-show_stack.patch
