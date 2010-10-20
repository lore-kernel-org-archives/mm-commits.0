From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds3232c-add-alarm-function.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:24:35 -0700
Message-ID: <201010202324.o9KNOZ3s010757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab0JTXZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b25806@freescale.com, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-ds3232.c: add alarm function
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds3232c-add-alarm-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-ds3232.c: add alarm function
From: Lan Chunhe-B25806 <b25806@freescale.com>

The DS3232 RTC driver only has the tick function.  Add an alarm function
so the driver is complete.

Signed-off-by: Lan Chunhe-B25806 <b25806@freescale.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    3 
 drivers/rtc/rtc-ds3232.c |  181 +++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-ds3232c-add-alarm-function drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-ds3232c-add-alarm-function
+++ a/drivers/rtc/Kconfig
@@ -171,7 +171,8 @@ config RTC_DRV_DS3232
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
-	  DS3232 real-time clock chips.
+	  DS3232 real-time clock chips. If an interrupt is associated
+	  with the device, the alarm functionality is supported.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called rtc-ds3232.
diff -puN drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-add-alarm-function drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-add-alarm-function
+++ a/drivers/rtc/rtc-ds3232.c
@@ -2,6 +2,7 @@
  * RTC client/driver for the Maxim/Dallas DS3232 Real-Time Clock over I2C
  *
  * Copyright (C) 2009-2010 Freescale Semiconductor.
+ * Author: Jack Lan <jack.lan@freescale.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -175,6 +176,182 @@ static int ds3232_set_time(struct device
 					      DS3232_REG_SECONDS, 7, buf);
 }
 
