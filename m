From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
 removed from -mm tree
Date: Mon, 16 Dec 2013 12:39:30 -0800
Message-ID: <52af6502.1jN9jSc0jByZ4K1U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3LPUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sachin.kamat@linaro.org, k.kozlowski@samsung.com, geert@linux-m68k.org

Subject: [merged] drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch removed from -mm tree
To: geert@linux-m68k.org,k.kozlowski@samsung.com,sachin.kamat@linaro.org,sbkim73@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:30 -0800


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: fix info->rtc assignment
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/rtc/rtc-s5m.c: fix info->rtc assignment

drivers/rtc/rtc-s5m.c: In function `s5m_rtc_probe':
drivers/rtc/rtc-s5m.c:545: warning: assignment from incompatible pointer type

struct s5m_rtc_info.rtc has type "struct regmap *", while
struct sec_pmic_dev.rtc has type "struct i2c_client *".

Probably the author wanted to assign "struct sec_pmic_dev.regmap", which
has the correct type.

Also, as "rtc" doesn't make much sense as a name for a regmap, rename it to
"regmap".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   54 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~drivers-rtc-rtc-s5mc-fix-info-rtc-assignment drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~drivers-rtc-rtc-s5mc-fix-info-rtc-assignment
+++ a/drivers/rtc/rtc-s5m.c
@@ -31,7 +31,7 @@
 struct s5m_rtc_info {
 	struct device *dev;
 	struct sec_pmic_dev *s5m87xx;
-	struct regmap *rtc;
+	struct regmap *regmap;
 	struct rtc_device *rtc_dev;
 	int irq;
 	int device_type;
@@ -89,7 +89,7 @@ static inline int s5m8767_rtc_set_time_r
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to read update reg(%d)\n", ret);
 		return ret;
@@ -98,14 +98,14 @@ static inline int s5m8767_rtc_set_time_r
 	data |= RTC_TIME_EN_MASK;
 	data |= RTC_UDR_MASK;
 
-	ret = regmap_write(info->rtc, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to write update reg(%d)\n", ret);
 		return ret;
 	}
 
 	do {
-		ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	} while ((data & RTC_UDR_MASK) && !ret);
 
 	return ret;
@@ -116,7 +116,7 @@ static inline int s5m8767_rtc_set_alarm_
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read update reg(%d)\n",
 			__func__, ret);
@@ -126,7 +126,7 @@ static inline int s5m8767_rtc_set_alarm_
 	data &= ~RTC_TIME_EN_MASK;
 	data |= RTC_UDR_MASK;
 
-	ret = regmap_write(info->rtc, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 			__func__, ret);
@@ -134,7 +134,7 @@ static inline int s5m8767_rtc_set_alarm_
 	}
 
 	do {
-		ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &data);
+		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
 	} while ((data & RTC_UDR_MASK) && !ret);
 
 	return ret;
@@ -178,7 +178,7 @@ static int s5m_rtc_read_time(struct devi
 	u8 data[8];
 	int ret;
 
-	ret = regmap_bulk_read(info->rtc, SEC_RTC_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -226,7 +226,7 @@ static int s5m_rtc_set_time(struct devic
 		1900 + tm->tm_year, 1 + tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec, tm->tm_wday);
 
-	ret = regmap_raw_write(info->rtc, SEC_RTC_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, SEC_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -242,20 +242,20 @@ static int s5m_rtc_read_alarm(struct dev
 	unsigned int val;
 	int ret, i;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
 	switch (info->device_type) {
 	case S5M8763X:
 		s5m8763_data_to_tm(data, &alrm->time);
-		ret = regmap_read(info->rtc, SEC_ALARM0_CONF, &val);
+		ret = regmap_read(info->regmap, SEC_ALARM0_CONF, &val);
 		if (ret < 0)
 			return ret;
 
 		alrm->enabled = !!val;
 
-		ret = regmap_read(info->rtc, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 
@@ -278,7 +278,7 @@ static int s5m_rtc_read_alarm(struct dev
 		}
 
 		alrm->pending = 0;
-		ret = regmap_read(info->rtc, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 		break;
@@ -301,7 +301,7 @@ static int s5m_rtc_stop_alarm(struct s5m
 	int ret, i;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -312,14 +312,14 @@ static int s5m_rtc_stop_alarm(struct s5m
 
 	switch (info->device_type) {
 	case S5M8763X:
-		ret = regmap_write(info->rtc, SEC_ALARM0_CONF, 0);
+		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, 0);
 		break;
 
 	case S5M8767X:
 		for (i = 0; i < 7; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 
@@ -341,7 +341,7 @@ static int s5m_rtc_start_alarm(struct s5
 	u8 alarm0_conf;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -353,7 +353,7 @@ static int s5m_rtc_start_alarm(struct s5
 	switch (info->device_type) {
 	case S5M8763X:
 		alarm0_conf = 0x77;
-		ret = regmap_write(info->rtc, SEC_ALARM0_CONF, alarm0_conf);
+		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, alarm0_conf);
 		break;
 
 	case S5M8767X:
@@ -368,7 +368,7 @@ static int s5m_rtc_start_alarm(struct s5
 		if (data[RTC_YEAR1] & 0x7f)
 			data[RTC_YEAR1] |= ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 		ret = s5m8767_rtc_set_alarm_reg(info);
@@ -410,7 +410,7 @@ static int s5m_rtc_set_alarm(struct devi
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_raw_write(info->rtc, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -455,7 +455,7 @@ static const struct rtc_class_ops s5m_rt
 static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->rtc, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
 				 WTSR_ENABLE_MASK,
 				 enable ? WTSR_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -466,7 +466,7 @@ static void s5m_rtc_enable_wtsr(struct s
 static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->rtc, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
 				 SMPL_ENABLE_MASK,
 				 enable ? SMPL_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -481,7 +481,7 @@ static int s5m8767_rtc_init_reg(struct s
 	int ret;
 	struct rtc_time tm;
 
-	ret = regmap_read(info->rtc, SEC_RTC_UDR_CON, &tp_read);
+	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &tp_read);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
 			__func__, ret);
@@ -493,7 +493,7 @@ static int s5m8767_rtc_init_reg(struct s
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->rtc, SEC_ALARM0_CONF, data, 2);
+	ret = regmap_raw_write(info->regmap, SEC_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -515,7 +515,7 @@ static int s5m8767_rtc_init_reg(struct s
 		ret = s5m_rtc_set_time(info->dev, &tm);
 	}
 
-	ret = regmap_update_bits(info->rtc, SEC_RTC_UDR_CON,
+	ret = regmap_update_bits(info->regmap, SEC_RTC_UDR_CON,
 				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
@@ -542,7 +542,7 @@ static int s5m_rtc_probe(struct platform
 
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
-	info->rtc = s5m87xx->rtc;
+	info->regmap = s5m87xx->regmap;
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
@@ -596,7 +596,7 @@ static void s5m_rtc_shutdown(struct plat
 	if (info->wtsr_smpl) {
 		for (i = 0; i < 3; i++) {
 			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->rtc, SEC_WTSR_SMPL_CNTL, &val);
+			regmap_read(info->regmap, SEC_WTSR_SMPL_CNTL, &val);
 			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
 			if (val & WTSR_ENABLE_MASK)
 				pr_emerg("%s: fail to disable WTSR\n",
_

Patches currently in -mm which might be from geert@linux-m68k.org are

futex-switch-to-user_ds-for-futex-test.patch
sh-always-link-in-helper-functions-extracted-from-libgcc.patch
sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

