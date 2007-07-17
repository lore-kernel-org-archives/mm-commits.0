From: akpm@linux-foundation.org
Subject: - rtc-rs5c372-becomes-a-new-style-i2c-driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:25 -0700
Message-ID: <200707172305.l6HN5Pf9011922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936822AbXGQXRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, Riku.Voipio@movial.fi, a.zummo@towertech.it, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, khali@linux-fr.org, tbm@cyrius.com, mm-commits@vger.kernel.org


The patch titled
     rtc-rs5c372 becomes a new-style i2c driver
has been removed from the -mm tree.  Its filename was
     rtc-rs5c372-becomes-a-new-style-i2c-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-rs5c372 becomes a new-style i2c driver
From: David Brownell <david-b@pacbell.net>

Convert rtc-rs5c372 to be a "new style" I2C driver, and update the
Kconfig text to be more complete..

Verified on an OMAP H4 development platform, along with a board
init patch to declare its rv5c387a device.



Only one defconfig -- powerpc/linkstation -- uses this driver; but
several other platforms use it, just without defconfig support.

Such platforms need to be converted so (a) their I2C adapter driver
supports new-style drivers, and (b) board init code declares this
I2C device.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Voipio Riku <Riku.Voipio@movial.fi>
Cc: <g.liakhovetski@gmx.de>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    4 -
 drivers/rtc/rtc-rs5c372.c |   95 ++++++++++++------------------------
 2 files changed, 36 insertions(+), 63 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-rs5c372-becomes-a-new-style-i2c-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rs5c372-becomes-a-new-style-i2c-driver
+++ a/drivers/rtc/Kconfig
@@ -160,11 +160,11 @@ config RTC_DRV_MAX6900
 	  will be called rtc-max6900.
 
 config RTC_DRV_RS5C372
-	tristate "Ricoh RS5C372A/B"
+	tristate "Ricoh RS5C372A/B, RV5C386, RV5C387A"
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
-	  Ricoh RS5C372A and RS5C372B RTC chips.
+	  Ricoh RS5C372A, RS5C372B, RV5C386, and RV5C387A RTC chips.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-rs5c372.
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-becomes-a-new-style-i2c-driver drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-becomes-a-new-style-i2c-driver
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -13,13 +13,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 
-#define DRV_VERSION "0.4"
-
-/* Addresses to scan */
-static unsigned short normal_i2c[] = { /* 0x32,*/ I2C_CLIENT_END };
-
-/* Insmod parameters */
-I2C_CLIENT_INSMOD;
+#define DRV_VERSION "0.5"
 
 
 /*
@@ -88,9 +82,6 @@ struct rs5c372 {
 	unsigned		has_irq:1;
 	char			buf[17];
 	char			*regs;
-
-	/* on conversion to a "new style" i2c driver, this vanishes */
-	struct i2c_client	dev;
 };
 
 static int rs5c_get_regs(struct rs5c372 *rs5c)
@@ -483,25 +474,35 @@ static int rs5c_sysfs_register(struct de
 	return err;
 }
 
+static void rs5c_sysfs_unregister(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_trim);
+	device_remove_file(dev, &dev_attr_osc);
+}
+
 #else
 static int rs5c_sysfs_register(struct device *dev)
 {
 	return 0;
 }
+
+static void rs5c_sysfs_unregister(struct device *dev)
+{
+	/* nothing */
+}
 #endif	/* SYSFS */
 
 static struct i2c_driver rs5c372_driver;
 
-static int rs5c372_probe(struct i2c_adapter *adapter, int address, int kind)
+static int rs5c372_probe(struct i2c_client *client)
 {
 	int err = 0;
-	struct i2c_client *client;
 	struct rs5c372 *rs5c372;
 	struct rtc_time tm;
 
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&client->dev, "%s\n", __FUNCTION__);
 
-	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		err = -ENODEV;
 		goto exit;
 	}
