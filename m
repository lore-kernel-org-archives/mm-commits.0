From: akpm@linux-foundation.org
Subject: - set_irq_wake-fix-return-code-and-wake-status-tracking.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:45 -0700
Message-ID: <200807232102.m6NL2jhq011785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164AbYGWVDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, dbrownell@users.sourceforge.net, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     set_irq_wake: fix return code and wake status tracking
has been removed from the -mm tree.  Its filename was
     set_irq_wake-fix-return-code-and-wake-status-tracking.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: set_irq_wake: fix return code and wake status tracking
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

Since 15a647eba94c3da27ccc666bea72e7cca06b2d19 set_irq_wake returned
-ENXIO if another device had it already enabled.  Zero is the right val=
ue
to return in this case.  Moreover the change to desc->status was not
reverted if desc->chip->set_wake returned an error.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff -puN kernel/irq/manage.c~set_irq_wake-fix-return-code-and-wake-sta=
tus-tracking kernel/irq/manage.c
--- a/kernel/irq/manage.c~set_irq_wake-fix-return-code-and-wake-status-=
tracking
+++ a/kernel/irq/manage.c
@@ -224,6 +224,17 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
=20
+int set_irq_wake_real(unsigned int irq, unsigned int on)
+{
+	struct irq_desc *desc =3D irq_desc + irq;
+	int ret =3D -ENXIO;
+
+	if (desc->chip->set_wake)
+		ret =3D desc->chip->set_wake(irq, on);
+
+	return ret;
+}
+
 /**
  *	set_irq_wake - control irq power management wakeup
  *	@irq:	interrupt to control
@@ -240,30 +251,34 @@ int set_irq_wake(unsigned int irq, unsig
 {
 	struct irq_desc *desc =3D irq_desc + irq;
 	unsigned long flags;
-	int ret =3D -ENXIO;
-	int (*set_wake)(unsigned, unsigned) =3D desc->chip->set_wake;
+	int ret =3D 0;
=20
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
 	spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
-		if (desc->wake_depth++ =3D=3D 0)
-			desc->status |=3D IRQ_WAKEUP;
-		else
-			set_wake =3D NULL;
+		if (desc->wake_depth++ =3D=3D 0) {
+			ret =3D set_irq_wake_real(irq, on);
+			if (ret)
+				desc->wake_depth =3D 0;
+			else
+				desc->status |=3D IRQ_WAKEUP;
+		}
 	} else {
 		if (desc->wake_depth =3D=3D 0) {
 			printk(KERN_WARNING "Unbalanced IRQ %d "
 					"wake disable\n", irq);
 			WARN_ON(1);
-		} else if (--desc->wake_depth =3D=3D 0)
-			desc->status &=3D ~IRQ_WAKEUP;
-		else
-			set_wake =3D NULL;
+		} else if (--desc->wake_depth =3D=3D 0) {
+			ret =3D set_irq_wake_real(irq, on);
+			if (ret)
+				desc->wake_depth =3D 1;
+			else
+				desc->status &=3D ~IRQ_WAKEUP;
+		}
 	}
-	if (set_wake)
-		ret =3D desc->chip->set_wake(irq, on);
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

origin.patch
linux-next.patch
handle-failure-of-irqchip-set_type-in-setup_irq.patch
handle-failure-of-irqchip-set_type-in-setup_irq-update.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
