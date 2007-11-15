From: akpm@linux-foundation.org
Subject: - cris-build-fixes-irq-fixes.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:37 -0800
Message-ID: <200711152111.lAFLBbq1015781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbXKOVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: irq fixes
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-irq-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: irq fixes
From: Jesper Nilsson <jesper.nilsson@axis.com>

- New file include/asm-cris/irq_regs.h.
- Change handling of registers for do_IRQ.
- Add GENERIC_HARDIRQS to Kconfig.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig      |    4 ++++
 arch/cris/kernel/irq.c |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/cris/Kconfig~cris-build-fixes-irq-fixes arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-build-fixes-irq-fixes
+++ a/arch/cris/Kconfig
@@ -57,6 +57,10 @@ menu "General setup"
 
 source "fs/Kconfig.binfmt"
 
+config GENERIC_HARDIRQS
+	bool
+	default y
+
 config ETRAX_CMDLINE
 	string "Kernel command line"
 	default "root=/dev/mtdblock3"
diff -puN arch/cris/kernel/irq.c~cris-build-fixes-irq-fixes arch/cris/kernel/irq.c
--- a/arch/cris/kernel/irq.c~cris-build-fixes-irq-fixes
+++ a/arch/cris/kernel/irq.c
@@ -2,7 +2,7 @@
  *
  *	linux/arch/cris/kernel/irq.c
  *
- *      Copyright (c) 2000,2001 Axis Communications AB
+ *      Copyright (c) 2000,2007 Axis Communications AB
  *
  *      Authors: Bjorn Wesen (bjornw@axis.com)
  *
@@ -92,14 +92,16 @@ skip:
 asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
 {
 	unsigned long sp;
+	struct pt_regs *old_regs = set_irq_regs(regs);
 	irq_enter();
 	sp = rdsp();
 	if (unlikely((sp & (PAGE_SIZE - 1)) < (PAGE_SIZE/8))) {
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq, regs);
+	__do_IRQ(irq);
         irq_exit();
+	set_irq_regs(old_regs);
 }
 
 void weird_irq(void)
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
