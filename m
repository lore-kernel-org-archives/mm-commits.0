From: akpm@linux-foundation.org
Subject: + rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
 added to -mm tree
Date: Mon, 02 Dec 2013 15:15:41 -0800
Message-ID: <529d149d.3xQGC6RSbWUszFKU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3LBXPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 18:15:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lgirdwood@gmail.com, lee.jones@linaro.org, kyungmin.park@samsung.com, geert@linux-m68k.org, broonie@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + rtc-s5m-limit-endless-loop-waiting-for-register-update.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,broonie@linaro.org,geert@linux-m68k.org,kyungmin.park@samsung.com,lee.jones@linaro.org,lgirdwood@gmail.com,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 15:15:41 -0800


The patch titled
     Subject: rtc: s5m: limit endless loop waiting for register update
has been added to the -mm tree.  Its filename is
     rtc-s5m-limit-endless-loop-waiting-for-register-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-limit-endless-loop-waiting-for-register-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc: s5m: limit endless loop waiting for register update

After setting alarm or time the driver is waiting for UDR register to be
cleared indicating that registers data have been transferred.

Limit the endless loop to only 5 retries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviwed-by: Mark Brown <broonie@linaro.org>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-limit-endless-loop-waiting-for-register-update drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-limit-endless-loop-waiting-for-register-update
+++ a/drivers/rtc/rtc-s5m.c
@@ -28,6 +28,16 @@
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
 
+/*
+ * Maximum number of retries for checking changes in UDR field
+ * of SEC_RTC_UDR_CON register (to limit possible endless loop).
+ *
+ * After writing to RTC registers (setting time or alarm) read the UDR field
+ * in SEC_RTC_UDR_CON register. UDR is auto-cleared when data have
+ * been transferred.
+ */
+#define UDR_READ_RETRY_CNT	5
+
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
@@ -84,6 +94,25 @@ static int s5m8767_tm_to_data(struct rtc
 	}
 }
 
+/*
+ * Read RTC_UDR_CON register and wait till UDR field is cleared.
+ * This indicates that time/alarm update ended.
+ */
+static inline int s5m8767_wait_for_udr_update(struct s5m_rtc_info *info)
+{
+	int ret, retry = UDR_READ_RETRY_CNT;
+	unsigned int data;
+
+	do {
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	} while (--retry && (data & RTC_UDR_MASK) && !ret);
+
+	if (!retry)
+		dev_err(info->dev, "waiting for UDR update, reached max number of retries\n");
+
+	return ret;
+}
+
 static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 {
 	int ret;
@@ -104,9 +133,7 @@ static inline int s5m8767_rtc_set_time_r
 		return ret;
 	}
 
-	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while ((data & RTC_UDR_MASK) && !ret);
+	ret = s5m8767_wait_for_udr_update(info);
 
 	return ret;
 }
@@ -133,9 +160,7 @@ static inline int s5m8767_rtc_set_alarm_
 		return ret;
 	}
 
-	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while ((data & RTC_UDR_MASK) && !ret);
+	ret = s5m8767_wait_for_udr_update(info);
 
 	return ret;
 }
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-sec-constify-regmap-configs-and-regmap-irqs.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
linux-next.patch

