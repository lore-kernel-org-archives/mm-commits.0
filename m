From: akpm@linux-foundation.org
Subject: [merged] nios2-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:37:42 -0700
Message-ID: <20200610003742.0pHYOSOny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgFJAhn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, lftan@altera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     nios2-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: nios2: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-24-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/kernel/traps.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/arch/nios2/kernel/traps.c~nios2-add-show_stack_loglvl
+++ a/arch/nios2/kernel/traps.c
@@ -52,12 +52,14 @@ void _exception(int signo, struct pt_reg
 }
 
 /*
- * The show_stack is an external API which we do not use ourselves.
+ * The show_stack(), show_stack_loglvl() are external API
+ * which we do not use ourselves.
  */
 
 int kstack_depth_to_print = 48;
 
-void show_stack(struct task_struct *task, unsigned long *stack)
+void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+		       const char *loglvl)
 {
 	unsigned long *endstack, addr;
 	int i;
@@ -72,16 +74,16 @@ void show_stack(struct task_struct *task
 	addr = (unsigned long) stack;
 	endstack = (unsigned long *) PAGE_ALIGN(addr);
 
-	pr_emerg("Stack from %08lx:", (unsigned long)stack);
+	printk("%sStack from %08lx:", loglvl, (unsigned long)stack);
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (stack + 1 > endstack)
 			break;
 		if (i % 8 == 0)
-			pr_emerg("\n       ");
-		pr_emerg(" %08lx", *stack++);
+			printk("%s\n       ", loglvl);
+		printk("%s %08lx", loglvl, *stack++);
 	}
 
-	pr_emerg("\nCall Trace:");
+	printk("%s\nCall Trace:", loglvl);
 	i = 0;
 	while (stack + 1 <= endstack) {
 		addr = *stack++;
@@ -97,11 +99,16 @@ void show_stack(struct task_struct *task
 		     (addr <= (unsigned long) _etext))) {
 			if (i % 4 == 0)
 				pr_emerg("\n       ");
-			pr_emerg(" [<%08lx>]", addr);
+			printk("%s [<%08lx>]", loglvl, addr);
 			i++;
 		}
 	}
-	pr_emerg("\n");
+	printk("%s\n", loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	show_stack_loglvl(task, stack, KERN_EMERG);
 }
 
 void __init trap_init(void)
_

Patches currently in -mm which might be from dima@arista.com are
