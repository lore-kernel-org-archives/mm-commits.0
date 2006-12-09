From: akpm@osdl.org
Subject: + rtc-rtc-class-driver-for-the-ds1374.patch added to -mm tree
Date: Fri, 08 Dec 2006 20:38:49 -0800
Message-ID: <200612090438.kB94cnNU016403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267AbWLIEi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 23:38:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scottwood@freescale.com, a.zummo@towertech.it


The patch titled
     rtc: RTC class driver for the ds1374
has been added to the -mm tree.  Its filename is
     rtc-rtc-class-driver-for-the-ds1374.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: RTC class driver for the ds1374
From: Scott Wood <scottwood@freescale.com>

Add an RTC class driver for the Maxim/Dallas 1374 RTC chip, based on
drivers/i2c/chips/ds1374.c.  It uses new-style device enumeration and supports
alarm functionality.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/Kconfig      |   11 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-ds1374.c |  439 +++++++++++++++++++++++++++++++++++++
 3 files changed, 451 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rtc-class-driver-for-the-ds1374 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-class-driver-for-the-ds1374
+++ a/drivers/rtc/Kconfig
@@ -123,6 +123,17 @@ config RTC_DRV_DS1307
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1307.
 
+config RTC_DRV_DS1374
+	tristate "Maxim/Dallas Semiconductor DS1374 Real Time Clock"
+	depends on RTC_CLASS && I2C && !SENSORS_DS1374
+	help
+	  If you say yes here you get support for Dallas Semiconductor
+	  DS1374 real-time clock chips.  If an interrupt is associated
+	  with the device, the alarm functionality is supported.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called rtc-ds1374.
+
 config RTC_DRV_DS1553
 	tristate "Dallas DS1553"
 	depends on RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-rtc-class-driver-for-the-ds1374 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rtc-class-driver-for-the-ds1374
+++ a/drivers/rtc/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
+obj-$(CONFIG_RTC_DRV_DS1374)	+= rtc-ds1374.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
 obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds1742.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
diff -puN /dev/null drivers/rtc/rtc-ds1374.c
--- /dev/null
+++ a/drivers/rtc/rtc-ds1374.c
@@ -0,0 +1,439 @@
+/*
+ * RTC client/driver for the Maxim/Dallas DS1374 Real-Time Clock over I2C
+ *
+ * Based on drivers/i2c/chips/ds1374.c by Randy Vinson <rvinson@mvista.com>,
+ * which was based on the m41t00.c by Mark Greer <mgreer@mvista.com>.
+ *
+ * Copyright (C) 2006 Freescale Semiconductor
+ *
+ * 2005 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ */
+/*
+ * It would be more efficient to use i2c msgs/i2c_transfer directly but, as
+ * recommened in .../Documentation/i2c/writing-clients section
+ * "Sending and receiving", using SMBus level communication is preferred.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/workqueue.h>
+
+#define DS1374_REG_TOD0		0x00 /* Time of Day */
+#define DS1374_REG_TOD1		0x01
+#define DS1374_REG_TOD2		0x02
+#define DS1374_REG_TOD3		0x03
+#define DS1374_REG_WDALM0	0x04 /* Watchdog/Alarm */
+#define DS1374_REG_WDALM1	0x05
+#define DS1374_REG_WDALM2	0x06
+#define DS1374_REG_CR		0x07 /* Control */
+#define DS1374_REG_CR_AIE	0x01 /* Alarm Int. Enable */
+#define DS1374_REG_CR_WDALM	0x20 /* 1=Watchdog, 0=Alarm */
+#define DS1374_REG_CR_WACE	0x40 /* WD/Alarm counter enable */
+#define DS1374_REG_SR		0x08 /* Status */
+#define DS1374_REG_SR_OSF	0x80 /* Oscillator Stop Flag */
+#define DS1374_REG_SR_AF	0x01 /* Alarm Flag */
+#define DS1374_REG_TCR		0x09 /* Trickle Charge */
+
+#define	DS1374_DRV_NAME		"ds1374"
+
+struct ds1374 {
+	struct rtc_device *rtc;
+	struct work_struct work;
+	struct mutex mutex;
+	spinlock_t lock;
+	int have_irq;
+};
+
+static struct i2c_driver ds1374_driver;
+
+static u8 read_reg(struct i2c_client *client, int reg, int *err)
+{
+	s32 val = i2c_smbus_read_byte_data(client, reg);
+
+	if (val < 0) {
+		dev_warn(&client->dev, "read from I2C register %d failed\n",
+		         reg);
+
+		if (err)
+			*err = -EIO;
+
+		return 0;
+	}
+
+	return val;
+}
+
+static void write_reg(struct i2c_client *client, int reg, u8 val, int *err)
+{
+	if (i2c_smbus_write_byte_data(client, reg, val) < 0) {
+		dev_warn(&client->dev, "write to I2C register %d failed\n",
+		         reg);
+
+		if (err)
+			*err = -EIO;
+	}
+}
+
+static int ds1374_read_rtc(struct i2c_client *client, ulong *time,
+                           int from, int to)
+{
+	int reg, ret = 0;
+	*time = 0;
+
+	for (reg = to; reg >= from; reg--)
+		*time = (*time << 8) | read_reg(client, reg, &ret);
+
+	return ret;
+}
+
+static int ds1374_write_rtc(struct i2c_client *client, ulong time,
+                            int from, int to)
+{
+	int reg, ret = 0;
+
+	for (reg = from; reg <= to; reg++) {
+		write_reg(client, reg, time & 0xff, &ret);
+		time = time >> 8;
+	}
+
+	return ret;
+}
+
+static int ds1374_check_rtc_status(struct i2c_client *client)
+{
+	int ret = 0;
+	u8 stat = read_reg(client, DS1374_REG_SR, &ret);
+	u8 control;
+
+	if (ret == 0) {
+		if (stat & DS1374_REG_SR_OSF)
+			dev_warn(&client->dev,
+			         "oscillator discontinuity flagged, "
+			         "time unreliable\n");
+
+		stat &= ~(DS1374_REG_SR_OSF | DS1374_REG_SR_AF);
+		write_reg(client, DS1374_REG_SR, stat, &ret);
+	}
+
+	/* If the alarm is pending, clear it before requesting
+	 * the interrupt, so an interrupt event isn't reported
+	 * before everything is initialized.
+	 */
+
+	control = read_reg(client, DS1374_REG_CR, &ret);
+
+	if (ret == 0) {
+		control &= ~(DS1374_REG_CR_WACE | DS1374_REG_CR_AIE);
+		write_reg(client, DS1374_REG_CR, control, &ret);
+	}
+
+	return ret;
+}
+
+static int ds1374_read_rtc_retry(struct device *dev, ulong *time,
+                                 int from, int to)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	ulong time2;
+	int limit = 10;		/* arbitrary retry limit */
+	int ret;
+
+	/*
+	 * Since the reads are being performed one byte at a time using
+	 * the SMBus vs a 4-byte i2c transfer, there is a chance that a
+	 * carry will occur during the read. To detect this, 2 reads are
+	 * performed and compared.
+	 */
+	do {
+		ret = ds1374_read_rtc(client, time, from, to);
+		if (ret)
+			return ret;
+
+		ret = ds1374_read_rtc(client, &time2, from, to);
+		if (ret)
+			return ret;
+	} while (*time != time2 && limit--);
+
+	if (*time != time2) {
+		dev_warn(dev, "can't get consistent time from rtc chip\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ds1374_write_rtc_retry(struct device *dev, ulong time,
+                                  int from, int to)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	ulong time2;
+	int limit = 10;		/* arbitrary retry limit */
+	int ret;
+
+	/*
+	 * Since the writes are being performed one byte at a time using
+	 * the SMBus vs a 4-byte i2c transfer, there is a chance that a
+	 * carry will occur during the write. To detect this, the write
+	 * value is read back and compared.
+	 */
+	do {
+		ds1374_write_rtc(client, time, from, to);
+
+		ret = ds1374_read_rtc(client, &time2, from, to);
+		if (ret)
+			return ret;
+	} while (time != time2 && limit--);
+
+	if (time != time2) {
+		dev_warn(dev, "can't confirm time set from rtc chip\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ds1374_read_time(struct device *dev, struct rtc_time *time)
+{
+	ulong itime;
+
+	int ret = ds1374_read_rtc_retry(dev, &itime,
+	                                DS1374_REG_TOD0,
+	                                DS1374_REG_TOD3);
+
+	if (!ret)
+		rtc_time_to_tm(itime, time);
+
+	return ret;
+}
+
+static int ds1374_set_time(struct device *dev, struct rtc_time *time)
+{
+	ulong itime;
+	rtc_tm_to_time(time, &itime);
+
+	return ds1374_write_rtc_retry(dev, itime,
+	                              DS1374_REG_TOD0,
+	                              DS1374_REG_TOD3);
+}
+
+/* The ds1374 has a decrementer for an alarm, rather than a comparator.
+ * If the time of day is changed, then the alarm will need to be
+ * reset.
+ */
+static int ds1374_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	ulong now, cur_alarm;
+	u8 cr, sr;
+	int ret = 0;
+
+	cr = read_reg(client, DS1374_REG_CR, &ret);
+	sr = read_reg(client, DS1374_REG_SR, &ret);
+	if (ret)
+		return ret;
+
+	ret = ds1374_read_rtc_retry(dev, &now,
+	                            DS1374_REG_TOD0, DS1374_REG_TOD3);
+	if (ret)
+		return ret;
+
+	ret = ds1374_read_rtc_retry(dev, &cur_alarm,
+	                            DS1374_REG_WDALM0, DS1374_REG_WDALM2);
+	if (ret)
+		return ret;
+
+	rtc_time_to_tm(now + cur_alarm, &alarm->time);
+	alarm->enabled = !!(cr & DS1374_REG_CR_WACE);
+	alarm->pending = !!(sr & DS1374_REG_SR_AF);
+
+	return 0;
+}
+
+static int ds1374_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds1374 *ds1374 = i2c_get_clientdata(client);
+	struct rtc_time now;
+	ulong new_alarm, itime;
+	u8 cr;
+	int ret = 0;
+
+	if (!ds1374->have_irq)
+		return -EINVAL;
+
+	cr = read_reg(client, DS1374_REG_CR, &ret);
+	if (ret)
+		return ret;
+
+	ret = ds1374_read_time(dev, &now);
+	if (ret)
+		return ret;
+
+	rtc_merge_alarm(&now, &alarm->time);
+	rtc_tm_to_time(&alarm->time, &new_alarm);
+	rtc_tm_to_time(&now, &itime);
+
+	new_alarm -= itime;
+
+	/* This should only happen due to races, or if the full date
+	 * up to the year was specified (and is in the past).  Partial
+	 * dates in the past are interpreted into the future by
+	 * rtc_merge_alarm().
+	 */
+	if (new_alarm <= 0)
+		new_alarm = 1;
+
+	mutex_lock(&ds1374->mutex);
+
+	ret = ds1374_write_rtc_retry(dev, new_alarm,
+	                             DS1374_REG_WDALM0,
+	                             DS1374_REG_WDALM2);
+
+	if (alarm->enabled) {
+		cr |= DS1374_REG_CR_WACE | DS1374_REG_CR_AIE;
+		cr &= ~DS1374_REG_CR_WDALM;
+
+		write_reg(client, DS1374_REG_CR, cr, &ret);
+	}
+
+	mutex_unlock(&ds1374->mutex);
+	return ret;
+}
+
+static irqreturn_t ds1374_irq(int irq, void *dev_id)
+{
+	struct i2c_client *client = dev_id;
+	struct ds1374 *ds1374 = i2c_get_clientdata(client);
+	irqreturn_t ret = IRQ_NONE;
+
+	spin_lock_irq(&ds1374->lock);
+
+	if (ds1374->have_irq) {
+		disable_irq_nosync(irq);
+		schedule_work(&ds1374->work);
+		ret = IRQ_HANDLED;
+	}
+
+	spin_unlock_irq(&ds1374->lock);
+	return ret;
+}
+
+static void ds1374_work(void *arg)
+{
+	struct i2c_client *client = arg;
+	struct ds1374 *ds1374 = i2c_get_clientdata(client);
+	u8 stat, control;
+
+	mutex_lock(&ds1374->mutex);
+
+	stat = read_reg(client, DS1374_REG_SR, NULL);
+
+	if (stat & DS1374_REG_SR_AF) {
+		stat &= ~DS1374_REG_SR_AF;
+		write_reg(client, DS1374_REG_SR, stat, NULL);
+
+		control = read_reg(client, DS1374_REG_CR, NULL);
+		control &= ~(DS1374_REG_CR_WACE | DS1374_REG_CR_AIE);
+		write_reg(client, DS1374_REG_CR, control, NULL);
+
+		rtc_update_irq(&ds1374->rtc->class_dev, 1, RTC_AF | RTC_IRQF);
+	}
+
+	mutex_unlock(&ds1374->mutex);
+
+	enable_irq(client->irq);
+}
+
+static const struct rtc_class_ops ds1374_rtc_ops = {
+	.read_time = ds1374_read_time,
+	.set_time = ds1374_set_time,
+	.read_alarm = ds1374_read_alarm,
+	.set_alarm = ds1374_set_alarm,
+};
+
+static int ds1374_probe(struct i2c_client *client)
+{
+	struct ds1374 *ds1374;
+	int ret;
+
+	ds1374 = kzalloc(sizeof(struct ds1374), GFP_KERNEL);
+	if (!ds1374)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, ds1374);
+
+	INIT_WORK(&ds1374->work, ds1374_work, client);
+	spin_lock_init(&ds1374->lock);
+	mutex_init(&ds1374->mutex);
+
+	ret = ds1374_check_rtc_status(client);
+	if (ret)
+		return ret;
+
+	if (client->irq != -1 &&
+	    !request_irq(client->irq, ds1374_irq, 0, DS1374_DRV_NAME, client))
+		ds1374->have_irq = 1;
+
+	ds1374->rtc = rtc_device_register(client->name, &client->dev,
+	                                  &ds1374_rtc_ops, THIS_MODULE);
+	if (IS_ERR(ds1374->rtc)) {
+		ret = PTR_ERR(ds1374->rtc);
+		dev_err(&client->dev, "unable to register the class device\n");
+		kfree(ds1374);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit ds1374_remove(struct i2c_client *client)
+{
+	struct ds1374 *ds1374 = i2c_get_clientdata(client);
+
+	if (ds1374->have_irq) {
+		spin_lock_irq(&ds1374->lock);
+		ds1374->have_irq = 0;
+		spin_unlock_irq(&ds1374->lock);
+
+		flush_scheduled_work();
+		free_irq(client->irq, client);
+	}
+
+	rtc_device_unregister(ds1374->rtc);
+	kfree(ds1374);
+	return 0;
+}
+
+static struct i2c_driver ds1374_driver = {
+	.driver = {
+		.name	= DS1374_DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.id = I2C_DRIVERID_DS1374,
+	.probe = ds1374_probe,
+	.remove = __devexit_p(ds1374_remove),
+};
+
+static int __init ds1374_init(void)
+{
+	return i2c_add_driver(&ds1374_driver);
+}
+
+static void __exit ds1374_exit(void)
+{
+	i2c_del_driver(&ds1374_driver);
+}
+
+module_init(ds1374_init);
+module_exit(ds1374_exit);
+
+MODULE_AUTHOR("Scott Wood <scottwood@freescale.com>");
+MODULE_DESCRIPTION("Maxim/Dallas DS1374 RTC I2C Client Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from scottwood@freescale.com are

origin.patch
make-platform_device_add_data-accept-a-const-pointer.patch
rtc-add-rtc_merge_alarm.patch
rtc-rtc-class-driver-for-the-ds1374.patch

