From: akpm@linux-foundation.org
Subject: [failures]
 drivers-rtc-rtc-ds3232c-enable-ds3232-to-work-as-wakeup-source.patch
 removed from -mm tree
Date: Tue, 25 Feb 2014 14:07:15 -0800
Message-ID: <530d1413.pLI2gF+1l0Ae32ze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaBYWHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 17:07:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, chenhui.zhao@freescale.com, dongsheng.wang@freescale.com

Subject: [failures] drivers-rtc-rtc-ds3232c-enable-ds3232-to-work-as-wakeup-source.patch removed from -mm tree
To: dongsheng.wang@freescale.com,chenhui.zhao@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 14:07:15 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds3232.c: enable ds3232 to work as wakeup source
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds3232c-enable-ds3232-to-work-as-wakeup-source.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Dongsheng <dongsheng.wang@freescale.com>
Subject: drivers/rtc/rtc-ds3232.c: enable ds3232 to work as wakeup source

Add suspend/resume and device_init_wakeup to enable ds3232 as wakeup
source, /sys/class/rtc/rtcX/wakealarm for set wakeup alarm.

Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3232.c |   90 +++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-enable-ds3232-to-work-as-wakeup-source drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-enable-ds3232-to-work-as-wakeup-source
+++ a/drivers/rtc/rtc-ds3232.c
@@ -57,6 +57,7 @@ struct ds3232 {
 	 * in the remove function.
 	 */
 	struct mutex mutex;
+	bool suspended;
 	int exiting;
 };
 
@@ -345,7 +346,15 @@ static irqreturn_t ds3232_irq(int irq, v
 	struct ds3232 *ds3232 = i2c_get_clientdata(client);
 
 	disable_irq_nosync(irq);
-	schedule_work(&ds3232->work);
+
+	/*
+	 * If rtc as a wakeup source, can't schedule the work
+	 * at system resume flow, because at this time the i2c bus
+	 * has not been resumed.
+	 */
+	if (!ds3232->suspended)
+		schedule_work(&ds3232->work);
+
 	return IRQ_HANDLED;
 }
 
@@ -363,22 +372,26 @@ static void ds3232_work(struct work_stru
 
 	if (stat & DS3232_REG_SR_A1F) {
 		control = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
-		if (control < 0)
-			goto out;
-		/* disable alarm1 interrupt */
-		control &= ~(DS3232_REG_CR_A1IE);
-		i2c_smbus_write_byte_data(client, DS3232_REG_CR, control);
+		if (control < 0) {
+			pr_warn("Read DS3232 Control Register error."
+				"Disable IRQ%d.\n", client->irq);
+		} else {
+			/* disable alarm1 interrupt */
+			control &= ~(DS3232_REG_CR_A1IE);
+			i2c_smbus_write_byte_data(client, DS3232_REG_CR,
+						control);
+
+			/* clear the alarm pend flag */
+			stat &= ~DS3232_REG_SR_A1F;
+			i2c_smbus_write_byte_data(client, DS3232_REG_SR, stat);
 
-		/* clear the alarm pend flag */
-		stat &= ~DS3232_REG_SR_A1F;
-		i2c_smbus_write_byte_data(client, DS3232_REG_SR, stat);
+			rtc_update_irq(ds3232->rtc, 1, RTC_AF | RTC_IRQF);
 
-		rtc_update_irq(ds3232->rtc, 1, RTC_AF | RTC_IRQF);
+			if (!ds3232->exiting)
+				enable_irq(client->irq);
+		}
 	}
 
-out:
-	if (!ds3232->exiting)
-		enable_irq(client->irq);
 unlock:
 	mutex_unlock(&ds3232->mutex);
 }
@@ -411,23 +424,19 @@ static int ds3232_probe(struct i2c_clien
 	if (ret)
 		return ret;
 
-	ds3232->rtc = devm_rtc_device_register(&client->dev, client->name,
-					  &ds3232_rtc_ops, THIS_MODULE);
-	if (IS_ERR(ds3232->rtc)) {
-		dev_err(&client->dev, "unable to register the class device\n");
-		return PTR_ERR(ds3232->rtc);
-	}
-
-	if (client->irq >= 0) {
+	if (client->irq != NO_IRQ) {
 		ret = devm_request_irq(&client->dev, client->irq, ds3232_irq,
 				       IRQF_SHARED, "ds3232", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
 			return ret;
 		}
+		device_init_wakeup(&client->dev, 1);
 	}
 
-	return 0;
+	ds3232->rtc = devm_rtc_device_register(&client->dev, client->name,
+					  &ds3232_rtc_ops, THIS_MODULE);
+	return PTR_ERR_OR_ZERO(ds3232->rtc);
 }
 
 static int ds3232_remove(struct i2c_client *client)
@@ -446,6 +455,42 @@ static int ds3232_remove(struct i2c_clie
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int ds3232_suspend(struct device *dev)
+{
+	struct ds3232 *ds3232 = dev_get_drvdata(dev);
+	struct i2c_client *client = to_i2c_client(dev);
+
+	if (device_can_wakeup(dev)) {
+		ds3232->suspended = true;
+		irq_set_irq_wake(client->irq, 1);
+	}
+
+	return 0;
+}
+
+static int ds3232_resume(struct device *dev)
+{
+	struct ds3232 *ds3232 = dev_get_drvdata(dev);
+	struct i2c_client *client = to_i2c_client(dev);
+
+	if (ds3232->suspended) {
+		ds3232->suspended = false;
+
+		/* Clear the hardware alarm pend flag */
+		schedule_work(&ds3232->work);
+
+		irq_set_irq_wake(client->irq, 0);
+	}
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops ds3232_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ds3232_suspend, ds3232_resume)
+};
+
 static const struct i2c_device_id ds3232_id[] = {
 	{ "ds3232", 0 },
 	{ }
@@ -456,6 +501,7 @@ static struct i2c_driver ds3232_driver =
 	.driver = {
 		.name = "rtc-ds3232",
 		.owner = THIS_MODULE,
+		.pm	= &ds3232_pm_ops,
 	},
 	.probe = ds3232_probe,
 	.remove = ds3232_remove,
_

Patches currently in -mm which might be from dongsheng.wang@freescale.com are