@@ -514,35 +515,22 @@ static int rs5c372_probe(struct i2c_adap
 	/* we read registers 0x0f then 0x00-0x0f; skip the first one */
 	rs5c372->regs=&rs5c372->buf[1];
 
-	/* On conversion to a "new style" i2c driver, we'll be handed
-	 * the i2c_client (we won't create it)
-	 */
-	client = &rs5c372->dev;
 	rs5c372->client = client;
-
-	/* I2C client */
-	client->addr = address;
-	client->driver = &rs5c372_driver;
-	client->adapter = adapter;
-
-	strlcpy(client->name, rs5c372_driver.driver.name, I2C_NAME_SIZE);
-
 	i2c_set_clientdata(client, rs5c372);
 
-	/* Inform the i2c layer */
-	if ((err = i2c_attach_client(client)))
-		goto exit_kfree;
-
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
-		goto exit_detach;
+		goto exit_kfree;
 
-	/* For "new style" drivers, irq is in i2c_client and chip type
-	 * info comes from i2c_client.dev.platform_data.  Meanwhile:
-	 *
-	 * STICK BOARD-SPECIFIC SETUP CODE RIGHT HERE
-	 */
-	if (rs5c372->type == rtc_undef) {
+	if (strcmp(client->name, "rs5c372a") == 0)
+		rs5c372->type = rtc_rs5c372a;
+	else if (strcmp(client->name, "rs5c372b") == 0)
+		rs5c372->type = rtc_rs5c372b;
+	else if (strcmp(client->name, "rv5c386") == 0)
+		rs5c372->type = rtc_rv5c386;
+	else if (strcmp(client->name, "rv5c387a") == 0)
+		rs5c372->type = rtc_rv5c387a;
+	else {
 		rs5c372->type = rtc_rs5c372b;
 		dev_warn(&client->dev, "assuming rs5c372b\n");
 	}
@@ -567,7 +555,7 @@ static int rs5c372_probe(struct i2c_adap
 		break;
 	default:
 		dev_err(&client->dev, "unknown RTC type\n");
-		goto exit_detach;
+		goto exit_kfree;
 	}
 
 	/* if the oscillator lost power and no other software (like
@@ -601,7 +589,7 @@ static int rs5c372_probe(struct i2c_adap
 
 		if ((i2c_master_send(client, buf, 3)) != 3) {
 			dev_err(&client->dev, "setup error\n");
-			goto exit_detach;
+			goto exit_kfree;
 		}
 		rs5c372->regs[RS5C_REG_CTRL1] = buf[1];
 		rs5c372->regs[RS5C_REG_CTRL2] = buf[2];
@@ -621,14 +609,14 @@ static int rs5c372_probe(struct i2c_adap
 			rs5c372->time24 ? "24hr" : "am/pm"
 			);
 
-	/* FIXME when client->irq exists, use it to register alarm irq */
+	/* REVISIT use client->irq to register alarm irq ... */
 
 	rs5c372->rtc = rtc_device_register(rs5c372_driver.driver.name,
 				&client->dev, &rs5c372_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rs5c372->rtc)) {
 		err = PTR_ERR(rs5c372->rtc);
-		goto exit_detach;
+		goto exit_kfree;
 	}
 
 	err = rs5c_sysfs_register(&client->dev);
@@ -640,9 +628,6 @@ static int rs5c372_probe(struct i2c_adap
 exit_devreg:
 	rtc_device_unregister(rs5c372->rtc);
 
-exit_detach:
-	i2c_detach_client(client);
-
 exit_kfree:
 	kfree(rs5c372);
 
@@ -650,24 +635,12 @@ exit:
 	return err;
 }
 
-static int rs5c372_attach(struct i2c_adapter *adapter)
+static int rs5c372_remove(struct i2c_client *client)
 {
-	return i2c_probe(adapter, &addr_data, rs5c372_probe);
-}
-
-static int rs5c372_detach(struct i2c_client *client)
-{
-	int err;
 	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
 
-	if (rs5c372->rtc)
-		rtc_device_unregister(rs5c372->rtc);
-
-	/* REVISIT properly destroy the sysfs files ... */
-
-	if ((err = i2c_detach_client(client)))
-		return err;
-
+	rtc_device_unregister(rs5c372->rtc);
+	rs5c_sysfs_unregister(&client->dev);
 	kfree(rs5c372);
 	return 0;
 }
@@ -676,8 +649,8 @@ static struct i2c_driver rs5c372_driver 
 	.driver		= {
 		.name	= "rtc-rs5c372",
 	},
-	.attach_adapter	= &rs5c372_attach,
-	.detach_client	= &rs5c372_detach,
+	.probe		= rs5c372_probe,
+	.remove		= rs5c372_remove,
 };
 
 static __init int rs5c372_init(void)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
