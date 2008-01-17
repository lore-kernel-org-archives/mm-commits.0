From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-s-35390a-rtc-chip-update.patch removed from -mm tree
Date: Thu, 17 Jan 2008 11:05:25 -0800
Message-ID: <200801171905.m0HJ552U007886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYAQTFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 14:05:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byron.bbradley@gmail.com, david-b@pacbell.net, khali@linux-fr.org, tim@ngndg.com, mm-commits@vger.kernel.org


The patch titled
     rtc: add support for the S-35390A RTC chip
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-s-35390a-rtc-chip-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add support for the S-35390A RTC chip
From: Byron Bradley <byron.bbradley@gmail.com>

This adds basic get/set time support for the Seiko Instruments S-35390A. 
This chip communicates using I2C and is used on the QNAP TS-109/TS-209 NAS
devices.  It takes up eight addresses on the I2C bus and depends on the
following patches:

	i2c-remove-redundant-i2c_client-list.patch
	i2c-add-i2c_new_dummy-utility.patch

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Tested-by: Tim Ellis <tim@ngndg.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s35390a.c |   64 +++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-update drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-update
+++ a/drivers/rtc/rtc-s35390a.c
@@ -14,6 +14,7 @@
 #include <linux/i2c.h>
 #include <linux/bitrev.h>
 #include <linux/bcd.h>
+#include <linux/slab.h>
 
 #define S35390A_CMD_STATUS1	0
 #define S35390A_CMD_STATUS2	1
@@ -34,22 +35,18 @@
 #define S35390A_FLAG_TEST	0x01
 
 struct s35390a {
-	struct i2c_client *client;
+	struct i2c_client *client[8];
 	struct rtc_device *rtc;
 	int twentyfourhour;
 };
 
 static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 {
-	struct i2c_client *client = s35390a->client;
+	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr | reg, 0, len, buf },
+		{ client->addr, 0, len, buf },
 	};
 
-	/* Only write to the writable bits in the status1 register */
-	if (reg == S35390A_CMD_STATUS1)
-		buf[0] &= 0xf;
-
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
 		return -EIO;
 
@@ -58,9 +55,9 @@ static int s35390a_set_reg(struct s35390
 
 static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
 {
-	struct i2c_client *client = s35390a->client;
+	struct i2c_client *client = s35390a->client[reg];
 	struct i2c_msg msg[] = {
-		{ client->addr | reg, I2C_M_RD, len, buf },
+		{ client->addr, I2C_M_RD, len, buf },
 	};
 
 	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
@@ -79,7 +76,8 @@ static int s35390a_reset(struct s35390a 
 	if (!(buf[0] & (S35390A_FLAG_POC | S35390A_FLAG_BLD)))
 		return 0;
 
-	buf[0] |= S35390A_FLAG_RESET;
+	buf[0] |= (S35390A_FLAG_RESET | S35390A_FLAG_24H);
+	buf[0] &= 0xf0;
 	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
 }
 
@@ -199,7 +197,8 @@ static struct i2c_driver s35390a_driver;
 
 static int s35390a_probe(struct i2c_client *client)
 {
-	int err = 0;
+	int err;
+	unsigned int i;
 	struct s35390a *s35390a;
 	struct rtc_time tm;
 	char buf[1];
@@ -215,25 +214,37 @@ static int s35390a_probe(struct i2c_clie
 		goto exit;
 	}
 
-	s35390a->client = client;
+	s35390a->client[0] = client;
 	i2c_set_clientdata(client, s35390a);
 
-	err = s35390a_disable_test_mode(s35390a);
-	if (err < 0) {
-		dev_err(&client->dev, "error disabling test mode\n");
-		goto exit_kfree;
+	/* This chip uses multiple addresses, use dummy devices for them */
+	for (i = 1; i < 8; ++i) {
+		s35390a->client[i] = i2c_new_dummy(client->adapter,
+					client->addr + i, "rtc-s35390a");
+		if (!s35390a->client[i]) {
+			dev_err(&client->dev, "Address %d unavailable\n",
+						client->addr + i);
+			err = -ENOCSI;
+			goto exit_dummy;
+		}
 	}
 
 	err = s35390a_reset(s35390a);
 	if (err < 0) {
 		dev_err(&client->dev, "error resetting chip\n");
-		goto exit_kfree;
+		goto exit_dummy;
+	}
+
+	err = s35390a_disable_test_mode(s35390a);
+	if (err < 0) {
+		dev_err(&client->dev, "error disabling test mode\n");
+		goto exit_dummy;
 	}
 
 	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
 	if (err < 0) {
 		dev_err(&client->dev, "error checking 12/24 hour mode\n");
-		goto exit_kfree;
+		goto exit_dummy;
 	}
 	if (buf[0] & S35390A_FLAG_24H)
 		s35390a->twentyfourhour = 1;
@@ -243,19 +254,21 @@ static int s35390a_probe(struct i2c_clie
 	if (s35390a_get_datetime(client, &tm) < 0)
 		dev_warn(&client->dev, "clock needs to be set\n");
 
-	dev_info(&client->dev, "S35390A found\n");
-
 	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
 				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(s35390a->rtc)) {
 		err = PTR_ERR(s35390a->rtc);
-		goto exit_kfree;
+		goto exit_dummy;
 	}
 	return 0;
 
-exit_kfree:
+exit_dummy:
+	for (i = 1; i < 8; ++i)
+		if (s35390a->client[i])
+			i2c_unregister_device(s35390a->client[i]);
 	kfree(s35390a);
+	i2c_set_clientdata(client, NULL);
 
 exit:
 	return err;
@@ -263,10 +276,17 @@ exit:
 
 static int s35390a_remove(struct i2c_client *client)
 {
+	unsigned int i;
+
 	struct s35390a *s35390a = i2c_get_clientdata(client);
+	for (i = 1; i < 8; ++i)
+		if (s35390a->client[i])
+			i2c_unregister_device(s35390a->client[i]);
 
 	rtc_device_unregister(s35390a->rtc);
 	kfree(s35390a);
+	i2c_set_clientdata(client, NULL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from byron.bbradley@gmail.com are

git-arm.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
