From: akpm@linux-foundation.org
Subject: - genirq-better-warning-on-irqchip-set_type-failure.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:22 -0700
Message-ID: <200808062056.m76KuMGk014661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757604AbYHFU5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, Uwe.Kleine-Koenig@digi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: better warning on irqchip->set_type() failure
has been removed from the -mm tree.  Its filename was
     genirq-better-warning-on-irqchip-set_type-failure.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: genirq: better warning on irqchip->set_type() failure
=46rom: David Brownell <dbrownell@users.sourceforge.net>

While I'm glad to finally see the hole fixed whereby passing an invalid
IRQ trigger type to request_irq() would be ignored, the current diagnos=
tic
isn't quite useful.  Fixed by also listing the trigger type which was
rejected.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~genirq-better-warning-on-irqchip-set_type=
-failure kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-better-warning-on-irqchip-set_type-fai=
lure
+++ a/kernel/irq/manage.c
@@ -323,7 +323,8 @@ static int __irq_set_trigger(struct irq_
 	ret =3D chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
=20
 	if (ret)
-		pr_err("setting flow type for irq %u failed (%pF)\n",
+		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
+				(int)(flags & IRQF_TRIGGER_MASK),
 				irq, chip->set_type);
=20
 	return ret;
_

Patches currently in -mm which might be from dbrownell@users.sourceforg=
e.net are

linux-next.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
