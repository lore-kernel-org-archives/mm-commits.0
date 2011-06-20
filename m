From: akpm@linux-foundation.org
Subject: + genirq-fix-missing-parenthesises-in-generic-chip.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:11:29 -0700
Message-ID: <201106201911.p5KJBUd5012760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755857Ab1FTTMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, tglx@linutronix.de


The patch titled
     genirq: fix missing parenthesises in generic-chip
has been added to the -mm tree.  Its filename is
     genirq-fix-missing-parenthesises-in-generic-chip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -232,7 +232,7 @@ void irq_setup_generic_chip(struct irq_c
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -287,7 +287,7 @@ void irq_remove_generic_chip(struct irq_
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
genirq-fix-missing-parenthesises-in-generic-chip.patch
frv-hook-up-gpiolib-support.patch

