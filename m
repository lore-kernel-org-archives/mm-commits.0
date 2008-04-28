From: akpm@linux-foundation.org
Subject: - rtc-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:27 -0700
Message-ID: <200804282150.m3SLoRd0017475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934590AbYD1Vuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     rtc-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   12 ++++-----
 drivers/rtc/rtc-at91sam9.c   |    2 -
 drivers/rtc/rtc-ds1302.c     |    2 -
 drivers/rtc/rtc-ds1672.c     |   14 +++++------
 drivers/rtc/rtc-max6900.c    |    6 ++--
 drivers/rtc/rtc-max6902.c    |    4 +--
 drivers/rtc/rtc-pcf8563.c    |   14 +++++------
 drivers/rtc/rtc-rs5c313.c    |    4 +--
 drivers/rtc/rtc-rs5c372.c    |   10 ++++----
 drivers/rtc/rtc-s3c.c        |    6 ++--
 drivers/rtc/rtc-sh.c         |    2 -
 drivers/rtc/rtc-v3020.c      |    4 +--
 drivers/rtc/rtc-x1205.c      |   40 ++++++++++++++++-----------------
 13 files changed, 60 insertions(+), 60 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -83,7 +83,7 @@ static int at91_rtc_readtime(struct devi
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = tm->tm_year - 1900;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
+	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -97,7 +97,7 @@ static int at91_rtc_settime(struct devic
 {
 	unsigned long cr;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
+	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -142,7 +142,7 @@ static int at91_rtc_readalarm(struct dev
 	alrm->enabled = (at91_sys_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
+	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -178,7 +178,7 @@ static int at91_rtc_setalarm(struct devi
 	if (alrm->enabled)
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
+	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
 		tm.tm_min, tm.tm_sec);
 
@@ -193,7 +193,7 @@ static int at91_rtc_ioctl(struct device 
 {
 	int ret = 0;
 
-	pr_debug("%s(): cmd=%08x, arg=%08lx.\n", __FUNCTION__, cmd, arg);
+	pr_debug("%s(): cmd=%08x, arg=%08lx.\n", __func__, cmd, arg);
 
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
@@ -265,7 +265,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 		rtc_update_irq(rtc, 1, events);
 
-		pr_debug("%s(): num=%ld, events=0x%02lx\n", __FUNCTION__,
+		pr_debug("%s(): num=%ld, events=0x%02lx\n", __func__,
 			events >> 8, events & 0x000000FF);
 
 		return IRQ_HANDLED;
diff -puN drivers/rtc/rtc-at91sam9.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -288,7 +288,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 	rtc_update_irq(rtc->rtcdev, 1, events);
 
-	pr_debug("%s: num=%ld, events=0x%02lx\n", __FUNCTION__,
+	pr_debug("%s: num=%ld, events=0x%02lx\n", __func__,
 		events >> 8, events & 0x000000FF);
 
 	return IRQ_HANDLED;
diff -puN drivers/rtc/rtc-ds1302.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-ds1302.c
@@ -122,7 +122,7 @@ static int ds1302_rtc_read_time(struct d
 
 	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon + 1, tm->tm_year, tm->tm_wday);
 
diff -puN drivers/rtc/rtc-ds1672.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-ds1672.c
@@ -50,13 +50,13 @@ static int ds1672_get_datetime(struct i2
 
 	/* read date registers */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
 	dev_dbg(&client->dev,
 		"%s: raw read data - counters=%02x,%02x,%02x,%02x\n",
-		__FUNCTION__, buf[0], buf[1], buf[2], buf[3]);
+		__func__, buf[0], buf[1], buf[2], buf[3]);
 
 	time = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
 
@@ -64,7 +64,7 @@ static int ds1672_get_datetime(struct i2
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__, tm->tm_sec, tm->tm_min, tm->tm_hour,
+		__func__, tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 	return 0;
@@ -84,7 +84,7 @@ static int ds1672_set_mmss(struct i2c_cl
 
 	xfer = i2c_master_send(client, buf, 6);
 	if (xfer != 6) {
-		dev_err(&client->dev, "%s: send: %d\n", __FUNCTION__, xfer);
+		dev_err(&client->dev, "%s: send: %d\n", __func__, xfer);
 		return -EIO;
 	}
 
@@ -98,7 +98,7 @@ static int ds1672_set_datetime(struct i2
 	dev_dbg(&client->dev,
 		"%s: secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -133,7 +133,7 @@ static int ds1672_get_control(struct i2c
 
 	/* read control register */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
@@ -199,7 +199,7 @@ static int ds1672_probe(struct i2c_adapt
 	struct i2c_client *client;
 	struct rtc_device *rtc;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&adapter->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-max6900.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-max6900.c
@@ -98,7 +98,7 @@ static int max6900_i2c_read_regs(struct 
 	rc = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
 	if (rc != ARRAY_SIZE(msgs)) {
 		dev_err(&client->dev, "%s: register read failed\n",
-			__FUNCTION__);
+			__func__);
 		return -EIO;
 	}
 	return 0;
@@ -150,7 +150,7 @@ static int max6900_i2c_write_regs(struct
 
 write_failed:
 	dev_err(&client->dev, "%s: register write failed\n",
-		__FUNCTION__);
+		__func__);
 	return -EIO;
 }
 
@@ -214,7 +214,7 @@ static int max6900_i2c_clear_write_prote
 	rc = i2c_smbus_write_byte_data (client, MAX6900_REG_CONTROL_WRITE, 0);
 	if (rc < 0) {
 		dev_err(&client->dev, "%s: control register write failed\n",
-			__FUNCTION__);
+			__func__);
 		return -EIO;
 	}
 	return 0;
diff -puN drivers/rtc/rtc-max6902.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-max6902.c
@@ -140,7 +140,7 @@ static int max6902_get_datetime(struct d
 	dt->tm_year -= 1900;
 
 #ifdef MAX6902_DEBUG
-	printk("\n%s : Read RTC values\n",__FUNCTION__);
+	printk("\n%s : Read RTC values\n",__func__);
 	printk("tm_hour: %i\n",dt->tm_hour);
 	printk("tm_min : %i\n",dt->tm_min);
 	printk("tm_sec : %i\n",dt->tm_sec);
@@ -158,7 +158,7 @@ static int max6902_set_datetime(struct d
 	dt->tm_year = dt->tm_year+1900;
 
 #ifdef MAX6902_DEBUG
-	printk("\n%s : Setting RTC values\n",__FUNCTION__);
+	printk("\n%s : Setting RTC values\n",__func__);
 	printk("tm_sec : %i\n",dt->tm_sec);
 	printk("tm_min : %i\n",dt->tm_min);
 	printk("tm_hour: %i\n",dt->tm_hour);
diff -puN drivers/rtc/rtc-pcf8563.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -80,7 +80,7 @@ static int pcf8563_get_datetime(struct i
 
 	/* read registers */
 	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
@@ -91,7 +91,7 @@ static int pcf8563_get_datetime(struct i
 	dev_dbg(&client->dev,
 		"%s: raw data is st1=%02x, st2=%02x, sec=%02x, min=%02x, hr=%02x, "
 		"mday=%02x, wday=%02x, mon=%02x, year=%02x\n",
-		__FUNCTION__,
+		__func__,
 		buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6], buf[7],
 		buf[8]);
@@ -112,7 +112,7 @@ static int pcf8563_get_datetime(struct i
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -133,7 +133,7 @@ static int pcf8563_set_datetime(struct i
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -163,7 +163,7 @@ static int pcf8563_set_datetime(struct i
 		if (err != sizeof(data)) {
 			dev_err(&client->dev,
 				"%s: err=%d addr=%02x, data=%02x\n",
-				__FUNCTION__, err, data[0], data[1]);
+				__func__, err, data[0], data[1]);
 			return -EIO;
 		}
 	};
@@ -208,7 +208,7 @@ static int pcf8563_validate_client(struc
 		if (xfer != ARRAY_SIZE(msgs)) {
 			dev_err(&client->dev,
 				"%s: could not read register 0x%02X\n",
-				__FUNCTION__, pattern[i].reg);
+				__func__, pattern[i].reg);
 
 			return -EIO;
 		}
@@ -220,7 +220,7 @@ static int pcf8563_validate_client(struc
 			dev_dbg(&client->dev,
 				"%s: pattern=%d, reg=%x, mask=0x%02x, min=%d, "
 				"max=%d, value=%d, raw=0x%02X\n",
-				__FUNCTION__, i, pattern[i].reg, pattern[i].mask,
+				__func__, i, pattern[i].reg, pattern[i].mask,
 				pattern[i].min, pattern[i].max,
 				value, buf);
 
diff -puN drivers/rtc/rtc-rs5c313.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -228,7 +228,7 @@ static int rs5c313_rtc_read_time(struct 
 		ndelay(700);	/* CE:L */
 
 		if (cnt++ > 100) {
-			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			dev_err(dev, "%s: timeout error\n", __func__);
 			return -EIO;
 		}
 	}
@@ -289,7 +289,7 @@ static int rs5c313_rtc_set_time(struct d
 		ndelay(700);	/* CE:L */
 
 		if (cnt++ > 100) {
-			dev_err(dev, "%s: timeout error\n", __FUNCTION__);
+			dev_err(dev, "%s: timeout error\n", __func__);
 			return -EIO;
 		}
 	}
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -166,7 +166,7 @@ static int rs5c372_get_datetime(struct i
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -181,7 +181,7 @@ static int rs5c372_set_datetime(struct i
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -195,7 +195,7 @@ static int rs5c372_set_datetime(struct i
 	buf[7] = BIN2BCD(tm->tm_year - 100);
 
 	if ((i2c_master_send(client, buf, 8)) != 8) {
-		dev_err(&client->dev, "%s: write error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: write error\n", __func__);
 		return -EIO;
 	}
 
@@ -220,7 +220,7 @@ static int rs5c372_get_trim(struct i2c_c
 		*osc = (tmp & RS5C372_TRIM_XSL) ? 32000 : 32768;
 
 	if (trim) {
-		dev_dbg(&client->dev, "%s: raw trim=%x\n", __FUNCTION__, tmp);
+		dev_dbg(&client->dev, "%s: raw trim=%x\n", __func__, tmp);
 		tmp &= RS5C372_TRIM_MASK;
 		if (tmp & 0x3e) {
 			int t = tmp & 0x3f;
@@ -500,7 +500,7 @@ static int rs5c372_probe(struct i2c_clie
 	struct rs5c372 *rs5c372;
 	struct rtc_time tm;
 
-	dev_dbg(&client->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&client->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-s3c.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-s3c.c
@@ -68,7 +68,7 @@ static void s3c_rtc_setaie(int to)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __FUNCTION__, to);
+	pr_debug("%s: aie=%d\n", __func__, to);
 
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
@@ -82,7 +82,7 @@ static void s3c_rtc_setpie(int to)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: pie=%d\n", __FUNCTION__, to);
+	pr_debug("%s: pie=%d\n", __func__, to);
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
 	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & ~S3C2410_TICNT_ENABLE;
@@ -457,7 +457,7 @@ static int s3c_rtc_probe(struct platform
 	struct resource *res;
 	int ret;
 
-	pr_debug("%s: probe=%p\n", __FUNCTION__, pdev);
+	pr_debug("%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 
diff -puN drivers/rtc/rtc-sh.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-sh.c
@@ -361,7 +361,7 @@ static int sh_rtc_read_time(struct devic
 
 	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon + 1, tm->tm_year, tm->tm_wday);
 
diff -puN drivers/rtc/rtc-v3020.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-v3020.c
@@ -107,7 +107,7 @@ static int v3020_read_time(struct device
 	dt->tm_year = BCD2BIN(tmp)+100;
 
 #ifdef DEBUG
-	printk("\n%s : Read RTC values\n",__FUNCTION__);
+	printk("\n%s : Read RTC values\n",__func__);
 	printk("tm_hour: %i\n",dt->tm_hour);
 	printk("tm_min : %i\n",dt->tm_min);
 	printk("tm_sec : %i\n",dt->tm_sec);
@@ -126,7 +126,7 @@ static int v3020_set_time(struct device 
 	struct v3020 *chip = dev_get_drvdata(dev);
 
 #ifdef DEBUG
-	printk("\n%s : Setting RTC values\n",__FUNCTION__);
+	printk("\n%s : Setting RTC values\n",__func__);
 	printk("tm_sec : %i\n",dt->tm_sec);
 	printk("tm_min : %i\n",dt->tm_min);
 	printk("tm_hour: %i\n",dt->tm_hour);
diff -puN drivers/rtc/rtc-x1205.c~rtc-replace-remaining-__function__-occurrences drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-replace-remaining-__function__-occurrences
+++ a/drivers/rtc/rtc-x1205.c
@@ -99,14 +99,14 @@ static int x1205_get_datetime(struct i2c
 
 	/* read date registers */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
 	dev_dbg(&client->dev,
 		"%s: raw read data - sec=%02x, min=%02x, hr=%02x, "
 		"mday=%02x, mon=%02x, year=%02x, wday=%02x, y2k=%02x\n",
-		__FUNCTION__,
+		__func__,
 		buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6], buf[7]);
 
@@ -121,7 +121,7 @@ static int x1205_get_datetime(struct i2c
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour,
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
@@ -139,7 +139,7 @@ static int x1205_get_status(struct i2c_c
 
 	/* read status register */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
@@ -162,7 +162,7 @@ static int x1205_set_datetime(struct i2c
 
 	dev_dbg(&client->dev,
 		"%s: secs=%d, mins=%d, hours=%d\n",
-		__FUNCTION__,
+		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour);
 
 	buf[CCR_SEC] = BIN2BCD(tm->tm_sec);
@@ -175,7 +175,7 @@ static int x1205_set_datetime(struct i2c
 	if (datetoo) {
 		dev_dbg(&client->dev,
 			"%s: mday=%d, mon=%d, year=%d, wday=%d\n",
-			__FUNCTION__,
+			__func__,
 			tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 		buf[CCR_MDAY] = BIN2BCD(tm->tm_mday);
@@ -191,12 +191,12 @@ static int x1205_set_datetime(struct i2c
 
 	/* this sequence is required to unlock the chip */
 	if ((xfer = i2c_master_send(client, wel, 3)) != 3) {
-		dev_err(&client->dev, "%s: wel - %d\n", __FUNCTION__, xfer);
+		dev_err(&client->dev, "%s: wel - %d\n", __func__, xfer);
 		return -EIO;
 	}
 
 	if ((xfer = i2c_master_send(client, rwel, 3)) != 3) {
-		dev_err(&client->dev, "%s: rwel - %d\n", __FUNCTION__, xfer);
+		dev_err(&client->dev, "%s: rwel - %d\n", __func__, xfer);
 		return -EIO;
 	}
 
@@ -208,7 +208,7 @@ static int x1205_set_datetime(struct i2c
 		if (xfer != 3) {
 			dev_err(&client->dev,
 				"%s: xfer=%d addr=%02x, data=%02x\n",
-				__FUNCTION__,
+				__func__,
 				 xfer, rdata[1], rdata[2]);
 			return -EIO;
 		}
@@ -216,7 +216,7 @@ static int x1205_set_datetime(struct i2c
 
 	/* disable further writes */
 	if ((xfer = i2c_master_send(client, diswe, 3)) != 3) {
-		dev_err(&client->dev, "%s: diswe - %d\n", __FUNCTION__, xfer);
+		dev_err(&client->dev, "%s: diswe - %d\n", __func__, xfer);
 		return -EIO;
 	}
 
@@ -249,11 +249,11 @@ static int x1205_get_dtrim(struct i2c_cl
 
 	/* read dtr register */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
-	dev_dbg(&client->dev, "%s: raw dtr=%x\n", __FUNCTION__, dtr);
+	dev_dbg(&client->dev, "%s: raw dtr=%x\n", __func__, dtr);
 
 	*trim = 0;
 
@@ -281,11 +281,11 @@ static int x1205_get_atrim(struct i2c_cl
 
 	/* read atr register */
 	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
+		dev_err(&client->dev, "%s: read error\n", __func__);
 		return -EIO;
 	}
 
-	dev_dbg(&client->dev, "%s: raw atr=%x\n", __FUNCTION__, atr);
+	dev_dbg(&client->dev, "%s: raw atr=%x\n", __func__, atr);
 
 	/* atr is a two's complement value on 6 bits,
 	 * perform sign extension. The formula is
@@ -294,11 +294,11 @@ static int x1205_get_atrim(struct i2c_cl
 	if (atr & 0x20)
 		atr |= 0xC0;
 
-	dev_dbg(&client->dev, "%s: raw atr=%x (%d)\n", __FUNCTION__, atr, atr);
+	dev_dbg(&client->dev, "%s: raw atr=%x (%d)\n", __func__, atr, atr);
 
 	*trim = (atr * 250) + 11000;
 
-	dev_dbg(&client->dev, "%s: real=%d\n", __FUNCTION__, *trim);
+	dev_dbg(&client->dev, "%s: real=%d\n", __func__, *trim);
 
 	return 0;
 }
@@ -352,7 +352,7 @@ static int x1205_validate_client(struct 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
-				__FUNCTION__, probe_zero_pattern[i]);
+				__func__, probe_zero_pattern[i]);
 
 			return -EIO;
 		}
@@ -360,7 +360,7 @@ static int x1205_validate_client(struct 
 		if ((buf & probe_zero_pattern[i+1]) != 0) {
 			dev_err(&client->dev,
 				"%s: register=%02x, zero pattern=%d, value=%x\n",
-				__FUNCTION__, probe_zero_pattern[i], i, buf);
+				__func__, probe_zero_pattern[i], i, buf);
 
 			return -ENODEV;
 		}
@@ -380,7 +380,7 @@ static int x1205_validate_client(struct 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
-				__FUNCTION__, probe_limits_pattern[i].reg);
+				__func__, probe_limits_pattern[i].reg);
 
 			return -EIO;
 		}
@@ -391,7 +391,7 @@ static int x1205_validate_client(struct 
 			value < probe_limits_pattern[i].min) {
 			dev_dbg(&client->dev,
 				"%s: register=%x, lim pattern=%d, value=%d\n",
-				__FUNCTION__, probe_limits_pattern[i].reg,
+				__func__, probe_limits_pattern[i].reg,
 				i, value);
 
 			return -ENODEV;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

