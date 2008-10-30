From: akpm@linux-foundation.org
Subject: + genirq-record-irq_level-in-irq_desc.patch added to -mm tree
Date: Thu, 30 Oct 2008 15:21:55 -0700
Message-ID: <200810302221.m9UMLtoN006534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYJ3WXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 18:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: record IRQ_LEVEL in irq_desc[]
has been added to the -mm tree.  Its filename is
     genirq-record-irq_level-in-irq_desc.patch

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
Subject: genirq: record IRQ_LEVEL in irq_desc[]
From: David Brownell <dbrownell@users.sourceforge.net>

When recording the irq trigger type, let's also make sure
that IRQ_LEVEL gets set correctly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c   |    1 +
 kernel/irq/manage.c |   15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/irq/chip.c~genirq-record-irq_level-in-irq_desc kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-record-irq_level-in-irq_desc
+++ a/kernel/irq/chip.c
@@ -124,6 +124,7 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
+	type &= IRQ_TYPE_SENSE_MASK;
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
diff -puN kernel/irq/manage.c~genirq-record-irq_level-in-irq_desc kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-record-irq_level-in-irq_desc
+++ a/kernel/irq/manage.c
@@ -332,16 +332,18 @@ int __irq_set_trigger(struct irq_desc *d
 		return 0;
 	}
 
-	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+	/* caller masked out all except trigger mode flags */
+	ret = chip->set_type(irq, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)(flags & IRQF_TRIGGER_MASK),
-				irq, chip->set_type);
+				(int)flags, irq, chip->set_type);
 	else {
+		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+			flags |= IRQ_LEVEL;
 		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
+		desc->status |= flags;
 	}
 
 	return ret;
@@ -421,7 +423,8 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq,
+					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
rtc-ds1307-remove-legacy-probe-checks.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch

