From: akpm@osdl.org
Subject: - rtc-rs5c372-change-register-reading-method.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:52 -0800
Message-ID: <200612072307.kB7N7qe7030404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163963AbWLGXIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@movial.fi, alessandro.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-rs5c372: change register reading method
has been removed from the -mm tree.  Its filename was
     rtc-rs5c372-change-register-reading-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-rs5c372: change register reading method
From: Riku Voipio <riku.voipio@movial.fi>

According to the datasheet rs5c372 supports three different methods for
reading register values.  Change from method #1 to method #3, since method #3
is the only one that works on Thecus N2100 board with this RTC.  

Signed-off-by: Riku Voipio <riku.voipio@movial.fi>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-rs5c372.c |   84 ++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-change-register-reading-method drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-change-register-reading-method
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -13,7 +13,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 
-#define DRV_VERSION "0.2"
+#define DRV_VERSION "0.3"
 
 /* Addresses to scan */
 static unsigned short normal_i2c[] = { /* 0x32,*/ I2C_CLIENT_END };
@@ -39,6 +39,14 @@ static int rs5c372_attach(struct i2c_ada
 static int rs5c372_detach(struct i2c_client *client);
 static int rs5c372_probe(struct i2c_adapter *adapter, int address, int kind);
 
+struct rs5c372 {
+	u8 reg_addr;
+	u8 regs[17];
+	struct i2c_msg msg[1];
+	struct i2c_client client;
+	struct rtc_device *rtc;
+};
+
 static struct i2c_driver rs5c372_driver = {
 	.driver		= {
 		.name	= "rs5c372",
@@ -49,18 +57,16 @@ static struct i2c_driver rs5c372_driver 
 
 static int rs5c372_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	unsigned char buf[7] = { RS5C372_REG_BASE };
 
-	/* this implements the 1st reading method, according
-	 * to the datasheet. buf[0] is initialized with
-	 * address ptr and transmission format register.
+	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
+	u8 *buf = &(rs5c372->regs[1]);
+
+	/* this implements the 3rd reading method, according
+	 * to the datasheet. rs5c372 defaults to internal
+	 * address 0xF, so 0x0 is in regs[1]
 	 */
-	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, buf },
-		{ client->addr, I2C_M_RD, 7, buf },
-	};
 
-	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+	if ((i2c_transfer(client->adapter, rs5c372->msg, 1)) != 1) {
 		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
 		return -EIO;
 	}
@@ -114,23 +120,14 @@ static int rs5c372_set_datetime(struct i
 
 static int rs5c372_get_trim(struct i2c_client *client, int *osc, int *trim)
 {
-	unsigned char buf = RS5C372_REG_TRIM;
-
-	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 1, &buf },
-		{ client->addr, I2C_M_RD, 1, &buf },
-	};
-
-	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __FUNCTION__);
-		return -EIO;
-	}
+	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
+	u8 tmp = rs5c372->regs[RS5C372_REG_TRIM + 1];
 
 	if (osc)
-		*osc = (buf & RS5C372_TRIM_XSL) ? 32000 : 32768;
+		*osc = (tmp & RS5C372_TRIM_XSL) ? 32000 : 32768;
 
 	if (trim) {
-		*trim = buf & RS5C372_TRIM_MASK;
+		*trim = tmp & RS5C372_TRIM_MASK;
 		dev_dbg(&client->dev, "%s: raw trim=%x\n", __FUNCTION__, *trim);
 	}
 
@@ -201,7 +198,7 @@ static int rs5c372_probe(struct i2c_adap
 {
 	int err = 0;
 	struct i2c_client *client;
-	struct rtc_device *rtc;
+	struct rs5c372 *rs5c372;
 
 	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
 
@@ -210,10 +207,11 @@ static int rs5c372_probe(struct i2c_adap
 		goto exit;
 	}
 
-	if (!(client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
+	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
 		err = -ENOMEM;
 		goto exit;
 	}
+	client = &rs5c372->client;
 
 	/* I2C client */
 	client->addr = address;
@@ -222,26 +220,33 @@ static int rs5c372_probe(struct i2c_adap
 
 	strlcpy(client->name, rs5c372_driver.driver.name, I2C_NAME_SIZE);
 
+	i2c_set_clientdata(client, rs5c372);
+
+	rs5c372->msg[0].addr = address;
+	rs5c372->msg[0].flags = I2C_M_RD;
+	rs5c372->msg[0].len = sizeof(rs5c372->regs);
+	rs5c372->msg[0].buf = rs5c372->regs;
+
 	/* Inform the i2c layer */
 	if ((err = i2c_attach_client(client)))
 		goto exit_kfree;
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(rs5c372_driver.driver.name, &client->dev,
-				&rs5c372_rtc_ops, THIS_MODULE);
+	rs5c372->rtc = rtc_device_register(rs5c372_driver.driver.name,
+				&client->dev, &rs5c372_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
+	if (IS_ERR(rs5c372->rtc)) {
+		err = PTR_ERR(rs5c372->rtc);
 		goto exit_detach;
 	}
 
-	i2c_set_clientdata(client, rtc);
-
 	err = device_create_file(&client->dev, &dev_attr_trim);
-	if (err) goto exit_devreg;
+	if (err)
+		goto exit_devreg;
 	err = device_create_file(&client->dev, &dev_attr_osc);
-	if (err) goto exit_trim;
+	if (err)
+		goto exit_trim;
 
 	return 0;
 
@@ -249,13 +254,13 @@ exit_trim:
 	device_remove_file(&client->dev, &dev_attr_trim);
 
 exit_devreg:
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(rs5c372->rtc);
 
 exit_detach:
 	i2c_detach_client(client);
 
 exit_kfree:
-	kfree(client);
+	kfree(rs5c372);
 
 exit:
 	return err;
@@ -264,16 +269,15 @@ exit:
 static int rs5c372_detach(struct i2c_client *client)
 {
 	int err;
-	struct rtc_device *rtc = i2c_get_clientdata(client);
+	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
 
-	if (rtc)
-		rtc_device_unregister(rtc);
+	if (rs5c372->rtc)
+		rtc_device_unregister(rs5c372->rtc);
 
 	if ((err = i2c_detach_client(client)))
 		return err;
 
-	kfree(client);
-
+	kfree(rs5c372);
 	return 0;
 }
 
_

Patches currently in -mm which might be from riku.voipio@movial.fi are

origin.patch

