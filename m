From: akpm@linux-foundation.org
Subject: - rtc-ds1307-cleanups.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:23 -0700
Message-ID: <200707172305.l6HN5NuY011919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936278AbXGQXPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1307 cleanups
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-ds1307 cleanups
From: David Brownell <david-b@pacbell.net>

This updates the rtc-ds1307 driver so that converting it to a "new style"
driver (driver model, not legacy i2c model) will involve fewer changes.

 - Use pointer to i2c_client almost everywhere, so that it's easy
   to let the i2c core create that object;

 - Avoid using i2c_client.adapter, since that field is redundant and
   thus may go away (same object as i2c_client.dev.parent).

 - Extend type enum to include various RTCs this is expected to
   work with, and include register support for them.

It also cleans up the support for multiple chip types, and fixes a
glitch that could appear with an un-initialized RTC.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  176 ++++++++++++++++++++++++++-----------
 1 file changed, 124 insertions(+), 52 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-cleanups drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-cleanups
+++ a/drivers/rtc/rtc-ds1307.c
@@ -24,15 +24,22 @@
  * setting the date and time), Linux can ignore the non-clock features.
  * That's a natural job for a factory or repair bench.
  *
+ * This is currently a simple no-alarms driver.  If your board has the
+ * alarm irq wired up on a ds1337 or ds1339, and you want to use that,
+ * then look at the rtc-rs5c372 driver for code to steal...
+ *
  * If the I2C "force" mechanism is used, we assume the chip is a ds1337.
  * (Much better would be board-specific tables of I2C devices, along with
  * the platform_data drivers would use to sort such issues out.)
  */
 enum ds_type {
 	unknown = 0,
-	ds_1307,		/* or ds1338, ... */
-	ds_1337,		/* or ds1339, ... */
-	ds_1340,		/* or st m41t00, ... */
+	ds_1307,
+	ds_1337,
+	ds_1338,
+	ds_1339,
+	ds_1340,
+	m41t00,
 	// rs5c372 too?  different address...
 };
 
@@ -56,11 +63,12 @@ I2C_CLIENT_INSMOD;
 #define DS1307_REG_YEAR		0x06	/* 00-99 */
 
 /* Other registers (control, status, alarms, trickle charge, NVRAM, etc)
- * start at 7, and they differ a lot. Only control and status matter for RTC;
- * be careful using them.
+ * start at 7, and they differ a LOT. Only control and status matter for
+ * basic RTC date and time functionality; be careful using them.
  */
-#define DS1307_REG_CONTROL	0x07
+#define DS1307_REG_CONTROL	0x07		/* or ds1338 */
 #	define DS1307_BIT_OUT		0x80
+#	define DS1338_BIT_STOP		0x20
 #	define DS1307_BIT_SQWE		0x10
 #	define DS1307_BIT_RS1		0x02
 #	define DS1307_BIT_RS0		0x01
@@ -71,6 +79,13 @@ I2C_CLIENT_INSMOD;
 #	define DS1337_BIT_INTCN		0x04
 #	define DS1337_BIT_A2IE		0x02
 #	define DS1337_BIT_A1IE		0x01
+#define DS1340_REG_CONTROL	0x07
+#	define DS1340_BIT_OUT		0x80
+#	define DS1340_BIT_FT		0x40
+#	define DS1340_BIT_CALIB_SIGN	0x20
+#	define DS1340_M_CALIBRATION	0x1f
+#define DS1338_REG_FLAG		0x09
+#	define DS1338_BIT_OSF		0x80
 #define DS1337_REG_STATUS	0x0f
 #	define DS1337_BIT_OSF		0x80
 #	define DS1337_BIT_A2I		0x02
@@ -84,21 +99,63 @@ struct ds1307 {
 	u8			regs[8];
 	enum ds_type		type;
 	struct i2c_msg		msg[2];
-	struct i2c_client	client;
+	struct i2c_client	*client;
+	struct i2c_client	dev;
 	struct rtc_device	*rtc;
 };
 
