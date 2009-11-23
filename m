From: akpm@linux-foundation.org
Subject: + rtc-add-freescale-mc13783-rtc-driver.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:31:44 -0800
Message-ID: <200911232131.nANLViBp002831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZKWVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, valentin.longchamp@epfl.ch


The patch titled
     rtc: add freescale MC13783 RTC driver
has been added to the -mm tree.  Its filename is
     rtc-add-freescale-mc13783-rtc-driver.patch

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
Subject: rtc: add freescale MC13783 RTC driver
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This driver provides support for the RTC part integrated into the
=46reescale MC13783 PMIC and bases on patch created earlier by Sascha
Hauer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    6=20
 drivers/rtc/Makefile      |    1=20
 drivers/rtc/rtc-mc13783.c |  262 ++++++++++++++++++++++++++++++++++++
 3 files changed, 269 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-freescale-mc13783-rtc-driver driv=
ers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-freescale-mc13783-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -846,4 +846,10 @@ config RTC_DRV_PCAP
 	  If you say Y here you will get support for the RTC found on
 	  the PCAP2 ASIC used on some Motorola phones.
=20
+config RTC_DRV_MC13783
+	depends on MFD_MC13783
+	tristate "Freescale MC13783 RTC"
+	help
+	  This enables support for the Freescale MC13783 PMIC RTC
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-add-freescale-mc13783-rtc-driver dri=
vers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-freescale-mc13783-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_RTC_DRV_M48T86)	+=3D rtc-m48t
 obj-$(CONFIG_RTC_MXC)		+=3D rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+=3D rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+=3D rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MC13783)	+=3D rtc-mc13783.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+=3D rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MV)	+=3D rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+=3D rtc-omap.o
diff -puN /dev/null drivers/rtc/rtc-mc13783.c
--- /dev/null
+++ a/drivers/rtc/rtc-mc13783.c
@@ -0,0 +1,262 @@
+/*
+ * Real Time Clock driver for Freescale MC13783 PMIC
+ *
+ * (C) 2009 Sascha Hauer, Pengutronix
+ * (C) 2009 Uwe Kleine-Koenig, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mfd/mc13783.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
+
+#define DRIVER_NAME "mc13783-rtc"
+
+#define MC13783_RTCTOD	20
+#define MC13783_RTCTODA	21
+#define MC13783_RTCDAY	22
+#define MC13783_RTCDAYA	23
+
+struct mc13783_rtc {
+	struct rtc_device *rtc;
+	struct mc13783 *mc13783;
+	int valid;
+};
+
+static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *=
tm)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	unsigned int seconds, days1, days2;
+	unsigned long s1970;
+	int ret;
+
+	mc13783_lock(priv->mc13783);
+
+	if (!priv->valid) {
+		ret =3D -ENODATA;
+		goto out;
+	}
+
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days1);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCTOD, &seconds);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_reg_read(priv->mc13783, MC13783_RTCDAY, &days2);
+out:
+	mc13783_unlock(priv->mc13783);
+
+	if (ret)
+		return ret;
+
+	if (days2 =3D=3D days1 + 1) {
+		if (seconds >=3D 86400 / 2)
+			days2 =3D days1;
+		else
+			days1 =3D days2;
+	}
+
+	if (days1 !=3D days2)
+		return -EIO;
+
+	s1970 =3D days1 * 86400 + seconds;
+
+	rtc_time_to_tm(s1970, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs=
)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	unsigned int seconds, days;
+	int ret;
+
+	seconds =3D secs % 86400;
+	days =3D secs / 86400;
+
+	mc13783_lock(priv->mc13783);
+
+	/*
+	 * first write seconds=3D0 to prevent a day switch between writing da=
ys
+	 * and seconds below
+	 */
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, 0);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCDAY, days);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_reg_write(priv->mc13783, MC13783_RTCTOD, seconds);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_ackirq(priv->mc13783, MC13783_IRQ_RTCRST);
+	if (unlikely(ret))
+		goto out;
+
+	ret =3D mc13783_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
+out:
+	priv->valid =3D !ret;
+
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv =3D dev;
+	struct mc13783 *mc13783 =3D priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "1HZ\n");
+
+	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
+
+	mc13783_ackirq(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int mc13783_rtc_update_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct mc13783_rtc *priv =3D dev_get_drvdata(dev);
+	int ret =3D -ENODATA;
+
+	mc13783_lock(priv->mc13783);
+	if (!priv->valid)
+		goto out;
+
+	ret =3D (enabled ? mc13783_unmask : mc13783_mask)(priv->mc13783,
+			MC13783_IRQ_1HZ);
+out:
+	mc13783_unlock(priv->mc13783);
+
+	return ret;
+}
+
+static const struct rtc_class_ops mc13783_rtc_ops =3D {
+	.read_time =3D mc13783_rtc_read_time,
+	.set_mmss =3D mc13783_rtc_set_mmss,
+	.update_irq_enable =3D mc13783_rtc_update_irq_enable,
+};
+
+static irqreturn_t mc13783_rtc_reset_handler(int irq, void *dev)
+{
+	struct mc13783_rtc *priv =3D dev;
+	struct mc13783 *mc13783 =3D priv->mc13783;
+
+	dev_dbg(&priv->rtc->dev, "RTCRST\n");
+	priv->valid =3D 0;
+
+	mc13783_mask(mc13783, irq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit mc13783_rtc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct mc13783_rtc *priv;
+
+	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 =3D dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, priv);
+
+	priv->valid =3D 1;
+
+	mc13783_lock(priv->mc13783);
+
+	ret =3D mc13783_irq_request(priv->mc13783, MC13783_IRQ_RTCRST,
+			mc13783_rtc_reset_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_reset_irq_request;
+
+	ret =3D mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
+			mc13783_rtc_update_handler, DRIVER_NAME, priv);
+	if (ret)
+		goto err_update_irq_request;
+
+	mc13783_unlock(priv->mc13783);
+
+	priv->rtc =3D rtc_device_register(pdev->name,
+			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(priv->rtc)) {
+		ret =3D PTR_ERR(priv->rtc);
+
+		mc13783_lock(priv->mc13783);
+
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+err_update_irq_request:
+
+		mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+err_reset_irq_request:
+
+		mc13783_unlock(priv->mc13783);
+
+		platform_set_drvdata(pdev, NULL);
+		kfree(priv);
+	}
+
+	return ret;
+}
+
+static int __devexit mc13783_rtc_remove(struct platform_device *pdev)
+{
+	struct mc13783_rtc *priv =3D platform_get_drvdata(pdev);
+
+	rtc_device_unregister(priv->rtc);
+
+	mc13783_lock(priv->mc13783);
+
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_1HZ, priv);
+	mc13783_irq_free(priv->mc13783, MC13783_IRQ_RTCRST, priv);
+
+	mc13783_unlock(priv->mc13783);
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_rtc_driver =3D {
+	.remove =3D __devexit_p(mc13783_rtc_remove),
+	.driver =3D {
+		.name =3D DRIVER_NAME,
+		.owner =3D THIS_MODULE,
+	},
+};
+
+static int __init mc13783_rtc_init(void)
+{
+	return platform_driver_probe(&mc13783_rtc_driver, &mc13783_rtc_probe)=
;
+}
+module_init(mc13783_rtc_init);
+
+static void __exit mc13783_rtc_exit(void)
+{
+	platform_driver_unregister(&mc13783_rtc_driver);
+}
+module_exit(mc13783_rtc_exit);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("RTC driver for Freescale MC13783 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
