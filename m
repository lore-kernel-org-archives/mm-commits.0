From: akpm@linux-foundation.org
Subject: + microblaze-add-loglvl-to-microblaze_unwind.patch added
 to -mm tree
Date: Mon, 20 Apr 2020 16:11:23 -0700
Message-ID: <20200420231123.cFf4cdXTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgDTXL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, monstr@monstr.eu


The patch titled
     Subject: microblaze: add loglvl to microblaze_unwind()
has been added to the -mm tree.  Its filename is
     microblaze-add-loglvl-to-microblaze_unwind.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-add-loglvl-to-microblaze_unwind.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-add-loglvl-to-microblaze_unwind.patch

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
Subject: microblaze: add loglvl to microblaze_unwind()

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

Add log level parameter to microblaze_unwind() as a preparation to add
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-20-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/unwind.h |    3 ++-
 arch/microblaze/kernel/stacktrace.c  |    4 ++--
 arch/microblaze/kernel/traps.c       |    2 +-
 arch/microblaze/kernel/unwind.c      |    6 +++---
 4 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/microblaze/include/asm/unwind.h~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/include/asm/unwind.h
@@ -20,7 +20,8 @@ extern struct trap_handler_info microbla
 extern const char _hw_exception_handler;
 extern const char ex_handler_unhandled;
 
-void microblaze_unwind(struct task_struct *task, struct stack_trace *trace);
+void microblaze_unwind(struct task_struct *task, struct stack_trace *trace,
+		       const char *loglvl);
 
 #endif	/* __MICROBLAZE_UNWIND_H */
 
--- a/arch/microblaze/kernel/stacktrace.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/stacktrace.c
@@ -20,12 +20,12 @@ void save_stack_trace(struct stack_trace
 {
 	/* Exclude our helper functions from the trace*/
 	trace->skip += 2;
-	microblaze_unwind(NULL, trace);
+	microblaze_unwind(NULL, trace, "");
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	microblaze_unwind(tsk, trace);
+	microblaze_unwind(tsk, trace, "");
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
--- a/arch/microblaze/kernel/traps.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/traps.c
@@ -68,7 +68,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 32, 4, (void *)fp,
 		       words_to_show << 2, 0);
 	pr_info("\n\nCall Trace:\n");
-	microblaze_unwind(task, NULL);
+	microblaze_unwind(task, NULL, KERN_INFO);
 	pr_info("\n");
 
 	if (!task)
--- a/arch/microblaze/kernel/unwind.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/unwind.c
@@ -287,11 +287,11 @@ static void microblaze_unwind_inner(stru
  * @task  : Task whose stack we are to unwind (NULL == current)
  * @trace : Where to store stack backtrace (PC values).
  *	    NULL == print backtrace to kernel log
+ * @loglvl : Used for printk log level if (trace == NULL).
  */
-void microblaze_unwind(struct task_struct *task, struct stack_trace *trace)
+void microblaze_unwind(struct task_struct *task, struct stack_trace *trace,
+		       const char *loglvl)
 {
-	const char *loglvl = KERN_INFO;
-
 	if (task) {
 		if (task == current) {
 			const struct pt_regs *regs = task_pt_regs(task);
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
