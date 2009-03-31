From: akpm@linux-foundation.org
Subject: + rtc-add-m41t62-support-to-rtc-m41t80-driver.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:53:51 -0700
Message-ID: <200903312353.n2VNrpYd015599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbZCaX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, a.zummo@towertech.it, chris@zankel.net, david-b@pacbell.net


The patch titled
     rtc: add m41t62 support to rtc-m41t80 driver
has been added to the -mm tree.  Its filename is
     rtc-add-m41t62-support-to-rtc-m41t80-driver.patch

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
Subject: rtc: add m41t62 support to rtc-m41t80 driver
From: Daniel Glockner <dg@emlix.com>

Compared to the other supported chips, the m41t62 uses a different
register to set the square wave frequency.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    4 ++--
 drivers/rtc/rtc-m41t80.c |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-m41t62-support-to-rtc-m41t80-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-m41t62-support-to-rtc-m41t80-driver
+++ a/drivers/rtc/Kconfig
@@ -237,11 +237,11 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T65/M41T80/81/82/83/84/85/87"
+	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87"
 	help
 	  If you say Y here you will get support for the ST M41T60
 	  and M41T80 RTC chips series. Currently, the following chips are
-	  supported: M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
+	  supported: M41T62, M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
 	  M41ST85, and M41ST87.
 
 	  This driver can also be built as a module. If so, the module
diff -puN drivers/rtc/rtc-m41t80.c~rtc-add-m41t62-support-to-rtc-m41t80-driver drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-add-m41t62-support-to-rtc-m41t80-driver
+++ a/drivers/rtc/rtc-m41t80.c
@@ -64,10 +64,12 @@
 #define M41T80_FEATURE_BL	(1 << 1)	/* Battery low indicator */
 #define M41T80_FEATURE_SQ	(1 << 2)	/* Squarewave feature */
 #define M41T80_FEATURE_WD	(1 << 3)	/* Extra watchdog resolution */
+#define M41T80_FEATURE_SQ_ALT	(1 << 4)	/* RSx bits are in reg 4 */
 
 #define DRV_VERSION "0.05"
 
 static const struct i2c_device_id m41t80_id[] = {
+	{ "m41t62", M41T80_FEATURE_SQ | M41T80_FEATURE_SQ_ALT },
 	{ "m41t65", M41T80_FEATURE_HT | M41T80_FEATURE_WD },
 	{ "m41t80", M41T80_FEATURE_SQ },
 	{ "m41t81", M41T80_FEATURE_HT | M41T80_FEATURE_SQ},
@@ -393,12 +395,15 @@ static ssize_t m41t80_sysfs_show_sqwfreq
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	int val;
+	int val, reg_sqw;
 
 	if (!(clientdata->features & M41T80_FEATURE_SQ))
 		return -EINVAL;
 
-	val = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	reg_sqw = M41T80_REG_SQW;
+	if (clientdata->features & M41T80_FEATURE_SQ_ALT)
+		reg_sqw = M41T80_REG_WDAY;
+	val = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (val < 0)
 		return -EIO;
 	val = (val >> 4) & 0xf;
@@ -419,7 +424,7 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	int almon, sqw;
+	int almon, sqw, reg_sqw;
 	int val = simple_strtoul(buf, NULL, 0);
 
 	if (!(clientdata->features & M41T80_FEATURE_SQ))
@@ -440,13 +445,16 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 	almon = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (almon < 0)
 		return -EIO;
-	sqw = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	reg_sqw = M41T80_REG_SQW;
+	if (clientdata->features & M41T80_FEATURE_SQ_ALT)
+		reg_sqw = M41T80_REG_WDAY;
+	sqw = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (sqw < 0)
 		return -EIO;
 	sqw = (sqw & 0x0f) | (val << 4);
 	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
 				      almon & ~M41T80_ALMON_SQWE) < 0 ||
-	    i2c_smbus_write_byte_data(client, M41T80_REG_SQW, sqw) < 0)
+	    i2c_smbus_write_byte_data(client, reg_sqw, sqw) < 0)
 		return -EIO;
 	if (val && i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
 					     almon | M41T80_ALMON_SQWE) < 0)
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
linux-next.patch
xtensa-make-startup-code-discardable.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
rtc-add-m41t62-support-to-rtc-m41t80-driver.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch

