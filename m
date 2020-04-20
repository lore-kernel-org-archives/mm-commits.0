From: akpm@linux-foundation.org
Subject: + microblaze-add-loglvl-to-microblaze_unwind_inner.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 16:11:21 -0700
Message-ID: <20200420231121.YMp6H-Q0N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgDTXLW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, monstr@monstr.eu


The patch titled
     Subject: microblaze: add loglvl to microblaze_unwind_inner()
has been added to the -mm tree.  Its filename is
     microblaze-add-loglvl-to-microblaze_unwind_inner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-add-loglvl-to-microblaze_unwind_inner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-add-loglvl-to-microblaze_unwind_inner.patch

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
Subject: microblaze: add loglvl to microblaze_unwind_inner()

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

Add log level argument to microblaze_unwind_inner() as a preparation for
introducing show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-19-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/unwind.c |   38 ++++++++++++++++++------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/arch/microblaze/kernel/unwind.c~microblaze-add-loglvl-to-microblaze_unwind_inner
+++ a/arch/microblaze/kernel/unwind.c
@@ -154,7 +154,8 @@ static int lookup_prev_stack_frame(unsig
 static void microblaze_unwind_inner(struct task_struct *task,
 				    unsigned long pc, unsigned long fp,
 				    unsigned long leaf_return,
-				    struct stack_trace *trace);
+				    struct stack_trace *trace,
+				    const char *loglvl);
 
 /**
  * unwind_trap - Unwind through a system trap, that stored previous state
@@ -162,16 +163,18 @@ static void microblaze_unwind_inner(stru
  */
 #ifdef CONFIG_MMU
 static inline void unwind_trap(struct task_struct *task, unsigned long pc,
-				unsigned long fp, struct stack_trace *trace)
+				unsigned long fp, struct stack_trace *trace,
+				const char *loglvl)
 {
 	/* To be implemented */
 }
 #else
 static inline void unwind_trap(struct task_struct *task, unsigned long pc,
-				unsigned long fp, struct stack_trace *trace)
+				unsigned long fp, struct stack_trace *trace,
+				const char *loglvl)
 {
 	const struct pt_regs *regs = (const struct pt_regs *) fp;
-	microblaze_unwind_inner(task, regs->pc, regs->r1, regs->r15, trace);
+	microblaze_unwind_inner(task, regs->pc, regs->r1, regs->r15, trace, loglvl);
 }
 #endif
 
@@ -184,11 +187,13 @@ static inline void unwind_trap(struct ta
  *				  the caller's return address.
  * @trace : Where to store stack backtrace (PC values).
  *	    NULL == print backtrace to kernel log
+ * @loglvl : Used for printk log level if (trace == NULL).
  */
 static void microblaze_unwind_inner(struct task_struct *task,
 			     unsigned long pc, unsigned long fp,
 			     unsigned long leaf_return,
-			     struct stack_trace *trace)
+			     struct stack_trace *trace,
+			     const char *loglvl)
 {
 	int ofs = 0;
 
@@ -214,11 +219,11 @@ static void microblaze_unwind_inner(stru
 			const struct pt_regs *regs =
 				(const struct pt_regs *) fp;
 #endif
-			pr_info("HW EXCEPTION\n");
+			printk("%sHW EXCEPTION\n", loglvl);
 #ifndef CONFIG_MMU
 			microblaze_unwind_inner(task, regs->r17 - 4,
 						fp + EX_HANDLER_STACK_SIZ,
-						regs->r15, trace);
+						regs->r15, trace, loglvl);
 #endif
 			return;
 		}
@@ -228,8 +233,8 @@ static void microblaze_unwind_inner(stru
 			if ((return_to >= handler->start_addr)
 			    && (return_to <= handler->end_addr)) {
 				if (!trace)
-					pr_info("%s\n", handler->trap_name);
-				unwind_trap(task, pc, fp, trace);
+					printk("%s%s\n", loglvl, handler->trap_name);
+				unwind_trap(task, pc, fp, trace, loglvl);
 				return;
 			}
 		}
@@ -248,13 +253,13 @@ static void microblaze_unwind_inner(stru
 		} else {
 			/* Have we reached userland? */
 			if (unlikely(pc == task_pt_regs(task)->pc)) {
-				pr_info("[<%p>] PID %lu [%s]\n",
-					(void *) pc,
+				printk("%s[<%p>] PID %lu [%s]\n",
+					loglvl, (void *) pc,
 					(unsigned long) task->pid,
 					task->comm);
 				break;
 			} else
-				print_ip_sym(KERN_INFO, pc);
+				print_ip_sym(loglvl, pc);
 		}
 
 		/* Stop when we reach anything not part of the kernel */
@@ -285,11 +290,13 @@ static void microblaze_unwind_inner(stru
  */
 void microblaze_unwind(struct task_struct *task, struct stack_trace *trace)
 {
+	const char *loglvl = KERN_INFO;
+
 	if (task) {
 		if (task == current) {
 			const struct pt_regs *regs = task_pt_regs(task);
 			microblaze_unwind_inner(task, regs->pc, regs->r1,
-						regs->r15, trace);
+						regs->r15, trace, loglvl);
 		} else {
 			struct thread_info *thread_info =
 				(struct thread_info *)(task->stack);
@@ -299,7 +306,8 @@ void microblaze_unwind(struct task_struc
 			microblaze_unwind_inner(task,
 						(unsigned long) &_switch_to,
 						cpu_context->r1,
-						cpu_context->r15, trace);
+						cpu_context->r15,
+						trace, loglvl);
 		}
 	} else {
 		unsigned long pc, fp;
@@ -314,7 +322,7 @@ void microblaze_unwind(struct task_struc
 		);
 
 		/* Since we are not a leaf function, use leaf_return = 0 */
-		microblaze_unwind_inner(current, pc, fp, 0, trace);
+		microblaze_unwind_inner(current, pc, fp, 0, trace, loglvl);
 	}
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
