From: akpm@linux-foundation.org
Subject: - x86_64-remove-empty-lines-from-stack-traces-oopses.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:47 -0700
Message-ID: <200808261844.m7QIilBH021340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757469AbYHZSpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove empty lines from stack traces/oopses
has been removed from the -mm tree.  Its filename was
     x86_64-remove-empty-lines-from-stack-traces-oopses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: remove empty lines from stack traces/oopses
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/traps_64.c~x86_64-remove-empty-lines-from-stack-traces-oopses arch/x86/kernel/traps_64.c
--- a/arch/x86/kernel/traps_64.c~x86_64-remove-empty-lines-from-stack-traces-oopses
+++ a/arch/x86/kernel/traps_64.c
@@ -341,9 +341,8 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
-	printk("\nCall Trace:\n");
+	printk("Call Trace:\n");
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("\n");
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
@@ -390,6 +389,7 @@ show_stack_log_lvl(struct task_struct *t
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
+	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
@@ -446,7 +446,6 @@ void show_registers(struct pt_regs *regs
 		printk("Stack: ");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
 				regs->bp, "");
-		printk("\n");
 
 		printk(KERN_EMERG "Code: ");
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

