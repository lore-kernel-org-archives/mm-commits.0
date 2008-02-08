From: akpm@linux-foundation.org
Subject: - mips-mark-all-but-i8259-interrupts-as-no-probe.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:53 -0800
Message-ID: <200802082020.m18KKYH9011239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYBHUmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:42:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     MIPS: Mark all but i8259 interrupts as no-probe.
has been removed from the -mm tree.  Its filename was
     mips-mark-all-but-i8259-interrupts-as-no-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MIPS: Mark all but i8259 interrupts as no-probe.
From: Ralf Baechle <ralf@linux-mips.org>

Use set_irq_noprobe() to mark all MIPS interrupts as non-probe.  Override that
default for i8259 interrupts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-and-tested-by: Rob Landley <rob@landley.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/i8259.c |    4 +++-
 arch/mips/kernel/irq.c   |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/mips/kernel/i8259.c~mips-mark-all-but-i8259-interrupts-as-no-probe arch/mips/kernel/i8259.c
--- a/arch/mips/kernel/i8259.c~mips-mark-all-but-i8259-interrupts-as-no-probe
+++ a/arch/mips/kernel/i8259.c
@@ -338,8 +338,10 @@ void __init init_i8259_irqs(void)
 
 	init_8259A(0);
 
-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++)
+	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
 		set_irq_chip_and_handler(i, &i8259A_chip, handle_level_irq);
+		set_irq_probe(i);
+	}
 
 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
diff -puN arch/mips/kernel/irq.c~mips-mark-all-but-i8259-interrupts-as-no-probe arch/mips/kernel/irq.c
--- a/arch/mips/kernel/irq.c~mips-mark-all-but-i8259-interrupts-as-no-probe
+++ a/arch/mips/kernel/irq.c
@@ -145,6 +145,11 @@ __setup("nokgdb", nokgdb);
 
 void __init init_IRQ(void)
 {
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		set_irq_noprobe(i);
+
 	arch_init_irq();
 
 #ifdef CONFIG_KGDB
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-watchdog.patch
