From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtc-s3c-add-support-for-rtc-of-exynos3250-soc.patch removed from -mm tree
Date: Thu, 28 Aug 2014 14:59:09 -0700
Message-ID: <53ffa62d.vI5nuKA+trMdpe+k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:49494 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaH1WyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:54:18 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so419060oac.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: s3c: add support for RTC of Exynos3250 SoC
has been removed from the -mm tree.  Its filename was
     rtc-s3c-add-support-for-rtc-of-exynos3250-soc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: rtc: s3c: add support for RTC of Exynos3250 SoC

Add support for RTC of Exynos3250 SoC.  The Exynos3250 needs source
clock(32.768KHz) for RTC block.  If source clock of RTC is registerd on
clock list of common clk framework, Exynos RTC drvier have to control this
clock.

Clock list for s3c-rtc device:
- rtc : CLK_RTC of CLK_GATE_IP_PERIR is gate clock for RTC.
- rtc_src : XrtcXTI is 32.768.kHz source clock for RTC.
 (XRTCXTI: Specifies a clock from 32.768 kHz crystal pad with XRTCXTI and
 XRTCXTO pins. RTC uses this clock as the source of a real-time clock.)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |    1 
 drivers/rtc/rtc-s3c.c                             |   93 +++++++++++-
 2 files changed, 93 insertions(+), 1 deletion(-)

diff -puN Documentation/devicetree/bindings/rtc/s3c-rtc.txt~rtc-s3c-add-support-for-rtc-of-exynos3250-soc Documentation/devicetree/bindings/rtc/s3c-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt~rtc-s3c-add-support-for-rtc-of-exynos3250-soc
+++ a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -6,6 +6,7 @@ Required properties:
     * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
     * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
