From: akpm@linux-foundation.org
Subject: + sched-print-stack-trace-with-kern_info.patch added to
 -mm tree
Date: Mon, 20 Apr 2020 16:14:12 -0700
Message-ID: <20200420231412.JIHKEAtlx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgDTXOO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsegall@google.com, dietmar.eggemann@arm.com, dima@arista.com, juri.lelli@redhat.com, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org


The patch titled
     Subject: sched: print stack trace with KERN_INFO
has been added to the -mm tree.  Its filename is
     sched-print-stack-trace-with-kern_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-print-stack-trace-with-kern_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-print-stack-trace-with-kern_info.patch

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
Subject: sched: print stack trace with KERN_INFO

Aligning with other messages printed in sched_show_task() - use KERN_INFO
to print the backtrace.

Link: http://lkml.kernel.org/r/20200418201944.482088-49-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c~sched-print-stack-trace-with-kern_info
+++ a/kernel/sched/core.c
@@ -6005,7 +6005,7 @@ void sched_show_task(struct task_struct
 		(unsigned long)task_thread_info(p)->flags);
 
 	print_worker_info(KERN_INFO, p);
-	show_stack(p, NULL);
+	show_stack_loglvl(p, NULL, KERN_INFO);
 	put_task_stack(p);
 }
 EXPORT_SYMBOL_GPL(sched_show_task);
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
