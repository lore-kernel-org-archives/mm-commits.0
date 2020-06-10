From: akpm@linux-foundation.org
Subject: [merged] h8300-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:37:22 -0700
Message-ID: <20200610003722.oVZaejEKp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFJAhX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     h8300-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: h8300: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-14-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/traps.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/h8300/kernel/traps.c~h8300-add-show_stack_loglvl
+++ a/arch/h8300/kernel/traps.c
@@ -115,7 +115,8 @@ void die(const char *str, struct pt_regs
 
 static int kstack_depth_to_print = 24;
 
-void show_stack(struct task_struct *task, unsigned long *esp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *esp,
+		       const char *loglvl)
 {
 	unsigned long *stack,  addr;
 	int i;
@@ -125,17 +126,17 @@ void show_stack(struct task_struct *task
 
 	stack = esp;
 
-	pr_info("Stack from %08lx:", (unsigned long)stack);
+	printk("%sStack from %08lx:", loglvl, (unsigned long)stack);
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (((unsigned long)stack & (THREAD_SIZE - 1)) >=
 		    THREAD_SIZE-4)
 			break;
 		if (i % 8 == 0)
-			pr_info(" ");
+			printk("%s ", loglvl);
 		pr_cont(" %08lx", *stack++);
 	}
 
-	pr_info("\nCall Trace:\n");
+	printk("%s\nCall Trace:\n", loglvl);
 	i = 0;
 	stack = esp;
 	while (((unsigned long)stack & (THREAD_SIZE - 1)) < THREAD_SIZE-4) {
@@ -150,10 +151,15 @@ void show_stack(struct task_struct *task
 		 */
 		if (check_kernel_text(addr)) {
 			if (i % 4 == 0)
-				pr_info("       ");
+				printk("%s       ", loglvl);
 			pr_cont(" [<%08lx>]", addr);
 			i++;
 		}
 	}
-	pr_info("\n");
+	printk("%s\n", loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *esp)
+{
+	show_stack_loglvl(task, esp, KERN_INFO);
 }
_

Patches currently in -mm which might be from dima@arista.com are
