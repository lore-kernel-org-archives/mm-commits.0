From: akpm@linux-foundation.org
Subject: + rtc-max6900-new-style-driver.patch added to -mm tree
Date: Fri, 10 Oct 2008 19:45:39 -0700
Message-ID: <200810110245.m9B2jdDs002238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754669AbYJKCqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 22:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, dale@farnsworth.org, david-b@pacbell.net


The patch titled
     rtc-max6900 new style driver
has been added to the -mm tree.  Its filename is
     rtc-max6900-new-style-driver.patch

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
Subject: rtc-max6900 new style driver
From: Alessandro Zummo <alessandro.zummo@towertech.it>

New style conversion and reformatting as per indent --linux-style

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |  223 +++++++++++-------------------------
 1 file changed, 69 insertions(+), 154 deletions(-)

diff -puN drivers/rtc/rtc-max6900.c~rtc-max6900-new-style-driver drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-max6900-new-style-driver
+++ a/drivers/rtc/rtc-max6900.c
@@ -17,19 +17,18 @@
 #include <linux/rtc.h>
 #include <linux/delay.h>
 
-#define DRV_NAME "max6900"
-#define DRV_VERSION "0.1"
+#define DRV_VERSION "0.2"
 
 /*
  * register indices
  */
-#define MAX6900_REG_SC			0	/* seconds	00-59 */
-#define MAX6900_REG_MN			1	/* minutes	00-59 */
-#define MAX6900_REG_HR			2	/* hours	00-23 */
-#define MAX6900_REG_DT			3	/* day of month	00-31 */
-#define MAX6900_REG_MO			4	/* month	01-12 */
-#define MAX6900_REG_DW			5	/* day of week	 1-7  */
-#define MAX6900_REG_YR			6	/* year		00-99 */
+#define MAX6900_REG_SC			0	/* seconds      00-59 */
+#define MAX6900_REG_MN			1	/* minutes      00-59 */
+#define MAX6900_REG_HR			2	/* hours        00-23 */
+#define MAX6900_REG_DT			3	/* day of month 00-31 */
+#define MAX6900_REG_MO			4	/* month        01-12 */
+#define MAX6900_REG_DW			5	/* day of week   1-7  */
+#define MAX6900_REG_YR			6	/* year         00-99 */
 #define MAX6900_REG_CT			7	/* control */
 						/* register 8 is undocumented */
 #define MAX6900_REG_CENTURY		9	/* century */
@@ -39,7 +38,6 @@
 
 #define MAX6900_REG_CT_WP		(1 << 7)	/* Write Protect */
 
-
 /*
  * register read/write commands
  */
@@ -52,16 +50,7 @@
 
 #define MAX6900_IDLE_TIME_AFTER_WRITE	3	/* specification says 2.5 mS */
 
-#define MAX6900_I2C_ADDR		0xa0
-
-static const unsigned short normal_i2c[] = {
-	MAX6900_I2C_ADDR >> 1,
-	I2C_CLIENT_END
-};
-
-I2C_CLIENT_INSMOD;			/* defines addr_data */
-
-static int max6900_probe(struct i2c_adapter *adapter, int addr, int kind);
+static struct i2c_driver max6900_driver;
 
 static int max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
 {
@@ -69,36 +58,35 @@ static int max6900_i2c_read_regs(struct 
 	u8 reg_century_read[1] = { MAX6900_REG_CENTURY_READ };
 	struct i2c_msg msgs[4] = {
 		{
-			.addr	= client->addr,
-			.flags	= 0, /* write */
-			.len	= sizeof(reg_burst_read),
-			.buf	= reg_burst_read
-		},
+		 .addr = client->addr,
+		 .flags = 0,	/* write */
+		 .len = sizeof(reg_burst_read),
+		 .buf = reg_burst_read}
+		,
 		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= MAX6900_BURST_LEN,
-			.buf	= buf
-		},
+		 .addr = client->addr,
+		 .flags = I2C_M_RD,
+		 .len = MAX6900_BURST_LEN,
+		 .buf = buf}
+		,
 		{
-			.addr	= client->addr,
-			.flags	= 0, /* write */
-			.len	= sizeof(reg_century_read),
-			.buf	= reg_century_read
-		},
+		 .addr = client->addr,
+		 .flags = 0,	/* write */
+		 .len = sizeof(reg_century_read),
+		 .buf = reg_century_read}
+		,
 		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= sizeof(buf[MAX6900_REG_CENTURY]),
