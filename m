From: akpm@linux-foundation.org
Subject: [merged] c6x-add-show_stack_loglvl.patch removed from -mm
 tree
Date: Tue, 09 Jun 2020 17:37:18 -0700
Message-ID: <20200610003718.6e22U2urm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAhT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, jacquiot.aurelien@gmail.com, mm-commits@vger.kernel.org, msalter@redhat.com


The patch titled
     Subject: c6x: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     c6x-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: c6x: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-12-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/kernel/traps.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/c6x/kernel/traps.c~c6x-add-show_stack_loglvl
+++ a/arch/c6x/kernel/traps.c
@@ -344,12 +344,13 @@ asmlinkage int process_exception(struct
 
 static int kstack_depth_to_print = 48;
 
-static void show_trace(unsigned long *stack, unsigned long *endstack)
+static void show_trace(unsigned long *stack, unsigned long *endstack,
+		       const char *loglvl)
 {
 	unsigned long addr;
 	int i;
 
-	pr_debug("Call trace:");
+	printk("%sCall trace:", loglvl);
 	i = 0;
 	while (stack + 1 <= endstack) {
 		addr = *stack++;
@@ -364,16 +365,17 @@ static void show_trace(unsigned long *st
 		if (__kernel_text_address(addr)) {
 #ifndef CONFIG_KALLSYMS
 			if (i % 5 == 0)
-				pr_debug("\n	    ");
+				printk("%s\n	    ", loglvl);
 #endif
-			pr_debug(" [<%08lx>] %pS\n", addr, (void *)addr);
+			printk("%s [<%08lx>] %pS\n", loglvl, addr, (void *)addr);
 			i++;
 		}
 	}
-	pr_debug("\n");
+	printk("%s\n", loglvl);
 }
 
-void show_stack(struct task_struct *task, unsigned long *stack)
+void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
+		const char *loglvl)
 {
 	unsigned long *p, *endstack;
 	int i;
@@ -398,7 +400,12 @@ void show_stack(struct task_struct *task
 		pr_cont(" %08lx", *p++);
 	}
 	pr_cont("\n");
-	show_trace(stack, endstack);
+	show_trace(stack, endstack, loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	show_stack_loglvl(task, stack, KERN_DEBUG);
 }
 
 int is_valid_bugaddr(unsigned long addr)
_

Patches currently in -mm which might be from dima@arista.com are
