From: akpm@linux-foundation.org
Subject: + rtc-mc13783-protect-rtc-unregistration-by-mc13783-lock.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:58:14 -0800
Message-ID: <201003022358.o22NwEhx005577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab0CCAH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dmitry.torokhov@gmail.com, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.longchamp@epfl.ch


The patch titled
     rtc/mc13783: protect rtc {,un}registration by mc13783 lock
has been added to the -mm tree.  Its filename is
     rtc-mc13783-protect-rtc-unregistration-by-mc13783-lock.patch

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
Subject: rtc/mc13783: protect rtc {,un}registration by mc13783 lock
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This is to protect from interrupt handlers using an unregistered rtc
device.

To assert that the reset irq is considered now before the rtc is
registered the corresponding status is checked before.

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

 drivers/rtc/rtc-mc13783.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-mc13783.c~rtc-mc13783-protect-rtc-unregistrat=
ion-by-mc13783-lock drivers/rtc/rtc-mc13783.c
--- a/drivers/rtc/rtc-mc13783.c~rtc-mc13783-protect-rtc-unregistration-=
by-mc13783-lock
+++ a/drivers/rtc/rtc-mc13783.c
@@ -169,6 +169,7 @@ static int __devinit mc13783_rtc_probe(s
 {
 	int ret;
 	struct mc13783_rtc *priv;
+	int rtcrst_pending;
=20
 	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -177,8 +178,6 @@ static int __devinit mc13783_rtc_probe(s
 	priv->mc13783 =3D dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, priv);
=20
-	priv->valid =3D 1;
-
 	mc13783_lock(priv->mc13783);
=20
 	ret =3D mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
@@ -186,33 +185,37 @@ static int __devinit mc13783_rtc_probe(s
 	if (ret)
 		goto err_reset_irq_request;
=20
+	ret =3D mc13783_irq_status(priv->mc13783, MC13783_IRQ_RTCRST,
+			NULL, &rtcrst_pending);
+	if (ret)
+		goto err_reset_irq_status;
+
+	priv->valid =3D !rtcrst_pending;
+
 	ret =3D mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
 			mc13783_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_update_irq_request;
=20
-	mc13783_unlock(priv->mc13783);
-
 	priv->rtc =3D rtc_device_register(pdev->name,
 			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
-
 	if (IS_ERR(priv->rtc)) {
 		ret =3D PTR_ERR(priv->rtc);
=20
-		mc13783_lock(priv->mc13783);
-
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
=20
+err_reset_irq_status:
+
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
 err_reset_irq_request:
=20
-		mc13783_unlock(priv->mc13783);
-
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
=20
+	mc13783_unlock(priv->mc13783);
+
 	return ret;
 }
=20
@@ -220,10 +223,10 @@ static int __devexit mc13783_rtc_remove(
 {
 	struct mc13783_rtc *priv =3D platform_get_drvdata(pdev);
=20
-	rtc_device_unregister(priv->rtc);
-
 	mc13783_lock(priv->mc13783);
=20
+	rtc_device_unregister(priv->rtc);
+
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
mc13783-rename-mc13783_unmaskack_irq-to-have-a-mc13783_irq-prefix.patch
input-mc13783-ts-dont-use-deprecated-mc13783-api-calls.patch
rtc-mc13783-dont-use-deprecated-mc13783-api-calls.patch
mfd-mc13783-new-function-reading-irq-mask-and-status-register.patch
rtc-mc13783-protect-rtc-unregistration-by-mc13783-lock.patch
rtc-mc13783-implement-alarm.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