+struct chip_desc {
+	char			name[9];
+	unsigned		nvram56:1;
+	unsigned		alarm:1;
+	enum ds_type		type;
+};
+
+static const struct chip_desc chips[] = { {
+	.name		= "ds1307",
+	.type		= ds_1307,
+	.nvram56	= 1,
+}, {
+	.name		= "ds1337",
+	.type		= ds_1337,
+	.alarm		= 1,
+}, {
+	.name		= "ds1338",
+	.type		= ds_1338,
+	.nvram56	= 1,
+}, {
+	.name		= "ds1339",
+	.type		= ds_1339,
+	.alarm		= 1,
+}, {
+	.name		= "ds1340",
+	.type		= ds_1340,
+}, {
+	.name		= "m41t00",
+	.type		= m41t00,
+}, };
+
+static inline const struct chip_desc *find_chip(const char *s)
+{
+	unsigned i;
+
+	for (i = 0; i < ARRAY_SIZE(chips); i++)
+		if (strnicmp(s, chips[i].name, sizeof chips[i].name) == 0)
+			return &chips[i];
+	return NULL;
+}
 
 static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 {
 	struct ds1307	*ds1307 = dev_get_drvdata(dev);
 	int		tmp;
 
-	/* read the RTC registers all at once */
+	/* read the RTC date and time registers all at once */
 	ds1307->msg[1].flags = I2C_M_RD;
 	ds1307->msg[1].len = 7;
 
-	tmp = i2c_transfer(ds1307->client.adapter, ds1307->msg, 2);
+	tmp = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
+			ds1307->msg, 2);
 	if (tmp != 2) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
 		return -EIO;
@@ -129,7 +186,8 @@ static int ds1307_get_time(struct device
 		t->tm_hour, t->tm_mday,
 		t->tm_mon, t->tm_year, t->tm_wday);
 
-	return 0;
+	/* initial clock setting can be undefined */
+	return rtc_valid_tm(t);
 }
 
 static int ds1307_set_time(struct device *dev, struct rtc_time *t)
@@ -170,7 +228,8 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = i2c_transfer(ds1307->client.adapter, &ds1307->msg[1], 1);
+	result = i2c_transfer(to_i2c_adapter(ds1307->client->dev.parent),
+			&ds1307->msg[1], 1);
 	if (result != 1) {
 		dev_err(dev, "%s error %d\n", "write", tmp);
 		return -EIO;
@@ -192,18 +251,34 @@ ds1307_detect(struct i2c_adapter *adapte
 	int			err = -ENODEV;
 	struct i2c_client	*client;
 	int			tmp;
+	const struct chip_desc	*chip;
 
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL))) {
 		err = -ENOMEM;
 		goto exit;
 	}
 
-	client = &ds1307->client;
+	/* REVISIT:  pending driver model conversion, set up "client"
+	 * ourselves, and use a hack to determine the RTC type (instead
+	 * of reading the client->name we're given)
+	 */
+	client = &ds1307->dev;
 	client->addr = address;
 	client->adapter = adapter;
 	client->driver = &ds1307_driver;
-	client->flags = 0;
 
+	/* HACK: "force" implies "needs ds1337-style-oscillator setup", and
+	 * that's the only kind of chip setup we'll know about.  Until the
+	 * driver model conversion, here's where to add any board-specific
+	 * code to say what kind of chip is present...
+	 */
+	if (kind >= 0)
+		chip = find_chip("ds1337");
+	else
+		chip = find_chip("ds1307");
+	strlcpy(client->name, chip->name, I2C_NAME_SIZE);
+
+	ds1307->client = client;
 	i2c_set_clientdata(client, ds1307);
 
 	ds1307->msg[0].addr = client->addr;
