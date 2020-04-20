From: akpm@linux-foundation.org
Subject: + parisc-add-show_stack_loglvl.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:12:57 -0700
Message-ID: <20200420231257.Io294BuNc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDTXNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, dima@arista.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: add show_stack_loglvl()
has been added to the -mm tree.  Its filename is
     parisc-add-show_stack_loglvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-add-show_stack_loglvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-add-show_stack_loglvl.patch

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
Subject: parisc: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-26-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/traps.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/arch/parisc/kernel/traps.c~parisc-add-show_stack_loglvl
+++ a/arch/parisc/kernel/traps.c
@@ -49,7 +49,7 @@
 #include "../math-emu/math-emu.h"	/* for handle_fpe() */
 
 static void parisc_show_stack(struct task_struct *task,
-	struct pt_regs *regs);
+	struct pt_regs *regs, const char *loglvl);
 
 static int printbinary(char *buf, unsigned long x, int nbits)
 {
@@ -155,7 +155,7 @@ void show_regs(struct pt_regs *regs)
 		printk("%s IAOQ[1]: %pS\n", level, (void *) regs->iaoq[1]);
 		printk("%s RP(r2): %pS\n", level, (void *) regs->gr[2]);
 
-		parisc_show_stack(current, regs);
+		parisc_show_stack(current, regs, KERN_DEFAULT);
 	}
 }
 
@@ -170,37 +170,43 @@ static DEFINE_RATELIMIT_STATE(_hppa_rs,
 }
 
 
-static void do_show_stack(struct unwind_frame_info *info)
+static void do_show_stack(struct unwind_frame_info *info, const char *loglvl)
 {
 	int i = 1;
 
-	printk(KERN_CRIT "Backtrace:\n");
+	printk("%sBacktrace:\n", loglvl);
 	while (i <= MAX_UNWIND_ENTRIES) {
 		if (unwind_once(info) < 0 || info->ip == 0)
 			break;
 
 		if (__kernel_text_address(info->ip)) {
-			printk(KERN_CRIT " [<" RFMT ">] %pS\n",
-				info->ip, (void *) info->ip);
+			printk("%s [<" RFMT ">] %pS\n",
+				loglvl, info->ip, (void *) info->ip);
 			i++;
 		}
 	}
-	printk(KERN_CRIT "\n");
+	printk("%s\n", loglvl);
 }
 
 static void parisc_show_stack(struct task_struct *task,
-	struct pt_regs *regs)
+	struct pt_regs *regs, const char *loglvl)
 {
 	struct unwind_frame_info info;
 
 	unwind_frame_init_task(&info, task, regs);
 
-	do_show_stack(&info);
+	do_show_stack(&info, loglvl);
+}
+
+void show_stack_loglvl(struct task_struct *t, unsigned long *sp,
+		       const char *loglvl)
+{
+	parisc_show_stack(t, NULL, loglvl);
 }
 
 void show_stack(struct task_struct *t, unsigned long *sp)
 {
-	parisc_show_stack(t, NULL);
+	show_stack_loglvl(t, sp, KERN_CRIT)
 }
 
 int is_valid_bugaddr(unsigned long iaoq)
@@ -446,7 +452,7 @@ void parisc_terminate(char *msg, struct
 		/* show_stack(NULL, (unsigned long *)regs->gr[30]); */
 		struct unwind_frame_info info;
 		unwind_frame_init(&info, current, regs);
-		do_show_stack(&info);
+		do_show_stack(&info, KERN_CRIT);
 	}
 
 	printk("\n");
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
