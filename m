From: akpm@linux-foundation.org
Subject: + rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:42:13 -0700
Message-ID: <200808282342.m7SNgDVU020520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbYH1Xmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfalco@harris.com, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net, macro@linux-mips.org


The patch titled
     rtc: rtc-m41t80.c: add support for the ST M41T65 RTC
has been added to the -mm tree.  Its filename is
     rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-m41t80.c: add support for the ST M41T65 RTC
From: "Steven A. Falco" <sfalco@harris.com>

Add support for M41T65 Real Time Clock chip.

The main differences I see between the M41T65 and M41T80 are that:

1) The M41T65 watchdog timer has three bits controlling resolution
   (versus two for the M41T80).

2) There is no register 0x13 for controlling square-wave output.

Signed-off-by: Steven A. Falco <sfalco@harris.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   14 +++++------
 drivers/rtc/rtc-m41t80.c |   45 +++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc
+++ a/drivers/rtc/Kconfig
@@ -220,22 +220,22 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T80/81/82/83/84/85/87"
+	tristate "ST M41T65/M41T80/81/82/83/84/85/87"
 	help
-	  If you say Y here you will get support for the
-	  ST M41T80 RTC chips series. Currently following chips are
-	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
-	  and M41ST87.
+	  If you say Y here you will get support for the ST M41T60
+	  and M41T80 RTC chips series. Currently, the following chips are
+	  supported: M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
+	  M41ST85, and M41ST87.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m41t80.
 
 config RTC_DRV_M41T80_WDT
-	bool "ST M41T80 series RTC watchdog timer"
+	bool "ST M41T65/M41T80 series RTC watchdog timer"
 	depends on RTC_DRV_M41T80
 	help
 	  If you say Y here you will get support for the
-	  watchdog timer in ST M41T80 RTC chips series.
+	  watchdog timer in the ST M41T60 and M41T80 RTC chips series.
 
 config RTC_DRV_TWL92330
 	boolean "TI TWL92330/Menelaus"
diff -puN drivers/rtc/rtc-m41t80.c~rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc
+++ a/drivers/rtc/rtc-m41t80.c
@@ -56,21 +56,27 @@
 #define M41T80_ALHOUR_HT	(1 << 6)	/* HT: Halt Update Bit */
 #define M41T80_FLAGS_AF		(1 << 6)	/* AF: Alarm Flag Bit */
 #define M41T80_FLAGS_BATT_LOW	(1 << 4)	/* BL: Battery Low Bit */
-
-#define M41T80_FEATURE_HT	(1 << 0)
-#define M41T80_FEATURE_BL	(1 << 1)
+#define M41T80_WATCHDOG_RB2	(1 << 7)	/* RB: Watchdog resolution */
+#define M41T80_WATCHDOG_RB1	(1 << 1)	/* RB: Watchdog resolution */
+#define M41T80_WATCHDOG_RB0	(1 << 0)	/* RB: Watchdog resolution */
+
+#define M41T80_FEATURE_HT	(1 << 0)	/* Halt feature */
+#define M41T80_FEATURE_BL	(1 << 1)	/* Battery low indicator */
+#define M41T80_FEATURE_SQ	(1 << 2)	/* Squarewave feature */
+#define M41T80_FEATURE_WD	(1 << 3)	/* Extra watchdog resolution */
 
 #define DRV_VERSION "0.05"
 
 static const struct i2c_device_id m41t80_id[] = {
-	{ "m41t80", 0 },
-	{ "m41t81", M41T80_FEATURE_HT },
-	{ "m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41t65", M41T80_FEATURE_HT | M41T80_FEATURE_WD },
+	{ "m41t80", M41T80_FEATURE_SQ },
+	{ "m41t81", M41T80_FEATURE_HT | M41T80_FEATURE_SQ},
+	{ "m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, m41t80_id);
@@ -386,8 +392,12 @@ static ssize_t m41t80_sysfs_show_sqwfreq
 				struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	int val;
 
+	if (!(clientdata->features & M41T80_FEATURE_SQ))
+		return -EINVAL;
+
 	val = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
 	if (val < 0)
 		return -EIO;
@@ -408,9 +418,13 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 				const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	int almon, sqw;
 	int val = simple_strtoul(buf, NULL, 0);
 
+	if (!(clientdata->features & M41T80_FEATURE_SQ))
+		return -EINVAL;
+
 	if (val) {
 		if (!is_power_of_2(val))
 			return -EINVAL;
@@ -499,6 +513,8 @@ static void wdt_ping(void)
 			.buf	= i2c_data,
 		},
 	};
+	struct m41t80_data *clientdata = i2c_get_clientdata(save_client);
+
 	i2c_data[0] = 0x09;		/* watchdog register */
 
 	if (wdt_margin > 31)
@@ -509,6 +525,13 @@ static void wdt_ping(void)
 		 */
 		i2c_data[1] = wdt_margin<<2 | 0x82;
 
+	/*
+	 * M41T65 has three bits for watchdog resolution.  Don't set bit 7, as
+	 * that would be an invalid resolution.
+	 */
+	if (clientdata->features & M41T80_FEATURE_WD)
+		i2c_data[1] &= ~M41T80_WATCHDOG_RB2;
+
 	i2c_transfer(save_client->adapter, msgs1, 1);
 }
 
_

Patches currently in -mm which might be from sfalco@harris.com are

rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch

