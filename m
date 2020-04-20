From: akpm@linux-foundation.org
Subject: + arc-add-show_stack_loglvl.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:10:44 -0700
Message-ID: <20200420231044.pcqcIWHeM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgDTXKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, vgupta@synopsys.com


The patch titled
     Subject: arc: add show_stack_loglvl()
has been added to the -mm tree.  Its filename is
     arc-add-show_stack_loglvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-add-show_stack_loglvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-add-show_stack_loglvl.patch

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
Subject: arc: add show_stack_loglvl()

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

As a good side-effect header "Stack Trace:" is now printed with the same
log level as the rest of backtrace.

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-4-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/bug.h     |    3 ++-
 arch/arc/kernel/stacktrace.c   |   21 +++++++++++++++------
 arch/arc/kernel/troubleshoot.c |    2 +-
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/arch/arc/include/asm/bug.h~arc-add-show_stack_loglvl
+++ a/arch/arc/include/asm/bug.h
@@ -13,7 +13,8 @@
 struct task_struct;
 
 void show_regs(struct pt_regs *regs);
-void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs);
+void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs,
+		     const char *loglvl);
 void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
 			    unsigned long address);
 void die(const char *str, struct pt_regs *regs, unsigned long address);
--- a/arch/arc/kernel/stacktrace.c~arc-add-show_stack_loglvl
+++ a/arch/arc/kernel/stacktrace.c
@@ -158,9 +158,11 @@ arc_unwind_core(struct task_struct *tsk,
 /* Call-back which plugs into unwinding core to dump the stack in
  * case of panic/OOPs/BUG etc
  */
-static int __print_sym(unsigned int address, void *unused)
+static int __print_sym(unsigned int address, void *arg)
 {
-	printk("  %pS\n", (void *)address);
+	const char *loglvl = arg;
+
+	printk("%s  %pS\n", loglvl, (void *)address);
 	return 0;
 }
 
@@ -217,17 +219,24 @@ static int __get_first_nonsched(unsigned
  *-------------------------------------------------------------------------
  */
 
-noinline void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs)
+noinline void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs,
+			      const char *loglvl)
 {
-	pr_info("\nStack Trace:\n");
-	arc_unwind_core(tsk, regs, __print_sym, NULL);
+	printk("%s\nStack Trace:\n", loglvl);
+	arc_unwind_core(tsk, regs, __print_sym, (void *)loglvl);
 }
 EXPORT_SYMBOL(show_stacktrace);
 
 /* Expected by sched Code */
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
+			const char *loglvl)
+{
+	show_stacktrace(tsk, NULL, loglvl);
+}
+
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
-	show_stacktrace(tsk, NULL);
+	show_stack_loglvl(tsk, sp, KERN_DEFAULT);
 }
 
 /* Another API expected by schedular, shows up in "ps" as Wait Channel
--- a/arch/arc/kernel/troubleshoot.c~arc-add-show_stack_loglvl
+++ a/arch/arc/kernel/troubleshoot.c
@@ -242,5 +242,5 @@ void show_kernel_fault_diag(const char *
 
 	/* Show stack trace if this Fatality happened in kernel mode */
 	if (!user_mode(regs))
-		show_stacktrace(current, regs);
+		show_stacktrace(current, regs, KERN_DEFAULT);
 }
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
