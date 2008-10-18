From: akpm@linux-foundation.org
Subject: - rtc-ds1307-alarm-support-for-ds1337-ds1339.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:17 -0700
Message-ID: <200810182315.m9INFHdj028576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYJRXPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1307:  alarm support for ds1337/ds1339
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-alarm-support-for-ds1337-ds1339.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1307:  alarm support for ds1337/ds1339
From: Rodolfo Giometti <giometti@linux.it>

Update the ds1307 driver with alarm support for ds1337/ds1339.  This uses
the first alarm (there are two), and matches on seconds, minutes, hours,
and day-of-month.  Tested on ds1339.


[dbrownell@users.sourceforge.net: add comments; fixup style, valid irq
checks, debug dumps; lock; more careful IRQ shutdown; switch BCD2BIN to
bcd2bin (and vice versa); ENOTTY not EINVAL.]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  308 +++++++++++++++++++++++++++++++++++--
 1 file changed, 295 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-alarm-support-for-ds1337-ds1339 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-alarm-support-for-ds1337-ds1339
+++ a/drivers/rtc/rtc-ds1307.c
@@ -23,10 +23,6 @@
  * to have set the chip up as a clock (turning on the oscillator and
  * setting the date and time), Linux can ignore the non-clock features.
  * That's a natural job for a factory or repair bench.
