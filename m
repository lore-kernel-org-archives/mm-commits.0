From: akpm@linux-foundation.org
Subject: + sysrq-use-show_stack_loglvl.patch added to -mm tree
Date: Mon, 20 Apr 2020 16:14:03 -0700
Message-ID: <20200420231403.ByDslwZ14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXOG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, gregkh@linuxfoundation.org, jslaby@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysrq: use show_stack_loglvl()
has been added to the -mm tree.  Its filename is
     sysrq-use-show_stack_loglvl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysrq-use-show_stack_loglvl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysrq-use-show_stack_loglvl.patch

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
Subject: sysrq: use show_stack_loglvl()

Show the stack trace on a CPU with the same log level as "CPU%d" header.

Link: http://lkml.kernel.org/r/20200418201944.482088-45-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c         |    2 +-
 include/linux/sched/debug.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/sysrq.c~sysrq-use-show_stack_loglvl
+++ a/drivers/tty/sysrq.c
@@ -232,7 +232,7 @@ static void showacpu(void *dummy)
 
 	raw_spin_lock_irqsave(&show_lock, flags);
 	pr_info("CPU%d:\n", smp_processor_id());
-	show_stack(NULL, NULL);
+	show_stack_loglvl(NULL, NULL, KERN_INFO);
 	raw_spin_unlock_irqrestore(&show_lock, flags);
 }
 
--- a/include/linux/sched/debug.h~sysrq-use-show_stack_loglvl
+++ a/include/linux/sched/debug.h
@@ -31,6 +31,8 @@ extern void show_regs(struct pt_regs *);
  * trace (or NULL if the entire call-chain of the task should be shown).
  */
 extern void show_stack(struct task_struct *task, unsigned long *sp);
+extern void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+			      const char *loglvl);
 
 extern void sched_show_task(struct task_struct *p);
 
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
