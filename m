From: akpm@linux-foundation.org
Subject: - irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:06 -0700
Message-ID: <200705090248.l492m6HU009060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934777AbXEICsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     IRQ: check for PERCPU flag only when adding first irqaction
has been removed from the -mm tree.  Its filename was
     irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IRQ: check for PERCPU flag only when adding first irqaction
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

An irqaction structure won't be added to an IRQ descriptor irqaction list if
it doesn't agree with other irqactions on the IRQF_PERCPU flag.  Don't check
for this flag to change IRQ descriptor `status' for every irqaction added to
the list, Doing the check only for the first irqaction added is enough.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/irq/manage.c~irq-check-for-percpu-flag-only-when-adding-first-irqaction kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-check-for-percpu-flag-only-when-adding-first-irqaction
+++ a/kernel/irq/manage.c
@@ -317,10 +317,7 @@ int setup_irq(unsigned int irq, struct i
 	}
 
 	*p = new;
-#if defined(CONFIG_IRQ_PER_CPU)
-	if (new->flags & IRQF_PERCPU)
-		desc->status |= IRQ_PER_CPU;
-#endif
+
 	/* Exclude IRQ from balancing */
 	if (new->flags & IRQF_NOBALANCING)
 		desc->status |= IRQ_NO_BALANCING;
@@ -328,6 +325,11 @@ int setup_irq(unsigned int irq, struct i
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |= IRQ_PER_CPU;
+#endif
+
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			if (desc->chip && desc->chip->set_type)
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
git-e1000.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
