From: akpm@linux-foundation.org
Subject: +
 unicore32-remove-unused-pmode-argument-in-c_backtrace.patch added to -mm
 tree
Date: Mon, 20 Apr 2020 16:13:46 -0700
Message-ID: <20200420231346.bSFzbtMrf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXNr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, gxt@pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: remove unused pmode argument in c_backtrace()
has been added to the -mm tree.  Its filename is
     unicore32-remove-unused-pmode-argument-in-c_backtrace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/unicore32-remove-unused-pmode-argument-in-c_backtrace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/unicore32-remove-unused-pmode-argument-in-c_backtrace.patch

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
Subject: unicore32: remove unused pmode argument in c_backtrace()

The pmode parameter isn't used in assembly - remove it.  Second argument
will be reused for printk() log level.

Link: http://lkml.kernel.org/r/20200418201944.482088-38-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/setup.h |    2 +-
 arch/unicore32/kernel/traps.c |   14 +++++---------
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/unicore32/kernel/setup.h~unicore32-remove-unused-pmode-argument-in-c_backtrace
+++ a/arch/unicore32/kernel/setup.h
@@ -29,7 +29,7 @@ extern void kernel_thread_helper(void);
 extern void __init early_signal_init(void);
 
 extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+extern asmlinkage void c_backtrace(unsigned long fp);
 
 extern void __show_regs(struct pt_regs *);
 
--- a/arch/unicore32/kernel/traps.c~unicore32-remove-unused-pmode-argument-in-c_backtrace
+++ a/arch/unicore32/kernel/traps.c
@@ -137,7 +137,7 @@ static void dump_instr(const char *lvl,
 
 static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 {
-	unsigned int fp, mode;
+	unsigned int fp;
 	int ok = 1;
 
 	printk(KERN_DEFAULT "Backtrace: ");
@@ -145,16 +145,12 @@ static void dump_backtrace(struct pt_reg
 	if (!tsk)
 		tsk = current;
 
-	if (regs) {
+	if (regs)
 		fp = regs->UCreg_fp;
-		mode = processor_mode(regs);
-	} else if (tsk != current) {
+	else if (tsk != current)
 		fp = thread_saved_fp(tsk);
-		mode = 0x10;
-	} else {
+	else
 		asm("mov %0, fp" : "=r" (fp) : : "cc");
-		mode = 0x10;
-	}
 
 	if (!fp) {
 		printk("no frame pointer");
@@ -167,7 +163,7 @@ static void dump_backtrace(struct pt_reg
 	printk("\n");
 
 	if (ok)
-		c_backtrace(fp, mode);
+		c_backtrace(fp);
 }
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
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
