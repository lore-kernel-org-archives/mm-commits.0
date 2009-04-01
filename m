From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-true-smbus-compatibility.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:07 -0700
Message-ID: <200904011842.n31Ig7GI009581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933565AbZDASrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eswierk@aristanetworks.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, khali@linux-fr.org, sbarre@sdelcc.com, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1307: true SMBus compatibility
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-true-smbus-compatibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1307: true SMBus compatibility
From: Ed Swierk <eswierk@aristanetworks.com>

Allow the rtc-ds1307 driver to work with SMBus controllers like nforce2
that do not support i2c block transfers.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: BARRE Sebastien <sbarre@sdelcc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  109 ++++++++++++++++++++++++++++++++-----
 1 file changed, 97 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-true-smbus-compatibility drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-true-smbus-compatibility
+++ a/drivers/rtc/rtc-ds1307.c
@@ -94,6 +94,10 @@ struct ds1307 {
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
 	struct work_struct	work;
+	s32 (*read_block_data)(struct i2c_client *client, u8 command,
+			       u8 length, u8 *values);
+	s32 (*write_block_data)(struct i2c_client *client, u8 command,
+				u8 length, const u8 *values);
 };
 
 struct chip_desc {
@@ -132,6 +136,79 @@ MODULE_DEVICE_TABLE(i2c, ds1307_id);
 
 /*----------------------------------------------------------------------*/
 
+#define BLOCK_DATA_MAX_TRIES 10
+
+static s32 ds1307_read_block_data_once(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	s32 i, data;
+
+	for (i = 0; i < length; i++) {
+		data = i2c_smbus_read_byte_data(client, command + i);
+		if (data < 0)
+			return data;
+		values[i] = data;
+	}
+	return i;
+}
+
+static s32 ds1307_read_block_data(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	u8 oldvalues[I2C_SMBUS_BLOCK_MAX];
+	s32 ret;
+	int tries = 0;
+
+	dev_dbg(&client->dev, "ds1307_read_block_data (length=%d)\n", length);
+	ret = ds1307_read_block_data_once(client, command, length, values);
+	if (ret < 0)
+		return ret;
+	do {
+		if (++tries > BLOCK_DATA_MAX_TRIES) {
+			dev_err(&client->dev,
+				"ds1307_read_block_data failed\n");
+			return -EIO;
+		}
+		memcpy(oldvalues, values, length);
+		ret = ds1307_read_block_data_once(client, command, length,
+						  values);
+		if (ret < 0)
+			return ret;
+	} while (memcmp(oldvalues, values, length));
+	return length;
+}
+
+static s32 ds1307_write_block_data(struct i2c_client *client, u8 command,
+				   u8 length, const u8 *values)
+{
+	u8 currvalues[I2C_SMBUS_BLOCK_MAX];
+	int tries = 0;
+
+	dev_dbg(&client->dev, "ds1307_write_block_data (length=%d)\n", length);
+	do {
+		s32 i, ret;
+
+		if (++tries > BLOCK_DATA_MAX_TRIES) {
+			dev_err(&client->dev,
+				"ds1307_write_block_data failed\n");
+			return -EIO;
+		}
+		for (i = 0; i < length; i++) {
+			ret = i2c_smbus_write_byte_data(client, command + i,
+							values[i]);
+			if (ret < 0)
+				return ret;
+		}
+		ret = ds1307_read_block_data_once(client, command, length,
+						  currvalues);
+		if (ret < 0)
+			return ret;
+	} while (memcmp(currvalues, values, length));
+	return length;
+}
+
+/*----------------------------------------------------------------------*/
+
 /*
  * The IRQ logic includes a "real" handler running in IRQ context just
  * long enough to schedule this workqueue entry.   We need a task context
@@ -202,7 +279,7 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+	tmp = ds1307->read_block_data(ds1307->client,
 		DS1307_REG_SECS, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
@@ -279,7 +356,7 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = i2c_smbus_write_i2c_block_data(ds1307->client, 0, 7, buf);
+	result = ds1307->write_block_data(ds1307->client, 0, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
 		return result;
@@ -297,7 +374,7 @@ static int ds1337_read_alarm(struct devi
 		return -EINVAL;
 
 	/* read all ALARM1, ALARM2, and status registers at once */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307->read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, ds1307->regs);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm read", ret);
@@ -356,7 +433,7 @@ static int ds1337_set_alarm(struct devic
 		t->enabled, t->pending);
 
 	/* read current status of both alarms and the chip */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307->read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm write", ret);
@@ -391,7 +468,7 @@ static int ds1337_set_alarm(struct devic
 	}
 	buf[8] = status & ~(DS1337_BIT_A1I | DS1337_BIT_A2I);
 
-	ret = i2c_smbus_write_i2c_block_data(client,
+	ret = ds1307->write_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret < 0) {
 		dev_err(dev, "can't set alarm time\n");
@@ -479,7 +556,7 @@ ds1307_nvram_read(struct kobject *kobj, 
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_read_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, 8 + off, count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -490,9 +567,11 @@ ds1307_nvram_write(struct kobject *kobj,
 		char *buf, loff_t off, size_t count)
 {
 	struct i2c_client	*client;
+	struct ds1307		*ds1307;
 	int			result;
 
 	client = kobj_to_i2c_client(kobj);
+	ds1307 = i2c_get_clientdata(client);
 
 	if (unlikely(off >= NVRAM_SIZE))
 		return -EFBIG;
@@ -501,7 +580,7 @@ ds1307_nvram_write(struct kobject *kobj,
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_write_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, 8 + off, count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -535,9 +614,8 @@ static int __devinit ds1307_probe(struct
 	int			want_irq = false;
 	unsigned char		*buf;
 
-	if (!i2c_check_functionality(adapter,
-			I2C_FUNC_SMBUS_WRITE_BYTE_DATA |
-			I2C_FUNC_SMBUS_I2C_BLOCK))
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)
+	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
@@ -547,6 +625,13 @@ static int __devinit ds1307_probe(struct
 	i2c_set_clientdata(client, ds1307);
 	ds1307->type = id->driver_data;
 	buf = ds1307->regs;
+	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		ds1307->read_block_data = i2c_smbus_read_i2c_block_data;
+		ds1307->write_block_data = i2c_smbus_write_i2c_block_data;
+	} else {
+		ds1307->read_block_data = ds1307_read_block_data;
+		ds1307->write_block_data = ds1307_write_block_data;
+	}
 
 	switch (ds1307->type) {
 	case ds_1337:
@@ -557,7 +642,7 @@ static int __devinit ds1307_probe(struct
 			want_irq = true;
 		}
 		/* get registers that the "rtc" read below won't read... */
-		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		tmp = ds1307->read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -595,7 +680,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307->read_block_data(ds1307->client, 0, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
_

Patches currently in -mm which might be from eswierk@aristanetworks.com are

origin.patch

