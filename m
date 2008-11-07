From: akpm@linux-foundation.org
Subject: + rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-update.patch added to -mm tree
Date: Thu, 06 Nov 2008 17:19:13 -0800
Message-ID: <200811070119.mA71JEnZ005984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbYKGBUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: martyn.welch@gefanuc.com, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org


The patch titled
     rtc: improvements to the basic implementation of Epson RX-8581 I2C Real Time Clock
has been added to the -mm tree.  Its filename is
     rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-update.patch

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
Subject: rtc: improvements to the basic implementation of Epson RX-8581 I2C Real Time Clock
From: Martyn Welch <martyn.welch@gefanuc.com>

These improvements resolve the issues raised by Jean Delvare in the Epson
RX-8581 driver (thank you for your help):

 * Added linux/module.h include
 * Removed black line
 * Removed useless test in rx8581_remove
 * Us i2c_smbus_* functions rather than raw i2c messaging

Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8581.c |  127 ++++++++++++-------------------------
 1 file changed, 43 insertions(+), 84 deletions(-)

diff -puN drivers/rtc/rtc-rx8581.c~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-update drivers/rtc/rtc-rx8581.c
--- a/drivers/rtc/rtc-rx8581.c~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-update
+++ a/drivers/rtc/rtc-rx8581.c
@@ -12,6 +12,7 @@
  * Copyright 2005-06 Tower Technologies
  */
 
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/bcd.h>
 #include <linux/rtc.h>
@@ -59,66 +60,49 @@ static struct i2c_driver rx8581_driver;
  */
 static int rx8581_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	unsigned char date[7] = { RX8581_REG_SC };
-	unsigned char flags = RX8581_REG_FLAG;
-	int err;
+	unsigned char date[7];
+	int data, err;
 
 	/* First we ensure that the "update flag" is not set, we read the
 	 * time and date then re-read the "update flag". If the update flag
 	 * has been set, we know that the time has changed during the read so
 	 * we repeat the whole process again.
 	 */
-	/* Read flag register */
-	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, &flags },		/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &flags },	/* read flags */
-	};
-
-	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __func__);
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_FLAG);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read device flags\n");
 		return -EIO;
 	}
 
 	do {
-
 		/* If update flag set, clear it */
-		if (flags & RX8581_FLAG_UF) {
-			unsigned char data[2] = { RX8581_REG_FLAG,
-				(flags & ~RX8581_FLAG_UF) };
-
-			err = i2c_master_send(client, data, sizeof(data));
-			if (err != sizeof(data)) {
-				dev_err(&client->dev,
-					"%s: err=%d addr=%02x, data=%02x\n",
-					__func__, err, data[0], data[1]);
+		if (data & RX8581_FLAG_UF) {
+			err = i2c_smbus_write_byte_data(client,
+				RX8581_REG_FLAG, (data & ~RX8581_FLAG_UF));
+			if (err != 0) {
+				dev_err(&client->dev, "Unable to write device "
+					"flags\n");
 				return -EIO;
 			}
 		}
 
 		/* Now read time and date */
-		date[0] = RX8581_REG_SC;
-		msgs[0].buf = date;
-		msgs[1].buf = date;
-		msgs[1].len = 7;
-
-		if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-			dev_err(&client->dev, "%s: read error\n", __func__);
+		err = i2c_smbus_read_i2c_block_data(client, RX8581_REG_SC,
+			7, date);
+		if (err < 0) {
+			dev_err(&client->dev, "Unable to read date\n");
 			return -EIO;
 		}
 
 		/* Check flag register */
-		flags = RX8581_REG_FLAG;
-		msgs[0].buf = &flags;
-		msgs[1].buf = &flags;
-		msgs[1].len = 1;
-
-		if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-			dev_err(&client->dev, "%s: read error\n", __func__);
+		data = i2c_smbus_read_byte_data(client, RX8581_REG_FLAG);
+		if (data < 0) {
+			dev_err(&client->dev, "Unable to read device flags\n");
 			return -EIO;
 		}
-	} while (flags & RX8581_FLAG_UF);
+	} while (data & RX8581_FLAG_UF);
 
-	if (flags & RX8581_FLAG_VLF)
+	if (data & RX8581_FLAG_VLF)
 		dev_info(&client->dev,
 			"low voltage detected, date/time is not reliable.\n");
 
@@ -154,14 +138,8 @@ static int rx8581_get_datetime(struct i2
 
 static int rx8581_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	int i, err;
-	unsigned char buf[9];
-	unsigned char ctrl = RX8581_REG_CTRL;
-	unsigned char data[2];
-	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, &ctrl },		/* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &ctrl },	/* read flags */
-	};
+	int data, err;
+	unsigned char buf[7];
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -184,55 +162,37 @@ static int rx8581_set_datetime(struct i2
 	buf[RX8581_REG_DW] = (0x1 << tm->tm_wday);
 
 	/* Stop the clock */
-	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __func__);
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_CTRL);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read control register\n");
 		return -EIO;
 	}
 
-	data[0] = RX8581_REG_CTRL;
-	data[1] = (ctrl | RX8581_CTRL_STOP);
-
-	err = i2c_master_send(client, data, sizeof(data));
-	if (err != sizeof(data)) {
-		dev_err(&client->dev,
-			"%s: err=%d addr=%02x, data=%02x\n",
-			__func__, err, data[0], data[1]);
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+		(data | RX8581_CTRL_STOP));
+	if (err < 0) {
+		dev_err(&client->dev, "Unable to write control register\n");
 		return -EIO;
 	}
 
 	/* write register's data */
-	for (i = 0; i < 7; i++) {
-		data[0] = RX8581_REG_SC + i;
-		data[1] = buf[RX8581_REG_SC + i];
-
-		err = i2c_master_send(client, data, sizeof(data));
-		if (err != sizeof(data)) {
-			dev_err(&client->dev,
-				"%s: err=%d addr=%02x, data=%02x\n",
-				__func__, err, data[0], data[1]);
-			return -EIO;
-		}
-	};
+	err = i2c_smbus_write_i2c_block_data(client, RX8581_REG_SC, 7, buf);
+	if (err < 0) {
+		dev_err(&client->dev, "Unable to write to date registers\n");
+		return -EIO;
+	}
 
 	/* Restart the clock */
-	ctrl = RX8581_REG_CTRL;
-
-	msgs[0].buf = &ctrl;
-	msgs[1].buf = &ctrl;
-
-	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __func__);
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_CTRL);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read control register\n");
 		return -EIO;
 	}
 
-	data[0] = RX8581_REG_CTRL;
-	data[1] = (ctrl & ~(RX8581_CTRL_STOP));
-
-	err = i2c_master_send(client, data, sizeof(data));
-	if (err != sizeof(data)) {
-		dev_err(&client->dev,
-			"%s: err=%d addr=%02x, data=%02x\n",
-			__func__, err, data[0], data[1]);
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+		(data | ~(RX8581_CTRL_STOP)));
+	if (err != 0) {
+		dev_err(&client->dev, "Unable to write control register\n");
 		return -EIO;
 	}
 
@@ -281,8 +241,7 @@ static int __devexit rx8581_remove(struc
 {
 	struct rtc_device *rtc = i2c_get_clientdata(client);
 
-	if (rtc)
-		rtc_device_unregister(rtc);
+	rtc_device_unregister(rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from martyn.welch@gefanuc.com are

rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-update.patch

