From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 16/93] ia64: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:30:44 -0700
Message-ID: <20200609043044.qyPV2sfuB%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:46 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, fenghua.yu@intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, tony.luck@intel.com, torvalds@linux-foundation.org

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
