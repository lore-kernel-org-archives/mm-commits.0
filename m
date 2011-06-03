From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device.patch added to -mm tree
Date: Fri, 03 Jun 2011 16:46:55 -0700
Message-ID: <201106032346.p53Nktoa015301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab1FCXrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Priyanka.Jain@freescale.com, B04825@freescale.com, B32167@freescale.com, a.zummo@towertech.it, avorontsov@mvista.com, benh@kernel.crashing.org, galak@gate.crashing.org, grant.likely@secretlab.ca, w.sang@pengutronix.de


The patch titled
     drivers/rtc/rtc-ds1307.c: add support for the pt7c4338 rtc device
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device.patch

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
Subject: drivers/rtc/rtc-ds1307.c: add support for the pt7c4338 rtc device
From: Priyanka Jain <Priyanka.Jain@freescale.com>

PT7C4338 chip is being manufactured by Pericom Technology Inc.  It is a
serial real-time clock which provides:

1) Low-power clock/calendar.
2) Programmable square-wave output.

It has 56 bytes of nonvolatile RAM.  Its register set is same as that of
the rtc device DS1307.

Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jain Priyanka-B32167 <B32167@freescale.com>
Cc: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    6 +++---
 drivers/rtc/rtc-ds1307.c |    7 +++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device
+++ a/drivers/rtc/Kconfig
@@ -136,13 +136,13 @@ config RTC_DRV_88PM860X
 	  will be called rtc-88pm860x.
 
 config RTC_DRV_DS1307
-	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025"
+	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00, EPSON RX-8025, PT7C4338"
 	help
 	  If you say yes here you get support for various compatible RTC
 	  chips (often with battery backup) connected with I2C. This driver
 	  should handle DS1307, DS1337, DS1338, DS1339, DS1340, ST M41T00,
-	  EPSON RX-8025 and probably other chips. In some cases the RTC
-	  must already have been initialized (by manufacturing or a
+	  EPSON RX-8025, PT7C4338 and probably other chips. In some cases
+	  the RTC must already have been initialized (by manufacturing or a
 	  bootloader).
 
 	  The first seven registers on these chips hold an RTC, and other
diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device
+++ a/drivers/rtc/rtc-ds1307.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 2005 James Chapman (ds1337 core)
  *  Copyright (C) 2006 David Brownell
  *  Copyright (C) 2009 Matthias Fuchs (rx8025 support)
+ *  Copyright (C) 2011 Priyanka Jain (Priyanka.Jain@freescale.com)
+ *                                   (pt7c4338 support)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -34,6 +36,7 @@ enum ds_type {
 	ds_1388,
 	ds_3231,
 	m41t00,
+	pt7c4338,
 	rx_8025,
 	// rs5c372 too?  different address...
 };
@@ -137,6 +140,8 @@ static const struct chip_desc chips[] = 
 },
 [m41t00] = {
 },
+[pt7c4338] = {
+},
 [rx_8025] = {
 }, };
 
@@ -149,6 +154,7 @@ static const struct i2c_device_id ds1307
 	{ "ds1340", ds_1340 },
 	{ "ds3231", ds_3231 },
 	{ "m41t00", m41t00 },
+	{ "pt7c4338", pt7c4338 },
 	{ "rx8025", rx_8025 },
 	{ }
 };
@@ -769,6 +775,7 @@ read_rtc:
 	switch (ds1307->type) {
 	case ds_1307:
 	case m41t00:
+	case pt7c4338:
 		/* clock halted?  turn it on, so clock can tick. */
 		if (tmp & DS1307_BIT_CH) {
 			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
_

Patches currently in -mm which might be from Priyanka.Jain@freescale.com are

drivers-rtc-rtc-ds1307c-add-support-for-the-pt7c4338-rtc-device.patch

