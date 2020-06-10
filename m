From: akpm@linux-foundation.org
Subject: [merged]
 ia64-pass-log-level-as-arg-into-ia64_do_show_stack.patch removed from -mm
 tree
Date: Tue, 09 Jun 2020 17:37:26 -0700
Message-ID: <20200610003726.eWzD026SM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFJAh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, fenghua.yu@intel.com, mm-commits@vger.kernel.org, tony.luck@intel.com


The patch titled
     Subject: ia64: pass log level as arg into ia64_do_show_stack()
has been removed from the -mm tree.  Its filename was
     ia64-pass-log-level-as-arg-into-ia64_do_show_stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: ia64: pass log level as arg into ia64_do_show_stack()

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

Add log level argument to ia64_do_show_stack() as a preparation to
introduce show_stack_loglvl().  Also, make ia64_do_show_stack() static as
it's not used outside.

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-16-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/ptrace.h |    1 -
 arch/ia64/kernel/process.c     |   13 +++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/ia64/include/asm/ptrace.h~ia64-pass-log-level-as-arg-into-ia64_do_show_stack
+++ a/arch/ia64/include/asm/ptrace.h
@@ -114,7 +114,6 @@ static inline long regs_return_value(str
   struct task_struct;			/* forward decl */
   struct unw_frame_info;		/* forward decl */
 
-  extern void ia64_do_show_stack (struct unw_frame_info *, void *);
   extern unsigned long ia64_get_user_rbs_end (struct task_struct *, struct pt_regs *,
 					      unsigned long *);
   extern long ia64_peek (struct task_struct *, struct switch_stack *, unsigned long,
--- a/arch/ia64/kernel/process.c~ia64-pass-log-level-as-arg-into-ia64_do_show_stack
+++ a/arch/ia64/kernel/process.c
@@ -64,12 +64,13 @@ EXPORT_SYMBOL(boot_option_idle_override)
 void (*pm_power_off) (void);
 EXPORT_SYMBOL(pm_power_off);
 
-void
+static void
 ia64_do_show_stack (struct unw_frame_info *info, void *arg)
 {
 	unsigned long ip, sp, bsp;
+	const char *loglvl = arg;
 
-	printk("\nCall Trace:\n");
+	printk("%s\nCall Trace:\n", loglvl);
 	do {
 		unw_get_ip(info, &ip);
 		if (ip == 0)
@@ -77,9 +78,9 @@ ia64_do_show_stack (struct unw_frame_inf
 
 		unw_get_sp(info, &sp);
 		unw_get_bsp(info, &bsp);
-		printk(" [<%016lx>] %pS\n"
+		printk("%s [<%016lx>] %pS\n"
 			 "                                sp=%016lx bsp=%016lx\n",
-			 ip, (void *)ip, sp, bsp);
+			 loglvl, ip, (void *)ip, sp, bsp);
 	} while (unw_unwind(info) >= 0);
 }
 
@@ -87,12 +88,12 @@ void
 show_stack (struct task_struct *task, unsigned long *sp)
 {
 	if (!task)
-		unw_init_running(ia64_do_show_stack, NULL);
+		unw_init_running(ia64_do_show_stack, (void *)KERN_DEFAULT);
 	else {
 		struct unw_frame_info info;
 
 		unw_init_from_blocked_task(&info, task);
-		ia64_do_show_stack(&info, NULL);
+		ia64_do_show_stack(&info, (void *)KERN_DEFAULT);
 	}
 }
 
_

Patches currently in -mm which might be from dima@arista.com are
