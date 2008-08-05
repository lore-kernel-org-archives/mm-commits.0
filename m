From: akpm@linux-foundation.org
Subject: + x86_64-remove-empty-lines-from-stack-traces-oopses.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:13:54 -0700
Message-ID: <200808052113.m75LDsvq023749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbYHEVO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: remove empty lines from stack traces/oopses
has been added to the -mm tree.  Its filename is
     x86_64-remove-empty-lines-from-stack-traces-oopses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -340,9 +340,8 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
-	printk("\nCall Trace:\n");
+	printk("Call Trace:\n");
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("\n");
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
@@ -387,6 +386,7 @@ show_stack_log_lvl(struct task_struct *t
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
+	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
@@ -444,7 +444,6 @@ void show_registers(struct pt_regs *regs
 		printk("Stack: ");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
 				regs->bp, "");
-		printk("\n");
 
 		printk(KERN_EMERG "Code: ");
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vt8623fb-fix-kernel-oops.patch
linux-next.patch
x86_64-remove-empty-lines-from-stack-traces-oopses.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
seq_file-add-seq_cpumask-seq_nodemask.patch
switch-proc-irq-smp_affinity-et-al-to-seqfiles.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
devpts-switch-to-ida-checkpatch-fixes.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

