From: akpm@linux-foundation.org
Subject: [merged] genirq-fix-missing-parenthesises-in-generic-chip.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:41 -0700
Message-ID: <201108161848.p7GImmL6015393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab1HPSt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: fix missing parenthesises in generic-chip
has been removed from the -mm tree.  Its filename was
     genirq-fix-missing-parenthesises-in-generic-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: fix missing parenthesises in generic-chip
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Unless I'm very much missing something these tests are intended to check
if bit zero is set, rather than checking if msk is entirely zero (in which
case the logic would be very confusing.  I haven't actually observed any
runtime issues so this may be a misreading of the code on my part.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/generic-chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/irq/generic-chip.c~genirq-fix-missing-parenthesises-in-generic-chip kernel/irq/generic-chip.c
--- a/kernel/irq/generic-chip.c~genirq-fix-missing-parenthesises-in-generic-chip
+++ a/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_c
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

