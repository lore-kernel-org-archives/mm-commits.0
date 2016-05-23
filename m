From: akpm@linux-foundation.org
Subject: [merged] kprobes-print-out-the-symbol-name-for-the-hooks.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:51:59 -0700
Message-ID: <57435f5f.oEA2C/xYLOZw4qTI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbcEWTwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: print out the symbol name for the hooks
has been removed from the -mm tree.  Its filename was
     kprobes-print-out-the-symbol-name-for-the-hooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/kprobes: print out the symbol name for the hooks

Print out the symbol name for the hooks, it makes the logs more readable.

Link: http://lkml.kernel.org/r/1463535417-29637-2-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kprobe_example.c |   32 ++++++++++++++---------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN samples/kprobes/kprobe_example.c~kprobes-print-out-the-symbol-name-for-the-hooks samples/kprobes/kprobe_example.c
--- a/samples/kprobes/kprobe_example.c~kprobes-print-out-the-symbol-name-for-the-hooks
+++ a/samples/kprobes/kprobe_example.c
@@ -27,24 +27,24 @@ static struct kprobe kp = {
 static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "pre_handler: p->addr = 0x%p, ip = %lx,"
+	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, ip = %lx,"
 			" flags = 0x%lx\n",
-		p->addr, regs->ip, regs->flags);
+		p->symbol_name, p->addr, regs->ip, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "pre_handler: p->addr = 0x%p, nip = 0x%lx,"
+	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, nip = 0x%lx,"
 			" msr = 0x%lx\n",
-		p->addr, regs->nip, regs->msr);
+		p->symbol_name, p->addr, regs->nip, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "pre_handler: p->addr = 0x%p, epc = 0x%lx,"
+	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, epc = 0x%lx,"
 			" status = 0x%lx\n",
-		p->addr, regs->cp0_epc, regs->cp0_status);
+		p->symbol_name, p->addr, regs->cp0_epc, regs->cp0_status);
 #endif
 #ifdef CONFIG_TILEGX
-	printk(KERN_INFO "pre_handler: p->addr = 0x%p, pc = 0x%lx,"
+	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx,"
 			" ex1 = 0x%lx\n",
-		p->addr, regs->pc, regs->ex1);
+		p->symbol_name, p->addr, regs->pc, regs->ex1);
 #endif
 
 	/* A dump_stack() here will give a stack backtrace */
@@ -56,20 +56,20 @@ static void handler_post(struct kprobe *
 				unsigned long flags)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
-		p->addr, regs->flags);
+	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, flags = 0x%lx\n",
+		p->symbol_name, p->addr, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
-		p->addr, regs->msr);
+	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+		p->symbol_name, p->addr, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, status = 0x%lx\n",
-		p->addr, regs->cp0_status);
+	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, status = 0x%lx\n",
+		p->symbol_name, p->addr, regs->cp0_status);
 #endif
 #ifdef CONFIG_TILEGX
-	printk(KERN_INFO "post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
-		p->addr, regs->ex1);
+	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
+		p->symbol_name, p->addr, regs->ex1);
 #endif
 }
 
_

Patches currently in -mm which might be from shijie.huang@arm.com are


