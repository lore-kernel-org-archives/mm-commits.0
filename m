From: akpm@osdl.org
Subject: + rtcs-dont-use-i2c_adapterdev.patch added to -mm tree
Date: Fri, 08 Dec 2006 20:38:51 -0800
Message-ID: <200612090438.kB94cpwN016406@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbWLIEjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 23:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     RTCs don't use i2c_adapter.dev
has been added to the -mm tree.  Its filename is
     rtcs-dont-use-i2c_adapterdev.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTCs don't use i2c_adapter.dev
From: David Brownell <david-b@pacbell.net>

Update more I2C drivers that live outside drivers/i2c to understand that using
adapter->dev is not The Way.  When actually referring to the adapter hardware,
adapter->class_dev.dev is the answer.  When referring to a device connected to
it, client->dev.dev is the answer.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-ds1672.c  |    2 +-
 drivers/rtc/rtc-pcf8563.c |    6 +++---
 drivers/rtc/rtc-rs5c372.c |    2 +-
 drivers/rtc/rtc-x1205.c   |   10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-ds1672.c~rtcs-dont-use-i2c_adapterdev drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtcs-dont-use-i2c_adapterdev
+++ a/drivers/rtc/rtc-ds1672.c
@@ -199,7 +199,7 @@ static int ds1672_probe(struct i2c_adapt
 	struct i2c_client *client;
 	struct rtc_device *rtc;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(adapter->class_dev.dev, "%s\n", __FUNCTION__);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-pcf8563.c~rtcs-dont-use-i2c_adapterdev drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtcs-dont-use-i2c_adapterdev
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -192,7 +192,7 @@ static int pcf8563_validate_client(struc
 		xfer = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
 
 		if (xfer != ARRAY_SIZE(msgs)) {
-			dev_err(&client->adapter->dev,
+			dev_err(&client->dev,
 				"%s: could not read register 0x%02X\n",
 				__FUNCTION__, pattern[i].reg);
 
@@ -203,7 +203,7 @@ static int pcf8563_validate_client(struc
 
 		if (value > pattern[i].max ||
 			value < pattern[i].min) {
-			dev_dbg(&client->adapter->dev,
+			dev_dbg(&client->dev,
 				"%s: pattern=%d, reg=%x, mask=0x%02x, min=%d, "
 				"max=%d, value=%d, raw=0x%02X\n",
 				__FUNCTION__, i, pattern[i].reg, pattern[i].mask,
@@ -253,7 +253,7 @@ static int pcf8563_probe(struct i2c_adap
 
 	int err = 0;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(adapter->class_dev.dev, "%s\n", __FUNCTION__);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-rs5c372.c~rtcs-dont-use-i2c_adapterdev drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtcs-dont-use-i2c_adapterdev
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -200,7 +200,7 @@ static int rs5c372_probe(struct i2c_adap
 	struct i2c_client *client;
 	struct rs5c372 *rs5c372;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(adapter->class_dev.dev, "%s\n", __FUNCTION__);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
diff -puN drivers/rtc/rtc-x1205.c~rtcs-dont-use-i2c_adapterdev drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtcs-dont-use-i2c_adapterdev
+++ a/drivers/rtc/rtc-x1205.c
@@ -372,7 +372,7 @@ static int x1205_validate_client(struct 
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
-			dev_err(&client->adapter->dev,
+			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__FUNCTION__, probe_zero_pattern[i]);
 
@@ -380,7 +380,7 @@ static int x1205_validate_client(struct 
 		}
 
 		if ((buf & probe_zero_pattern[i+1]) != 0) {
-			dev_err(&client->adapter->dev,
+			dev_err(&client->dev,
 				"%s: register=%02x, zero pattern=%d, value=%x\n",
 				__FUNCTION__, probe_zero_pattern[i], i, buf);
 
@@ -400,7 +400,7 @@ static int x1205_validate_client(struct 
 		};
 
 		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
-			dev_err(&client->adapter->dev,
+			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__FUNCTION__, probe_limits_pattern[i].reg);
 
@@ -411,7 +411,7 @@ static int x1205_validate_client(struct 
 
 		if (value > probe_limits_pattern[i].max ||
 			value < probe_limits_pattern[i].min) {
-			dev_dbg(&client->adapter->dev,
+			dev_dbg(&client->dev,
 				"%s: register=%x, lim pattern=%d, value=%d\n",
 				__FUNCTION__, probe_limits_pattern[i].reg,
 				i, value);
@@ -506,7 +506,7 @@ static int x1205_probe(struct i2c_adapte
 	struct i2c_client *client;
 	struct rtc_device *rtc;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(adapter->class_dev.dev, "%s\n", __FUNCTION__);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
watchdog-omap_wdt-build-fix.patch
rtcs-dont-use-i2c_adapterdev.patch