@@ -216,14 +291,17 @@ ds1307_detect(struct i2c_adapter *adapte
 	ds1307->msg[1].len = sizeof(ds1307->regs);
 	ds1307->msg[1].buf = ds1307->regs;
 
-	/* HACK: "force" implies "needs ds1337-style-oscillator setup" */
-	if (kind >= 0) {
+	ds1307->type = chip->type;
+
+	switch (ds1307->type) {
+	case ds_1337:
+	case ds_1339:
 		ds1307->type = ds_1337;
 
 		ds1307->reg_addr = DS1337_REG_CONTROL;
 		ds1307->msg[1].len = 2;
 
-		tmp = i2c_transfer(client->adapter, ds1307->msg, 2);
+		tmp = i2c_transfer(adapter, ds1307->msg, 2);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
 			err = -EIO;
@@ -236,16 +314,20 @@ ds1307_detect(struct i2c_adapter *adapte
 		/* oscillator is off; need to turn it on */
 		if ((ds1307->regs[0] & DS1337_BIT_nEOSC)
 				|| (ds1307->regs[1] & DS1337_BIT_OSF)) {
-			printk(KERN_ERR "no ds1337 oscillator code\n");
+no_osc_start:
+			printk(KERN_ERR "no %s oscillator code\n",
+				chip->name);
 			goto exit_free;
 		}
-	} else
-		ds1307->type = ds_1307;
+		break;
+	default:
+		break;
+	}
 
 read_rtc:
 	/* read RTC registers */
 
-	tmp = i2c_transfer(client->adapter, ds1307->msg, 2);
+	tmp = i2c_transfer(adapter, ds1307->msg, 2);
 	if (tmp != 2) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -257,20 +339,27 @@ read_rtc:
 	 * still a few values that are clearly out-of-range.
 	 */
 	tmp = ds1307->regs[DS1307_REG_SECS];
-	if (tmp & DS1307_BIT_CH) {
-		if (ds1307->type && ds1307->type != ds_1307) {
-			pr_debug("not a ds1307?\n");
-			goto exit_free;
+	switch (ds1307->type) {
+	case ds_1307:
+	case ds_1338:
+	case m41t00:
+		if (tmp & DS1307_BIT_CH) {
+			i2c_smbus_write_byte_data(client, 0, 0);
+			dev_warn(&client->dev,
+				"oscillator started; SET TIME!\n");
+			goto read_rtc;
 		}
-		ds1307->type = ds_1307;
-
-		/* this partial initialization should work for ds1307,
-		 * ds1338, ds1340, st m41t00, and more.
-		 */
-		dev_warn(&client->dev, "oscillator started; SET TIME!\n");
-		i2c_smbus_write_byte_data(client, 0, 0);
-		goto read_rtc;
+		break;
+	case ds_1340:
+		/* FIXME write code to start the oscillator */
+		if (tmp & DS1307_BIT_CH)
+			goto no_osc_start;
+		break;
+	default:
+		break;
 	}
+
+	tmp = ds1307->regs[DS1307_REG_SECS];
 	tmp = BCD2BIN(tmp & 0x7f);
 	if (tmp > 60)
 		goto exit_free;
@@ -288,6 +377,9 @@ read_rtc:
 
 	/* force into in 24 hour mode (most chips) or
 	 * disable century bit (ds1340)
+	 *
+	 * REVISIT forcing 24 hour mode can prevent multi-master
+	 * configs from sharing this RTC ... don't do this.
 	 */
 	tmp = ds1307->regs[DS1307_REG_HOUR];
 	if (tmp & (1 << 6)) {
@@ -300,26 +392,6 @@ read_rtc:
 				BIN2BCD(tmp));
 	}
 
-	/* FIXME chips like 1337 can generate alarm irqs too; those are
-	 * worth exposing through the API (especially when the irq is
-	 * wakeup-capable).
-	 */
-
-	switch (ds1307->type) {
-	case unknown:
-		strlcpy(client->name, "unknown", I2C_NAME_SIZE);
-		break;
-	case ds_1307:
-		strlcpy(client->name, "ds1307", I2C_NAME_SIZE);
-		break;
-	case ds_1337:
-		strlcpy(client->name, "ds1337", I2C_NAME_SIZE);
-		break;
-	case ds_1340:
-		strlcpy(client->name, "ds1340", I2C_NAME_SIZE);
-		break;
-	}
-
 	/* Tell the I2C layer a new client has arrived */
 	if ((err = i2c_attach_client(client)))
 		goto exit_free;
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
