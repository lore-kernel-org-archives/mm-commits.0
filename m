From: akpm@linux-foundation.org
Subject: [merged] rtc-mc13783-dont-use-deprecated-mc13783-api-calls.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:46 -0800
Message-ID: <201003091910.o29JAkLF031612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab0CITLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dmitry.torokhov@gmail.com, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.lo


The patch titled
     rtc/mc13783: don't use deprecated mc13783 API calls
has been removed from the -mm tree.  Its filename was
     rtc-mc13783-dont-use-deprecated-mc13783-api-calls.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc/mc13783: don't use deprecated mc13783 API calls
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

mc13783_ackirq, mc13783_unmask and mc13783_mask are deprecated, use the
drop in replacements with the nicer names.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13783.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-mc13783.c~rtc-mc13783-dont-use-deprecated-mc1=
3783-api-calls drivers/rtc/rtc-mc13783.c
--- a/drivers/rtc/rtc-mc13783.c~rtc-mc13783-dont-use-deprecated-mc13783=
-api-calls
+++ a/drivers/rtc/rtc-mc13783.c
@@ -101,11 +101,11 @@ static int mc13783_rtc_set_mmss(struct d
 	if (unlikely(ret))
 		goto out;
=20
-	ret =3D mc13783_ackirq(priv->mc13783, MC13783_IRQ_RTCRST);
+	ret =3D mc13783_irq_ack(priv->mc13783, MC13783_IRQ_RTCRST);
 	if (unlikely(ret))
 		goto out;
=20
-	ret =3D mc13783_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
+	ret =3D mc13783_irq_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
 out:
 	priv->valid =3D !ret;
=20
@@ -123,7 +123,7 @@ static irqreturn_t mc13783_rtc_update_ha
=20
 	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
=20
-	mc13783_ackirq(mc13783, irq);
+	mc13783_irq_ack(mc13783, irq);
=20
 	return IRQ_HANDLED;
 }
@@ -138,7 +138,7 @@ static int mc13783_rtc_update_irq_enable
 	if (!priv->valid)
 		goto out;
=20
-	ret =3D (enabled ? mc13783_unmask : mc13783_mask)(priv->mc13783,
+	ret =3D (enabled ? mc13783_irq_unmask : mc13783_irq_mask)(priv->mc137=
83,
 			MC13783_IRQ_1HZ);
 out:
 	mc13783_unlock(priv->mc13783);
@@ -160,7 +160,7 @@ static irqreturn_t mc13783_rtc_reset_han
 	dev_dbg(&priv->rtc->dev, "RTCRST\n");
 	priv->valid =3D 0;
=20
-	mc13783_mask(mc13783, irq);
+	mc13783_irq_mask(mc13783, irq);
=20
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
