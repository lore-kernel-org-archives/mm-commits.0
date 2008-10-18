From: akpm@linux-foundation.org
Subject: - rtc-rtc-rs5c372-smbus-conversion-support.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:25 -0700
Message-ID: <200810182315.m9INFPkE028617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYJRXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, a.zummo@towertech.it, david-b@pacbell.net, riku.voipio@movial.fi, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-rs5c372: SMBus conversion/support
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c372-smbus-conversion-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-rs5c372: SMBus conversion/support
From: Paul Mundt <lethal@linux-sh.org>

rtc-rs5c372 presently depends on I2C master mode transfers, despite the
fact that these RTCs frequently find themselves on SMBus-only adapters.

Given that the only capabilities that were checked were for I2C_FUNC_I2C,
it's assumed that most of the adapters that are currently using this
driver are fairly sane, and are able to handle SMBus emulation (though we
adjust the default capabilities to check for I2C_FUNC_SMBUS_EMUL anyways,
which is the vast majority of them.  The adapters that don't have their
own ->smbus_xfer() fall back on the ->master_xfer() through the emulated
transfer).

The special case is iop3xx, which has more than its fair share of hacks
within this driver, it remains untested -- though also claims to support
emulated SMBus accesses.  The corner case there is rs5c_get_regs() which
uses access mode #3 for transferring the register state, while we use mode
#1 for SMBus.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Brownell <david-b@pacbell.net>
Tested-by: Riku Voipio <riku.voipio@movial.fi>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |  209 ++++++++++++++++++++++--------------
 1 file changed, 131 insertions(+), 78 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-smbus-conversion-support drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-smbus-conversion-support
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2005 Pavel Mironchik <pmironchik@optifacio.net>
  * Copyright (C) 2006 Tower Technologies
+ * Copyright (C) 2008 Paul Mundt
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,7 +14,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 
-#define DRV_VERSION "0.5"
+#define DRV_VERSION "0.6"
 
 
 /*
@@ -89,6 +90,7 @@ struct rs5c372 {
 	enum rtc_type		type;
 	unsigned		time24:1;
 	unsigned		has_irq:1;
+	unsigned		smbus:1;
 	char			buf[17];
 	char			*regs;
 };
@@ -106,10 +108,25 @@ static int rs5c_get_regs(struct rs5c372 
 	 *
 	 * The first method doesn't work with the iop3xx adapter driver, on at
 	 * least 80219 chips; this works around that bug.
+	 *
+	 * The third method on the other hand doesn't work for the SMBus-only
+	 * configurations, so we use the the first method there, stripping off
+	 * the extra register in the process.
 	 */
