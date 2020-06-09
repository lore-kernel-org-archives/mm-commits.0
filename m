From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 06/93] arm: add loglvl to dump_backtrace()
Date: Mon, 08 Jun 2020 21:30:13 -0700
Message-ID: <20200609043013.2flDR1oWJ%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEaP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:15 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, will@kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: arm: add loglvl to dump_backtrace()

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

Add log level argument to dump_backtrace() as a preparation for
introducing show_stack_loglvl().

As a good side-effect __die() now prints not only "Stack:" header with
KERN_EMERG, but the backtrace itself.

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-7-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/arm/kernel/traps.c~arm-add-loglvl-to-dump_backtrace
+++ a/arch/arm/kernel/traps.c
@@ -202,17 +202,19 @@ static void dump_instr(const char *lvl,
 }
 
 #ifdef CONFIG_ARM_UNWIND
-static inline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
+static inline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
+				  const char *loglvl)
 {
-	unwind_backtrace(regs, tsk, KERN_DEFAULT);
+	unwind_backtrace(regs, tsk, loglvl);
 }
 #else
-static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
+static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
+			   const char *loglvl)
 {
 	unsigned int fp, mode;
 	int ok = 1;
 
-	printk("Backtrace: ");
+	printk("%sBacktrace: ", loglvl);
 
 	if (!tsk)
 		tsk = current;
@@ -239,13 +241,13 @@ static void dump_backtrace(struct pt_reg
 	pr_cont("\n");
 
 	if (ok)
-		c_backtrace(fp, mode, NULL);
+		c_backtrace(fp, mode, loglvl);
 }
 #endif
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
 {
-	dump_backtrace(NULL, tsk);
+	dump_backtrace(NULL, tsk, KERN_DEFAULT);
 	barrier();
 }
 
@@ -289,7 +291,7 @@ static int __die(const char *str, int er
 	if (!user_mode(regs) || in_interrupt()) {
 		dump_mem(KERN_EMERG, "Stack: ", regs->ARM_sp,
 			 THREAD_SIZE + (unsigned long)task_stack_page(tsk));
-		dump_backtrace(regs, tsk);
+		dump_backtrace(regs, tsk, KERN_EMERG);
 		dump_instr(KERN_EMERG, regs);
 	}
 
_
