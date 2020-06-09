From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/93] alpha: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:30:01 -0700
Message-ID: <20200609043001.OnQrLiLbI%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:02 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, ink@jurassic.park.msu.ru, linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: alpha: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-3-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/arch/alpha/kernel/traps.c~alpha-add-show_stack_loglvl
+++ a/arch/alpha/kernel/traps.c
@@ -121,10 +121,10 @@ dik_show_code(unsigned int *pc)
 }
 
 static void
-dik_show_trace(unsigned long *sp)
+dik_show_trace(unsigned long *sp, const char *loglvl)
 {
 	long i = 0;
-	printk("Trace:\n");
+	printk("%sTrace:\n", loglvl);
 	while (0x1ff8 & (unsigned long) sp) {
 		extern char _stext[], _etext[];
 		unsigned long tmp = *sp;
@@ -133,24 +133,25 @@ dik_show_trace(unsigned long *sp)
 			continue;
 		if (tmp >= (unsigned long) &_etext)
 			continue;
-		printk("[<%lx>] %pSR\n", tmp, (void *)tmp);
+		printk("%s[<%lx>] %pSR\n", loglvl, tmp, (void *)tmp);
 		if (i > 40) {
-			printk(" ...");
+			printk("%s ...", loglvl);
 			break;
 		}
 	}
-	printk("\n");
+	printk("%s\n", loglvl);
 }
 
 static int kstack_depth_to_print = 24;
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+			const char *loglvl)
 {
 	unsigned long *stack;
 	int i;
 
 	/*
-	 * debugging aid: "show_stack(NULL);" prints the
+	 * debugging aid: "show_stack(NULL, NULL, KERN_EMERG);" prints the
 	 * back trace for this cpu.
 	 */
 	if(sp==NULL)
@@ -163,14 +164,19 @@ void show_stack(struct task_struct *task
 		if ((i % 4) == 0) {
 			if (i)
 				pr_cont("\n");
-			printk("       ");
+			printk("%s       ", loglvl);
 		} else {
 			pr_cont(" ");
 		}
 		pr_cont("%016lx", *stack++);
 	}
 	pr_cont("\n");
-	dik_show_trace(sp);
+	dik_show_trace(sp, loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT);
 }
 
 void
@@ -184,7 +190,7 @@ die_if_kernel(char * str, struct pt_regs
 	printk("%s(%d): %s %ld\n", current->comm, task_pid_nr(current), str, err);
 	dik_show_regs(regs, r9_15);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	dik_show_trace((unsigned long *)(regs+1));
+	dik_show_trace((unsigned long *)(regs+1), KERN_DEFAULT);
 	dik_show_code((unsigned int *)regs->pc);
 
 	if (test_and_set_thread_flag (TIF_DIE_IF_KERNEL)) {
@@ -625,7 +631,7 @@ got_exception:
 	printk("gp = %016lx  sp = %p\n", regs->gp, regs+1);
 
 	dik_show_code((unsigned int *)pc);
-	dik_show_trace((unsigned long *)(regs+1));
+	dik_show_trace((unsigned long *)(regs+1), KERN_DEFAULT);
 
 	if (test_and_set_thread_flag (TIF_DIE_IF_KERNEL)) {
 		printk("die_if_kernel recursion detected.\n");
_
