From: akpm@linux-foundation.org
Subject: + xtensa-add-loglvl-to-show_trace.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:13:59 -0700
Message-ID: <20200420231359.GjYrUZR2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXOA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@zankel.net, dima@arista.com, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: add loglvl to show_trace()
has been added to the -mm tree.  Its filename is
     xtensa-add-loglvl-to-show_trace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-add-loglvl-to-show_trace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-add-loglvl-to-show_trace.patch

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
Subject: xtensa: add loglvl to show_trace()

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

Add log level argument to show_trace() as a preparation for introducing
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-43-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/xtensa/kernel/traps.c~xtensa-add-loglvl-to-show_trace
+++ a/arch/xtensa/kernel/traps.c
@@ -479,18 +479,22 @@ void show_regs(struct pt_regs * regs)
 
 static int show_trace_cb(struct stackframe *frame, void *data)
 {
+	const char *loglvl = data;
+
 	if (kernel_text_address(frame->pc))
-		pr_cont(" [<%08lx>] %pB\n", frame->pc, (void *)frame->pc);
+		printk("%s [<%08lx>] %pB\n",
+			loglvl, frame->pc, (void *)frame->pc);
 	return 0;
 }
 
-void show_trace(struct task_struct *task, unsigned long *sp)
+static void show_trace(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	if (!sp)
 		sp = stack_pointer(task);
 
-	pr_info("Call Trace:\n");
-	walk_stackframe(sp, show_trace_cb, NULL);
+	printk("%sCall Trace:\n", loglvl);
+	walk_stackframe(sp, show_trace_cb, (void *)loglvl);
 }
 
 #define STACK_DUMP_ENTRY_SIZE 4
@@ -511,7 +515,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, " ", DUMP_PREFIX_NONE,
 		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
 		       sp, len, false);
-	show_trace(task, sp);
+	show_trace(task, stack, KERN_INFO);
 }
 
 DEFINE_SPINLOCK(die_lock);
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
