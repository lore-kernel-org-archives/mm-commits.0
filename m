From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-add-trickle-charger-support.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:34 -0700
Message-ID: <20120531192034.5F087A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46086 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2EaTUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:36 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76227wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, alessandro.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: add trickle charger support
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-add-trickle-charger-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: add trickle charger support

Some DS13XX devices have "trickle chargers".  Its configuration register
is at different locations, the setup is the same, though.  Since the
configuration is board specific, introduce a platform_data to this driver.
Tested with a DS1339 on a custom board.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c   |   19 ++++++++++++++++---
 include/linux/rtc/ds1307.h |   22 ++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-trickle-charger-support drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-add-trickle-charger-support
+++ a/drivers/rtc/rtc-ds1307.c
@@ -17,8 +17,7 @@
 #include <linux/string.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
-
-
+#include <linux/rtc/ds1307.h>
 
 /*
  * We can't determine type by probing, but if we expect pre-Linux code
@@ -92,7 +91,8 @@ enum ds_type {
 #	define DS1337_BIT_A2I		0x02
 #	define DS1337_BIT_A1I		0x01
 #define DS1339_REG_ALARM1_SECS	0x07
-#define DS1339_REG_TRICKLE	0x10
+
+#define DS13XX_TRICKLE_CHARGER_MAGIC	0xa0
 
 #define RX8025_REG_CTRL1	0x0e
 #	define RX8025_BIT_2412		0x20
@@ -124,6 +124,7 @@ struct chip_desc {
 	unsigned		alarm:1;
 	u16			nvram_offset;
 	u16			nvram_size;
+	u16			trickle_charger_reg;
 };
 
 static const struct chip_desc chips[last_ds_type] = {
@@ -140,6 +141,13 @@ static const struct chip_desc chips[last
 	},
 	[ds_1339] = {
 		.alarm		= 1,
+		.trickle_charger_reg = 0x10,
+	},
+	[ds_1340] = {
+		.trickle_charger_reg = 0x08,
+	},
+	[ds_1388] = {
+		.trickle_charger_reg = 0x0a,
 	},
 	[ds_3231] = {
 		.alarm		= 1,
@@ -619,6 +627,7 @@ static int __devinit ds1307_probe(struct
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	int			want_irq = false;
 	unsigned char		*buf;
+	struct ds1307_platform_data *pdata = client->dev.platform_data;
 	static const int	bbsqi_bitpos[] = {
 		[ds_1337] = 0,
 		[ds_1339] = DS1339_BIT_BBSQI,
@@ -638,6 +647,10 @@ static int __devinit ds1307_probe(struct
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
 
+	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
+		i2c_smbus_write_byte_data(client, chip->trickle_charger_reg,
+			DS13XX_TRICKLE_CHARGER_MAGIC | pdata->trickle_charger_setup);
+
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
 		ds1307->read_block_data = i2c_smbus_read_i2c_block_data;
diff -puN /dev/null include/linux/rtc/ds1307.h
--- /dev/null
+++ a/include/linux/rtc/ds1307.h
@@ -0,0 +1,22 @@
+/*
+ * ds1307.h - platform_data for the ds1307 (and variants) rtc driver
+ * (C) Copyright 2012 by Wolfram Sang, Pengutronix e.K.
+ * same license as the driver
+ */
+
+#ifndef _LINUX_DS1307_H
+#define _LINUX_DS1307_H
+
+#include <linux/types.h>
+
+#define DS1307_TRICKLE_CHARGER_250_OHM	0x01
+#define DS1307_TRICKLE_CHARGER_2K_OHM	0x02
+#define DS1307_TRICKLE_CHARGER_4K_OHM	0x03
+#define DS1307_TRICKLE_CHARGER_NO_DIODE	0x04
+#define DS1307_TRICKLE_CHARGER_DIODE	0x08
+
+struct ds1307_platform_data {
+	u8 trickle_charger_setup;
+};
+
+#endif /* _LINUX_DS1307_H */
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch

