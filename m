From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1307-add-ds3231.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:48:56 -0700
Message-ID: <200904091948.n39JmuOb025209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761694AbZDITvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc: rtc-ds1307 add ds3231
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1307-add-ds3231.patch

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
Subject: rtc: rtc-ds1307 add ds3231
From: Wolfram Sang <w.sang@pengutronix.de>

Add ds3231 variant.  For that, the BBSQI bit position was changed from a
simple define into a lookup-array as it differs.  This also removes
writing to an unused bit in case of the ds1337.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-add-ds3231 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-add-ds3231
+++ a/drivers/rtc/rtc-ds1307.c
@@ -32,6 +32,7 @@ enum ds_type {
 	ds_1339,
 	ds_1340,
 	ds_1388,
+	ds_3231,
 	m41t00,
 	rx_8025,
 	// rs5c372 too?  different address...
@@ -67,6 +68,7 @@ enum ds_type {
 #define DS1337_REG_CONTROL	0x0e
 #	define DS1337_BIT_nEOSC		0x80
 #	define DS1339_BIT_BBSQI		0x20
+#	define DS3231_BIT_BBSQW		0x40 /* same as BBSQI */
 #	define DS1337_BIT_RS2		0x10
 #	define DS1337_BIT_RS1		0x08
 #	define DS1337_BIT_INTCN		0x04
@@ -130,6 +132,9 @@ static const struct chip_desc chips[] = 
 },
 [ds_1340] = {
 },
+[ds_3231] = {
+	.alarm		= 1,
+},
 [m41t00] = {
 },
 [rx_8025] = {
@@ -142,6 +147,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1339", ds_1339 },
 	{ "ds1388", ds_1388 },
 	{ "ds1340", ds_1340 },
+	{ "ds3231", ds_3231 },
 	{ "m41t00", m41t00 },
 	{ "rx8025", rx_8025 },
 	{ }
@@ -356,6 +362,7 @@ static int ds1307_set_time(struct device
 	switch (ds1307->type) {
 	case ds_1337:
 	case ds_1339:
+	case ds_3231:
 		buf[DS1307_REG_MONTH] |= DS1337_BIT_CENTURY;
 		break;
 	case ds_1340:
@@ -628,6 +635,11 @@ static int __devinit ds1307_probe(struct
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
 	unsigned char		*buf;
+	static const int	bbsqi_bitpos[] = {
+		[ds_1337] = 0,
+		[ds_1339] = DS1339_BIT_BBSQI,
+		[ds_3231] = DS3231_BIT_BBSQW,
+	};
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
@@ -654,6 +666,7 @@ static int __devinit ds1307_probe(struct
 	switch (ds1307->type) {
 	case ds_1337:
 	case ds_1339:
+	case ds_3231:
 		/* has IRQ? */
 		if (ds1307->client->irq > 0 && chip->alarm) {
 			INIT_WORK(&ds1307->work, ds1307_work);
@@ -673,12 +686,12 @@ static int __devinit ds1307_probe(struct
 			ds1307->regs[0] &= ~DS1337_BIT_nEOSC;
 
 		/* Using IRQ?  Disable the square wave and both alarms.
-		 * For ds1339, be sure alarms can trigger when we're
-		 * running on Vbackup (BBSQI); we assume ds1337 will
-		 * ignore that bit
+		 * For some variants, be sure alarms can trigger when we're
+		 * running on Vbackup (BBSQI/BBSQW)
 		 */
 		if (want_irq) {
-			ds1307->regs[0] |= DS1337_BIT_INTCN | DS1339_BIT_BBSQI;
+			ds1307->regs[0] |= DS1337_BIT_INTCN
+					| bbsqi_bitpos[ds1307->type];
 			ds1307->regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
 		}
 
@@ -825,6 +838,7 @@ read_rtc:
 	case ds_1337:
 	case ds_1339:
 	case ds_1388:
+	case ds_3231:
 		break;
 	}
 
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-rtc-ds1307-add-ds3231.patch

