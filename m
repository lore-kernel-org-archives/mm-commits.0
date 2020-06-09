From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 39/93] unicore32: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:31:54 -0700
Message-ID: <20200609043154.kR7DP9iIq%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:56 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, gxt@pku.edu.cn, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: unicore32: add show_stack_loglvl()

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

As a nice side-effect - print backtrace in __die() with the same log level
as the rest of function.

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-40-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/traps.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/unicore32/kernel/traps.c~unicore32-add-show_stack_loglvl
+++ a/arch/unicore32/kernel/traps.c
@@ -135,12 +135,13 @@ static void dump_instr(const char *lvl,
 	set_fs(fs);
 }
 
-static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
+static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
+			   const char *loglvl)
 {
 	unsigned int fp;
 	int ok = 1;
 
-	printk(KERN_DEFAULT "Backtrace: ");
+	printk("%sBacktrace: ", loglvl);
 
 	if (!tsk)
 		tsk = current;
@@ -153,25 +154,31 @@ static void dump_backtrace(struct pt_reg
 		asm("mov %0, fp" : "=r" (fp) : : "cc");
 
 	if (!fp) {
-		printk("no frame pointer");
+		printk("%sno frame pointer", loglvl);
 		ok = 0;
 	} else if (verify_stack(fp)) {
-		printk("invalid frame pointer 0x%08x", fp);
+		printk("%sinvalid frame pointer 0x%08x", loglvl, fp);
 		ok = 0;
 	} else if (fp < (unsigned long)end_of_stack(tsk))
-		printk("frame pointer underflow");
-	printk("\n");
+		printk("%sframe pointer underflow", loglvl);
+	printk("%s\n", loglvl);
 
 	if (ok)
-		c_backtrace(fp, KERN_DEFAULT);
+		c_backtrace(fp, loglvl);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
+		       const char *loglvl)
 {
-	dump_backtrace(NULL, tsk);
+	dump_backtrace(NULL, tsk, loglvl);
 	barrier();
 }
 
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	show_stack_loglvl(tsk, sp, KERN_DEFAULT)
+}
+
 static int __die(const char *str, int err, struct thread_info *thread,
 		struct pt_regs *regs)
 {
@@ -196,7 +203,7 @@ static int __die(const char *str, int er
 	if (!user_mode(regs) || in_interrupt()) {
 		dump_mem(KERN_EMERG, "Stack: ", regs->UCreg_sp,
 			 THREAD_SIZE + (unsigned long)task_stack_page(tsk));
-		dump_backtrace(regs, tsk);
+		dump_backtrace(regs, tsk, KERN_EMERG);
 		dump_instr(KERN_EMERG, regs);
 	}
 
_
