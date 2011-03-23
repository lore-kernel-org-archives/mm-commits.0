From: akpm@linux-foundation.org
Subject: [merged] rtc-isl1208-add-alarm-support.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:42 -0700
Message-ID: <201103232044.p2NKiIl7029059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933473Ab1CWUoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan@bluewatersys.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-isl1208.c: add alarm support
has been removed from the -mm tree.  Its filename was
     rtc-isl1208-add-alarm-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-isl1208.c: add alarm support
From: Ryan Mallon <ryan@bluewatersys.com>

Add alarm/wakeup support to rtc isl1208 driver

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |  176 ++++++++++++++++++++++++++++++++++--
 1 file changed, 171 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-isl1208.c~rtc-isl1208-add-alarm-support drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-isl1208-add-alarm-support
+++ a/drivers/rtc/rtc-isl1208.c
@@ -39,6 +39,8 @@
 #define ISL1208_REG_SR_BAT     (1<<1)	/* battery */
 #define ISL1208_REG_SR_RTCF    (1<<0)	/* rtc fail */
 #define ISL1208_REG_INT 0x08
+#define ISL1208_REG_INT_ALME   (1<<6)   /* alarm enable */
+#define ISL1208_REG_INT_IM     (1<<7)   /* interrupt/alarm mode */
 #define ISL1208_REG_09  0x09	/* reserved */
 #define ISL1208_REG_ATR 0x0a
 #define ISL1208_REG_DTR 0x0b
@@ -202,6 +204,30 @@ isl1208_i2c_set_usr(struct i2c_client *c
 }
 
 static int
+isl1208_rtc_toggle_alarm(struct i2c_client *client, int enable)
+{
+	int icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
+
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: reading INT failed\n", __func__);
+		return icr;
+	}
+
+	if (enable)
+		icr |= ISL1208_REG_INT_ALME | ISL1208_REG_INT_IM;
+	else
+		icr &= ~(ISL1208_REG_INT_ALME | ISL1208_REG_INT_IM);
+
+	icr = i2c_smbus_write_byte_data(client, ISL1208_REG_INT, icr);
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: writing INT failed\n", __func__);
+		return icr;
+	}
+
+	return 0;
+}
+
+static int
 isl1208_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct i2c_client *const client = to_i2c_client(dev);
