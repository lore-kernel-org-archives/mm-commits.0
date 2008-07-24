From: akpm@linux-foundation.org
Subject: - handle-failure-of-irqchip-set_type-in-setup_irq.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:02 -0700
Message-ID: <200807242326.m6ONQ2XI010940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbYGXX01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     generic irqs: handle failure of irqchip->set_type in setup_irq
has been removed from the -mm tree.  Its filename was
     handle-failure-of-irqchip-set_type-in-setup_irq.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: generic irqs: handle failure of irqchip->set_type in setup_irq
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

set_type returns an int indicating success or failure, but up to now
setup_irq ignores that.

In my case this resulted in a machine hang:

gpio-keys requested IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, but
arm/ns9xxx can only trigger on one direction so set_type didn't touch
the configuration which happens do default to a level sensitiveness and
returned -EINVAL.  setup_irq ignored that and unmasked the irq.  This
resulted in an endless triggering of the gpio-key interrupt service
routine which effectively killed the machine.

With this patch applied setup_irq propagates the error to the caller.

Note that before in the case

	chip && !chip->set_type && !chip->name

a NULL pointer was feed to printk.  This is fixed, too.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   64 +++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff -puN kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-set=
up_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-setup_i=
rq
+++ a/kernel/irq/manage.c
@@ -308,6 +308,30 @@ void compat_irq_chip_set_default_handler
 		desc->handle_irq =3D NULL;
 }
=20
+static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
+		unsigned long flags)
+{
+	int ret;
+
+	if (!chip || !chip->set_type) {
+		/*
+		 * IRQF_TRIGGER_* but the PIC does not support multiple
+		 * flow-types?
+		 */
+		pr_warning("No set_type function for IRQ %d (%s)\n", irq,
+				chip ? (chip->name ? : "unknown") : "unknown");
+		return 0;
+	}
+
+	ret =3D chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+
+	if (ret)
+		pr_err("setting flow type for irq %u failed (%pF)\n",
+				irq, chip->set_type);
+
+	return ret;
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -319,6 +343,7 @@ int setup_irq(unsigned int irq, struct i
 	const char *old_name =3D NULL;
 	unsigned long flags;
 	int shared =3D 0;
+	int ret;
=20
 	if (irq >=3D NR_IRQS)
 		return -EINVAL;
@@ -376,35 +401,23 @@ int setup_irq(unsigned int irq, struct i
 		shared =3D 1;
 	}
=20
-	*p =3D new;
-
-	/* Exclude IRQ from balancing */
-	if (new->flags & IRQF_NOBALANCING)
-		desc->status |=3D IRQ_NO_BALANCING;
-
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
=20
-#if defined(CONFIG_IRQ_PER_CPU)
-		if (new->flags & IRQF_PERCPU)
-			desc->status |=3D IRQ_PER_CPU;
-#endif
-
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			if (desc->chip->set_type)
-				desc->chip->set_type(irq,
-						new->flags & IRQF_TRIGGER_MASK);
-			else
-				/*
-				 * IRQF_TRIGGER_* but the PIC does not support
-				 * multiple flow-types?
-				 */
-				printk(KERN_WARNING "No IRQF_TRIGGER set_type "
-				       "function for IRQ %d (%s)\n", irq,
-				       desc->chip->name);
+			ret =3D __irq_set_trigger(desc->chip, irq, new->flags);
+
+			if (ret) {
+				spin_unlock_irqrestore(&desc->lock, flags);
+				return ret;
+			}
 		} else
 			compat_irq_chip_set_default_handler(desc);
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |=3D IRQ_PER_CPU;
+#endif
=20
 		desc->status &=3D ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
@@ -423,6 +436,13 @@ int setup_irq(unsigned int irq, struct i
 		/* Set default affinity mask once everything is setup */
 		irq_select_affinity(irq);
 	}
+
+	*p =3D new;
+
+	/* Exclude IRQ from balancing */
+	if (new->flags & IRQF_NOBALANCING)
+		desc->status |=3D IRQ_NO_BALANCING;
+
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count =3D 0;
 	desc->irqs_unhandled =3D 0;
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
