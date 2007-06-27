From: akpm@linux-foundation.org
Subject: + rtc-ds1307-oscillator-restart-for-ds1337383940.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:33:27 -0700
Message-ID: <200706271933.l5RJXRRi004190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXF0Tea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@enneenne.com, dbrownell@users.sourceforge.net, giometti@linux.it


The patch titled
     rtc-ds1307: oscillator restart for ds13{37,38,39,40}
has been added to the -mm tree.  Its filename is
     rtc-ds1307-oscillator-restart-for-ds1337383940.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-ds1307: oscillator restart for ds13{37,38,39,40}
From: Rodolfo Giometti <giometti@enneenne.com>

When we find a ds1337 or ds1339 with the oscillator powered off, turn it
on.  If the oscillator fault flag was set, clear it and warn that the clock
needs to be set.


David Brownell: Bugfixes; provide corresponding update for ds1338, and the
core of the fix for ds1340.  Use a common warning message ("SET TIME!")
whenever the clock needs to be set after oscillator fault (or oscillator
enable, if fault is not a separate status).

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   66 +++++++++++++++++++++++++------------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-oscillator-restart-for-ds1337383940 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-oscillator-restart-for-ds1337383940
+++ a/drivers/rtc/rtc-ds1307.c
@@ -52,6 +52,7 @@ I2C_CLIENT_INSMOD;
 /* RTC registers don't differ much, except for the century flag */
 #define DS1307_REG_SECS		0x00	/* 00-59 */
 #	define DS1307_BIT_CH		0x80
+#	define DS1340_BIT_nEOSC		0x80
 #define DS1307_REG_MIN		0x01	/* 00-59 */
 #define DS1307_REG_HOUR		0x02	/* 00-23, or 1-12{am,pm} */
 #	define DS1340_BIT_CENTURY_EN	0x80	/* in REG_HOUR */
@@ -68,7 +69,7 @@ I2C_CLIENT_INSMOD;
  */
 #define DS1307_REG_CONTROL	0x07		/* or ds1338 */
 #	define DS1307_BIT_OUT		0x80
-#	define DS1338_BIT_STOP		0x20
+#	define DS1338_BIT_OSF		0x20
 #	define DS1307_BIT_SQWE		0x10
 #	define DS1307_BIT_RS1		0x02
 #	define DS1307_BIT_RS0		0x01
@@ -84,8 +85,8 @@ I2C_CLIENT_INSMOD;
 #	define DS1340_BIT_FT		0x40
 #	define DS1340_BIT_CALIB_SIGN	0x20
 #	define DS1340_M_CALIBRATION	0x1f
-#define DS1338_REG_FLAG		0x09
-#	define DS1338_BIT_OSF		0x80
+#define DS1340_REG_FLAG		0x09
+#	define DS1340_BIT_OSF		0x80
 #define DS1337_REG_STATUS	0x0f
 #	define DS1337_BIT_OSF		0x80
 #	define DS1337_BIT_A2I		0x02
@@ -215,11 +216,18 @@ static int ds1307_set_time(struct device
 	tmp = t->tm_year - 100;
 	buf[DS1307_REG_YEAR] = BIN2BCD(tmp);
 
-	if (ds1307->type == ds_1337)
+	switch (ds1307->type) {
+	case ds_1337:
+	case ds_1339:
 		buf[DS1307_REG_MONTH] |= DS1337_BIT_CENTURY;
-	else if (ds1307->type == ds_1340)
+		break;
+	case ds_1340:
 		buf[DS1307_REG_HOUR] |= DS1340_BIT_CENTURY_EN
 				| DS1340_BIT_CENTURY;
+		break;
+	default:
+		break;
+	}
 
 	ds1307->msg[1].flags = 0;
 	ds1307->msg[1].len = 8;
@@ -296,11 +304,10 @@ ds1307_detect(struct i2c_adapter *adapte
 	switch (ds1307->type) {
 	case ds_1337:
 	case ds_1339:
-		ds1307->type = ds_1337;
-
 		ds1307->reg_addr = DS1337_REG_CONTROL;
 		ds1307->msg[1].len = 2;
 
+		/* get registers that the "rtc" read below won't read... */
 		tmp = i2c_transfer(adapter, ds1307->msg, 2);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -311,13 +318,16 @@ ds1307_detect(struct i2c_adapter *adapte
 		ds1307->reg_addr = 0;
 		ds1307->msg[1].len = sizeof(ds1307->regs);
 
-		/* oscillator is off; need to turn it on */
-		if ((ds1307->regs[0] & DS1337_BIT_nEOSC)
-				|| (ds1307->regs[1] & DS1337_BIT_OSF)) {
-no_osc_start:
-			printk(KERN_ERR "no %s oscillator code\n",
-				chip->name);
-			goto exit_free;
+		/* oscillator off?  turn it on, so clock can tick. */
+		if (ds1307->regs[0] & DS1337_BIT_nEOSC)
+			i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL,
+				ds1307->regs[0] & ~DS1337_BIT_nEOSC);
+
+		/* oscillator fault?  clear flag, and warn */
+		if (ds1307->regs[1] & DS1337_BIT_OSF) {
+			i2c_smbus_write_byte_data(client, DS1337_REG_STATUS,
+				ds1307->regs[1] & ~DS1337_BIT_OSF);
+			dev_warn(&client->dev, "SET TIME!\n");
 		}
 		break;
 	default:
@@ -340,20 +350,33 @@ read_rtc:
 	 */
 	tmp = ds1307->regs[DS1307_REG_SECS];
 	switch (ds1307->type) {
+	case ds_1340:
+		/* FIXME read register with DS1340_BIT_OSF, use that to
+		 * trigger the "set time" warning (*after* restarting the
+		 * oscillator!) instead of this weaker ds1307/m41t00 test.
+		 */
 	case ds_1307:
-	case ds_1338:
 	case m41t00:
+		/* clock halted?  turn it on, so clock can tick. */
 		if (tmp & DS1307_BIT_CH) {
-			i2c_smbus_write_byte_data(client, 0, 0);
-			dev_warn(&client->dev,
-				"oscillator started; SET TIME!\n");
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
+			dev_warn(&client->dev, "SET TIME!\n");
 			goto read_rtc;
 		}
 		break;
-	case ds_1340:
-		/* FIXME write code to start the oscillator */
+	case ds_1338:
+		/* clock halted?  turn it on, so clock can tick. */
 		if (tmp & DS1307_BIT_CH)
-			goto no_osc_start;
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
+
+		/* oscillator fault?  clear flag, and warn */
+		if (ds1307->regs[DS1307_REG_CONTROL] & DS1338_BIT_OSF) {
+			i2c_smbus_write_byte_data(client, DS1307_REG_CONTROL,
+					ds1307->regs[DS1337_REG_CONTROL]
+					& ~DS1338_BIT_OSF);
+			dev_warn(&client->dev, "SET TIME!\n");
+			goto read_rtc;
+		}
 		break;
 	default:
 		break;
@@ -380,6 +403,7 @@ read_rtc:
 	 *
 	 * REVISIT forcing 24 hour mode can prevent multi-master
 	 * configs from sharing this RTC ... don't do this.
+	 * The clock needs to be reset after changing it, too...
 	 */
 	tmp = ds1307->regs[DS1307_REG_HOUR];
 	if (tmp & (1 << 6)) {
_

Patches currently in -mm which might be from giometti@enneenne.com are

rtc-ds1307-oscillator-restart-for-ds1337383940.patch