@@ -288,9 +314,8 @@ isl1208_i2c_read_alarm(struct i2c_client
 {
 	struct rtc_time *const tm = &alarm->time;
 	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
-	int sr;
+	int icr, yr, sr = isl1208_i2c_get_sr(client);
 
-	sr = isl1208_i2c_get_sr(client);
 	if (sr < 0) {
 		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
 		return sr;
@@ -313,6 +338,73 @@ isl1208_i2c_read_alarm(struct i2c_client
 		bcd2bin(regs[ISL1208_REG_MOA - ISL1208_REG_SCA] & 0x1f) - 1;
 	tm->tm_wday = bcd2bin(regs[ISL1208_REG_DWA - ISL1208_REG_SCA] & 0x03);
 
+	/* The alarm doesn't store the year so get it from the rtc section */
+	yr = i2c_smbus_read_byte_data(client, ISL1208_REG_YR);
+	if (yr < 0) {
+		dev_err(&client->dev, "%s: reading RTC YR failed\n", __func__);
+		return yr;
+	}
+	tm->tm_year = bcd2bin(yr) + 100;
+
+	icr = i2c_smbus_read_byte_data(client, ISL1208_REG_INT);
+	if (icr < 0) {
+		dev_err(&client->dev, "%s: reading INT failed\n", __func__);
+		return icr;
+	}
+	alarm->enabled = !!(icr & ISL1208_REG_INT_ALME);
+
+	return 0;
+}
+
+static int
+isl1208_i2c_set_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
+{
+	struct rtc_time *alarm_tm = &alarm->time;
+	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
+	const int offs = ISL1208_REG_SCA;
+	unsigned long rtc_secs, alarm_secs;
+	struct rtc_time rtc_tm;
+	int err, enable;
+
+	err = isl1208_i2c_read_time(client, &rtc_tm);
+	if (err)
+		return err;
+	err = rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (err)
+		return err;
+	err = rtc_tm_to_time(alarm_tm, &alarm_secs);
+	if (err)
+		return err;
+
+	/* If the alarm time is before the current time disable the alarm */
+	if (!alarm->enabled || alarm_secs <= rtc_secs)
+		enable = 0x00;
+	else
+		enable = 0x80;
+
+	/* Program the alarm and enable it for each setting */
+	regs[ISL1208_REG_SCA - offs] = bin2bcd(alarm_tm->tm_sec) | enable;
+	regs[ISL1208_REG_MNA - offs] = bin2bcd(alarm_tm->tm_min) | enable;
+	regs[ISL1208_REG_HRA - offs] = bin2bcd(alarm_tm->tm_hour) |
+		ISL1208_REG_HR_MIL | enable;
+
+	regs[ISL1208_REG_DTA - offs] = bin2bcd(alarm_tm->tm_mday) | enable;
+	regs[ISL1208_REG_MOA - offs] = bin2bcd(alarm_tm->tm_mon + 1) | enable;
+	regs[ISL1208_REG_DWA - offs] = bin2bcd(alarm_tm->tm_wday & 7) | enable;
+
+	/* write ALARM registers */
+	err = isl1208_i2c_set_regs(client, offs, regs,
+				  ISL1208_ALARM_SECTION_LEN);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: writing ALARM section failed\n",
+			__func__);
+		return err;
+	}
+
+	err = isl1208_rtc_toggle_alarm(client, enable);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -391,12 +483,63 @@ isl1208_rtc_read_alarm(struct device *de
 	return isl1208_i2c_read_alarm(to_i2c_client(dev), alarm);
 }
 
+static int
+isl1208_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	return isl1208_i2c_set_alarm(to_i2c_client(dev), alarm);
+}
+
+static irqreturn_t
+isl1208_rtc_interrupt(int irq, void *data)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+	struct i2c_client *client = data;
+	int handled = 0, sr, err;
+
+	/*
+	 * I2C reads get NAK'ed if we read straight away after an interrupt?
+	 * Using a mdelay/msleep didn't seem to help either, so we work around
+	 * this by continually trying to read the register for a short time.
+	 */
+	while (1) {
+		sr = isl1208_i2c_get_sr(client);
+		if (sr >= 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&client->dev, "%s: reading SR failed\n",
+				__func__);
+			return sr;
+		}
+	}
+
+	if (sr & ISL1208_REG_SR_ALM) {
+		dev_dbg(&client->dev, "alarm!\n");
+
+		/* Clear the alarm */
+		sr &= ~ISL1208_REG_SR_ALM;
+		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
+		if (sr < 0)
+			dev_err(&client->dev, "%s: writing SR failed\n",
+				__func__);
+		else
+			handled = 1;
+
+		/* Disable the alarm */
+		err = isl1208_rtc_toggle_alarm(client, 0);
+		if (err)
+			return err;
+	}
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
 static const struct rtc_class_ops isl1208_rtc_ops = {
 	.proc = isl1208_rtc_proc,
 	.read_time = isl1208_rtc_read_time,
 	.set_time = isl1208_rtc_set_time,
 	.read_alarm = isl1208_rtc_read_alarm,
-	/*.set_alarm    = isl1208_rtc_set_alarm, */
+	.set_alarm = isl1208_rtc_set_alarm,
 };
 
 /* sysfs interface */
@@ -488,11 +631,29 @@ isl1208_probe(struct i2c_client *client,
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
+	if (client->irq > 0) {
+		rc = request_threaded_irq(client->irq, NULL,
+					  isl1208_rtc_interrupt,
+					  IRQF_SHARED,
+					  isl1208_driver.driver.name, client);
+		if (!rc) {
+			device_init_wakeup(&client->dev, 1);
+			enable_irq_wake(client->irq);
+		} else {
+			dev_err(&client->dev,
+				"Unable to request irq %d, no alarm support\n",
+				client->irq);
+			client->irq = 0;
+		}
+	}
+
 	rtc = rtc_device_register(isl1208_driver.driver.name,
 				  &client->dev, &isl1208_rtc_ops,
 				  THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
+	if (IS_ERR(rtc)) {
+		rc = PTR_ERR(rtc);
+		goto exit_free_irq;
+	}
 
 	i2c_set_clientdata(client, rtc);
 
@@ -514,6 +675,9 @@ isl1208_probe(struct i2c_client *client,
 
 exit_unregister:
 	rtc_device_unregister(rtc);
+exit_free_irq:
+	if (client->irq)
+		free_irq(client->irq, client);
 
 	return rc;
 }
@@ -525,6 +689,8 @@ isl1208_remove(struct i2c_client *client
 
 	sysfs_remove_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	rtc_device_unregister(rtc);
+	if (client->irq)
+		free_irq(client->irq, client);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ryan@bluewatersys.com are

origin.patch
linux-next.patch

