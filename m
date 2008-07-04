From: akpm@linux-foundation.org
Subject: + handle-failure-of-irqchip-set_type-in-setup_irq.patch added to -mm tree
Date: Fri, 04 Jul 2008 10:17:23 -0700
Message-ID: <200807041717.m64HHNF2010222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757476AbYGDRRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 13:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, mingo@elte.hu


The patch titled
     generic irqs: handle failure of irqchip->set_type in setup_irq
has been added to the -mm tree.  Its filename is
     handle-failure-of-irqchip-set_type-in-setup_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

 kernel/irq/manage.c |   72 ++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff -puN kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-set=
up_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~handle-failure-of-irqchip-set_type-in-setup_i=
rq
+++ a/kernel/irq/manage.c
@@ -293,6 +293,35 @@ void compat_irq_chip_set_default_handler
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
+	if (ret) {
+		char buf[100];
+
+		snprintf(buf, sizeof(buf), KERN_ERR
+				"setting flow type for irq %u failed (%%s)\n",
+				irq);
+		print_fn_descriptor_symbol(buf, chip->set_type);
+	}
+
+	return ret;
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -304,6 +333,7 @@ int setup_irq(unsigned int irq, struct i
 	const char *old_name =3D NULL;
 	unsigned long flags;
 	int shared =3D 0;
+	int ret;
=20
 	if (irq >=3D NR_IRQS)
 		return -EINVAL;
@@ -361,37 +391,26 @@ int setup_irq(unsigned int irq, struct i
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
-			if (desc->chip && desc->chip->set_type)
-				desc->chip->set_type(irq,
-						new->flags & IRQF_TRIGGER_MASK);
-			else
-				/*
-				 * IRQF_TRIGGER_* but the PIC does not support
-				 * multiple flow-types?
-				 */
-				printk(KERN_WARNING "No IRQF_TRIGGER set_type "
-				       "function for IRQ %d (%s)\n", irq,
-				       desc->chip ? desc->chip->name :
-				       "unknown");
+			ret =3D __irq_set_trigger(desc->chip, irq, new->flags);
+
+			if (ret) {
+				spin_unlock_irqrestore(&desc->lock, flags);
+				return ret;
+			}
+
 		} else
 			compat_irq_chip_set_default_handler(desc);
=20
+#if defined(CONFIG_IRQ_PER_CPU)
+		if (new->flags & IRQF_PERCPU)
+			desc->status |=3D IRQ_PER_CPU;
+#endif
+
 		desc->status &=3D ~(IRQ_AUTODETECT | IRQ_WAITING |
 				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
=20
@@ -409,6 +428,13 @@ int setup_irq(unsigned int irq, struct i
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

linux-next.patch
handle-failure-of-irqchip-set_type-in-setup_irq.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
