From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 34/93] sparc: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:31:39 -0700
Message-ID: <20200609043139.s-UzlWZYL%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEbk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:40 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, dima@arista.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: sparc: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-35-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/process_32.c |   17 ++++++++++++-----
 arch/sparc/kernel/traps_64.c   |   15 +++++++++++----
 2 files changed, 23 insertions(+), 9 deletions(-)

--- a/arch/sparc/kernel/process_32.c~sparc-add-show_stack_loglvl
+++ a/arch/sparc/kernel/process_32.c
@@ -145,10 +145,12 @@ void show_regs(struct pt_regs *r)
 }
 
 /*
- * The show_stack is an external API which we do not use ourselves.
+ * The show_stack(), show_stack_loglvl() are external APIs which
+ * we do not use ourselves.
  * The oops is printed in die_if_kernel.
  */
-void show_stack(struct task_struct *tsk, unsigned long *_ksp)
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *_ksp,
+		       const char *loglvl)
 {
 	unsigned long pc, fp;
 	unsigned long task_base;
@@ -170,11 +172,16 @@ void show_stack(struct task_struct *tsk,
 			break;
 		rw = (struct reg_window32 *) fp;
 		pc = rw->ins[7];
-		printk("[%08lx : ", pc);
-		printk("%pS ] ", (void *) pc);
+		printk("%s[%08lx : ", loglvl, pc);
+		printk("%s%pS ] ", loglvl, (void *) pc);
 		fp = rw->ins[6];
 	} while (++count < 16);
-	printk("\n");
+	printk("%s\n", loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT);
 }
 
 /*
--- a/arch/sparc/kernel/traps_64.c~sparc-add-show_stack_loglvl
+++ a/arch/sparc/kernel/traps_64.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/kallsyms.h>
 #include <linux/kdebug.h>
 #include <linux/ftrace.h>
 #include <linux/reboot.h>
@@ -2452,7 +2453,8 @@ static void user_instruction_dump(unsign
 	printk("\n");
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *_ksp)
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *_ksp,
+			 const char *loglvl)
 {
 	unsigned long fp, ksp;
 	struct thread_info *tp;
@@ -2476,7 +2478,7 @@ void show_stack(struct task_struct *tsk,
 
 	fp = ksp + STACK_BIAS;
 
-	printk("Call Trace:\n");
+	printk("%sCall Trace:\n", loglvl);
 	do {
 		struct sparc_stackf *sf;
 		struct pt_regs *regs;
@@ -2497,14 +2499,14 @@ void show_stack(struct task_struct *tsk,
 			fp = (unsigned long)sf->fp + STACK_BIAS;
 		}
 
-		printk(" [%016lx] %pS\n", pc, (void *) pc);
+		print_ip_sym(loglvl, pc);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 		if ((pc + 8UL) == (unsigned long) &return_to_handler) {
 			struct ftrace_ret_stack *ret_stack;
 			ret_stack = ftrace_graph_get_ret_stack(tsk, graph);
 			if (ret_stack) {
 				pc = ret_stack->ret;
-				printk(" [%016lx] %pS\n", pc, (void *) pc);
+				print_ip_sym(loglvl, pc);
 				graph++;
 			}
 		}
@@ -2512,6 +2514,11 @@ void show_stack(struct task_struct *tsk,
 	} while (++count < 16);
 }
 
+void show_stack(struct task_struct *tsk, unsigned long *_ksp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT);
+}
+
 static inline struct reg_window *kernel_stack_up(struct reg_window *rw)
 {
 	unsigned long fp = rw->ins[6];
_
