From: akpm@linux-foundation.org
Subject: [merged] xtensa-s-irq_chip-irq_data-in-various-places.patch removed from -mm tree
Date: Mon, 25 Apr 2011 12:55:04 -0700
Message-ID: <201104251950.p3PJoCi2004544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820Ab1DYT7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 15:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanlong.gao@gmail.com, chris@zankel.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     xtensa: s/irq_chip/irq_data/ in various places
has been removed from the -mm tree.  Its filename was
     xtensa-s-irq_chip-irq_data-in-various-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: s/irq_chip/irq_data/ in various places
From: Wanlong Gao <wanlong.gao@gmail.com>

The functions of xtensa_irq_chip members use the wrong argument.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/irq.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/xtensa/kernel/irq.c~xtensa-s-irq_chip-irq_data-in-various-places arch/xtensa/kernel/irq.c
--- a/arch/xtensa/kernel/irq.c~xtensa-s-irq_chip-irq_data-in-various-places
+++ a/arch/xtensa/kernel/irq.c
@@ -75,36 +75,36 @@ int arch_show_interrupts(struct seq_file
 	return 0;
 }
 
-static void xtensa_irq_mask(struct irq_chip *d)
+static void xtensa_irq_mask(struct irq_data *d)
 {
 	cached_irq_mask &= ~(1 << d->irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(struct irq_chip *d)
+static void xtensa_irq_unmask(struct irq_data *d)
 {
 	cached_irq_mask |= 1 << d->irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(struct irq_chip *d)
+static void xtensa_irq_enable(struct irq_data *d)
 {
 	variant_irq_enable(d->irq);
 	xtensa_irq_unmask(d->irq);
 }
 
-static void xtensa_irq_disable(struct irq_chip *d)
+static void xtensa_irq_disable(struct irq_data *d)
 {
 	xtensa_irq_mask(d->irq);
 	variant_irq_disable(d->irq);
 }
 
-static void xtensa_irq_ack(struct irq_chip *d)
+static void xtensa_irq_ack(struct irq_data *d)
 {
 	set_sr(1 << d->irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(struct irq_chip *d)
+static int xtensa_irq_retrigger(struct irq_data *d)
 {
 	set_sr (1 << d->irq, INTSET);
 	return 1;
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are

linux-next.patch
bluetooth-fix-build-warnings-on-defconfigs.patch

