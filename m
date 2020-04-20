From: akpm@linux-foundation.org
Subject: + x86-add-missing-const-qualifiers-for-log_lvl.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 16:13:54 -0700
Message-ID: <20200420231354.WbsbsaUSH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, dima@arista.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86: add missing const qualifiers for log_lvl
has been added to the -mm tree.  Its filename is
     x86-add-missing-const-qualifiers-for-log_lvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-missing-const-qualifiers-for-log_lvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-missing-const-qualifiers-for-log_lvl.patch

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
Subject: x86: add missing const qualifiers for log_lvl

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

Keep log_lvl const show_trace_log_lvl() and printk_stack_address() as the
new generic show_stack_loglvl() wants to have a proper const qualifier.

And gcc rightfully produces warnings in case it's not keept:
arch/x86/kernel/dumpstack.c: In function `show_stack':
arch/x86/kernel/dumpstack.c:294:37: warning: passing argument 4 of `show_trace_log_lv ' discards `const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  294 |  show_trace_log_lvl(task, NULL, sp, loglvl);
      |                                     ^~~~~~
arch/x86/kernel/dumpstack.c:163:32: note: expected `char *' but argument is of type `const char *'
  163 |    unsigned long *stack, char *log_lvl)
      |                          ~~~~~~^~~~~~~

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-41-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/stacktrace.h |    2 +-
 arch/x86/kernel/dumpstack.c       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/stacktrace.h~x86-add-missing-const-qualifiers-for-log_lvl
+++ a/arch/x86/include/asm/stacktrace.h
@@ -87,7 +87,7 @@ get_stack_pointer(struct task_struct *ta
 }
 
 void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, char *log_lvl);
+			unsigned long *stack, const char *log_lvl);
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
--- a/arch/x86/kernel/dumpstack.c~x86-add-missing-const-qualifiers-for-log_lvl
+++ a/arch/x86/kernel/dumpstack.c
@@ -65,7 +65,7 @@ bool in_entry_stack(unsigned long *stack
 }
 
 static void printk_stack_address(unsigned long address, int reliable,
-				 char *log_lvl)
+				 const char *log_lvl)
 {
 	touch_nmi_watchdog();
 	printk("%s %s%pB\n", log_lvl, reliable ? "" : "? ", (void *)address);
@@ -160,7 +160,7 @@ static void show_regs_if_on_stack(struct
 }
 
 void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, char *log_lvl)
+			unsigned long *stack, const char *log_lvl)
 {
 	struct unwind_state state;
 	struct stack_info stack_info = {0};
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
