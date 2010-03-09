From: akpm@linux-foundation.org
Subject: [merged] rtc-mc13783-implement-alarm.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:58 -0800
Message-ID: <201003091910.o29JAwKa031630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011Ab0CITWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dmitry.torokhov@gmail.com, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.lo


The patch titled
     rtc/mc13783: implement alarm
has been removed from the -mm tree.  Its filename was
     rtc-mc13783-implement-alarm.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc/mc13783: implement alarm
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

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

 drivers/rtc/rtc-mc13783.c |  185 +++++++++++++++++++++++++++++++++---
 1 file changed, 172 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-mc13783.c~rtc-mc13783-implement-alarm drivers=
/rtc/rtc-mc13783.c
--- a/drivers/rtc/rtc-mc13783.c~rtc-mc13783-implement-alarm
+++ a/drivers/rtc/rtc-mc13783.c
@@ -28,6 +28,34 @@ struct mc13783_rtc {
 	int valid;
 };
=20
+static int mc13783_rtc_irq_enable_unlocked(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	int (*func)(struct mc13783 *mc13783, int irq);
+
+	if (!priv->valid)
+		return -ENODATA;
+
+	func =3D enabled ? mc13783_irq_unmask : mc13783_irq_mask;
+	return func(priv->mc13783, irq);
+}
+
+static int mc13783_rtc_irq_enable(struct device *dev,
+		unsigned int enabled, int irq)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	ret =3D mc13783_rtc_irq_enable_unlocked(dev, enabled, irq);
+
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
 static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *=
tm)
 {
 	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
@@ -78,6 +106,7 @@ static int mc13783_rtc_set_mmss(struct d
 {
 	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
 	unsigned int seconds, days;
+	unsigned int alarmseconds;
 	int ret;
=20
 	seconds =3D secs % 86400;
@@ -86,7 +115,22 @@ static int mc13783_rtc_set_mmss(struct d
 	mc13783_lock(priv->mc13783);
=20
 	/*
-	 * first write seconds=3D0 to prevent a day switch between writing da=
ys
+	 * temporarily invalidate alarm to prevent triggering it when the day=
 is
+	 * already updated while the time isn't yet.
+	 */
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &alarmsecond=
s);
+	if (unlikely(ret))
+		goto out;
+
+	if (alarmseconds < 86400) {
+		ret =3D mc13783_reg_write(priv->mc13783,
+				MC13783_RTCTODA, 0x1ffff);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	/*
+	 * write seconds=3D0 to prevent a day switch between writing days
 	 * and seconds below
 	 */
 	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, 0);
@@ -101,6 +145,14 @@ static int mc13783_rtc_set_mmss(struct d
 	if (unlikely(ret))
 		goto out;
=20
+	/* restore alarm */
+	if (alarmseconds < 86400) {
+		ret =3D mc13783_reg_write(priv->mc13783,
+				MC13783_RTCTODA, alarmseconds);
+		if (unlikely(ret))
+			goto out;
+	}
+
 	ret =3D mc13783_irq_ack(priv->mc13783, MC13783_IRQ_RTCRST);
 	if (unlikely(ret))
 		goto out;
@@ -114,6 +166,107 @@ out:
 	return ret;
 }
=20
+static int mc13783_rtc_read_alarm(struct device *dev, struct rtc_wkalr=
m *alarm)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	unsigned seconds, days;
+	unsigned long s1970;
+	int enabled, pending;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCTODA, &seconds);
+	if (unlikely(ret))
+		goto out;
+	if (seconds >=3D 86400) {
+		ret =3D -ENODATA;
+		goto out;
+	}
+
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_irq_status(priv->mc13783, MC13783_IRQ_TODA,
+			&enabled, &pending);
+
+out:
+	mc13783_unlock(priv->mc13783);
+
+	if (ret)
+		return ret;
+
+	alarm->enabled =3D enabled;
+	alarm->pending =3D pending;
+
+	s1970 =3D days * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, &alarm->time);
+	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
+
+	return 0;
+}
+
+static int mc13783_rtc_set_alarm(struct device *dev, struct rtc_wkalrm=
 *alarm)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	unsigned long s1970;
+	unsigned seconds, days;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	/* disable alarm to prevent false triggering */
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, 0x1ffff);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D rtc_tm_to_time(&alarm->time, &s1970);
+	if (unlikely(ret))
+		goto out;
+
+	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff"=
,
+			s1970);
+
+	ret =3D mc13783_rtc_irq_enable_unlocked(dev, alarm->enabled,
+			MC13783_IRQ_TODA);
+	if (unlikely(ret))
+		goto out;
+
+	seconds =3D s1970 % 86400;
+	days =3D s1970 / 86400;
+
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCDAYA, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCTODA, seconds);
+
+out:
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static irqreturn_t mc13783_rtc_alarm_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv =3D dev;
+	struct mc13783 *mc13783 =3D priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "Alarm\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_AF);
+
+	mc13783_irq_ack(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
 {
 	struct mc13783_rtc *priv =3D dev;
@@ -131,24 +284,21 @@ static irqreturn_t mc13783_rtc_update_ha
 static int mc13783_rtc_update_irq_enable(struct device *dev,
 		unsigned int enabled)
 {
-	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
-	int ret =3D -ENODATA;
-
-	mc13783_lock(priv->mc13783);
-	if (!priv->valid)
-		goto out;
-
-	ret =3D (enabled ? mc13783_irq_unmask : mc13783_irq_mask)(priv->mc137=
83,
-			MC13783_IRQ_1HZ);
-out:
-	mc13783_unlock(priv->mc13783);
+	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_1HZ);
+}
=20
-	return ret;
+static int mc13783_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	return mc13783_rtc_irq_enable(dev, enabled, MC13783_IRQ_TODA);
 }
=20
 static const struct rtc_class_ops mc13783_rtc_ops =3D {
 	.read_time =3D mc13783_rtc_read_time,
 	.set_mmss =3D mc13783_rtc_set_mmss,
+	.read_alarm =3D mc13783_rtc_read_alarm,
+	.set_alarm =3D mc13783_rtc_set_alarm,
+	.alarm_irq_enable =3D mc13783_rtc_alarm_irq_enable,
 	.update_irq_enable =3D mc13783_rtc_update_irq_enable,
 };
=20
@@ -197,11 +347,19 @@ static int __devinit mc13783_rtc_probe(s
 	if (ret)
 		goto err_update_irq_request;
=20
+	ret =3D mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_TODA,
+			mc13783_rtc_alarm_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_alarm_irq_request;
+
 	priv->rtc =3D rtc_device_register(pdev->name,
 			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret =3D PTR_ERR(priv->rtc);
=20
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
+err_alarm_irq_request:
+
 		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 err_update_irq_request:
=20
@@ -227,6 +385,7 @@ static int __devexit mc13783_rtc_remove(
=20
 	rtc_device_unregister(priv->rtc);
=20
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_TODA, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
 	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
=20
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