-			.buf	= &buf[MAX6900_REG_CENTURY]
-		}
+		 .addr = client->addr,
+		 .flags = I2C_M_RD,
+		 .len = sizeof(buf[MAX6900_REG_CENTURY]),
+		 .buf = &buf[MAX6900_REG_CENTURY]
+		 }
 	};
 	int rc;
 
 	rc = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
 	if (rc != ARRAY_SIZE(msgs)) {
-		dev_err(&client->dev, "%s: register read failed\n",
-			__func__);
+		dev_err(&client->dev, "%s: register read failed\n", __func__);
 		return -EIO;
 	}
 	return 0;
@@ -109,20 +97,18 @@ static int max6900_i2c_write_regs(struct
 	u8 i2c_century_buf[1 + 1] = { MAX6900_REG_CENTURY_WRITE };
 	struct i2c_msg century_msgs[1] = {
 		{
-			.addr	= client->addr,
-			.flags	= 0, /* write */
-			.len	= sizeof(i2c_century_buf),
-			.buf	= i2c_century_buf
-		}
+		 .addr = client->addr,
+		 .flags = 0,	/* write */
+		 .len = sizeof(i2c_century_buf),
+		 .buf = i2c_century_buf}
 	};
 	u8 i2c_burst_buf[MAX6900_BURST_LEN + 1] = { MAX6900_REG_BURST_WRITE };
 	struct i2c_msg burst_msgs[1] = {
 		{
-			.addr	= client->addr,
-			.flags	= 0, /* write */
-			.len	= sizeof(i2c_burst_buf),
-			.buf	= i2c_burst_buf
-		}
+		 .addr = client->addr,
+		 .flags = 0,	/* write */
+		 .len = sizeof(i2c_burst_buf),
+		 .buf = i2c_burst_buf}
 	};
 	int rc;
 