+    * "samsung,exynos3250-rtc" - for controllers compatible with exynos3250 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Two interrupt numbers to the cpu should be specified. First
diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-add-support-for-rtc-of-exynos3250-soc drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-add-support-for-rtc-of-exynos3250-soc
+++ a/drivers/rtc/rtc-s3c.c
@@ -38,6 +38,7 @@ struct s3c_rtc {
 
 	void __iomem *base;
 	struct clk *rtc_clk;
+	struct clk *rtc_src_clk;
 	bool enabled;
 
 	struct s3c_rtc_data *data;
@@ -54,6 +55,7 @@ struct s3c_rtc {
 
 struct s3c_rtc_data {
 	int max_user_freq;
+	bool needs_src_clk;
 
 	void (*irq_handler) (struct s3c_rtc *info, int mask);
 	void (*set_freq) (struct s3c_rtc *info, int freq);
@@ -73,10 +75,14 @@ static void s3c_rtc_alarm_clk_enable(str
 	if (enable) {
 		if (!info->enabled) {
 			clk_enable(info->rtc_clk);
+			if (info->data->needs_src_clk)
+				clk_enable(info->rtc_src_clk);
 			info->enabled = true;
 		}
 	} else {
 		if (info->enabled) {
+			if (info->data->needs_src_clk)
+				clk_disable(info->rtc_src_clk);
 			clk_disable(info->rtc_clk);
 			info->enabled = false;
 		}
@@ -117,12 +123,16 @@ static int s3c_rtc_setaie(struct device
 	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	tmp = readb(info->base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, info->base + S3C2410_RTCALM);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, enabled);
@@ -137,12 +147,16 @@ static int s3c_rtc_setfreq(struct s3c_rt
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	spin_lock_irq(&info->pie_lock);
 
 	if (info->data->set_freq)
 		info->data->set_freq(info, freq);
 
 	spin_unlock_irq(&info->pie_lock);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -158,6 +172,9 @@ static int s3c_rtc_gettime(struct device
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
  retry_get_time:
 	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(info->base + S3C2410_RTCHOUR);
@@ -191,6 +208,8 @@ static int s3c_rtc_gettime(struct device
 
 	rtc_tm->tm_mon -= 1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return rtc_valid_tm(rtc_tm);
@@ -216,6 +235,8 @@ static int s3c_rtc_settime(struct device
 	}
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	writeb(bin2bcd(tm->tm_sec),  info->base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  info->base + S3C2410_RTCMIN);
@@ -224,6 +245,8 @@ static int s3c_rtc_settime(struct device
 	writeb(bin2bcd(tm->tm_mon + 1), info->base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), info->base + S3C2410_RTCYEAR);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -239,6 +262,9 @@ static int s3c_rtc_getalarm(struct devic
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(info->base + S3C2410_ALMHOUR);
@@ -290,7 +316,10 @@ static int s3c_rtc_getalarm(struct devic
 	else
 		alm_tm->tm_year = -1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
+
 	return 0;
 }
 
@@ -304,6 +333,9 @@ static int s3c_rtc_setalarm(struct devic
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
@@ -333,6 +365,8 @@ static int s3c_rtc_setalarm(struct devic
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -346,10 +380,14 @@ static int s3c_rtc_proc(struct device *d
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable_tick)
 		info->data->enable_tick(info, seq);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -369,6 +407,8 @@ static void s3c24xx_rtc_enable(struct s3
 	unsigned int con, tmp;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	/* re-enable the device, and check it is ok */
@@ -396,6 +436,8 @@ static void s3c24xx_rtc_enable(struct s3
 			info->base + S3C2410_RTCCON);
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -404,6 +446,8 @@ static void s3c24xx_rtc_disable(struct s
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C2410_RTCCON_RTCEN;
@@ -413,6 +457,8 @@ static void s3c24xx_rtc_disable(struct s
 	con &= ~S3C2410_TICNT_ENABLE;
 	writeb(con, info->base + S3C2410_TICNT);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -421,12 +467,16 @@ static void s3c6410_rtc_disable(struct s
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C64XX_RTCCON_TICEN;
 	con &= ~S3C2410_RTCCON_RTCEN;
 	writew(con, info->base + S3C2410_RTCCON);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -498,11 +548,19 @@ static int s3c_rtc_probe(struct platform
 
 	info->rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(info->rtc_clk)) {
-		dev_err(&pdev->dev, "failed to find rtc clock source\n");
+		dev_err(&pdev->dev, "failed to find rtc clock\n");
 		return PTR_ERR(info->rtc_clk);
 	}
 	clk_prepare_enable(info->rtc_clk);
 
+	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
+	if (IS_ERR(info->rtc_src_clk)) {
+		dev_err(&pdev->dev, "failed to find rtc source clock\n");
+		return PTR_ERR(info->rtc_src_clk);
+	}
+	clk_prepare_enable(info->rtc_src_clk);
+
+
 	/* check to see if everything is setup correctly */
 	if (info->data->enable)
 		info->data->enable(info);
@@ -556,6 +614,8 @@ static int s3c_rtc_probe(struct platform
 
 	s3c_rtc_setfreq(info, 1);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -575,6 +635,8 @@ static int s3c_rtc_suspend(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	/* save TICNT for anyone using periodic interrupts */
 	if (info->data->save_tick_cnt)
@@ -590,6 +652,8 @@ static int s3c_rtc_suspend(struct device
 			dev_err(dev, "enable_irq_wake failed\n");
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -600,6 +664,8 @@ static int s3c_rtc_resume(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable)
 		info->data->enable(info);
@@ -612,6 +678,8 @@ static int s3c_rtc_resume(struct device
 		info->wake_en = false;
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -622,7 +690,11 @@ static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops,
 static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -631,8 +703,12 @@ static void s3c24xx_rtc_irq(struct s3c_r
 static void s3c6410_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
 	writeb(mask, info->base + S3C2410_INTP);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -798,6 +874,18 @@ static struct s3c_rtc_data const s3c6410
 	.disable		= s3c6410_rtc_disable,
 };
 
+static struct s3c_rtc_data const exynos3250_rtc_data = {
+	.max_user_freq		= 32768,
+	.needs_src_clk		= true,
+	.irq_handler		= s3c6410_rtc_irq,
+	.set_freq		= s3c6410_rtc_setfreq,
+	.enable_tick		= s3c6410_rtc_enable_tick,
+	.save_tick_cnt		= s3c6410_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c6410_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c6410_rtc_disable,
+};
+
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
@@ -811,6 +899,9 @@ static const struct of_device_id s3c_rtc
 	}, {
 		.compatible = "samsung,s3c6410-rtc",
 		.data = (void *)&s3c6410_rtc_data,
+	}, {
+		.compatible = "samsung,exynos3250-rtc",
+		.data = (void *)&exynos3250_rtc_data,
 	},
 	{ /* sentinel */ },
 };
_

Patches currently in -mm which might be from cw00.choi@samsung.com are

rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch
arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch
linux-next.patch

