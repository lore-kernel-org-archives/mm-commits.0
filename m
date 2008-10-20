From: akpm@linux-foundation.org
Subject: + rtc-ds1307-smbus-compatibility.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:10:44 -0700
Message-ID: <200810202310.m9KNAiB7007063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbYJTXLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sbarre@sdelcc.com, a.zummo@towertech.it, david-b@pacbell.net, giometti@enneenne.com, khali@linux-fr.org


The patch titled
     rtc-ds1307: SMBus compatibility
has been added to the -mm tree.  Its filename is
     rtc-ds1307-smbus-compatibility.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1307: SMBus compatibility
From: BARRE Sebastien <sbarre@sdelcc.com>

Change i2c access functions to SMBus access functions in order to use the
ds1307 with SMBus adapter.

Signed-off-by: Sebastien Barre <sbarre@sdelcc.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  123 ++++++++++---------------------------
 1 file changed, 35 insertions(+), 88 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-smbus-compatibility drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-smbus-compatibility
+++ a/drivers/rtc/rtc-ds1307.c
@@ -86,13 +86,11 @@ enum ds_type {
 
 
 struct ds1307 {
-	u8			reg_addr;
 	u8			regs[11];
 	enum ds_type		type;
 	unsigned long		flags;
 #define HAS_NVRAM	0		/* bit 0 == sysfs file active */
 #define HAS_ALARM	1		/* bit 1 == irq claimed */
-	struct i2c_msg		msg[2];
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
 	struct work_struct	work;
@@ -204,13 +202,9 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	ds1307->reg_addr = 0;
-	ds1307->msg[1].flags = I2C_M_RD;
-	ds1307->msg[1].len = 7;
-
-	tmp = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
-			ds1307->msg, 2);
-	if (tmp != 2) {
+	tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		DS1307_REG_SECS, 7, ds1307->regs);
+	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
 		return -EIO;
 	}
@@ -257,7 +251,6 @@ static int ds1307_set_time(struct device
 		t->tm_hour, t->tm_mday,
 		t->tm_mon, t->tm_year, t->tm_wday);
 
-	*buf++ = 0;		/* first register addr */
 	buf[DS1307_REG_SECS] = bin2bcd(t->tm_sec);
 	buf[DS1307_REG_MIN] = bin2bcd(t->tm_min);
 	buf[DS1307_REG_HOUR] = bin2bcd(t->tm_hour);
@@ -282,18 +275,14 @@ static int ds1307_set_time(struct device
 		break;
 	}
 
-	ds1307->msg[1].flags = 0;
-	ds1307->msg[1].len = 8;
-
 	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
-			&ds1307->msg[1], 1);
-	if (result != 1) {
-		dev_err(dev, "%s error %d\n", "write", tmp);
-		return -EIO;
+	result = i2c_smbus_write_i2c_block_data(ds1307->client, 0, 7, buf);
+	if (result < 0) {
+		dev_err(dev, "%s error %d\n", "write", result);
+		return result;
 	}
 	return 0;
 }
@@ -308,13 +297,9 @@ static int ds1307_read_alarm(struct devi
 		return -EINVAL;
 
 	/* read all ALARM1, ALARM2, and status registers at once */
-	ds1307->reg_addr = DS1339_REG_ALARM1_SECS;
-	ds1307->msg[1].flags = I2C_M_RD;
-	ds1307->msg[1].len = 9;
-
-	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
-			ds1307->msg, 2);
-	if (ret != 2) {
+	ret = i2c_smbus_read_i2c_block_data(client,
+			DS1339_REG_ALARM1_SECS, 9, ds1307->regs);
+	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm read", ret);
 		return -EIO;
 	}
@@ -371,13 +356,9 @@ static int ds1307_set_alarm(struct devic
 		t->enabled, t->pending);
 
 	/* read current status of both alarms and the chip */
-	ds1307->reg_addr = DS1339_REG_ALARM1_SECS;
-	ds1307->msg[1].flags = I2C_M_RD;
-	ds1307->msg[1].len = 9;
-
-	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
-			ds1307->msg, 2);
-	if (ret != 2) {
+	ret = i2c_smbus_read_i2c_block_data(client,
+			DS1339_REG_ALARM1_SECS, 9, buf);
+	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm write", ret);
 		return -EIO;
 	}
@@ -392,7 +373,6 @@ static int ds1307_set_alarm(struct devic
 			ds1307->regs[6], control, status);
 
 	/* set ALARM1, using 24 hour and day-of-month modes */
-	*buf++ = DS1339_REG_ALARM1_SECS;	/* first register addr */
 	buf[0] = bin2bcd(t->time.tm_sec);
 	buf[1] = bin2bcd(t->time.tm_min);
 	buf[2] = bin2bcd(t->time.tm_hour);
