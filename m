From: akpm@linux-foundation.org
Subject: - rtc-ds1307-becomes-new-style-i2c-driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:56 -0700
Message-ID: <200707172305.l6HN5ufG011964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936828AbXGQXRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, andrew@sanpeople.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbrownell@users.sourceforge.net, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1307 becomes new-style i2c driver
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-becomes-new-style-i2c-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-ds1307 becomes new-style i2c driver
From: David Brownell <david-b@pacbell.net>

Convert the rtc-ds1307 driver into a "new style" driver.

Also improve probe() checks:  be more correct about switching out of
AM/PM mode, and issue a (debug) diagnostic when failing due to bogus
register values.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  128 +++++++++++++++----------------------
 1 file changed, 53 insertions(+), 75 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-becomes-new-style-i2c-driver drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-becomes-new-style-i2c-driver
+++ a/drivers/rtc/rtc-ds1307.c
@@ -27,13 +27,8 @@
  * This is currently a simple no-alarms driver.  If your board has the
  * alarm irq wired up on a ds1337 or ds1339, and you want to use that,
  * then look at the rtc-rs5c372 driver for code to steal...
- *
- * If the I2C "force" mechanism is used, we assume the chip is a ds1337.
- * (Much better would be board-specific tables of I2C devices, along with
- * the platform_data drivers would use to sort such issues out.)
  */
 enum ds_type {
-	unknown = 0,
 	ds_1307,
 	ds_1337,
 	ds_1338,
@@ -43,11 +38,6 @@ enum ds_type {
 	// rs5c372 too?  different address...
 };
 
-static unsigned short normal_i2c[] = { 0x68, I2C_CLIENT_END };
-
-I2C_CLIENT_INSMOD;
-
-
 
 /* RTC registers don't differ much, except for the century flag */
 #define DS1307_REG_SECS		0x00	/* 00-59 */
@@ -55,6 +45,8 @@ I2C_CLIENT_INSMOD;
 #	define DS1340_BIT_nEOSC		0x80
 #define DS1307_REG_MIN		0x01	/* 00-59 */
 #define DS1307_REG_HOUR		0x02	/* 00-23, or 1-12{am,pm} */
+#	define DS1307_BIT_12HR		0x40	/* in REG_HOUR */
+#	define DS1307_BIT_PM		0x20	/* in REG_HOUR */
 #	define DS1340_BIT_CENTURY_EN	0x80	/* in REG_HOUR */
 #	define DS1340_BIT_CENTURY	0x40	/* in REG_HOUR */
 #define DS1307_REG_WDAY		0x03	/* 01-07 */
@@ -252,39 +244,27 @@ static const struct rtc_class_ops ds13xx
 
 static struct i2c_driver ds1307_driver;
 
-static int __devinit
-ds1307_detect(struct i2c_adapter *adapter, int address, int kind)
+static int __devinit ds1307_probe(struct i2c_client *client)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
-	struct i2c_client	*client;
 	int			tmp;
 	const struct chip_desc	*chip;
+	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 
-	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
+	chip = find_chip(client->name);
+	if (!chip) {
+		dev_err(&client->dev, "unknown chip type '%s'\n",
+				client->name);
+		return -ENODEV;
 	}
 
-	/* REVISIT:  pending driver model conversion, set up "client"
-	 * ourselves, and use a hack to determine the RTC type (instead
-	 * of reading the client->name we're given)
-	 */
-	client = &ds1307->dev;
-	client->addr = address;
-	client->adapter = adapter;
-	client->driver = &ds1307_driver;
-
-	/* HACK: "force" implies "needs ds1337-style-oscillator setup", and
-	 * that's the only kind of chip setup we'll know about.  Until the
-	 * driver model conversion, here's where to add any board-specific
-	 * code to say what kind of chip is present...
-	 */
-	if (kind >= 0)
-		chip = find_chip("ds1337");
-	else
-		chip = find_chip("ds1307");
-	strlcpy(client->name, chip->name, I2C_NAME_SIZE);
+	if (!i2c_check_functionality(adapter,
+			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+		return -EIO;
+
+	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
+		return -ENOMEM;
 
 	ds1307->client = client;
 	i2c_set_clientdata(client, ds1307);
@@ -378,94 +358,92 @@ read_rtc:
 			goto read_rtc;
 		}
 		break;
-	default:
+	case ds_1337:
+	case ds_1339:
 		break;
 	}
 
 	tmp = ds1307->regs[DS1307_REG_SECS];
 	tmp = BCD2BIN(tmp & 0x7f);
 	if (tmp > 60)
-		goto exit_free;
+		goto exit_bad;
 	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MIN] & 0x7f);
 	if (tmp > 60)
