From: akpm@linux-foundation.org
Subject: + rtc-ds1307-add-trickle-charger-support.patch added to -mm tree
Date: Thu, 19 Apr 2012 13:23:09 -0700
Message-ID: <20120419202309.3FD14A06B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:57109 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2DSUXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 16:23:12 -0400
Received: by lbol12 with SMTP id l12so242263lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 13:23:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, alessandro.zummo@towertech.it


The patch titled
     Subject: rtc: ds1307: add trickle charger support
has been added to the -mm tree.  Its filename is
     rtc-ds1307-add-trickle-charger-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc: ds1307: add trickle charger support

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
leds-add-led-driver-for-lm3556-chip.patch
rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
rtc-ds1307-remove-superfluous-initialization.patch
rtc-ds1307-add-trickle-charger-support.patch