@@ -411,14 +391,11 @@ static int ds1307_set_alarm(struct devic
 	}
 	buf[8] = status & ~(DS1337_BIT_A1I | DS1337_BIT_A2I);
 
-	ds1307->msg[1].flags = 0;
-	ds1307->msg[1].len = 10;
-
-	ret = i2c_transfer(to_i2c_adapter(client->dev.parent),
-			&ds1307->msg[1], 1);
-	if (ret != 1) {
+	ret = i2c_smbus_write_i2c_block_data(client,
+			DS1339_REG_ALARM1_SECS, 9, buf);
+	if (ret < 0) {
 		dev_err(dev, "can't set alarm time\n");
-		return -EIO;
+		return ret;
 	}
 
 	return 0;
@@ -490,7 +467,6 @@ ds1307_nvram_read(struct kobject *kobj, 
 {
 	struct i2c_client	*client;
 	struct ds1307		*ds1307;
-	struct i2c_msg		msg[2];
 	int			result;
 
 	client = kobj_to_i2c_client(kobj);
@@ -503,24 +479,10 @@ ds1307_nvram_read(struct kobject *kobj, 
 	if (unlikely(!count))
 		return count;
 
-	msg[0].addr = client->addr;
-	msg[0].flags = 0;
-	msg[0].len = 1;
-	msg[0].buf = buf;
-
-	buf[0] = 8 + off;
-
-	msg[1].addr = client->addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].len = count;
-	msg[1].buf = buf;
-
-	result = i2c_transfer(to_i2c_adapter(client->dev.parent), msg, 2);
-	if (result != 2) {
+	result = i2c_smbus_read_i2c_block_data(client, 8 + off, count, buf);
+	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
-		return -EIO;
-	}
-	return count;
+	return result;
 }
 
 static ssize_t
@@ -528,8 +490,7 @@ ds1307_nvram_write(struct kobject *kobj,
 		char *buf, loff_t off, size_t count)
 {
 	struct i2c_client	*client;
-	u8			buffer[NVRAM_SIZE + 1];
-	int			ret;
+	int			result;
 
 	client = kobj_to_i2c_client(kobj);
 
@@ -540,11 +501,12 @@ ds1307_nvram_write(struct kobject *kobj,
 	if (unlikely(!count))
 		return count;
 
-	buffer[0] = 8 + off;
-	memcpy(buffer + 1, buf, count);
-
-	ret = i2c_master_send(client, buffer, count + 1);
-	return (ret < 0) ? ret : (ret - 1);
+	result = i2c_smbus_write_i2c_block_data(client, 8 + off, count, buf);
+	if (result < 0) {
+		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
+		return result;
+	}
+	return count;
 }
 
 static struct bin_attribute nvram = {
@@ -571,9 +533,11 @@ static int __devinit ds1307_probe(struct
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
+	unsigned char		*buf;
 
 	if (!i2c_check_functionality(adapter,
-			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+			I2C_FUNC_SMBUS_WRITE_BYTE_DATA |
+			I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
@@ -581,18 +545,8 @@ static int __devinit ds1307_probe(struct
 
 	ds1307->client = client;
 	i2c_set_clientdata(client, ds1307);
-
-	ds1307->msg[0].addr = client->addr;
-	ds1307->msg[0].flags = 0;
-	ds1307->msg[0].len = 1;
-	ds1307->msg[0].buf = &ds1307->reg_addr;
-
-	ds1307->msg[1].addr = client->addr;
-	ds1307->msg[1].flags = I2C_M_RD;
-	ds1307->msg[1].len = sizeof(ds1307->regs);
-	ds1307->msg[1].buf = ds1307->regs;
-
 	ds1307->type = id->driver_data;
+	buf = ds1307->regs;
 
 	switch (ds1307->type) {
 	case ds_1337:
@@ -602,21 +556,15 @@ static int __devinit ds1307_probe(struct
 			INIT_WORK(&ds1307->work, ds1307_work);
 			want_irq = true;
 		}
-
-		ds1307->reg_addr = DS1337_REG_CONTROL;
-		ds1307->msg[1].len = 2;
-
 		/* get registers that the "rtc" read below won't read... */
-		tmp = i2c_transfer(adapter, ds1307->msg, 2);
+		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
 			err = -EIO;
 			goto exit_free;
 		}
 
-		ds1307->reg_addr = 0;
-		ds1307->msg[1].len = sizeof(ds1307->regs);
-
 		/* oscillator off?  turn it on, so clock can tick. */
 		if (ds1307->regs[0] & DS1337_BIT_nEOSC)
 			ds1307->regs[0] &= ~DS1337_BIT_nEOSC;
@@ -647,9 +595,8 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
