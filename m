From: akpm@linux-foundation.org
Subject: + mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 15:21:32 -0700
Message-ID: <535599ec.KRfkvVtXv9vs5/ck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaDUWVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lee.jones@linaro.org, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,lee.jones@linaro.org,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:21:32 -0700


The patch titled
     Subject: mfd/rtc: sec/s5m: rename SEC* symbols to S5M
has been added to the -mm tree.  Its filename is
     mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch

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
Subject: mfd/rtc: sec/s5m: rename SEC* symbols to S5M

Prepare for adding support for S2MPS14 RTC device to the rtc-s5m driver:

1. Rename SEC* symbols to S5M.
2. Add S5M prefix to some of defines which are different between S5M876X
   and S2MPS14.

This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c           |   66 +++++++++++++-------------
 include/linux/mfd/samsung/rtc.h |   76 +++++++++++++++---------------
 2 files changed, 71 insertions(+), 71 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m
+++ a/drivers/rtc/rtc-s5m.c
@@ -30,10 +30,10 @@
 
 /*
  * Maximum number of retries for checking changes in UDR field
- * of SEC_RTC_UDR_CON register (to limit possible endless loop).
+ * of S5M_RTC_UDR_CON register (to limit possible endless loop).
  *
  * After writing to RTC registers (setting time or alarm) read the UDR field
- * in SEC_RTC_UDR_CON register. UDR is auto-cleared when data have
+ * in S5M_RTC_UDR_CON register. UDR is auto-cleared when data have
  * been transferred.
  */
 #define UDR_READ_RETRY_CNT	5
@@ -54,7 +54,7 @@ static const struct regmap_config s5m_rt
 	.reg_bits = 8,
 	.val_bits = 8,
 
-	.max_register = SEC_RTC_REG_MAX,
+	.max_register = S5M_RTC_REG_MAX,
 };
 
 static const struct regmap_config s2mps14_rtc_regmap_config = {
@@ -119,8 +119,8 @@ static inline int s5m8767_wait_for_udr_u
 	unsigned int data;
 
 	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while (--retry && (data & RTC_UDR_MASK) && !ret);
+		ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
+	} while (--retry && (data & S5M_RTC_UDR_MASK) && !ret);
 
 	if (!retry)
 		dev_err(info->dev, "waiting for UDR update, reached max number of retries\n");
@@ -133,16 +133,16 @@ static inline int s5m8767_rtc_set_time_r
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to read update reg(%d)\n", ret);
 		return ret;
 	}
 
-	data |= RTC_TIME_EN_MASK;
-	data |= RTC_UDR_MASK;
+	data |= S5M_RTC_TIME_EN_MASK;
+	data |= S5M_RTC_UDR_MASK;
 
-	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to write update reg(%d)\n", ret);
 		return ret;
@@ -158,17 +158,17 @@ static inline int s5m8767_rtc_set_alarm_
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read update reg(%d)\n",
 			__func__, ret);
 		return ret;
 	}
 
-	data &= ~RTC_TIME_EN_MASK;
-	data |= RTC_UDR_MASK;
+	data &= ~S5M_RTC_TIME_EN_MASK;
+	data |= S5M_RTC_UDR_MASK;
 
