From: akpm@linux-foundation.org
Subject: + samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch added to -mm tree
Date: Wed, 25 May 2016 15:38:02 -0700
Message-ID: <5746294a.rcm5WUptqTz2y4m2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbcEYWiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2016 18:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@kernel.org, pmladek@suse.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobe: convert the printk to pr_info/pr_err
has been added to the -mm tree.  Its filename is
     samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: samples/kprobe: convert the printk to pr_info/pr_err

We prefer to use the pr_* to print out the log now, this patch converts
the printk to pr_info.  In the error path, use the pr_err to replace the
printk.

Link: http://lkml.kernel.org/r/1464143083-3877-1-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kprobe_example.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN samples/kprobes/kprobe_example.c~samples-kprobe-convert-the-printk-to-pr_info-pr_err samples/kprobes/kprobe_example.c
--- a/samples/kprobes/kprobe_example.c~samples-kprobe-convert-the-printk-to-pr_info-pr_err
+++ a/samples/kprobes/kprobe_example.c
@@ -27,23 +27,19 @@ static struct kprobe kp = {
 static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, ip = %lx,"
-			" flags = 0x%lx\n",
+	pr_info("<%s> pre_handler: p->addr = 0x%p, ip = %lx, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->ip, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, nip = 0x%lx,"
-			" msr = 0x%lx\n",
+	pr_info("<%s> pre_handler: p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
 		p->symbol_name, p->addr, regs->nip, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, epc = 0x%lx,"
-			" status = 0x%lx\n",
+	pr_info("<%s> pre_handler: p->addr = 0x%p, epc = 0x%lx, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->cp0_epc, regs->cp0_status);
 #endif
 #ifdef CONFIG_TILEGX
-	printk(KERN_INFO "<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx,"
-			" ex1 = 0x%lx\n",
+	pr_info("<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx, ex1 = 0x%lx\n",
 		p->symbol_name, p->addr, regs->pc, regs->ex1);
 #endif
 
@@ -56,19 +52,19 @@ static void handler_post(struct kprobe *
 				unsigned long flags)
 {
 #ifdef CONFIG_X86
-	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, flags = 0x%lx\n",
+	pr_info("<%s> post_handler: p->addr = 0x%p, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+	pr_info("<%s> post_handler: p->addr = 0x%p, msr = 0x%lx\n",
 		p->symbol_name, p->addr, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, status = 0x%lx\n",
+	pr_info("<%s> post_handler: p->addr = 0x%p, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->cp0_status);
 #endif
 #ifdef CONFIG_TILEGX
-	printk(KERN_INFO "<%s> post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
+	pr_info("<%s> post_handler: p->addr = 0x%p, ex1 = 0x%lx\n",
 		p->symbol_name, p->addr, regs->ex1);
 #endif
 }
@@ -80,8 +76,7 @@ static void handler_post(struct kprobe *
  */
 static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
 {
-	printk(KERN_INFO "fault_handler: p->addr = 0x%p, trap #%dn",
-		p->addr, trapnr);
+	pr_info("fault_handler: p->addr = 0x%p, trap #%dn", p->addr, trapnr);
 	/* Return 0 because we don't handle the fault. */
 	return 0;
 }
@@ -95,17 +90,17 @@ static int __init kprobe_init(void)
 
 	ret = register_kprobe(&kp);
 	if (ret < 0) {
-		printk(KERN_INFO "register_kprobe failed, returned %d\n", ret);
+		pr_err("register_kprobe failed, returned %d\n", ret);
 		return ret;
 	}
-	printk(KERN_INFO "Planted kprobe at %p\n", kp.addr);
+	pr_info("Planted kprobe at %p\n", kp.addr);
 	return 0;
 }
 
 static void __exit kprobe_exit(void)
 {
 	unregister_kprobe(&kp);
-	printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
+	pr_info("kprobe at %p unregistered\n", kp.addr);
 }
 
 module_init(kprobe_init)
_

Patches currently in -mm which might be from shijie.huang@arm.com are

samples-kprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-jprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-convert-the-printk-to-pr_info-pr_err.patch
samples-kretprobe-fix-the-wrong-type.patch

