From: akpm@linux-foundation.org
Subject: [merged] nds32-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:37:40 -0700
Message-ID: <20200610003740.0CkMBHmzl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgFJAhm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deanbo422@gmail.com, dima@arista.com, green.hu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     nds32-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
