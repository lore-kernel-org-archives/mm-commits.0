From: akpm@linux-foundation.org
Subject: + irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch added to -mm tree
Date: Wed, 28 Mar 2007 15:26:12 -0700
Message-ID: <200703282226.l2SMQCjH021552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbXC1W00 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 18:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     IRQ: check for PERCPU flag only when adding first irqaction
has been added to the -mm tree.  Its filename is
     irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 4 deletions(-)

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

git-drm.patch
git-kvm.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
i386-fix-gdts-number-of-quadwords-in.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
