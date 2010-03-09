From: akpm@linux-foundation.org
Subject: [merged] input-mc13783-ts-dont-use-deprecated-mc13783-api-calls.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:42 -0800
Message-ID: <201003091910.o29JAgna031608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab0CITWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dtor@mail.ru, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.longchamp@epfl.c


The patch titled
     input/mc13783-ts: don't use deprecated mc13783 API calls
has been removed from the -mm tree.  Its filename was
     input-mc13783-ts-dont-use-deprecated-mc13783-api-calls.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input/mc13783-ts: don't use deprecated mc13783 API calls
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

mc13783_ackirq is deprecated, use the drop in replacement mc13783_irq_a=
ck.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mc13783_ts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/mc13783_ts.c~input-mc13783-ts-dont-=
use-deprecated-mc13783-api-calls drivers/input/touchscreen/mc13783_ts.c
--- a/drivers/input/touchscreen/mc13783_ts.c~input-mc13783-ts-dont-use-=
deprecated-mc13783-api-calls
+++ a/drivers/input/touchscreen/mc13783_ts.c
@@ -44,7 +44,7 @@ static irqreturn_t mc13783_ts_handler(in
 {
 	struct mc13783_ts_priv *priv =3D data;
=20
-	mc13783_ackirq(priv->mc13783, irq);
+	mc13783_irq_ack(priv->mc13783, irq);
=20
 	/*
 	 * Kick off reading coordinates. Note that if work happens already
@@ -135,7 +135,7 @@ static int mc13783_ts_open(struct input_
=20
 	mc13783_lock(priv->mc13783);
=20
-	mc13783_ackirq(priv->mc13783, MC13783_IRQ_TS);
+	mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TS);
=20
 	ret =3D mc13783_irq_request(priv->mc13783, MC13783_IRQ_TS,
 		mc13783_ts_handler, MC13783_TS_NAME, priv);
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
