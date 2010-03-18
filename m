From: akpm@linux-foundation.org
Subject: + rtc-mc13783-fix-use-after-free-bug.patch added to -mm tree
Date: Thu, 18 Mar 2010 12:02:20 -0700
Message-ID: <201003181902.o2IJ2KYf010047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab0CRTCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, error27@gmail.com


The patch titled
     rtc/mc13783: fix use after free bug
has been added to the -mm tree.  Its filename is
     rtc-mc13783-fix-use-after-free-bug.patch

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
Subject: rtc/mc13783: fix use after free bug
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This was introduced by v2.6.34-rc1~38:

	4c014e8 (rtc/mc13783: protect rtc {,un}registration by mc13783 lock)

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13783.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-mc13783.c~rtc-mc13783-fix-use-after-free-bug =
drivers/rtc/rtc-mc13783.c
--- a/drivers/rtc/rtc-mc13783.c~rtc-mc13783-fix-use-after-free-bug
+++ a/drivers/rtc/rtc-mc13783.c
@@ -319,35 +319,38 @@ static int __devinit mc13783_rtc_probe(s
 {
 	int ret;
 	struct mc13783_rtc *priv;
+	struct mc13783 *mc13783;
 	int rtcrst_pending;
=20
 	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
=20
-	priv->mc13783 =3D dev_get_drvdata(pdev->dev.parent);
+	mc13783 =3D dev_get_drvdata(pdev->dev.parent);
+	priv->mc13783 =3D mc13783;
+
 	platform_set_drvdata(pdev, priv);
=20
-	mc13783_lock(priv->mc13783);
+	mc13783_lock(mc13783);
=20
-	ret =3D mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
+	ret =3D mc13783_irq_request(mc13783, MC13783_IRQ_RTCRST,
 			mc13783_rtc_reset_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_reset_irq_request;
=20
-	ret =3D mc13783_irq_status(priv->mc13783, MC13783_IRQ_RTCRST,
+	ret =3D mc13783_irq_status(mc13783, MC13783_IRQ_RTCRST,
 			NULL, &rtcrst_pending);
 	if (ret)
 		goto err_reset_irq_status;
=20
 	priv->valid =3D !rtcrst_pending;
=20
-	ret =3D mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
+	ret =3D mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_1HZ,
 			mc13783_rtc_update_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_update_irq_request;
=20
-	ret =3D mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_TODA,
+	ret =3D mc13783_irq_request_nounmask(mc13783, MC13783_IRQ_TODA,
 			mc13783_rtc_alarm_handler, DRIVER_NAME, priv);
 	if (ret)
 		goto err_alarm_irq_request;
@@ -357,22 +360,22 @@ static int __devinit mc13783_rtc_probe(s
 	if (IS_ERR(priv->rtc)) {
 		ret =3D PTR_ERR(priv->rtc);
=20
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_TODA, priv);
 err_alarm_irq_request:
=20
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
=20
 err_reset_irq_status:
=20
-		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+		mc13783_irq_free(mc13783, MC13783_IRQ_RTCRST, priv);
 err_reset_irq_request:
=20
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
=20
-	mc13783_unlock(priv->mc13783);
+	mc13783_unlock(mc13783);
=20
 	return ret;
 }
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