+/*
+ * DS3232 has two alarm, we only use alarm1
+ * According to linux specification, only support one-shot alarm
+ * no periodic alarm mode
+ */
+static int ds3232_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds3232 *ds3232 = i2c_get_clientdata(client);
+	int control, stat;
+	int ret;
+	u8 buf[4];
+
+	mutex_lock(&ds3232->mutex);
+
+	ret = i2c_smbus_read_byte_data(client, DS3232_REG_SR);
+	if (ret < 0)
+		goto out;
+	stat = ret;
+	ret = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
+	if (ret < 0)
+		goto out;
+	control = ret;
+	ret = i2c_smbus_read_i2c_block_data(client, DS3232_REG_ALARM1, 4, buf);
+	if (ret < 0)
+		goto out;
+
+	alarm->time.tm_sec = bcd2bin(buf[0] & 0x7F);
+	alarm->time.tm_min = bcd2bin(buf[1] & 0x7F);
+	alarm->time.tm_hour = bcd2bin(buf[2] & 0x7F);
+	alarm->time.tm_mday = bcd2bin(buf[3] & 0x7F);
+
+	alarm->time.tm_mon = -1;
+	alarm->time.tm_year = -1;
+	alarm->time.tm_wday = -1;
+	alarm->time.tm_yday = -1;
+	alarm->time.tm_isdst = -1;
+
+	alarm->enabled = !!(control & DS3232_REG_CR_A1IE);
+	alarm->pending = !!(stat & DS3232_REG_SR_A1F);
+
+	ret = 0;
+out:
+	mutex_unlock(&ds3232->mutex);
+	return ret;
+}
+
+/*
+ * linux rtc-module does not support wday alarm
+ * and only 24h time mode supported indeed
+ */
+static int ds3232_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds3232 *ds3232 = i2c_get_clientdata(client);
+	int control, stat;
+	int ret;
+	u8 buf[4];
+
+	if (client->irq <= 0)
+		return -EINVAL;
+
+	mutex_lock(&ds3232->mutex);
+
+	buf[0] = bin2bcd(alarm->time.tm_sec);
+	buf[1] = bin2bcd(alarm->time.tm_min);
+	buf[2] = bin2bcd(alarm->time.tm_hour);
+	buf[3] = bin2bcd(alarm->time.tm_mday);
+
+	/* clear alarm interrupt enable bit */
+	ret = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
+	if (ret < 0)
+		goto out;
+	control = ret;
+	control &= ~(DS3232_REG_CR_A1IE | DS3232_REG_CR_A2IE);
+	ret = i2c_smbus_write_byte_data(client, DS3232_REG_CR, control);
+	if (ret < 0)
+		goto out;
+
+	/* clear any pending alarm flag */
+	ret = i2c_smbus_read_byte_data(client, DS3232_REG_SR);
+	if (ret < 0)
+		goto out;
+	stat = ret;
+	stat &= ~(DS3232_REG_SR_A1F | DS3232_REG_SR_A2F);
+	ret = i2c_smbus_write_byte_data(client, DS3232_REG_SR, stat);
+	if (ret < 0)
+		goto out;
+
+	ret = i2c_smbus_write_i2c_block_data(client, DS3232_REG_ALARM1, 4, buf);
+
+	if (alarm->enabled) {
+		control |= DS3232_REG_CR_A1IE;
+		ret = i2c_smbus_write_byte_data(client, DS3232_REG_CR, control);
+	}
+out:
+	mutex_unlock(&ds3232->mutex);
+	return ret;
+}
+
+static void ds3232_update_alarm(struct i2c_client *client)
+{
+	struct ds3232 *ds3232 = i2c_get_clientdata(client);
+	int control;
+	int ret;
+	u8 buf[4];
+
+	mutex_lock(&ds3232->mutex);
+
+	ret = i2c_smbus_read_i2c_block_data(client, DS3232_REG_ALARM1, 4, buf);
+	if (ret < 0)
+		goto unlock;
+
+	buf[0] = bcd2bin(buf[0]) < 0 || (ds3232->rtc->irq_data & RTC_UF) ?
+								0x80 : buf[0];
+	buf[1] = bcd2bin(buf[1]) < 0 || (ds3232->rtc->irq_data & RTC_UF) ?
+								0x80 : buf[1];
+	buf[2] = bcd2bin(buf[2]) < 0 || (ds3232->rtc->irq_data & RTC_UF) ?
+								0x80 : buf[2];
+	buf[3] = bcd2bin(buf[3]) < 0 || (ds3232->rtc->irq_data & RTC_UF) ?
+								0x80 : buf[3];
+
+	ret = i2c_smbus_write_i2c_block_data(client, DS3232_REG_ALARM1, 4, buf);
+	if (ret < 0)
+		goto unlock;
+
+	control = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
+	if (control < 0)
+		goto unlock;
+
+	if (ds3232->rtc->irq_data & (RTC_AF | RTC_UF))
+		/* enable alarm1 interrupt */
+		control |= DS3232_REG_CR_A1IE;
+	else
+		/* disable alarm1 interrupt */
+		control &= ~(DS3232_REG_CR_A1IE);
+	i2c_smbus_write_byte_data(client, DS3232_REG_CR, control);
+
+unlock:
+	mutex_unlock(&ds3232->mutex);
+}
+
+static int ds3232_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds3232 *ds3232 = i2c_get_clientdata(client);
+
+	if (client->irq <= 0)
+		return -EINVAL;
+
+	if (enabled)
+		ds3232->rtc->irq_data |= RTC_AF;
+	else
+		ds3232->rtc->irq_data &= ~RTC_AF;
+
+	ds3232_update_alarm(client);
+	return 0;
+}
+
+static int ds3232_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds3232 *ds3232 = i2c_get_clientdata(client);
+
+	if (client->irq <= 0)
+		return -EINVAL;
+
+	if (enabled)
+		ds3232->rtc->irq_data |= RTC_UF;
+	else
+		ds3232->rtc->irq_data &= ~RTC_UF;
+
+	ds3232_update_alarm(client);
+	return 0;
+}
+
 static irqreturn_t ds3232_irq(int irq, void *dev_id)
 {
 	struct i2c_client *client = dev_id;
@@ -222,6 +399,10 @@ unlock:
 static const struct rtc_class_ops ds3232_rtc_ops = {
 	.read_time = ds3232_read_time,
 	.set_time = ds3232_set_time,
+	.read_alarm = ds3232_read_alarm,
+	.set_alarm = ds3232_set_alarm,
+	.alarm_irq_enable = ds3232_alarm_irq_enable,
+	.update_irq_enable = ds3232_update_irq_enable,
 };
 
 static int __devinit ds3232_probe(struct i2c_client *client,
_

Patches currently in -mm which might be from b25806@freescale.com are

drivers-rtc-rtc-ds3232c-add-alarm-function.patch

