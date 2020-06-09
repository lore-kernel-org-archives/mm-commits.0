From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 37/93] unicore32: remove unused pmode argument in
 c_backtrace()
Date: Mon, 08 Jun 2020 21:31:48 -0700
Message-ID: <20200609043148.UOE1srLmm%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEbt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:49 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, gxt@pku.edu.cn, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: unicore32: remove unused pmode argument in c_backtrace()

The pmode parameter isn't used in assembly - remove it.  Second argument
will be reused for printk() log level.

Link: http://lkml.kernel.org/r/20200418201944.482088-38-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/setup.h |    2 +-
 arch/unicore32/kernel/traps.c |   14 +++++---------
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/unicore32/kernel/setup.h~unicore32-remove-unused-pmode-argument-in-c_backtrace
+++ a/arch/unicore32/kernel/setup.h
@@ -29,7 +29,7 @@ extern void kernel_thread_helper(void);
 extern void __init early_signal_init(void);
 
 extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+extern asmlinkage void c_backtrace(unsigned long fp);
 
 extern void __show_regs(struct pt_regs *);
 
--- a/arch/unicore32/kernel/traps.c~unicore32-remove-unused-pmode-argument-in-c_backtrace
+++ a/arch/unicore32/kernel/traps.c
@@ -137,7 +137,7 @@ static void dump_instr(const char *lvl,
 
 static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 {
-	unsigned int fp, mode;
+	unsigned int fp;
 	int ok = 1;
 
 	printk(KERN_DEFAULT "Backtrace: ");
@@ -145,16 +145,12 @@ static void dump_backtrace(struct pt_reg
 	if (!tsk)
 		tsk = current;
 
-	if (regs) {
+	if (regs)
 		fp = regs->UCreg_fp;
-		mode = processor_mode(regs);
-	} else if (tsk != current) {
+	else if (tsk != current)
 		fp = thread_saved_fp(tsk);
-		mode = 0x10;
-	} else {
+	else
 		asm("mov %0, fp" : "=r" (fp) : : "cc");
-		mode = 0x10;
-	}
 
 	if (!fp) {
 		printk("no frame pointer");
@@ -167,7 +163,7 @@ static void dump_backtrace(struct pt_reg
 	printk("\n");
 
 	if (ok)
-		c_backtrace(fp, mode);
+		c_backtrace(fp);
 }
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
_
