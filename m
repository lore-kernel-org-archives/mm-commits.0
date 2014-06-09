From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-ds1343c-fix-potential-race-condition.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:57 -0700
Message-ID: <53960b35.X8iz76YHSynA+QRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFIT35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, ravi23ganiga@gmail.com

Subject: [merged] drivers-rtc-rtc-ds1343c-fix-potential-race-condition.patch removed from -mm tree
To: ravi23ganiga@gmail.com,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:57 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1343.c: fix potential race condition
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1343c-fix-potential-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: drivers/rtc/rtc-ds1343.c: fix potential race condition

Avoid the potential race condition by avoiding bailing out of driver in
probe after registering with rtc subsystem

Also the set_alarm , read_alarm and alarm_irq_enable returns error if irq
registration fails in probe.

Also the sysfs will not create entry for alarm if irq registration fails
in probe.

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1343.c |   38 +++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-ds1343.c~drivers-rtc-rtc-ds1343c-fix-potential-race-condition drivers/rtc/rtc-ds1343.c
--- a/drivers/rtc/rtc-ds1343.c~drivers-rtc-rtc-ds1343c-fix-potential-race-condition
+++ a/drivers/rtc/rtc-ds1343.c
@@ -80,6 +80,7 @@ struct ds1343_priv {
 	struct regmap *map;
 	struct mutex mutex;
 	unsigned int irqen;
+	int irq;
 	int alarm_sec;
 	int alarm_min;
 	int alarm_hour;
@@ -262,28 +263,32 @@ static DEVICE_ATTR(trickle_charger, S_IR
 
 static int ds1343_sysfs_register(struct device *dev)
 {
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
 	int err;
 
 	err = device_create_file(dev, &dev_attr_glitch_filter);
 	if (err)
 		return err;
 
-	err = device_create_file(dev, &dev_attr_alarm_status);
+	err = device_create_file(dev, &dev_attr_trickle_charger);
 	if (err)
 		goto error1;
 
+	if (priv->irq <= 0)
+		return err;
+
 	err = device_create_file(dev, &dev_attr_alarm_mode);
 	if (err)
 		goto error2;
 
-	err = device_create_file(dev, &dev_attr_trickle_charger);
+	err = device_create_file(dev, &dev_attr_alarm_status);
 	if (!err)
 		return err;
 
 	device_remove_file(dev, &dev_attr_alarm_mode);
 
 error2:
-	device_remove_file(dev, &dev_attr_alarm_status);
+	device_remove_file(dev, &dev_attr_trickle_charger);
 
 error1:
 	device_remove_file(dev, &dev_attr_glitch_filter);
@@ -293,10 +298,16 @@ error1:
 
 static void ds1343_sysfs_unregister(struct device *dev)
 {
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
 	device_remove_file(dev, &dev_attr_glitch_filter);
+	device_remove_file(dev, &dev_attr_trickle_charger);
+
+	if (priv->irq <= 0)
+		return;
+
 	device_remove_file(dev, &dev_attr_alarm_status);
 	device_remove_file(dev, &dev_attr_alarm_mode);
-	device_remove_file(dev, &dev_attr_trickle_charger);
 }
 
 static int ds1343_read_time(struct device *dev, struct rtc_time *dt)
@@ -415,11 +426,10 @@ static int ds1343_update_alarm(struct de
 static int ds1343_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 	unsigned int stat;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -450,10 +460,9 @@ out:
 static int ds1343_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -476,10 +485,9 @@ static int ds1343_set_alarm(struct devic
 static int ds1343_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct ds1343_priv *priv = dev_get_drvdata(dev);
-	struct spi_device *spi = priv->spi;
 	int res = 0;
 
-	if (spi->irq <= 0)
+	if (priv->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
@@ -593,18 +601,20 @@ static int ds1343_probe(struct spi_devic
 		return PTR_ERR(priv->rtc);
 	}
 
-	if (spi->irq >= 0) {
+	priv->irq = spi->irq;
+
+	if (priv->irq >= 0) {
 		res = devm_request_threaded_irq(&spi->dev, spi->irq, NULL,
 						ds1343_thread,
 						IRQF_NO_SUSPEND | IRQF_ONESHOT,
 						"ds1343", priv);
 		if (res) {
+			priv->irq = -1;
 			dev_err(&spi->dev,
 				"unable to request irq for rtc ds1343\n");
-			return res;
+		} else {
+			device_set_wakeup_capable(&spi->dev, 1);
 		}
