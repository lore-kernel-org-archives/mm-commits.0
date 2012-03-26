From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-comment-and-format-cleanup.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:51 -0700
Message-ID: <20120326193151.618B2A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39425 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2CZTbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:52 -0400
Received: by yhgm50 with SMTP id m50so834231yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: x0132446@ti.com, Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: comment and format cleanup
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-comment-and-format-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Anders <x0132446@ti.com>
Subject: rtc: ds1307: comment and format cleanup

Do some cleanup of the comment sections as well as correct some formatting
issues reported by checkpatch.pl.

Signed-off-by: David Anders <x0132446@ti.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-comment-and-format-cleanup drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-comment-and-format-cleanup
+++ a/drivers/rtc/rtc-ds1307.c
@@ -20,7 +20,8 @@
 
 
 
-/* We can't determine type by probing, but if we expect pre-Linux code
+/*
+ * We can't determine type by probing, but if we expect pre-Linux code
  * to have set the chip up as a clock (turning on the oscillator and
  * setting the date and time), Linux can ignore the non-clock features.
  * That's a natural job for a factory or repair bench.
@@ -37,7 +38,7 @@ enum ds_type {
 	mcp7941x,
 	rx_8025,
 	last_ds_type /* always last */
-	// rs5c372 too?  different address...
+	/* rs5c372 too?  different address... */
 };
 
 
@@ -59,7 +60,8 @@ enum ds_type {
 #	define DS1337_BIT_CENTURY	0x80	/* in REG_MONTH */
 #define DS1307_REG_YEAR		0x06	/* 00-99 */
 
-/* Other registers (control, status, alarms, trickle charge, NVRAM, etc)
+/*
+ * Other registers (control, status, alarms, trickle charge, NVRAM, etc)
  * start at 7, and they differ a LOT. Only control and status matter for
  * basic RTC date and time functionality; be careful using them.
  */
@@ -366,6 +368,11 @@ static int ds1307_set_time(struct device
 				| DS1340_BIT_CENTURY;
 		break;
 	case mcp7941x:
+		/*
+		 * these bits were cleared when preparing the date/time
+		 * values and need to be set again before writing the
+		 * buffer out to the device.
+		 */
 		buf[DS1307_REG_SECS] |= MCP7941X_BIT_ST;
 		buf[DS1307_REG_WDAY] |= MCP7941X_BIT_VBATEN;
 		break;
@@ -411,7 +418,8 @@ static int ds1337_read_alarm(struct devi
 			ds1307->regs[6], ds1307->regs[7],
 			ds1307->regs[8]);
 
-	/* report alarm time (ALARM1); assume 24 hour and day-of-month modes,
+	/*
+	 * report alarm time (ALARM1); assume 24 hour and day-of-month modes,
 	 * and that all four fields are checked matches
 	 */
 	t->time.tm_sec = bcd2bin(ds1307->regs[0] & 0x7f);
@@ -439,7 +447,7 @@ static int ds1337_read_alarm(struct devi
 
 static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
-	struct i2c_client       *client = to_i2c_client(dev);
+	struct i2c_client	*client = to_i2c_client(dev);
 	struct ds1307		*ds1307 = i2c_get_clientdata(client);
 	unsigned char		*buf = ds1307->regs;
 	u8			control, status;
@@ -602,8 +610,6 @@ static struct bin_attribute nvram = {
 
 /*----------------------------------------------------------------------*/
 
-static struct i2c_driver ds1307_driver;
-
 static int __devinit ds1307_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
@@ -624,7 +630,8 @@ static int __devinit ds1307_probe(struct
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
+	ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
+	if (!ds1307)
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, ds1307);
@@ -659,7 +666,8 @@ static int __devinit ds1307_probe(struct
 		if (ds1307->regs[0] & DS1337_BIT_nEOSC)
 			ds1307->regs[0] &= ~DS1337_BIT_nEOSC;
 
-		/* Using IRQ?  Disable the square wave and both alarms.
+		/*
+		 * Using IRQ?  Disable the square wave and both alarms.
 		 * For some variants, be sure alarms can trigger when we're
 		 * running on Vbackup (BBSQI/BBSQW)
 		 */
@@ -765,7 +773,8 @@ read_rtc:
 		goto exit_free;
 	}
 
-	/* minimal sanity checking; some chips (like DS1340) don't
+	/*
+	 * minimal sanity checking; some chips (like DS1340) don't
 	 * specify the extra bits as must-be-zero, but there are
 	 * still a few values that are clearly out-of-range.
 	 */
@@ -837,7 +846,8 @@ read_rtc:
 	switch (ds1307->type) {
 	case ds_1340:
 	case m41t00:
-		/* NOTE: ignores century bits; fix before deploying
+		/*
+		 * NOTE: ignores century bits; fix before deploying
 		 * systems that will run through year 2100.
 		 */
 		break;
@@ -847,7 +857,8 @@ read_rtc:
 		if (!(tmp & DS1307_BIT_12HR))
 			break;
 
-		/* Be sure we're in 24 hour mode.  Multi-master systems
+		/*
+		 * Be sure we're in 24 hour mode.  Multi-master systems
 		 * take note...
 		 */
 		tmp = bcd2bin(tmp & 0x1f);
@@ -902,7 +913,7 @@ exit_free:
 
 static int __devexit ds1307_remove(struct i2c_client *client)
 {
-	struct ds1307		*ds1307 = i2c_get_clientdata(client);
+	struct ds1307 *ds1307 = i2c_get_clientdata(client);
 
 	if (test_and_clear_bit(HAS_ALARM, &ds1307->flags)) {
 		free_irq(client->irq, client);
_

Patches currently in -mm which might be from x0132446@ti.com are

origin.patch

