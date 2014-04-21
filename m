From: akpm@linux-foundation.org
Subject: + rtc-s5m-use-shorter-time-of-register-update.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 15:21:35 -0700
Message-ID: <535599ef.RjnmRGoo2PXVJkCk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaDUWVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lee.jones@linaro.org, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + rtc-s5m-use-shorter-time-of-register-update.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,lee.jones@linaro.org,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:21:35 -0700


The patch titled
     Subject: rtc: s5m: use shorter time of register update
has been added to the -mm tree.  Its filename is
     rtc-s5m-use-shorter-time-of-register-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-use-shorter-time-of-register-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-use-shorter-time-of-register-update.patch

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
Subject: rtc: s5m: use shorter time of register update

Set the time needed for updating alarm and time registers to 0.45 ms.
The default is 7.32 ms which is too long and leads to warnings when
setting alarm or time:

	s5m-rtc: waiting for UDR update, reached max number of retries

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c           |    7 +++++++
 include/linux/mfd/samsung/rtc.h |   10 ++++++++++
 2 files changed, 17 insertions(+)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-use-shorter-time-of-register-update drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-use-shorter-time-of-register-update
+++ a/drivers/rtc/rtc-s5m.c
@@ -519,6 +519,13 @@ static int s5m8767_rtc_init_reg(struct s
 	u8 data[2];
 	int ret;
 
+	/* UDR update time. Default of 7.32 ms is too long. */
+	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
+			S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
+	if (ret < 0)
+		dev_err(info->dev, "%s: fail to change UDR time: %d\n",
+				__func__, ret);
+
 	/* Set RTC control register : Binary mode, 24hour mode */
 	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
diff -puN include/linux/mfd/samsung/rtc.h~rtc-s5m-use-shorter-time-of-register-update include/linux/mfd/samsung/rtc.h
--- a/include/linux/mfd/samsung/rtc.h~rtc-s5m-use-shorter-time-of-register-update
+++ a/include/linux/mfd/samsung/rtc.h
@@ -111,6 +111,16 @@ enum s2mps_rtc_reg {
 #define RTC_TCON_MASK		(1 << RTC_TCON_SHIFT)
 #define S5M_RTC_TIME_EN_SHIFT	3
 #define S5M_RTC_TIME_EN_MASK	(1 << S5M_RTC_TIME_EN_SHIFT)
+/*
+ * UDR_T field in S5M_RTC_UDR_CON register determines the time needed
+ * for updating alarm and time registers. Default is 7.32 ms.
+ */
+#define S5M_RTC_UDR_T_SHIFT	6
+#define S5M_RTC_UDR_T_MASK	(0x3 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_7320_US	(0x0 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_1830_US	(0x1 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_3660_US	(0x2 << S5M_RTC_UDR_T_SHIFT)
+#define S5M_RTC_UDR_T_450_US	(0x3 << S5M_RTC_UDR_T_SHIFT)
 
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

