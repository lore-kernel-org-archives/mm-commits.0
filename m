From: akpm@linux-foundation.org
Subject: [merged] rtc-fix-driver-data-issues-in-several-rtc-drivers.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:11 -0800
Message-ID: <200912162034.nBGKYBfq013011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763212AbZLPUeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.zummo@towertech.it, a.zummo@towertech.it, ab@mycable.de, andy.sharp@onstor.com, anemo@mba.ocn.ne.jp, davem@davemloft.net, hcegtvedt@atmel.com, lethal@linux-sh.org, rongkai.


The patch titled
     rtc: fix driver data issues in several rtc drivers
has been removed from the -mm tree.  Its filename was
     rtc-fix-driver-data-issues-in-several-rtc-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix driver data issues in several rtc drivers
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Herton Ronaldo Krzesinski recently raised up, and fixed, an issue with the
rtc_cmos driver, which was referring to an inconsistent driver data.

This patch ensures that driver data registration happens before
rtc_device_register().

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Thomas Hommel <thomas.hommel@gefanuc.com>
Acked-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Andrew Sharp <andy.sharp@onstor.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    4 +++-
 drivers/rtc/rtc-bq4802.c     |    3 ++-
 drivers/rtc/rtc-ds1302.c     |    1 -
 drivers/rtc/rtc-ds1305.c     |   14 ++++++--------
 drivers/rtc/rtc-m48t35.c     |   16 ++++++++--------
 drivers/rtc/rtc-m48t59.c     |   11 ++++++-----
 drivers/rtc/rtc-pcf8563.c    |    4 ++--
 drivers/rtc/rtc-pcf8583.c    |    3 ++-
 drivers/rtc/rtc-stk17ta8.c   |   20 ++++++++++----------
 drivers/rtc/rtc-v3020.c      |    8 +++-----
 10 files changed, 42 insertions(+), 42 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -256,6 +256,8 @@ static int __init at32_rtc_probe(struct 
 		goto out_iounmap;
 	}
 
+	platform_set_drvdata(pdev, rtc);
+
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at32_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
@@ -264,7 +266,6 @@ static int __init at32_rtc_probe(struct 
 		goto out_free_irq;
 	}
 