-	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 			__func__, ret);
@@ -218,7 +218,7 @@ static int s5m_rtc_read_time(struct devi
 	u8 data[8];
 	int ret;
 
-	ret = regmap_bulk_read(info->regmap, SEC_RTC_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -266,7 +266,7 @@ static int s5m_rtc_set_time(struct devic
 		1900 + tm->tm_year, 1 + tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec, tm->tm_wday);
 
-	ret = regmap_raw_write(info->regmap, SEC_RTC_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, S5M_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -282,20 +282,20 @@ static int s5m_rtc_read_alarm(struct dev
 	unsigned int val;
 	int ret, i;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
 	switch (info->device_type) {
 	case S5M8763X:
 		s5m8763_data_to_tm(data, &alrm->time);
-		ret = regmap_read(info->regmap, SEC_ALARM0_CONF, &val);
+		ret = regmap_read(info->regmap, S5M_ALARM0_CONF, &val);
 		if (ret < 0)
 			return ret;
 
 		alrm->enabled = !!val;
 
-		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 
@@ -318,7 +318,7 @@ static int s5m_rtc_read_alarm(struct dev
 		}
 
 		alrm->pending = 0;
-		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 		break;
@@ -327,7 +327,7 @@ static int s5m_rtc_read_alarm(struct dev
 		return -EINVAL;
 	}
 
-	if (val & ALARM0_STATUS)
+	if (val & S5M_ALARM0_STATUS)
 		alrm->pending = 1;
 	else
 		alrm->pending = 0;
@@ -341,7 +341,7 @@ static int s5m_rtc_stop_alarm(struct s5m
 	int ret, i;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -352,14 +352,14 @@ static int s5m_rtc_stop_alarm(struct s5m
 
 	switch (info->device_type) {
 	case S5M8763X:
-		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, 0);
+		ret = regmap_write(info->regmap, S5M_ALARM0_CONF, 0);
 		break;
 
 	case S5M8767X:
 		for (i = 0; i < 7; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 
@@ -381,7 +381,7 @@ static int s5m_rtc_start_alarm(struct s5
 	u8 alarm0_conf;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -393,7 +393,7 @@ static int s5m_rtc_start_alarm(struct s5
 	switch (info->device_type) {
 	case S5M8763X:
 		alarm0_conf = 0x77;
-		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, alarm0_conf);
+		ret = regmap_write(info->regmap, S5M_ALARM0_CONF, alarm0_conf);
 		break;
 
 	case S5M8767X:
@@ -408,7 +408,7 @@ static int s5m_rtc_start_alarm(struct s5
 		if (data[RTC_YEAR1] & 0x7f)
 			data[RTC_YEAR1] |= ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 		ret = s5m8767_rtc_set_alarm_reg(info);
@@ -450,7 +450,7 @@ static int s5m_rtc_set_alarm(struct devi
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -495,7 +495,7 @@ static const struct rtc_class_ops s5m_rt
 static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
 				 WTSR_ENABLE_MASK,
 				 enable ? WTSR_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -506,7 +506,7 @@ static void s5m_rtc_enable_wtsr(struct s
 static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
 				 SMPL_ENABLE_MASK,
 				 enable ? SMPL_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -521,7 +521,7 @@ static int s5m8767_rtc_init_reg(struct s
 	int ret;
 	struct rtc_time tm;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &tp_read);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &tp_read);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
 			__func__, ret);
@@ -533,7 +533,7 @@ static int s5m8767_rtc_init_reg(struct s
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->regmap, SEC_ALARM0_CONF, data, 2);
+	ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -555,7 +555,7 @@ static int s5m8767_rtc_init_reg(struct s
 		ret = s5m_rtc_set_time(info->dev, &tm);
 	}
 
-	ret = regmap_update_bits(info->regmap, SEC_RTC_UDR_CON,
+	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
 				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
@@ -676,7 +676,7 @@ static void s5m_rtc_shutdown(struct plat
 	if (info->wtsr_smpl) {
 		for (i = 0; i < 3; i++) {
 			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->regmap, SEC_WTSR_SMPL_CNTL, &val);
+			regmap_read(info->regmap, S5M_WTSR_SMPL_CNTL, &val);
 			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
 			if (val & WTSR_ENABLE_MASK)
 				pr_emerg("%s: fail to disable WTSR\n",
diff -puN include/linux/mfd/samsung/rtc.h~mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m include/linux/mfd/samsung/rtc.h
--- a/include/linux/mfd/samsung/rtc.h~mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m
+++ a/include/linux/mfd/samsung/rtc.h
@@ -18,38 +18,38 @@
 #ifndef __LINUX_MFD_SEC_RTC_H
 #define __LINUX_MFD_SEC_RTC_H
 
-enum sec_rtc_reg {
-	SEC_RTC_SEC,
-	SEC_RTC_MIN,
-	SEC_RTC_HOUR,
-	SEC_RTC_WEEKDAY,
-	SEC_RTC_DATE,
-	SEC_RTC_MONTH,
-	SEC_RTC_YEAR1,
-	SEC_RTC_YEAR2,
-	SEC_ALARM0_SEC,
-	SEC_ALARM0_MIN,
-	SEC_ALARM0_HOUR,
-	SEC_ALARM0_WEEKDAY,
-	SEC_ALARM0_DATE,
-	SEC_ALARM0_MONTH,
-	SEC_ALARM0_YEAR1,
-	SEC_ALARM0_YEAR2,
-	SEC_ALARM1_SEC,
-	SEC_ALARM1_MIN,
-	SEC_ALARM1_HOUR,
-	SEC_ALARM1_WEEKDAY,
-	SEC_ALARM1_DATE,
-	SEC_ALARM1_MONTH,
-	SEC_ALARM1_YEAR1,
-	SEC_ALARM1_YEAR2,
-	SEC_ALARM0_CONF,
-	SEC_ALARM1_CONF,
-	SEC_RTC_STATUS,
-	SEC_WTSR_SMPL_CNTL,
-	SEC_RTC_UDR_CON,
+enum s5m_rtc_reg {
+	S5M_RTC_SEC,
+	S5M_RTC_MIN,
+	S5M_RTC_HOUR,
+	S5M_RTC_WEEKDAY,
+	S5M_RTC_DATE,
+	S5M_RTC_MONTH,
+	S5M_RTC_YEAR1,
+	S5M_RTC_YEAR2,
+	S5M_ALARM0_SEC,
+	S5M_ALARM0_MIN,
+	S5M_ALARM0_HOUR,
+	S5M_ALARM0_WEEKDAY,
+	S5M_ALARM0_DATE,
+	S5M_ALARM0_MONTH,
+	S5M_ALARM0_YEAR1,
+	S5M_ALARM0_YEAR2,
+	S5M_ALARM1_SEC,
+	S5M_ALARM1_MIN,
+	S5M_ALARM1_HOUR,
+	S5M_ALARM1_WEEKDAY,
+	S5M_ALARM1_DATE,
+	S5M_ALARM1_MONTH,
+	S5M_ALARM1_YEAR1,
+	S5M_ALARM1_YEAR2,
+	S5M_ALARM0_CONF,
+	S5M_ALARM1_CONF,
+	S5M_RTC_STATUS,
+	S5M_WTSR_SMPL_CNTL,
+	S5M_RTC_UDR_CON,
 
-	SEC_RTC_REG_MAX,
+	S5M_RTC_REG_MAX,
 };
 
 enum s2mps_rtc_reg {
@@ -88,9 +88,9 @@ enum s2mps_rtc_reg {
 #define HOUR_12			(1 << 7)
 #define HOUR_AMPM		(1 << 6)
 #define HOUR_PM			(1 << 5)
-#define ALARM0_STATUS		(1 << 1)
-#define ALARM1_STATUS		(1 << 2)
-#define UPDATE_AD		(1 << 0)
+#define S5M_ALARM0_STATUS	(1 << 1)
+#define S5M_ALARM1_STATUS	(1 << 2)
+#define S5M_UPDATE_AD		(1 << 0)
 
 #define S2MPS_ALARM0_STATUS	(1 << 2)
 #define S2MPS_ALARM1_STATUS	(1 << 1)
@@ -101,16 +101,16 @@ enum s2mps_rtc_reg {
 #define MODEL24_SHIFT		1
 #define MODEL24_MASK		(1 << MODEL24_SHIFT)
 /* RTC Update Register1 */
-#define RTC_UDR_SHIFT		0
-#define RTC_UDR_MASK		(1 << RTC_UDR_SHIFT)
+#define S5M_RTC_UDR_SHIFT	0
+#define S5M_RTC_UDR_MASK	(1 << S5M_RTC_UDR_SHIFT)
 #define S2MPS_RTC_WUDR_SHIFT	4
 #define S2MPS_RTC_WUDR_MASK	(1 << S2MPS_RTC_WUDR_SHIFT)
 #define S2MPS_RTC_RUDR_SHIFT	0
 #define S2MPS_RTC_RUDR_MASK	(1 << S2MPS_RTC_RUDR_SHIFT)
 #define RTC_TCON_SHIFT		1
 #define RTC_TCON_MASK		(1 << RTC_TCON_SHIFT)
-#define RTC_TIME_EN_SHIFT	3
-#define RTC_TIME_EN_MASK	(1 << RTC_TIME_EN_SHIFT)
+#define S5M_RTC_TIME_EN_SHIFT	3
+#define S5M_RTC_TIME_EN_MASK	(1 << S5M_RTC_TIME_EN_SHIFT)
 
 /* RTC Hour register */
 #define HOUR_PM_SHIFT		6
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

linux-next.patch
mfd-rtc-s5m-do-not-allocate-rtc-i2c-dummy-and-regmap-for-unsupported-chipsets.patch
mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch
rtc-s5m-remove-undocumented-time-init-on-first-boot.patch
rtc-s5m-use-shorter-time-of-register-update.patch
rtc-s5m-support-different-register-layout.patch
rtc-s5m-add-support-for-s2mps14-rtc.patch
rtc-s5m-consolidate-two-device-type-switch-statements.patch

