From: akpm@linux-foundation.org
Subject: + xtensa-s-irq_chip-irq_data-in-various-places.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:20:41 -0700
Message-ID: <201104112320.p3BNKfnI010263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328Ab1DKXUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wanlong.gao@gmail.com, chris@zankel.net, tglx@linutronix.de


The patch titled
     xtensa: s/irq_chip/irq_data/ in various places
has been added to the -mm tree.  Its filename is
     xtensa-s-irq_chip-irq_data-in-various-places.patch

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

xtensa-s-irq_chip-irq_data-in-various-places.patch

