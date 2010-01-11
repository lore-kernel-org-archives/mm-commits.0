From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-irq-chipc-set_irq_noprobe-shouldnt-be-__init.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:32:26 -0800
Message-ID: <201001112032.o0BKWQE1026308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab0AKUee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:34:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mingo@elte.hu, ralf@linux-mips.org, sameo@linux.intel.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/irq/chip.c: set_irq_noprobe shouldn't be __init
has been removed from the -mm tree.  Its filename was
     kernel-irq-chipc-set_irq_noprobe-shouldnt-be-__init.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/chip.c: set_irq_noprobe shouldn't be __init
From: Jean Delvare <khali@linux-fr.org>

Non-__init functions need to call set_irq_noprobe() so this function
shouldn't be marked __init.  Also remove __init from set_irq_probe() for
consistency.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/irq/chip.c~kernel-irq-chipc-set_irq_noprobe-shouldnt-be-__init kernel/irq/chip.c
--- a/kernel/irq/chip.c~kernel-irq-chipc-set_irq_noprobe-shouldnt-be-__init
+++ a/kernel/irq/chip.c
@@ -682,7 +682,7 @@ set_irq_chip_and_handler_name(unsigned i
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void __init set_irq_noprobe(unsigned int irq)
+void set_irq_noprobe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -697,7 +697,7 @@ void __init set_irq_noprobe(unsigned int
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void __init set_irq_probe(unsigned int irq)
+void set_irq_probe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
kernel-irq-chipc-set_irq_noprobe-shouldnt-be-__init.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
pca953x-minor-include-cleanup.patch

