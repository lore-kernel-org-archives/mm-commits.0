From: akpm@linux-foundation.org
Subject: [merged] rtc-use-more-standard-kernel-logging-styles.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:30 -0700
Message-ID: <55355106.o0nlVBVv5mBdQFQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbbDTTMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, a.zummo@towertech.it, aaro.koskinen@iki.fi, alexandre.belloni@free-electrons.com, cw00.choi@samsung.com, k.kozlowski@samsung.com, kumba@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: use more standard kernel logging styles
has been removed from the -mm tree.  Its filename was
     rtc-use-more-standard-kernel-logging-styles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: rtc: use more standard kernel logging styles

Neaten the logging a bit by adding #define pr_fmt

Miscellanea:

o Remove __FILE__/__func__ uses
o Coalesce formats adding missing spaces
o Align arguments
o (rtc-cmos) Integrated 2 consecutive messages

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joshua Kinard <kumba@gentoo.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c          |    6 ++++--
 drivers/rtc/rtc-cmos.c         |    6 ++++--
 drivers/rtc/rtc-ds1374.c       |    8 +++++---
 drivers/rtc/rtc-ds1685.c       |    4 +++-
 drivers/rtc/rtc-ds3232.c       |    6 ++++--
 drivers/rtc/rtc-efi-platform.c |    3 +++
 drivers/rtc/rtc-m41t80.c       |    6 ++++--
 drivers/rtc/rtc-max77686.c     |    6 ++++--
 drivers/rtc/rtc-max8997.c      |    8 +++++---
 drivers/rtc/rtc-msm6242.c      |    4 +++-
 drivers/rtc/rtc-opal.c         |    3 ++-
 drivers/rtc/rtc-s5m.c          |    4 +++-
 drivers/rtc/rtc-twl.c          |    9 +++++----
 13 files changed, 49 insertions(+), 24 deletions(-)

diff -puN drivers/rtc/hctosys.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/hctosys.c
@@ -9,6 +9,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/rtc.h>
 
 /* IMPORTANT: the RTC only stores whole seconds. It is arbitrary
@@ -32,8 +34,8 @@ static int __init rtc_hctosys(void)
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
-		pr_info("%s: unable to open rtc device (%s)\n",
-			__func__, CONFIG_RTC_HCTOSYS_DEVICE);
+		pr_info("unable to open rtc device (%s)\n",
+			CONFIG_RTC_HCTOSYS_DEVICE);
 		goto err_open;
 	}
 
diff -puN drivers/rtc/rtc-cmos.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-cmos.c
@@ -28,6 +28,9 @@
  * interrupts disabled, holding the global rtc_lock, to exclude those
  * other drivers and utilities on correctly configured systems.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -385,8 +388,7 @@ static bool alarm_disable_quirk;
 static int __init set_alarm_disable_quirk(const struct dmi_system_id *id)
 {
 	alarm_disable_quirk = true;
-	pr_info("rtc-cmos: BIOS has alarm-disable quirk. ");
-	pr_info("RTC alarms disabled\n");
+	pr_info("BIOS has alarm-disable quirk - RTC alarms disabled\n");
 	return 0;
 }
 
diff -puN drivers/rtc/rtc-ds1374.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-ds1374.c
@@ -18,6 +18,8 @@
  * "Sending and receiving", using SMBus level communication is preferred.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -406,7 +408,7 @@ static int ds1374_wdt_settimeout(unsigne
 	/* Set new watchdog time */
 	ret = ds1374_write_rtc(save_client, timeout, DS1374_REG_WDALM0, 3);
 	if (ret) {
-		pr_info("rtc-ds1374 - couldn't set new watchdog time\n");
+		pr_info("couldn't set new watchdog time\n");
 		goto out;
 	}
 