- *
- * This is currently a simple no-alarms driver.  If your board has the
- * alarm irq wired up on a ds1337 or ds1339, and you want to use that,
- * then look at the rtc-rs5c372 driver for code to steal...
  */
 enum ds_type {
 	ds_1307,
@@ -67,6 +63,7 @@ enum ds_type {
 #	define DS1307_BIT_RS0		0x01
 #define DS1337_REG_CONTROL	0x0e
 #	define DS1337_BIT_nEOSC		0x80
+#	define DS1339_BIT_BBSQI		0x20
 #	define DS1337_BIT_RS2		0x10
 #	define DS1337_BIT_RS1		0x08
 #	define DS1337_BIT_INTCN		0x04
@@ -83,19 +80,22 @@ enum ds_type {
 #	define DS1337_BIT_OSF		0x80
 #	define DS1337_BIT_A2I		0x02
 #	define DS1337_BIT_A1I		0x01
+#define DS1339_REG_ALARM1_SECS	0x07
 #define DS1339_REG_TRICKLE	0x10
 
 
 
 struct ds1307 {
 	u8			reg_addr;
-	bool			has_nvram;
-	u8			regs[8];
+	u8			regs[11];
 	enum ds_type		type;
+	unsigned long		flags;
+#define HAS_NVRAM	0		/* bit 0 == sysfs file active */
+#define HAS_ALARM	1		/* bit 1 == irq claimed */
 	struct i2c_msg		msg[2];
 	struct i2c_client	*client;
-	struct i2c_client	dev;
 	struct rtc_device	*rtc;
+	struct work_struct	work;
 };
 
 struct chip_desc {
@@ -132,12 +132,79 @@ static const struct i2c_device_id ds1307
 };
 MODULE_DEVICE_TABLE(i2c, ds1307_id);
 
+/*----------------------------------------------------------------------*/
+
+/*
+ * The IRQ logic includes a "real" handler running in IRQ context just
+ * long enough to schedule this workqueue entry.   We need a task context
+ * to talk to the RTC, since I2C I/O calls require that; and disable the
+ * IRQ until we clear its status on the chip, so that this handler can
+ * work with any type of triggering (not just falling edge).
+ *
+ * The ds1337 and ds1339 both have two alarms, but we only use the first
+ * one (with a "seconds" field).  For ds1337 we expect nINTA is our alarm
+ * signal; ds1339 chips have only one alarm signal.
+ */
+static void ds1307_work(struct work_struct *work)
+{
+	struct ds1307		*ds1307;
+	struct i2c_client	*client;
+	struct mutex		*lock;
+	int			stat, control;
+
+	ds1307 = container_of(work, struct ds1307, work);
+	client = ds1307->client;
+	lock = &ds1307->rtc->ops_lock;
+
+	mutex_lock(lock);
+	stat = i2c_smbus_read_byte_data(client, DS1337_REG_STATUS);
+	if (stat < 0)
+		goto out;
+
+	if (stat & DS1337_BIT_A1I) {
+		stat &= ~DS1337_BIT_A1I;
+		i2c_smbus_write_byte_data(client, DS1337_REG_STATUS, stat);
+
+		control = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
+		if (control < 0)
+			goto out;
+
+		control &= ~DS1337_BIT_A1IE;
+		i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL, control);
+
+		/* rtc_update_irq() assumes that it is called
+		 * from IRQ-disabled context.
+		 */
+		local_irq_disable();
+		rtc_update_irq(ds1307->rtc, 1, RTC_AF | RTC_IRQF);
+		local_irq_enable();
+	}
+
+out:
+	if (test_bit(HAS_ALARM, &ds1307->flags))
+		enable_irq(client->irq);
+	mutex_unlock(lock);
+}
+
+static irqreturn_t ds1307_irq(int irq, void *dev_id)
+{
+	struct i2c_client	*client = dev_id;
+	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+
+	disable_irq_nosync(irq);
+	schedule_work(&ds1307->work);
+	return IRQ_HANDLED;
+}
+
+/*----------------------------------------------------------------------*/
+
 static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 {
 	struct ds1307	*ds1307 = dev_get_drvdata(dev);
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
+	ds1307->reg_addr = 0;
 	ds1307->msg[1].flags = I2C_M_RD;
 	ds1307->msg[1].len = 7;
 
@@ -231,9 +298,186 @@ static int ds1307_set_time(struct device
 	return 0;
 }
 
+static int ds1307_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client       *client = to_i2c_client(dev);
+	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+	int			ret;
+
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -EINVAL;
+
+	/* read all ALARM1, ALARM2, and status registers at once */
+	ds1307->reg_addr = DS1339_REG_ALARM1_SECS;
+	ds1307->msg[1].flags = I2C_M_RD;
+	ds1307->msg[1].len = 9;
+
+	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
+			ds1307->msg, 2);
+	if (ret != 2) {
+		dev_err(dev, "%s error %d\n", "alarm read", ret);
+		return -EIO;
+	}
+
+	dev_dbg(dev, "%s: %02x %02x %02x %02x, %02x %02x %02x, %02x %02x\n",
+			"alarm read",
+			ds1307->regs[0], ds1307->regs[1],
+			ds1307->regs[2], ds1307->regs[3],
+			ds1307->regs[4], ds1307->regs[5],
+			ds1307->regs[6], ds1307->regs[7],
+			ds1307->regs[8]);
+
+	/* report alarm time (ALARM1); assume 24 hour and day-of-month modes,
+	 * and that all four fields are checked matches
+	 */
+	t->time.tm_sec = bcd2bin(ds1307->regs[0] & 0x7f);
+	t->time.tm_min = bcd2bin(ds1307->regs[1] & 0x7f);
+	t->time.tm_hour = bcd2bin(ds1307->regs[2] & 0x3f);
+	t->time.tm_mday = bcd2bin(ds1307->regs[3] & 0x3f);
+	t->time.tm_mon = -1;
+	t->time.tm_year = -1;
+	t->time.tm_wday = -1;
+	t->time.tm_yday = -1;
+	t->time.tm_isdst = -1;
+
+	/* ... and status */
+	t->enabled = !!(ds1307->regs[7] & DS1337_BIT_A1IE);
+	t->pending = !!(ds1307->regs[8] & DS1337_BIT_A1I);
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, enabled=%d, pending=%d\n",
+		"alarm read", t->time.tm_sec, t->time.tm_min,
+		t->time.tm_hour, t->time.tm_mday,
+		t->enabled, t->pending);
+
+	return 0;
+}
+
+static int ds1307_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client       *client = to_i2c_client(dev);
+	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+	unsigned char		*buf = ds1307->regs;
+	u8			control, status;
+	int			ret;
+
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -EINVAL;
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, enabled=%d, pending=%d\n",
+		"alarm set", t->time.tm_sec, t->time.tm_min,
+		t->time.tm_hour, t->time.tm_mday,
+		t->enabled, t->pending);
+
+	/* read current status of both alarms and the chip */
+	ds1307->reg_addr = DS1339_REG_ALARM1_SECS;
+	ds1307->msg[1].flags = I2C_M_RD;
+	ds1307->msg[1].len = 9;
+
+	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
+			ds1307->msg, 2);
+	if (ret != 2) {
+		dev_err(dev, "%s error %d\n", "alarm write", ret);
+		return -EIO;
+	}
+	control = ds1307->regs[7];
+	status = ds1307->regs[8];
+
+	dev_dbg(dev, "%s: %02x %02x %02x %02x, %02x %02x %02x, %02x %02x\n",
+			"alarm set (old status)",
+			ds1307->regs[0], ds1307->regs[1],
+			ds1307->regs[2], ds1307->regs[3],
+			ds1307->regs[4], ds1307->regs[5],
+			ds1307->regs[6], control, status);
+
+	/* set ALARM1, using 24 hour and day-of-month modes */
+	*buf++ = DS1339_REG_ALARM1_SECS;	/* first register addr */
+	buf[0] = bin2bcd(t->time.tm_sec);
+	buf[1] = bin2bcd(t->time.tm_min);
+	buf[2] = bin2bcd(t->time.tm_hour);
+	buf[3] = bin2bcd(t->time.tm_mday);
+
+	/* set ALARM2 to non-garbage */
+	buf[4] = 0;
+	buf[5] = 0;
+	buf[6] = 0;
+
+	/* optionally enable ALARM1 */
+	buf[7] = control & ~(DS1337_BIT_A1IE | DS1337_BIT_A2IE);
+	if (t->enabled) {
+		dev_dbg(dev, "alarm IRQ armed\n");
+		buf[7] |= DS1337_BIT_A1IE;	/* only ALARM1 is used */
+	}
+	buf[8] = status & ~(DS1337_BIT_A1I | DS1337_BIT_A2I);
+
+	ds1307->msg[1].flags = 0;
+	ds1307->msg[1].len = 10;
+
+	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
+			&ds1307->msg[1], 1);
+	if (ret != 1) {
+		dev_err(dev, "can't set alarm time\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int ds1307_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct i2c_client	*client = to_i2c_client(dev);
+	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+	int			ret;
+
+	switch (cmd) {
+	case RTC_AIE_OFF:
+		if (!test_bit(HAS_ALARM, &ds1307->flags))
+			return -ENOTTY;
+
+		ret = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~DS1337_BIT_A1IE;
+
+		ret = i2c_smbus_write_byte_data(client,
+						DS1337_REG_CONTROL, ret);
+		if (ret < 0)
+			return ret;
+
+		break;
+
+	case RTC_AIE_ON:
+		if (!test_bit(HAS_ALARM, &ds1307->flags))
+			return -ENOTTY;
+
+		ret = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
+		if (ret < 0)
+			return ret;
+
+		ret |= DS1337_BIT_A1IE;
+
+		ret = i2c_smbus_write_byte_data(client,
+						DS1337_REG_CONTROL, ret);
+		if (ret < 0)
+			return ret;
+
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
 static const struct rtc_class_ops ds13xx_rtc_ops = {
 	.read_time	= ds1307_get_time,
 	.set_time	= ds1307_set_time,
+	.read_alarm	= ds1307_read_alarm,
+	.set_alarm	= ds1307_set_alarm,
+	.ioctl		= ds1307_ioctl,
 };
 
 /*----------------------------------------------------------------------*/
@@ -327,6 +571,7 @@ static int __devinit ds1307_probe(struct
 	int			tmp;
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
+	int			want_irq = false;
 
 	if (!i2c_check_functionality(adapter,
 			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
@@ -353,6 +598,12 @@ static int __devinit ds1307_probe(struct
 	switch (ds1307->type) {
 	case ds_1337:
 	case ds_1339:
+		/* has IRQ? */
+		if (ds1307->client->irq > 0 && chip->alarm) {
+			INIT_WORK(&ds1307->work, ds1307_work);
+			want_irq = true;
+		}
+
 		ds1307->reg_addr = DS1337_REG_CONTROL;
 		ds1307->msg[1].len = 2;
 
@@ -369,8 +620,20 @@ static int __devinit ds1307_probe(struct
 
 		/* oscillator off?  turn it on, so clock can tick. */
 		if (ds1307->regs[0] & DS1337_BIT_nEOSC)
-			i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL,
-				ds1307->regs[0] & ~DS1337_BIT_nEOSC);
+			ds1307->regs[0] &= ~DS1337_BIT_nEOSC;
+
+		/* Using IRQ?  Disable the square wave and both alarms.
+		 * For ds1339, be sure alarms can trigger when we're
+		 * running on Vbackup (BBSQI); we assume ds1337 will
+		 * ignore that bit
+		 */
+		if (want_irq) {
+			ds1307->regs[0] |= DS1337_BIT_INTCN | DS1339_BIT_BBSQI;
+			ds1307->regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
+		}
+
+		i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL,
+							ds1307->regs[0]);
 
 		/* oscillator fault?  clear flag, and warn */
 		if (ds1307->regs[1] & DS1337_BIT_OSF) {
@@ -495,10 +758,22 @@ read_rtc:
 		goto exit_free;
 	}
 
+	if (want_irq) {
+		err = request_irq(client->irq, ds1307_irq, 0,
+			  ds1307->rtc->name, client);
+		if (err) {
+			dev_err(&client->dev,
+				"unable to request IRQ!\n");
+			goto exit_irq;
+		}
+		set_bit(HAS_ALARM, &ds1307->flags);
+		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
+	}
+
 	if (chip->nvram56) {
 		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
 		if (err == 0) {
-			ds1307->has_nvram = true;
+			set_bit(HAS_NVRAM, &ds1307->flags);
 			dev_info(&client->dev, "56 bytes nvram\n");
 		}
 	}
@@ -512,7 +787,9 @@ exit_bad:
 			ds1307->regs[2], ds1307->regs[3],
 			ds1307->regs[4], ds1307->regs[5],
 			ds1307->regs[6]);
-
+exit_irq:
+	if (ds1307->rtc)
+		rtc_device_unregister(ds1307->rtc);
 exit_free:
 	kfree(ds1307);
 	return err;
@@ -520,9 +797,14 @@ exit_free:
 
 static int __devexit ds1307_remove(struct i2c_client *client)
 {
-	struct ds1307	*ds1307 = i2c_get_clientdata(client);
+	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+
+	if (test_and_clear_bit(HAS_ALARM, &ds1307->flags)) {
+		free_irq(client->irq, client);
+		cancel_work_sync(&ds1307->work);
+	}
 
-	if (ds1307->has_nvram)
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
 		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
 
 	rtc_device_unregister(ds1307->rtc);
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch

