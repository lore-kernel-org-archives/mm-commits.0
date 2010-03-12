From: akpm@linux-foundation.org
Subject: [nacked] genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch removed from -mm tree
Date: Fri, 12 Mar 2010 15:50:26 -0800
Message-ID: <201003122350.o2CNoQxK015105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932782Ab0CLXww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 18:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl, andrea.gallo@stericsson.com, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, hugh.dickins@tiscali.co.uk, jamie@shareabl


The patch titled
     genirq: warn about IRQF_SHARED|IRQF_DISABLED at the right place
has been removed from the -mm tree.  Its filename was
     genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patc=
h

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: genirq: warn about IRQF_SHARED|IRQF_DISABLED at the right plac=
e
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

=46or shared irqs IRQF_DISABLED is only guaranteed for the first handle=
r.=20
So only warn starting at the second registration.

The warning is moved to __setup_irq having the additional benefit of
catching actions registered using setup_irq not only register_irq.

This doesn't fix the cases where setup order is wrong but it should rep=
ort
the broken cases more reliably.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Remy Bohmer <linux@bohmer.net>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Gallo <andrea.gallo@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jamie Lokier <jamie@shareable.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/irq/manage.c~genirq-warn-about-irqf_sharedirqf_disable=
d-at-the-right-place kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-warn-about-irqf_sharedirqf_disabled-at=
-the-right-place
+++ a/kernel/irq/manage.c
@@ -702,6 +702,16 @@ __setup_irq(unsigned int irq, struct irq
 			goto mismatch;
 #endif
=20
+		/*
+		 * handle_IRQ_event() only honors IRQF_DISABLED for the _first_
+		 * irqaction.  As the first handler might reenable irqs all bets
+		 * are off for the later handlers even if the first one has
+		 * IRQF_DISABLED, too.
+		 */
+		if (new->flags & IRQF_DISABLED)
+			pr_warning("IRQ %d/%s: IRQF_DISABLED is not guaranteed "
+					"on shared IRQs\n", irq, new->name);
+
 		/* add new interrupt at end of irq queue */
 		do {
 			old_ptr =3D &old->next;
@@ -1008,19 +1018,6 @@ int request_threaded_irq(unsigned int ir
 	struct irq_desc *desc;
 	int retval;
=20
-	/*
-	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
-	 * the _first_ irqaction (sigh).  That can cause oopsing, but
-	 * the behavior is classified as "will not fix" so we need to
-	 * start nudging drivers away from using that idiom.
-	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) =3D=3D
-					(IRQF_SHARED|IRQF_DISABLED)) {
-		pr_warning(
-		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
-			irq, devname);
-	}