-		goto exit_free;
+		goto exit_bad;
 
 	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
 	if (tmp == 0 || tmp > 31)
-		goto exit_free;
+		goto exit_bad;
 
 	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
 	if (tmp == 0 || tmp > 12)
-		goto exit_free;
+		goto exit_bad;
 
-	/* force into in 24 hour mode (most chips) or
-	 * disable century bit (ds1340)
-	 *
-	 * REVISIT forcing 24 hour mode can prevent multi-master
-	 * configs from sharing this RTC ... don't do this.
-	 * The clock needs to be reset after changing it, too...
-	 */
 	tmp = ds1307->regs[DS1307_REG_HOUR];
-	if (tmp & (1 << 6)) {
-		if (tmp & (1 << 5))
-			tmp = BCD2BIN(tmp & 0x1f) + 12;
-		else
-			tmp = BCD2BIN(tmp);
+	switch (ds1307->type) {
+	case ds_1340:
+	case m41t00:
+		/* NOTE: ignores century bits; fix before deploying
+		 * systems that will run through year 2100.
+		 */
+		break;
+	default:
+		if (!(tmp & DS1307_BIT_12HR))
+			break;
+
+		/* Be sure we're in 24 hour mode.  Multi-master systems
+		 * take note...
+		 */
+		tmp = BCD2BIN(tmp & 0x1f);
+		if (tmp == 12)
+			tmp = 0;
+		if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
+			tmp += 12;
 		i2c_smbus_write_byte_data(client,
 				DS1307_REG_HOUR,
 				BIN2BCD(tmp));
 	}
 
-	/* Tell the I2C layer a new client has arrived */
-	if ((err = i2c_attach_client(client)))
-		goto exit_free;
-
 	ds1307->rtc = rtc_device_register(client->name, &client->dev,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
 		err = PTR_ERR(ds1307->rtc);
 		dev_err(&client->dev,
 			"unable to register the class device\n");
-		goto exit_detach;
+		goto exit_free;
 	}
 
 	return 0;
 
-exit_detach:
-	i2c_detach_client(client);
+exit_bad:
+	dev_dbg(&client->dev, "%s: %02x %02x %02x %02x %02x %02x %02x\n",
+			"bogus register",
+			ds1307->regs[0], ds1307->regs[1],
+			ds1307->regs[2], ds1307->regs[3],
+			ds1307->regs[4], ds1307->regs[5],
+			ds1307->regs[6]);
+
 exit_free:
 	kfree(ds1307);
-exit:
 	return err;
 }
 
-static int __devinit
-ds1307_attach_adapter(struct i2c_adapter *adapter)
-{
-	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
-		return 0;
-	return i2c_probe(adapter, &addr_data, ds1307_detect);
-}
-
-static int __devexit ds1307_detach_client(struct i2c_client *client)
+static int __devexit ds1307_remove(struct i2c_client *client)
 {
-	int		err;
 	struct ds1307	*ds1307 = i2c_get_clientdata(client);
 
 	rtc_device_unregister(ds1307->rtc);
-	if ((err = i2c_detach_client(client)))
-		return err;
 	kfree(ds1307);
 	return 0;
 }
 
 static struct i2c_driver ds1307_driver = {
 	.driver = {
-		.name	= "ds1307",
+		.name	= "rtc-ds1307",
 		.owner	= THIS_MODULE,
 	},
-	.attach_adapter	= ds1307_attach_adapter,
-	.detach_client	= __devexit_p(ds1307_detach_client),
+	.probe		= ds1307_probe,
+	.remove		= __devexit_p(ds1307_remove),
 };
 
 static int __init ds1307_init(void)
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
