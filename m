From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-rx8581c-add-smbus-only-adapters-support.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:03:04 -0800
Message-ID: <52e2b8e8.R9HwyWNJrBTL+bYA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaAXTDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.werner@men.de

Subject: [merged] drivers-rtc-rtc-rx8581c-add-smbus-only-adapters-support.patch removed from -mm tree
To: andreas.werner@men.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:04 -0800


The patch titled
     Subject: drivers/rtc/rtc-rx8581.c: add SMBus-only adapters support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-rx8581c-add-smbus-only-adapters-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andreas Werner <andreas.werner@men.de>
Subject: drivers/rtc/rtc-rx8581.c: add SMBus-only adapters support

Add support for SMBus-only adapters (e.g.  i2c-piix4).  The driver has
implemented only support for I2C adapters which implement the
I2C_FUNC_SMBUS_I2C_BLOCK functionality before.

With this patch it is possible to load and use the RTC driver with I2C and
SMBUS adapters like the rtc-ds1307 does.

Tested on AMD G Series Platform (i2c-piix4 adapter driver).

Signed-off-by: Andreas Werner <andreas.werner@men.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8581.c |   81 +++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-rx8581.c~drivers-rtc-rtc-rx8581c-add-smbus-only-adapters-support drivers/rtc/rtc-rx8581.c
--- a/drivers/rtc/rtc-rx8581.c~drivers-rtc-rtc-rx8581c-add-smbus-only-adapters-support
+++ a/drivers/rtc/rtc-rx8581.c
@@ -52,8 +52,45 @@
 #define RX8581_CTRL_STOP	0x02 /* STOP bit */
 #define RX8581_CTRL_RESET	0x01 /* RESET bit */
 
+struct rx8581 {
+	struct i2c_client	*client;
+	struct rtc_device	*rtc;
+	s32 (*read_block_data)(const struct i2c_client *client, u8 command,
+				u8 length, u8 *values);
+	s32 (*write_block_data)(const struct i2c_client *client, u8 command,
+				u8 length, const u8 *values);
+};
+
 static struct i2c_driver rx8581_driver;
 
+static int rx8581_read_block_data(const struct i2c_client *client, u8 command,
+					u8 length, u8 *values)
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
+static int rx8581_write_block_data(const struct i2c_client *client, u8 command,
+					u8 length, const u8 *values)
+{
+	s32 i, ret;
+
+	for (i = 0; i < length; i++) {
+		ret = i2c_smbus_write_byte_data(client, command + i,
+						values[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return length;
+}
+
 /*
  * In the routines that deal directly with the rx8581 hardware, we use
  * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
@@ -62,6 +99,7 @@ static int rx8581_get_datetime(struct i2
 {
 	unsigned char date[7];
 	int data, err;
+	struct rx8581 *rx8581 = i2c_get_clientdata(client);
 
 	/* First we ensure that the "update flag" is not set, we read the
 	 * time and date then re-read the "update flag". If the update flag
@@ -80,14 +118,13 @@ static int rx8581_get_datetime(struct i2
 			err = i2c_smbus_write_byte_data(client,
 				RX8581_REG_FLAG, (data & ~RX8581_FLAG_UF));
 			if (err != 0) {
-				dev_err(&client->dev, "Unable to write device "
-					"flags\n");
+				dev_err(&client->dev, "Unable to write device flags\n");
 				return -EIO;
 			}
 		}
 
 		/* Now read time and date */
-		err = i2c_smbus_read_i2c_block_data(client, RX8581_REG_SC,
+		err = rx8581->read_block_data(client, RX8581_REG_SC,
 			7, date);
 		if (err < 0) {
 			dev_err(&client->dev, "Unable to read date\n");
@@ -140,6 +177,7 @@ static int rx8581_set_datetime(struct i2
 {
 	int data, err;
 	unsigned char buf[7];
+	struct rx8581 *rx8581 = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -176,7 +214,7 @@ static int rx8581_set_datetime(struct i2
 	}
 
 	/* write register's data */
-	err = i2c_smbus_write_i2c_block_data(client, RX8581_REG_SC, 7, buf);
+	err = rx8581->write_block_data(client, RX8581_REG_SC, 7, buf);
 	if (err < 0) {
 		dev_err(&client->dev, "Unable to write to date registers\n");
 		return -EIO;
@@ -231,22 +269,39 @@ static const struct rtc_class_ops rx8581
 static int rx8581_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct rtc_device *rtc;
+	struct rx8581	  *rx8581;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return -ENODEV;
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA)
+		&& !i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+		return -EIO;
+
+	rx8581 = devm_kzalloc(&client->dev, sizeof(struct rx8581), GFP_KERNEL);
+	if (!rx8581)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, rx8581);
+	rx8581->client = client;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		rx8581->read_block_data = i2c_smbus_read_i2c_block_data;
+		rx8581->write_block_data = i2c_smbus_write_i2c_block_data;
+	} else {
+		rx8581->read_block_data = rx8581_read_block_data;
+		rx8581->write_block_data = rx8581_write_block_data;
+	}
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = devm_rtc_device_register(&client->dev, rx8581_driver.driver.name,
-					&rx8581_rtc_ops, THIS_MODULE);
+	rx8581->rtc = devm_rtc_device_register(&client->dev,
+		rx8581_driver.driver.name, &rx8581_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
