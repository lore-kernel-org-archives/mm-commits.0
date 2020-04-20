From: akpm@linux-foundation.org
Subject: + nds32-add-show_stack_loglvl.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:11:31 -0700
Message-ID: <20200420231131.iuweT9wxZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgDTXLc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deanbo422@gmail.com, dima@arista.com, green.hu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: add show_stack_loglvl()
has been added to the -mm tree.  Its filename is
     nds32-add-show_stack_loglvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nds32-add-show_stack_loglvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nds32-add-show_stack_loglvl.patch

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
Subject: nds32: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-23-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/traps.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/nds32/kernel/traps.c~nds32-add-show_stack_loglvl
+++ a/arch/nds32/kernel/traps.c
@@ -97,18 +97,19 @@ static void dump_instr(struct pt_regs *r
 }
 
 #define LOOP_TIMES (100)
-static void __dump(struct task_struct *tsk, unsigned long *base_reg)
+static void __dump(struct task_struct *tsk, unsigned long *base_reg,
+		   const char *loglvl)
 {
 	unsigned long ret_addr;
 	int cnt = LOOP_TIMES, graph = 0;
-	pr_emerg("Call Trace:\n");
+	printk("%sCall Trace:\n", loglvl);
 	if (!IS_ENABLED(CONFIG_FRAME_POINTER)) {
 		while (!kstack_end(base_reg)) {
 			ret_addr = *base_reg++;
 			if (__kernel_text_address(ret_addr)) {
 				ret_addr = ftrace_graph_ret_addr(
 						tsk, &graph, ret_addr, NULL);
-				print_ip_sym(KERN_EMERG, ret_addr);
+				print_ip_sym(loglvl, ret_addr);
 			}
 			if (--cnt < 0)
 				break;
@@ -124,17 +125,18 @@ static void __dump(struct task_struct *t
 
 				ret_addr = ftrace_graph_ret_addr(
 						tsk, &graph, ret_addr, NULL);
-				print_ip_sym(KERN_EMERG, ret_addr);
+				print_ip_sym(loglvl, ret_addr);
 			}
 			if (--cnt < 0)
 				break;
 			base_reg = (unsigned long *)next_fp;
 		}
 	}
-	pr_emerg("\n");
+	printk("%s\n", loglvl);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
+		       const char *loglvl)
 {
 	unsigned long *base_reg;
 
@@ -151,10 +153,15 @@ void show_stack(struct task_struct *tsk,
 		else
 			__asm__ __volatile__("\tori\t%0, $fp, #0\n":"=r"(base_reg));
 	}
-	__dump(tsk, base_reg);
+	__dump(tsk, base_reg, loglvl);
 	barrier();
 }
 
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	show_stack_loglvl(tsk, sp, KERN_EMERG);
+}
+
 DEFINE_SPINLOCK(die_lock);
 
 /*
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