@@ -133,10 +119,12 @@ static int max6900_i2c_write_regs(struct
 	 * bit as part of the burst write.
 	 */
 	i2c_century_buf[1] = buf[MAX6900_REG_CENTURY];
+
 	rc = i2c_transfer(client->adapter, century_msgs,
 			  ARRAY_SIZE(century_msgs));
 	if (rc != ARRAY_SIZE(century_msgs))
 		goto write_failed;
+
 	msleep(MAX6900_IDLE_TIME_AFTER_WRITE);
 
 	memcpy(&i2c_burst_buf[1], buf, MAX6900_BURST_LEN);
@@ -148,45 +136,11 @@ static int max6900_i2c_write_regs(struct
 
 	return 0;
 
-write_failed:
-	dev_err(&client->dev, "%s: register write failed\n",
-		__func__);
+ write_failed:
+	dev_err(&client->dev, "%s: register write failed\n", __func__);
 	return -EIO;
 }
 
-static int max6900_i2c_validate_client(struct i2c_client *client)
-{
-	u8 regs[MAX6900_REG_LEN];
-	u8 zero_mask[] = {
-		0x80,	/* seconds */
-		0x80,	/* minutes */
-		0x40,	/* hours */
-		0xc0,	/* day of month */
-		0xe0,	/* month */
-		0xf8,	/* day of week */
-		0x00,	/* year */
-		0x7f,	/* control */
-	};
-	int i;
-	int rc;
-	int reserved;
-
-	reserved = i2c_smbus_read_byte_data(client, MAX6900_REG_RESERVED_READ);
-	if (reserved != 0x07)
-		return -ENODEV;
-
-	rc = max6900_i2c_read_regs(client, regs);
-	if (rc < 0)
-		return rc;
-
-	for (i = 0; i < ARRAY_SIZE(zero_mask); ++i) {
-		if (regs[i] & zero_mask[i])
-			return -ENODEV;
-	}
-
-	return 0;
-}
-
 static int max6900_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
 {
 	int rc;
@@ -202,7 +156,7 @@ static int max6900_i2c_read_time(struct 
 	tm->tm_mday = BCD2BIN(regs[MAX6900_REG_DT]);
 	tm->tm_mon = BCD2BIN(regs[MAX6900_REG_MO]) - 1;
 	tm->tm_year = BCD2BIN(regs[MAX6900_REG_YR]) +
-		      BCD2BIN(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
+	    BCD2BIN(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
 	tm->tm_wday = BCD2BIN(regs[MAX6900_REG_DW]);
 
 	return 0;
@@ -211,7 +165,7 @@ static int max6900_i2c_read_time(struct 
 static int max6900_i2c_clear_write_protect(struct i2c_client *client)
 {
 	int rc;
-	rc = i2c_smbus_write_byte_data (client, MAX6900_REG_CONTROL_WRITE, 0);
+	rc = i2c_smbus_write_byte_data(client, MAX6900_REG_CONTROL_WRITE, 0);
 	if (rc < 0) {
 		dev_err(&client->dev, "%s: control register write failed\n",
 			__func__);
@@ -220,8 +174,8 @@ static int max6900_i2c_clear_write_prote
 	return 0;
 }
 
-static int max6900_i2c_set_time(struct i2c_client *client,
-				struct rtc_time const *tm)
+static int
+max6900_i2c_set_time(struct i2c_client *client, struct rtc_time const *tm)
 {
 	u8 regs[MAX6900_REG_LEN];
 	int rc;
@@ -258,89 +212,49 @@ static int max6900_rtc_set_time(struct d
 	return max6900_i2c_set_time(to_i2c_client(dev), tm);
 }
 
-static int max6900_attach_adapter(struct i2c_adapter *adapter)
-{
-	return i2c_probe(adapter, &addr_data, max6900_probe);
-}
-
-static int max6900_detach_client(struct i2c_client *client)
+static int max6900_remove(struct i2c_client *client)
 {
-	struct rtc_device *const rtc = i2c_get_clientdata(client);
+	struct rtc_device *rtc = i2c_get_clientdata(client);
 
 	if (rtc)
 		rtc_device_unregister(rtc);
 
-	return i2c_detach_client(client);
+	return 0;
 }
 
-static struct i2c_driver max6900_driver = {
-	.driver		= {
-		.name	= DRV_NAME,
-	},
-	.id		= I2C_DRIVERID_MAX6900,
-	.attach_adapter = max6900_attach_adapter,
-	.detach_client	= max6900_detach_client,
-};
-
 static const struct rtc_class_ops max6900_rtc_ops = {
-	.read_time	= max6900_rtc_read_time,
-	.set_time	= max6900_rtc_set_time,
+	.read_time = max6900_rtc_read_time,
+	.set_time = max6900_rtc_set_time,
 };
 
-static int max6900_probe(struct i2c_adapter *adapter, int addr, int kind)
+static int
+max6900_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	int rc = 0;
-	struct i2c_client *client = NULL;
-	struct rtc_device *rtc = NULL;
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
-		rc = -ENODEV;
-		goto failout;
-	}
+	struct rtc_device *rtc;
 
-	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == NULL) {
-		rc = -ENOMEM;
-		goto failout;
-	}
-
-	client->addr = addr;
-	client->adapter = adapter;
-	client->driver = &max6900_driver;
-	strlcpy(client->name, DRV_NAME, I2C_NAME_SIZE);
-
-	if (kind < 0) {
-		rc = max6900_i2c_validate_client(client);
-		if (rc < 0)
-			goto failout;
-	}
-
-	rc = i2c_attach_client(client);
-	if (rc < 0)
-		goto failout;
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
 
-	dev_info(&client->dev,
-		 "chip found, driver version " DRV_VERSION "\n");
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
 	rtc = rtc_device_register(max6900_driver.driver.name,
-				  &client->dev,
-				  &max6900_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		rc = PTR_ERR(rtc);
-		goto failout_detach;
-	}
+				  &client->dev, &max6900_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	i2c_set_clientdata(client, rtc);
 
 	return 0;
-
-failout_detach:
-	i2c_detach_client(client);
-failout:
-	kfree(client);
-	return rc;
 }
 
+static struct i2c_driver max6900_driver = {
+	.driver = {
+		   .name = "rtc-max6900",
+		   },
+	.probe = max6900_probe,
+	.remove = max6900_remove,
+};
+
 static int __init max6900_init(void)
 {
 	return i2c_add_driver(&max6900_driver);
@@ -352,6 +266,7 @@ static void __exit max6900_exit(void)
 }
 
 MODULE_DESCRIPTION("Maxim MAX6900 RTC driver");
+MODULE_AUTHOR("Dale Farnsworth <dale@farnsworth.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

rtc-max6900-new-style-driver.patch
rtc-ds1672-new-style-driver.patch

