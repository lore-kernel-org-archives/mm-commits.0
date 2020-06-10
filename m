From: akpm@linux-foundation.org
Subject: [merged] openrisc-add-show_stack_loglvl.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:37:44 -0700
Message-ID: <20200610003744.qMvpyikWj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgFJAhp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, jonas@southpole.se, mm-commits@vger.kernel.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi


The patch titled
     Subject: openrisc: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     openrisc-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: openrisc: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-25-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/traps.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/openrisc/kernel/traps.c~openrisc-add-show_stack_loglvl
+++ a/arch/openrisc/kernel/traps.c
@@ -41,18 +41,26 @@ unsigned long __user *lwa_addr;
 
 void print_trace(void *data, unsigned long addr, int reliable)
 {
-	pr_emerg("[<%p>] %s%pS\n", (void *) addr, reliable ? "" : "? ",
+	const char *loglvl = data;
+
+	printk("%s[<%p>] %s%pS\n", loglvl, (void *) addr, reliable ? "" : "? ",
 	       (void *) addr);
 }
 
 /* displays a short stack trace */
-void show_stack(struct task_struct *task, unsigned long *esp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *esp,
+		const char *loglvl)
 {
 	if (esp == NULL)
 		esp = (unsigned long *)&esp;
 
-	pr_emerg("Call trace:\n");
-	unwind_stack(NULL, esp, print_trace);
+	printk("%sCall trace:\n", loglvl);
+	unwind_stack((void *)loglvl, esp, print_trace);
+}
+
+void show_stack(struct task_struct *task, unsigned long *esp)
+{
+	show_stack_loglvl(task, esp, KERN_EMERG);
 }
 
 void show_registers(struct pt_regs *regs)
_

Patches currently in -mm which might be from dima@arista.com are
