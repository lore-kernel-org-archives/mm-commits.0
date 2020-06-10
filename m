From: akpm@linux-foundation.org
Subject: [merged] ia64-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:37:28 -0700
Message-ID: <20200610003728.uGUA2g96P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFJAh3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, fenghua.yu@intel.com, mm-commits@vger.kernel.org, tony.luck@intel.com


The patch titled
     Subject: ia64: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     ia64-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: ia64: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-17-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/process.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/ia64/kernel/process.c~ia64-add-show_stack_loglvl
+++ a/arch/ia64/kernel/process.c
@@ -85,19 +85,26 @@ ia64_do_show_stack (struct unw_frame_inf
 }
 
 void
-show_stack (struct task_struct *task, unsigned long *sp)
+show_stack_loglvl (struct task_struct *task, unsigned long *sp,
+		   const char *loglvl)
 {
 	if (!task)
-		unw_init_running(ia64_do_show_stack, (void *)KERN_DEFAULT);
+		unw_init_running(ia64_do_show_stack, (void *)loglvl);
 	else {
 		struct unw_frame_info info;
 
 		unw_init_from_blocked_task(&info, task);
-		ia64_do_show_stack(&info, (void *)KERN_DEFAULT);
+		ia64_do_show_stack(&info, (void *)loglvl);
 	}
 }
 
 void
+show_stack (struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT);
+}
+
+void
 show_regs (struct pt_regs *regs)
 {
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
_

Patches currently in -mm which might be from dima@arista.com are
