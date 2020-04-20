From: akpm@linux-foundation.org
Subject: + sh-add-loglvl-to-printk_address.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:13:29 -0700
Message-ID: <20200420231329.KVerjdqe6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXNa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, dima@arista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: add loglvl to printk_address()
has been added to the -mm tree.  Its filename is
     sh-add-loglvl-to-printk_address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-add-loglvl-to-printk_address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-add-loglvl-to-printk_address.patch

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
Subject: sh: add loglvl to printk_address()

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

Add log level argument to printk_address() as a preparation to introduce
show_stack_loglvl().

As a good side-effect show_fault_oops() now prints the address with
KERN_EMREG as the rest of output, making sure there won't be situation
where "PC: " is printed without actual address.

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-32-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/kdebug.h |    3 ++-
 arch/sh/kernel/dumpstack.c   |    6 +++---
 arch/sh/mm/fault.c           |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/sh/include/asm/kdebug.h~sh-add-loglvl-to-printk_address
+++ a/arch/sh/include/asm/kdebug.h
@@ -12,7 +12,8 @@ enum die_val {
 };
 
 /* arch/sh/kernel/dumpstack.c */
-extern void printk_address(unsigned long address, int reliable);
+extern void printk_address(unsigned long address, int reliable,
+			   const char *loglvl);
 extern void dump_mem(const char *str, const char *loglvl,
 		     unsigned long bottom, unsigned long top);
 
--- a/arch/sh/kernel/dumpstack.c~sh-add-loglvl-to-printk_address
+++ a/arch/sh/kernel/dumpstack.c
@@ -44,9 +44,9 @@ void dump_mem(const char *str, const cha
 	}
 }
 
-void printk_address(unsigned long address, int reliable)
+void printk_address(unsigned long address, int reliable, const char *loglvl)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk("%s [<%p>] %s%pS\n", loglvl, (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
@@ -118,7 +118,7 @@ static int print_trace_stack(void *data,
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk_address(addr, reliable);
+	printk_address(addr, reliable, (char *)data);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
--- a/arch/sh/mm/fault.c~sh-add-loglvl-to-printk_address
+++ a/arch/sh/mm/fault.c
@@ -213,7 +213,7 @@ show_fault_oops(struct pt_regs *regs, un
 				     : "paging request",
 		 address);
 	pr_alert("PC:");
-	printk_address(regs->pc, 1);
+	printk_address(regs->pc, 1, KERN_ALERT);
 
 	show_pte(NULL, address);
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
