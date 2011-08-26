From: akpm@linux-foundation.org
Subject: + input-mc13783-ts-convert-to-mc13xxx-api.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:15:12 -0700
Message-ID: <201108260015.p7Q0FCwt021985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1HZAPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david@protonic.nl, dmitry.torokhov@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, rpurdie@rpsys.net, s.hauer@pengutronix.de, sameo@linux.intel.com


The patch titled
     input/mc13783-ts: convert to mc13xxx API
has been added to the -mm tree.  Its filename is
     input-mc13783-ts-convert-to-mc13xxx-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input/mc13783-ts: convert to mc13xxx API
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This is the first step to also support the touch interface of the mc138=
92
pmic chip.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Jander <david@protonic.nl>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mc13783_ts.c |   34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/input/touchscreen/mc13783_ts.c~input-mc13783-ts-conve=
rt-to-mc13xxx-api drivers/input/touchscreen/mc13783_ts.c
--- a/drivers/input/touchscreen/mc13783_ts.c~input-mc13783-ts-convert-t=
o-mc13xxx-api
+++ a/drivers/input/touchscreen/mc13783_ts.c
@@ -35,7 +35,7 @@ MODULE_PARM_DESC(sample_tolerance,
=20
 struct mc13783_ts_priv {
 	struct input_dev *idev;
-	struct mc13783 *mc13783;
+	struct mc13xxx *mc13xxx;
 	struct delayed_work work;
 	struct workqueue_struct *workq;
 	unsigned int sample[4];
@@ -45,7 +45,7 @@ static irqreturn_t mc13783_ts_handler(in
 {
 	struct mc13783_ts_priv *priv =3D data;
=20
-	mc13783_irq_ack(priv->mc13783, irq);
+	mc13xxx_irq_ack(priv->mc13xxx, irq);
=20
 	/*
 	 * Kick off reading coordinates. Note that if work happens already
@@ -121,10 +121,10 @@ static void mc13783_ts_work(struct work_
 {
 	struct mc13783_ts_priv *priv =3D
 		container_of(work, struct mc13783_ts_priv, work.work);
-	unsigned int mode =3D MC13783_ADC_MODE_TS;
+	unsigned int mode =3D MC13XXX_ADC_MODE_TS;
 	unsigned int channel =3D 12;
=20
-	if (mc13783_adc_do_conversion(priv->mc13783,
+	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
 				mode, channel, priv->sample) =3D=3D 0)
 		mc13783_ts_report_sample(priv);
 }
@@ -134,21 +134,21 @@ static int mc13783_ts_open(struct input_
 	struct mc13783_ts_priv *priv =3D input_get_drvdata(dev);
 	int ret;
=20
-	mc13783_lock(priv->mc13783);
+	mc13xxx_lock(priv->mc13xxx);
=20
-	mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TS);
+	mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TS);
=20
-	ret =3D mc13783_irq_request(priv->mc13783, MC13783_IRQ_TS,
+	ret =3D mc13xxx_irq_request(priv->mc13xxx, MC13XXX_IRQ_TS,
 		mc13783_ts_handler, MC13783_TS_NAME, priv);
 	if (ret)
 		goto out;
=20
-	ret =3D mc13783_reg_rmw(priv->mc13783, MC13783_ADC0,
-			MC13783_ADC0_TSMOD_MASK, MC13783_ADC0_TSMOD0);
+	ret =3D mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
+			MC13XXX_ADC0_TSMOD_MASK, MC13XXX_ADC0_TSMOD0);
 	if (ret)
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
+		mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
 out:
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_unlock(priv->mc13xxx);
 	return ret;
 }
=20
@@ -156,11 +156,11 @@ static void mc13783_ts_close(struct inpu
 {
 	struct mc13783_ts_priv *priv =3D input_get_drvdata(dev);
=20
-	mc13783_lock(priv->mc13783);
-	mc13783_reg_rmw(priv->mc13783, MC13783_ADC0,
-			MC13783_ADC0_TSMOD_MASK, 0);
-	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TS, priv);
-	mc13783_unlock(priv->mc13783);
+	mc13xxx_lock(priv->mc13xxx);
+	mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
+			MC13XXX_ADC0_TSMOD_MASK, 0);
+	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
+	mc13xxx_unlock(priv->mc13xxx);
=20
 	cancel_delayed_work_sync(&priv->work);
 }
@@ -177,7 +177,7 @@ static int __init mc13783_ts_probe(struc
 		goto err_free_mem;
=20
 	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
-	priv->mc13783 =3D dev_get_drvdata(pdev->dev.parent);
+	priv->mc13xxx =3D dev_get_drvdata(pdev->dev.parent);
 	priv->idev =3D idev;
=20
 	/*
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
led-mc13783-convert-to-mc13xxx-mfd.patch
mfd-mc13xxx-provide-a-generic-version-of-adc_do_conversion.patch
input-mc13783-ts-convert-to-mc13xxx-api.patch
arm-imx-use-mc13xxx-constants-instead-of-mc13783.patch
hwmon-mc13783-adc-convert-to-mc13xxx-api.patch
mfd-mc13xxx-remove-mc13783-api-functions-and-symbols.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