-	platform_set_drvdata(pdev, rtc);
 	device_init_wakeup(&pdev->dev, 1);
 
 	dev_info(&pdev->dev, "Atmel RTC for AT32AP700x at %08lx irq %ld\n",
@@ -273,6 +274,7 @@ static int __init at32_rtc_probe(struct 
 	return 0;
 
 out_free_irq:
+	platform_set_drvdata(pdev, NULL);
 	free_irq(irq, rtc);
 out_iounmap:
 	iounmap(rtc->regs);
diff -puN drivers/rtc/rtc-bq4802.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-bq4802.c
--- a/drivers/rtc/rtc-bq4802.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-bq4802.c
@@ -169,6 +169,8 @@ static int __devinit bq4802_probe(struct
 		goto out_free;
 	}
 
+	platform_set_drvdata(pdev, p);
+
 	p->rtc = rtc_device_register("bq4802", &pdev->dev,
 				     &bq4802_ops, THIS_MODULE);
 	if (IS_ERR(p->rtc)) {
@@ -176,7 +178,6 @@ static int __devinit bq4802_probe(struct
 		goto out_iounmap;
 	}
 
-	platform_set_drvdata(pdev, p);
 	err = 0;
 out:
 	return err;
diff -puN drivers/rtc/rtc-ds1302.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-ds1302.c
@@ -143,7 +143,6 @@ static int ds1302_rtc_ioctl(struct devic
 #ifdef RTC_SET_CHARGE
 	case RTC_SET_CHARGE:
 	{
-		struct ds1302_rtc *rtc = dev_get_drvdata(dev);
 		int tcs_val;
 
 		if (copy_from_user(&tcs_val, (int __user *)arg, sizeof(int)))
diff -puN drivers/rtc/rtc-ds1305.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-ds1305.c
@@ -617,7 +617,6 @@ static struct bin_attribute nvram = {
 static int __devinit ds1305_probe(struct spi_device *spi)
 {
 	struct ds1305			*ds1305;
-	struct rtc_device		*rtc;
 	int				status;
 	u8				addr, value;
 	struct ds1305_platform_data	*pdata = spi->dev.platform_data;
@@ -756,14 +755,13 @@ static int __devinit ds1305_probe(struct
 		dev_dbg(&spi->dev, "AM/PM\n");
 
 	/* register RTC ... from here on, ds1305->ctrl needs locking */
-	rtc = rtc_device_register("ds1305", &spi->dev,
+	ds1305->rtc = rtc_device_register("ds1305", &spi->dev,
 			&ds1305_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		status = PTR_ERR(rtc);
+	if (IS_ERR(ds1305->rtc)) {
+		status = PTR_ERR(ds1305->rtc);
 		dev_dbg(&spi->dev, "register rtc --> %d\n", status);
 		goto fail0;
 	}
-	ds1305->rtc = rtc;
 
 	/* Maybe set up alarm IRQ; be ready to handle it triggering right
 	 * away.  NOTE that we don't share this.  The signal is active low,
@@ -774,7 +772,7 @@ static int __devinit ds1305_probe(struct
 	if (spi->irq) {
 		INIT_WORK(&ds1305->work, ds1305_work);
 		status = request_irq(spi->irq, ds1305_irq,
-				0, dev_name(&rtc->dev), ds1305);
+				0, dev_name(&ds1305->rtc->dev), ds1305);
 		if (status < 0) {
 			dev_dbg(&spi->dev, "request_irq %d --> %d\n",
 					spi->irq, status);
@@ -794,7 +792,7 @@ static int __devinit ds1305_probe(struct
 fail2:
 	free_irq(spi->irq, ds1305);
 fail1:
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(ds1305->rtc);
 fail0:
 	kfree(ds1305);
 	return status;
@@ -802,7 +800,7 @@ fail0:
 
 static int __devexit ds1305_remove(struct spi_device *spi)
 {
-	struct ds1305	*ds1305 = spi_get_drvdata(spi);
+	struct ds1305 *ds1305 = spi_get_drvdata(spi);
 
 	sysfs_remove_bin_file(&spi->dev.kobj, &nvram);
 
diff -puN drivers/rtc/rtc-m48t35.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-m48t35.c
@@ -142,7 +142,6 @@ static const struct rtc_class_ops m48t35
 
 static int __devinit m48t35_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
 	struct resource *res;
 	struct m48t35_priv *priv;
 	int ret = 0;
@@ -171,20 +170,21 @@ static int __devinit m48t35_probe(struct
 		ret = -ENOMEM;
 		goto out;
 	}
+
 	spin_lock_init(&priv->lock);
-	rtc = rtc_device_register("m48t35", &pdev->dev,
+
+	platform_set_drvdata(pdev, priv);
+
+	priv->rtc = rtc_device_register("m48t35", &pdev->dev,
 				  &m48t35_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
+	if (IS_ERR(priv->rtc)) {
+		ret = PTR_ERR(priv->rtc);
 		goto out;
 	}
-	priv->rtc = rtc;
-	platform_set_drvdata(pdev, priv);
+
 	return 0;
 
 out:
-	if (priv->rtc)
-		rtc_device_unregister(priv->rtc);
 	if (priv->reg)
 		iounmap(priv->reg);
 	if (priv->baseaddr)
diff -puN drivers/rtc/rtc-m48t59.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-m48t59.c
@@ -481,6 +481,9 @@ static int __devinit m48t59_rtc_probe(st
 		goto out;
 	}
 
+	spin_lock_init(&m48t59->lock);
+	platform_set_drvdata(pdev, m48t59);
+
 	m48t59->rtc = rtc_device_register(name, &pdev->dev, ops, THIS_MODULE);
 	if (IS_ERR(m48t59->rtc)) {
 		ret = PTR_ERR(m48t59->rtc);
@@ -490,16 +493,14 @@ static int __devinit m48t59_rtc_probe(st
 	m48t59_nvram_attr.size = pdata->offset;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (ret)
+	if (ret) {
+		rtc_device_unregister(m48t59->rtc);
 		goto out;
+	}
 
-	spin_lock_init(&m48t59->lock);
-	platform_set_drvdata(pdev, m48t59);
 	return 0;
 
 out:
-	if (!IS_ERR(m48t59->rtc))
-		rtc_device_unregister(m48t59->rtc);
 	if (m48t59->irq != NO_IRQ)
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
diff -puN drivers/rtc/rtc-pcf8563.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -212,6 +212,8 @@ static int pcf8563_probe(struct i2c_clie
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
+	i2c_set_clientdata(client, pcf8563);
+
 	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name,
 				&client->dev, &pcf8563_rtc_ops, THIS_MODULE);
 
@@ -220,8 +222,6 @@ static int pcf8563_probe(struct i2c_clie
 		goto exit_kfree;
 	}
 
-	i2c_set_clientdata(client, pcf8563);
-
 	return 0;
 
 exit_kfree:
diff -puN drivers/rtc/rtc-pcf8583.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -277,6 +277,8 @@ static int pcf8583_probe(struct i2c_clie
 	if (!pcf8583)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, pcf8583);
+
 	pcf8583->rtc = rtc_device_register(pcf8583_driver.driver.name,
 			&client->dev, &pcf8583_rtc_ops, THIS_MODULE);
 
@@ -285,7 +287,6 @@ static int pcf8583_probe(struct i2c_clie
 		goto exit_kfree;
 	}
 
-	i2c_set_clientdata(client, pcf8583);
 	return 0;
 
 exit_kfree:
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -288,7 +288,6 @@ static struct bin_attribute stk17ta8_nvr
 
 static int __devinit stk17ta8_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
 	struct resource *res;
 	unsigned int cal;
 	unsigned int flags;
@@ -338,22 +337,23 @@ static int __devinit stk17ta8_rtc_probe(
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	pdata->last_jiffies = jiffies;
+	platform_set_drvdata(pdev, pdata);
+
+	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &stk17ta8_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
+	if (IS_ERR(pdata->rtc)) {
+		ret = PTR_ERR(pdata->rtc);
 		goto out;
 	}
-	pdata->rtc = rtc;
-	pdata->last_jiffies = jiffies;
-	platform_set_drvdata(pdev, pdata);
+
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &stk17ta8_nvram_attr);
-	if (ret)
+	if (ret) {
+		rtc_device_unregister(pdata->rtc);
 		goto out;
+	}
 	return 0;
  out:
-	if (pdata->rtc)
-		rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		free_irq(pdata->irq, pdev);
 	if (ioaddr)
diff -puN drivers/rtc/rtc-v3020.c~rtc-fix-driver-data-issues-in-several-rtc-drivers drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-fix-driver-data-issues-in-several-rtc-drivers
+++ a/drivers/rtc/rtc-v3020.c
@@ -304,7 +304,6 @@ static int rtc_probe(struct platform_dev
 {
 	struct v3020_platform_data *pdata = pdev->dev.platform_data;
 	struct v3020 *chip;
-	struct rtc_device *rtc;
 	int retval = -EBUSY;
 	int i;
 	int temp;
@@ -353,13 +352,12 @@ static int rtc_probe(struct platform_dev
 
 	platform_set_drvdata(pdev, chip);
 
-	rtc = rtc_device_register("v3020",
+	chip->rtc = rtc_device_register("v3020",
 				&pdev->dev, &v3020_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		retval = PTR_ERR(rtc);
+	if (IS_ERR(chip->rtc)) {
+		retval = PTR_ERR(chip->rtc);
 		goto err_io;
 	}
-	chip->rtc = rtc;
 
 	return 0;
 
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch

