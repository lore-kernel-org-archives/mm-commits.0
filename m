From: akpm@linux-foundation.org
Subject: [merged] rtc-add-epson-rx8025-support-to-ds1307-rtc-driver.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:10 -0700
Message-ID: <200904011842.n31IgAZ0009625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933608AbZDASpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.fuchs@esd-electronics.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: add EPSON RX8025 support to DS1307 RTC driver
has been removed from the -mm tree.  Its filename was
     rtc-add-epson-rx8025-support-to-ds1307-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add EPSON RX8025 support to DS1307 RTC driver
From: Matthias Fuchs <matthias.fuchs@esd-electronics.com>

Add support for the EPSON RX8025 RTC.  The date/time registers of this
chip are compatible with the DS1307.

Signed-off-by: Matthias Fuchs <matthias.fuchs@esd-electronics.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    7 +--
 drivers/rtc/rtc-ds1307.c |   80 +++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-epson-rx8025-support-to-ds1307-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-epson-rx8025-support-to-ds1307-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -129,13 +129,14 @@ comment "I2C RTC drivers"
 if I2C
 
 config RTC_DRV_DS1307
-	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
+	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025"
 	help
 	  If you say yes here you get support for various compatible RTC
 	  chips (often with battery backup) connected with I2C. This driver
 	  should handle DS1307, DS1337, DS1338, DS1339, DS1340, ST M41T00,
-	  and probably other chips. In some cases the RTC must already
-	  have been initialized (by manufacturing or a bootloader).
+	  EPSON RX-8025 and probably other chips. In some cases the RTC
+	  must already have been initialized (by manufacturing or a
+	  bootloader).
 
 	  The first seven registers on these chips hold an RTC, and other
 	  registers may add features such as NVRAM, a trickle charger for
diff -puN drivers/rtc/rtc-ds1307.c~rtc-add-epson-rx8025-support-to-ds1307-rtc-driver drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-add-epson-rx8025-support-to-ds1307-rtc-driver
+++ a/drivers/rtc/rtc-ds1307.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2005 James Chapman (ds1337 core)
  *  Copyright (C) 2006 David Brownell
+ *  Copyright (C) 2009 Matthias Fuchs (rx8025 support)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -31,6 +32,7 @@ enum ds_type {
 	ds_1339,
 	ds_1340,
 	m41t00,
+	rx_8025,
 	// rs5c372 too?  different address...
 };
 
@@ -83,6 +85,12 @@ enum ds_type {
 #define DS1339_REG_ALARM1_SECS	0x07
 #define DS1339_REG_TRICKLE	0x10
 
+#define RX8025_REG_CTRL1	0x0e
+#	define RX8025_BIT_2412		0x20
+#define RX8025_REG_CTRL2	0x0f
+#	define RX8025_BIT_PON		0x10
+#	define RX8025_BIT_VDET		0x40
+#	define RX8025_BIT_XST		0x20
 
 
 struct ds1307 {
@@ -121,6 +129,8 @@ static const struct chip_desc chips[] = 
 [ds_1340] = {
 },
 [m41t00] = {
+},
+[rx_8025] = {
 }, };
 
 static const struct i2c_device_id ds1307_id[] = {
@@ -130,6 +140,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1339", ds_1339 },
 	{ "ds1340", ds_1340 },
 	{ "m41t00", m41t00 },
+	{ "rx8025", rx_8025 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ds1307_id);
@@ -674,6 +685,72 @@ static int __devinit ds1307_probe(struct
 			dev_warn(&client->dev, "SET TIME!\n");
 		}
 		break;
+
+	case rx_8025:
+		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
+		if (tmp != 2) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator off?  turn it on, so clock can tick. */
+		if (!(ds1307->regs[1] & RX8025_BIT_XST)) {
+			ds1307->regs[1] |= RX8025_BIT_XST;
+			i2c_smbus_write_byte_data(client,
+						  RX8025_REG_CTRL2 << 4 | 0x08,
+						  ds1307->regs[1]);
+			dev_warn(&client->dev,
+				 "oscillator stop detected - SET TIME!\n");
+		}
+
+		if (ds1307->regs[1] & RX8025_BIT_PON) {
+			ds1307->regs[1] &= ~RX8025_BIT_PON;
+			i2c_smbus_write_byte_data(client,
+						  RX8025_REG_CTRL2 << 4 | 0x08,
+						  ds1307->regs[1]);
+			dev_warn(&client->dev, "power-on detected\n");
+		}
+
+		if (ds1307->regs[1] & RX8025_BIT_VDET) {
+			ds1307->regs[1] &= ~RX8025_BIT_VDET;
+			i2c_smbus_write_byte_data(client,
+						  RX8025_REG_CTRL2 << 4 | 0x08,
+						  ds1307->regs[1]);
+			dev_warn(&client->dev, "voltage drop detected\n");
+		}
+
+		/* make sure we are running in 24hour mode */
+		if (!(ds1307->regs[0] & RX8025_BIT_2412)) {
+			u8 hour;
+
+			/* switch to 24 hour mode */
+			i2c_smbus_write_byte_data(client,
+						  RX8025_REG_CTRL1 << 4 | 0x08,
+						  ds1307->regs[0] |
+						  RX8025_BIT_2412);
+
+			tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+					RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
+			if (tmp != 2) {
+				pr_debug("read error %d\n", tmp);
+				err = -EIO;
+				goto exit_free;
+			}
+
+			/* correct hour */
+			hour = bcd2bin(ds1307->regs[DS1307_REG_HOUR]);
+			if (hour == 12)
+				hour = 0;
+			if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
+				hour += 12;
+
+			i2c_smbus_write_byte_data(client,
+						  DS1307_REG_HOUR << 4 | 0x08,
+						  hour);
+		}
+		break;
 	default:
 		break;
 	}
@@ -734,6 +811,7 @@ read_rtc:
 			dev_warn(&client->dev, "SET TIME!\n");
 		}
 		break;
+	case rx_8025:
 	case ds_1337:
 	case ds_1339:
 		break;
@@ -747,6 +825,8 @@ read_rtc:
 		 * systems that will run through year 2100.
 		 */
 		break;
+	case rx_8025:
+		break;
 	default:
 		if (!(tmp & DS1307_BIT_12HR))
 			break;
_

Patches currently in -mm which might be from matthias.fuchs@esd-electronics.com are

origin.patch
rtc-add-ds1685-ds1687-rtc-driver.patch