@@ -539,12 +541,12 @@ static long ds1374_wdt_ioctl(struct file
 			return -EFAULT;
 
 		if (options & WDIOS_DISABLECARD) {
-			pr_info("rtc-ds1374: disable watchdog\n");
+			pr_info("disable watchdog\n");
 			ds1374_wdt_disable();
 		}
 
 		if (options & WDIOS_ENABLECARD) {
-			pr_info("rtc-ds1374: enable watchdog\n");
+			pr_info("enable watchdog\n");
 			ds1374_wdt_settimeout(wdt_margin);
 			ds1374_wdt_ping();
 		}
diff -puN drivers/rtc/rtc-ds1685.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-ds1685.c
@@ -16,6 +16,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bcd.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -2182,7 +2184,7 @@ ds1685_rtc_poweroff(struct platform_devi
 
 	/* Check for valid RTC data, else, spin forever. */
 	if (unlikely(!pdev)) {
-		pr_emerg("rtc-ds1685: platform device data not available, spinning forever ...\n");
+		pr_emerg("platform device data not available, spinning forever ...\n");
 		unreachable();
 	} else {
 		/* Get the rtc data. */
diff -puN drivers/rtc/rtc-ds3232.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-ds3232.c
@@ -15,6 +15,8 @@
  * "Sending and receiving", using SMBus level communication is preferred.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -373,8 +375,8 @@ static void ds3232_work(struct work_stru
 	if (stat & DS3232_REG_SR_A1F) {
 		control = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
 		if (control < 0) {
-			pr_warn("Read DS3232 Control Register error."
-				"Disable IRQ%d.\n", client->irq);
+			pr_warn("Read Control Register error - Disable IRQ%d\n",
+				client->irq);
 		} else {
 			/* disable alarm1 interrupt */
 			control &= ~(DS3232_REG_CR_A1IE);
diff -puN drivers/rtc/rtc-efi-platform.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-efi-platform.c
--- a/drivers/rtc/rtc-efi-platform.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-efi-platform.c
@@ -8,6 +8,9 @@
  * Copyright (C) 1999-2000 VA Linux Systems
  * Copyright (C) 1999-2000 Walt Drummond <drummond@valinux.com>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff -puN drivers/rtc/rtc-m41t80.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-m41t80.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bcd.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
@@ -513,12 +515,12 @@ static int wdt_ioctl(struct file *file,
 			return -EFAULT;
 
 		if (rv & WDIOS_DISABLECARD) {
-			pr_info("rtc-m41t80: disable watchdog\n");
+			pr_info("disable watchdog\n");
 			wdt_disable();
 		}
 
 		if (rv & WDIOS_ENABLECARD) {
-			pr_info("rtc-m41t80: enable watchdog\n");
+			pr_info("enable watchdog\n");
 			wdt_ping();
 		}
 
diff -puN drivers/rtc/rtc-max77686.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-max77686.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/rtc.h>
 #include <linux/delay.h>
@@ -103,8 +105,8 @@ static int max77686_rtc_tm_to_data(struc
 	data[RTC_YEAR] = tm->tm_year > 100 ? (tm->tm_year - 100) : 0;
 
 	if (tm->tm_year < 100) {
-		pr_warn("%s: MAX77686 RTC cannot handle the year %d."
-			"Assume it's 2000.\n", __func__, 1900 + tm->tm_year);
+		pr_warn("RTC cannot handle the year %d.  Assume it's 2000.\n",
+			1900 + tm->tm_year);
 		return -EINVAL;
 	}
 	return 0;
diff -puN drivers/rtc/rtc-max8997.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-max8997.c
--- a/drivers/rtc/rtc-max8997.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-max8997.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/rtc.h>
 #include <linux/delay.h>
@@ -107,8 +109,8 @@ static int max8997_rtc_tm_to_data(struct
 	data[RTC_YEAR] = tm->tm_year > 100 ? (tm->tm_year - 100) : 0;
 
 	if (tm->tm_year < 100) {
-		pr_warn("%s: MAX8997 RTC cannot handle the year %d."
-			"Assume it's 2000.\n", __func__, 1900 + tm->tm_year);
+		pr_warn("RTC cannot handle the year %d.  Assume it's 2000.\n",
+			1900 + tm->tm_year);
 		return -EINVAL;
 	}
 	return 0;
@@ -424,7 +426,7 @@ static void max8997_rtc_enable_smpl(stru
 
 	val = 0;
 	max8997_read_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, &val);
-	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
+	pr_info("WTSR_SMPL(0x%02x)\n", val);
 }
 
 static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
diff -puN drivers/rtc/rtc-msm6242.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-msm6242.c
--- a/drivers/rtc/rtc-msm6242.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-msm6242.c
@@ -7,6 +7,8 @@
  *  Copyright (C) 1993 Hamish Macdonald
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -111,7 +113,7 @@ static void msm6242_lock(struct msm6242_
 	}
 
 	if (!cnt)
-		pr_warn("msm6242: timed out waiting for RTC (0x%x)\n",
+		pr_warn("timed out waiting for RTC (0x%x)\n",
 			msm6242_read(priv, MSM6242_CD));
 }
 
diff -puN drivers/rtc/rtc-opal.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-opal.c
--- a/drivers/rtc/rtc-opal.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-opal.c
@@ -16,8 +16,9 @@
  * along with this program.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DRVNAME		"rtc-opal"
-#define pr_fmt(fmt)	DRVNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/err.h>
diff -puN drivers/rtc/rtc-s5m.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-s5m.c
@@ -15,6 +15,8 @@
  *  GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/bcd.h>
@@ -146,7 +148,7 @@ static int s5m8767_tm_to_data(struct rtc
 	data[RTC_YEAR1] = tm->tm_year > 100 ? (tm->tm_year - 100) : 0;
 
 	if (tm->tm_year < 100) {
-		pr_err("s5m8767 RTC cannot handle the year %d.\n",
+		pr_err("RTC cannot handle the year %d\n",
 		       1900 + tm->tm_year);
 		return -EINVAL;
 	} else {
diff -puN drivers/rtc/rtc-twl.c~rtc-use-more-standard-kernel-logging-styles drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-use-more-standard-kernel-logging-styles
+++ a/drivers/rtc/rtc-twl.c
@@ -18,6 +18,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -145,8 +147,7 @@ static int twl_rtc_read_u8(u8 *data, u8
 
 	ret = twl_i2c_read_u8(TWL_MODULE_RTC, data, (rtc_reg_map[reg]));
 	if (ret < 0)
-		pr_err("twl_rtc: Could not read TWL"
-		       "register %X - error %d\n", reg, ret);
+		pr_err("Could not read TWL register %X - error %d\n", reg, ret);
 	return ret;
 }
 
@@ -159,8 +160,8 @@ static int twl_rtc_write_u8(u8 data, u8
 
 	ret = twl_i2c_write_u8(TWL_MODULE_RTC, data, (rtc_reg_map[reg]));
 	if (ret < 0)
-		pr_err("twl_rtc: Could not write TWL"
-		       "register %X - error %d\n", reg, ret);
+		pr_err("Could not write TWL register %X - error %d\n",
+		       reg, ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