-	if ((i2c_transfer(client->adapter, msgs, 1)) != 1) {
-		dev_warn(&client->dev, "can't read registers\n");
-		return -EIO;
+	if (rs5c->smbus) {
+		int addr = RS5C_ADDR(RS5C372_REG_SECS);
+		int size = sizeof(rs5c->buf) - 1;
+
+		if (i2c_smbus_read_i2c_block_data(client, addr, size,
+						  rs5c->buf + 1) != size) {
+			dev_warn(&client->dev, "can't read registers\n");
+			return -EIO;
+		}
+	} else {
+		if ((i2c_transfer(client->adapter, msgs, 1)) != 1) {
+			dev_warn(&client->dev, "can't read registers\n");
+			return -EIO;
+		}
 	}
 
 	dev_dbg(&client->dev,
@@ -187,6 +204,7 @@ static int rs5c372_set_datetime(struct i
 {
 	struct rs5c372	*rs5c = i2c_get_clientdata(client);
 	unsigned char	buf[8];
+	int		addr;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -194,16 +212,16 @@ static int rs5c372_set_datetime(struct i
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
-	buf[0] = RS5C_ADDR(RS5C372_REG_SECS);
-	buf[1] = BIN2BCD(tm->tm_sec);
-	buf[2] = BIN2BCD(tm->tm_min);
-	buf[3] = rs5c_hr2reg(rs5c, tm->tm_hour);
-	buf[4] = BIN2BCD(tm->tm_wday);
-	buf[5] = BIN2BCD(tm->tm_mday);
-	buf[6] = BIN2BCD(tm->tm_mon + 1);
-	buf[7] = BIN2BCD(tm->tm_year - 100);
+	addr   = RS5C_ADDR(RS5C372_REG_SECS);
+	buf[0] = BIN2BCD(tm->tm_sec);
+	buf[1] = BIN2BCD(tm->tm_min);
+	buf[2] = rs5c_hr2reg(rs5c, tm->tm_hour);
+	buf[3] = BIN2BCD(tm->tm_wday);
+	buf[4] = BIN2BCD(tm->tm_mday);
+	buf[5] = BIN2BCD(tm->tm_mon + 1);
+	buf[6] = BIN2BCD(tm->tm_year - 100);
 
-	if ((i2c_master_send(client, buf, 8)) != 8) {
+	if (i2c_smbus_write_i2c_block_data(client, addr, sizeof(buf), buf) < 0) {
 		dev_err(&client->dev, "%s: write error\n", __func__);
 		return -EIO;
 	}
@@ -266,16 +284,16 @@ rs5c_rtc_ioctl(struct device *dev, unsig
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct rs5c372		*rs5c = i2c_get_clientdata(client);
-	unsigned char		buf[2];
-	int			status;
+	unsigned char		buf;
+	int			status, addr;
 
-	buf[1] = rs5c->regs[RS5C_REG_CTRL1];
+	buf = rs5c->regs[RS5C_REG_CTRL1];
 	switch (cmd) {
 	case RTC_UIE_OFF:
 	case RTC_UIE_ON:
 		/* some 327a modes use a different IRQ pin for 1Hz irqs */
 		if (rs5c->type == rtc_rs5c372a
-				&& (buf[1] & RS5C372A_CTRL1_SL1))
+				&& (buf & RS5C372A_CTRL1_SL1))
 			return -ENOIOCTLCMD;
 	case RTC_AIE_OFF:
 	case RTC_AIE_ON:
@@ -293,28 +311,30 @@ rs5c_rtc_ioctl(struct device *dev, unsig
 	if (status < 0)
 		return status;
 
-	buf[0] = RS5C_ADDR(RS5C_REG_CTRL1);
+	addr = RS5C_ADDR(RS5C_REG_CTRL1);
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
-		buf[1] &= ~RS5C_CTRL1_AALE;
+		buf &= ~RS5C_CTRL1_AALE;
 		break;
 	case RTC_AIE_ON:	/* alarm on */
-		buf[1] |= RS5C_CTRL1_AALE;
+		buf |= RS5C_CTRL1_AALE;
 		break;
 	case RTC_UIE_OFF:	/* update off */
-		buf[1] &= ~RS5C_CTRL1_CT_MASK;
+		buf &= ~RS5C_CTRL1_CT_MASK;
 		break;
 	case RTC_UIE_ON:	/* update on */
-		buf[1] &= ~RS5C_CTRL1_CT_MASK;
-		buf[1] |= RS5C_CTRL1_CT4;
+		buf &= ~RS5C_CTRL1_CT_MASK;
+		buf |= RS5C_CTRL1_CT4;
 		break;
 	}
-	if ((i2c_master_send(client, buf, 2)) != 2) {
+
+	if (i2c_smbus_write_byte_data(client, addr, buf) < 0) {
 		printk(KERN_WARNING "%s: can't update alarm\n",
 			rs5c->rtc->name);
 		status = -EIO;
 	} else
-		rs5c->regs[RS5C_REG_CTRL1] = buf[1];
+		rs5c->regs[RS5C_REG_CTRL1] = buf;
+
 	return status;
 }
 
@@ -364,8 +384,8 @@ static int rs5c_set_alarm(struct device 
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct rs5c372		*rs5c = i2c_get_clientdata(client);
-	int			status;
-	unsigned char		buf[4];
+	int			status, addr, i;
+	unsigned char		buf[3];
 
 	/* only handle up to 24 hours in the future, like RTC_ALM_SET */
 	if (t->time.tm_mday != -1
@@ -380,33 +400,36 @@ static int rs5c_set_alarm(struct device 
 	if (status < 0)
 		return status;
 	if (rs5c->regs[RS5C_REG_CTRL1] & RS5C_CTRL1_AALE) {
-		buf[0] = RS5C_ADDR(RS5C_REG_CTRL1);
-		buf[1] = rs5c->regs[RS5C_REG_CTRL1] & ~RS5C_CTRL1_AALE;
-		if (i2c_master_send(client, buf, 2) != 2) {
+		addr = RS5C_ADDR(RS5C_REG_CTRL1);
+		buf[0] = rs5c->regs[RS5C_REG_CTRL1] & ~RS5C_CTRL1_AALE;
+		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0) {
 			pr_debug("%s: can't disable alarm\n", rs5c->rtc->name);
 			return -EIO;
 		}
-		rs5c->regs[RS5C_REG_CTRL1] = buf[1];
+		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
 	}
 
 	/* set alarm */
-	buf[0] = RS5C_ADDR(RS5C_REG_ALARM_A_MIN);
-	buf[1] = BIN2BCD(t->time.tm_min);
-	buf[2] = rs5c_hr2reg(rs5c, t->time.tm_hour);
-	buf[3] = 0x7f;	/* any/all days */
-	if ((i2c_master_send(client, buf, 4)) != 4) {
-		pr_debug("%s: can't set alarm time\n", rs5c->rtc->name);
-		return -EIO;
+	buf[0] = BIN2BCD(t->time.tm_min);
+	buf[1] = rs5c_hr2reg(rs5c, t->time.tm_hour);
+	buf[2] = 0x7f;	/* any/all days */
+
+	for (i = 0; i < sizeof(buf); i++) {
+		addr = RS5C_ADDR(RS5C_REG_ALARM_A_MIN + i);
+		if (i2c_smbus_write_byte_data(client, addr, buf[i]) < 0) {
+			pr_debug("%s: can't set alarm time\n", rs5c->rtc->name);
+			return -EIO;
+		}
 	}
 
 	/* ... and maybe enable its irq */
 	if (t->enabled) {
-		buf[0] = RS5C_ADDR(RS5C_REG_CTRL1);
-		buf[1] = rs5c->regs[RS5C_REG_CTRL1] | RS5C_CTRL1_AALE;
-		if ((i2c_master_send(client, buf, 2)) != 2)
+		addr = RS5C_ADDR(RS5C_REG_CTRL1);
+		buf[0] = rs5c->regs[RS5C_REG_CTRL1] | RS5C_CTRL1_AALE;
+		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0)
 			printk(KERN_WARNING "%s: can't enable alarm\n",
 				rs5c->rtc->name);
-		rs5c->regs[RS5C_REG_CTRL1] = buf[1];
+		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
 	}
 
 	return 0;
@@ -503,18 +526,74 @@ static void rs5c_sysfs_unregister(struct
 
 static struct i2c_driver rs5c372_driver;
 
+static int rs5c_oscillator_setup(struct rs5c372 *rs5c372)
+{
+	unsigned char buf[2];
+	int addr, i, ret = 0;
+
+	if (!(rs5c372->regs[RS5C_REG_CTRL2] & RS5C_CTRL2_XSTP))
+		return ret;
+	rs5c372->regs[RS5C_REG_CTRL2] &= ~RS5C_CTRL2_XSTP;
+
+	addr   = RS5C_ADDR(RS5C_REG_CTRL1);
+	buf[0] = rs5c372->regs[RS5C_REG_CTRL1];
+	buf[1] = rs5c372->regs[RS5C_REG_CTRL2];
+
+	/* use 24hr mode */
+	switch (rs5c372->type) {
+	case rtc_rs5c372a:
+	case rtc_rs5c372b:
+		buf[1] |= RS5C372_CTRL2_24;
+		rs5c372->time24 = 1;
+		break;
+	case rtc_rv5c386:
+	case rtc_rv5c387a:
+		buf[0] |= RV5C387_CTRL1_24;
+		rs5c372->time24 = 1;
+		break;
+	default:
+		/* impossible */
+		break;
+	}
+
+	for (i = 0; i < sizeof(buf); i++) {
+		addr = RS5C_ADDR(RS5C_REG_CTRL1 + i);
+		ret = i2c_smbus_write_byte_data(rs5c372->client, addr, buf[i]);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	rs5c372->regs[RS5C_REG_CTRL1] = buf[0];
+	rs5c372->regs[RS5C_REG_CTRL2] = buf[1];
+
+	return 0;
+}
+
 static int rs5c372_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	int err = 0;
+	int smbus_mode = 0;
 	struct rs5c372 *rs5c372;
 	struct rtc_time tm;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		err = -ENODEV;
-		goto exit;
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
+			I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		/*
+		 * If we don't have any master mode adapter, try breaking
+		 * it down in to the barest of capabilities.
+		 */
+		if (i2c_check_functionality(client->adapter,
+				I2C_FUNC_SMBUS_BYTE_DATA |
+				I2C_FUNC_SMBUS_I2C_BLOCK))
+			smbus_mode = 1;
+		else {
+			/* Still no good, give up */
+			err = -ENODEV;
+			goto exit;
+		}
 	}
 
 	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
@@ -528,6 +607,7 @@ static int rs5c372_probe(struct i2c_clie
 
 	/* we read registers 0x0f then 0x00-0x0f; skip the first one */
 	rs5c372->regs = &rs5c372->buf[1];
+	rs5c372->smbus = smbus_mode;
 
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
@@ -559,38 +639,10 @@ static int rs5c372_probe(struct i2c_clie
 	/* if the oscillator lost power and no other software (like
 	 * the bootloader) set it up, do it here.
 	 */
-	if (rs5c372->regs[RS5C_REG_CTRL2] & RS5C_CTRL2_XSTP) {
-		unsigned char buf[3];
-
-		rs5c372->regs[RS5C_REG_CTRL2] &= ~RS5C_CTRL2_XSTP;
-
-		buf[0] = RS5C_ADDR(RS5C_REG_CTRL1);
-		buf[1] = rs5c372->regs[RS5C_REG_CTRL1];
-		buf[2] = rs5c372->regs[RS5C_REG_CTRL2];
-
-		/* use 24hr mode */
-		switch (rs5c372->type) {
-		case rtc_rs5c372a:
-		case rtc_rs5c372b:
-			buf[2] |= RS5C372_CTRL2_24;
-			rs5c372->time24 = 1;
-			break;
-		case rtc_rv5c386:
-		case rtc_rv5c387a:
-			buf[1] |= RV5C387_CTRL1_24;
-			rs5c372->time24 = 1;
-			break;
-		default:
-			/* impossible */
-			break;
-		}
-
-		if ((i2c_master_send(client, buf, 3)) != 3) {
-			dev_err(&client->dev, "setup error\n");
-			goto exit_kfree;
-		}
-		rs5c372->regs[RS5C_REG_CTRL1] = buf[1];
-		rs5c372->regs[RS5C_REG_CTRL2] = buf[2];
+	err = rs5c_oscillator_setup(rs5c372);
+	if (unlikely(err < 0)) {
+		dev_err(&client->dev, "setup error\n");
+		goto exit_kfree;
 	}
 
 	if (rs5c372_get_datetime(client, &tm) < 0)
@@ -667,7 +719,8 @@ module_exit(rs5c372_exit);
 
 MODULE_AUTHOR(
 		"Pavel Mironchik <pmironchik@optifacio.net>, "
-		"Alessandro Zummo <a.zummo@towertech.it>");
+		"Alessandro Zummo <a.zummo@towertech.it>, "
+		"Paul Mundt <lethal@linux-sh.org>");
 MODULE_DESCRIPTION("Ricoh RS5C372 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch

