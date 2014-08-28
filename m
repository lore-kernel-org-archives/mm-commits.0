From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch removed
 from -mm tree
Date: Thu, 28 Aug 2014 14:59:57 -0700
Message-ID: <53ffa65d.QJ08uBorAQunnpcO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:37146 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH1WFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:05:37 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1080982pab.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:05:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: s3c: define s3c_rtc structure to remove global variables.
has been removed from the -mm tree.  Its filename was
     rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: rtc: s3c: define s3c_rtc structure to remove global variables.

Define s3c_rtc structure including necessary variables for S3C RTC device
instead of global variables.  This patch improves the readability by
removing global variables.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |  428 ++++++++++++++++++++--------------------
 1 file changed, 216 insertions(+), 212 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables
+++ a/drivers/rtc/rtc-s3c.c
@@ -43,125 +43,132 @@ struct s3c_rtc_drv_data {
 	int cpu_type;
 };
 
-/* I have yet to find an S3C implementation with more than one
- * of these rtc blocks in */
+struct s3c_rtc {
+	struct device *dev;
+	struct rtc_device *rtc;
+
+	void __iomem *base;
+	struct clk *rtc_clk;
+	bool enabled;
+
+	enum s3c_cpu_type cpu_type;
 
-static struct clk *rtc_clk;
-static void __iomem *s3c_rtc_base;
-static int s3c_rtc_alarmno;
-static int s3c_rtc_tickno;
-static enum s3c_cpu_type s3c_rtc_cpu_type;
+	int irq_alarm;
+	int irq_tick;
 
-static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
+	spinlock_t pie_lock;
+	spinlock_t alarm_clk_lock;
+
+	int ticnt_save, ticnt_en_save;
+	bool wake_en;
+};
 
-static void s3c_rtc_alarm_clk_enable(bool enable)
+static void s3c_rtc_alarm_clk_enable(struct s3c_rtc *info, bool enable)
 {
-	static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
-	static bool alarm_clk_enabled;
 	unsigned long irq_flags;
 
-	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
+	spin_lock_irqsave(&info->alarm_clk_lock, irq_flags);
 	if (enable) {
-		if (!alarm_clk_enabled) {
-			clk_enable(rtc_clk);
-			alarm_clk_enabled = true;
+		if (!info->enabled) {
+			clk_enable(info->rtc_clk);
+			info->enabled = true;
 		}
 	} else {
-		if (alarm_clk_enabled) {
-			clk_disable(rtc_clk);
-			alarm_clk_enabled = false;
+		if (info->enabled) {
+			clk_disable(info->rtc_clk);
+			info->enabled = false;
 		}
 	}
-	spin_unlock_irqrestore(&s3c_rtc_alarm_clk_lock, irq_flags);
+	spin_unlock_irqrestore(&info->alarm_clk_lock, irq_flags);
 }
 
 /* IRQ Handlers */
-
 static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 {
-	struct rtc_device *rdev = id;
+	struct s3c_rtc *info = (struct s3c_rtc *)id;
 
-	clk_enable(rtc_clk);
-	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
+	clk_enable(info->rtc_clk);
+	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
 
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
-		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
+	if (info->cpu_type == TYPE_S3C64XX)
+		writeb(S3C2410_INTP_ALM, info->base + S3C2410_INTP);
 
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 
-	s3c_rtc_alarm_clk_enable(false);
+	s3c_rtc_alarm_clk_enable(info, false);
 
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 {
-	struct rtc_device *rdev = id;
+	struct s3c_rtc *info = (struct s3c_rtc *)id;
+
+	clk_enable(info->rtc_clk);
+	rtc_update_irq(info->rtc, 1, RTC_PF | RTC_IRQF);
 
-	clk_enable(rtc_clk);
-	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
+	if (info->cpu_type == TYPE_S3C64XX)
+		writeb(S3C2410_INTP_TIC, info->base + S3C2410_INTP);
 
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
-		writeb(S3C2410_INTP_TIC, s3c_rtc_base + S3C2410_INTP);
+	clk_disable(info->rtc_clk);
 
-	clk_disable(rtc_clk);
 	return IRQ_HANDLED;
 }
 
 /* Update control registers */
 static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 {
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int tmp;
 
-	dev_dbg(dev, "%s: aie=%d\n", __func__, enabled);
+	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
-	clk_enable(rtc_clk);
-	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
+	clk_enable(info->rtc_clk);
+	tmp = readb(info->base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
-	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
-	clk_disable(rtc_clk);
+	writeb(tmp, info->base + S3C2410_RTCALM);
+	clk_disable(info->rtc_clk);
 
-	s3c_rtc_alarm_clk_enable(enabled);
+	s3c_rtc_alarm_clk_enable(info, enabled);
 
 	return 0;
 }
 
-static int s3c_rtc_setfreq(struct device *dev, int freq)
+static int s3c_rtc_setfreq(struct s3c_rtc *info, int freq)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
 	unsigned int tmp = 0;
 	int val;
 
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
-	clk_enable(rtc_clk);
-	spin_lock_irq(&s3c_rtc_pie_lock);
+	clk_enable(info->rtc_clk);
+	spin_lock_irq(&info->pie_lock);
 
-	if (s3c_rtc_cpu_type != TYPE_S3C64XX) {
-		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
+	if (info->cpu_type != TYPE_S3C64XX) {
+		tmp = readb(info->base + S3C2410_TICNT);
 		tmp &= S3C2410_TICNT_ENABLE;
 	}
 
-	val = (rtc_dev->max_user_freq / freq) - 1;
+	val = (info->rtc->max_user_freq / freq) - 1;
 
-	if (s3c_rtc_cpu_type == TYPE_S3C2416 || s3c_rtc_cpu_type == TYPE_S3C2443) {
+	if (info->cpu_type == TYPE_S3C2416 || info->cpu_type == TYPE_S3C2443) {
 		tmp |= S3C2443_TICNT_PART(val);
-		writel(S3C2443_TICNT1_PART(val), s3c_rtc_base + S3C2443_TICNT1);
+		writel(S3C2443_TICNT1_PART(val), info->base + S3C2443_TICNT1);
 
-		if (s3c_rtc_cpu_type == TYPE_S3C2416)
-			writel(S3C2416_TICNT2_PART(val), s3c_rtc_base + S3C2416_TICNT2);
+		if (info->cpu_type == TYPE_S3C2416)
+			writel(S3C2416_TICNT2_PART(val),
+				info->base + S3C2416_TICNT2);
 	} else {
 		tmp |= val;
 	}
 
-	writel(tmp, s3c_rtc_base + S3C2410_TICNT);
-	spin_unlock_irq(&s3c_rtc_pie_lock);
-	clk_disable(rtc_clk);
+	writel(tmp, info->base + S3C2410_TICNT);
+	spin_unlock_irq(&info->pie_lock);
+	clk_disable(info->rtc_clk);
 
 	return 0;
 }
@@ -170,17 +177,17 @@ static int s3c_rtc_setfreq(struct device
 
 static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int have_retried = 0;
-	void __iomem *base = s3c_rtc_base;
 
-	clk_enable(rtc_clk);
+	clk_enable(info->rtc_clk);
  retry_get_time:
-	rtc_tm->tm_min  = readb(base + S3C2410_RTCMIN);
-	rtc_tm->tm_hour = readb(base + S3C2410_RTCHOUR);
-	rtc_tm->tm_mday = readb(base + S3C2410_RTCDATE);
-	rtc_tm->tm_mon  = readb(base + S3C2410_RTCMON);
-	rtc_tm->tm_year = readb(base + S3C2410_RTCYEAR);
-	rtc_tm->tm_sec  = readb(base + S3C2410_RTCSEC);
+	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
+	rtc_tm->tm_hour = readb(info->base + S3C2410_RTCHOUR);
+	rtc_tm->tm_mday = readb(info->base + S3C2410_RTCDATE);
+	rtc_tm->tm_mon  = readb(info->base + S3C2410_RTCMON);
+	rtc_tm->tm_year = readb(info->base + S3C2410_RTCYEAR);
+	rtc_tm->tm_sec  = readb(info->base + S3C2410_RTCSEC);
 
 	/* the only way to work out whether the system was mid-update
 	 * when we read it is to check the second counter, and if it
@@ -207,13 +214,14 @@ static int s3c_rtc_gettime(struct device
 
 	rtc_tm->tm_mon -= 1;
 
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
+
 	return rtc_valid_tm(rtc_tm);
 }
 
 static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 {
-	void __iomem *base = s3c_rtc_base;
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	int year = tm->tm_year - 100;
 
 	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
@@ -227,33 +235,35 @@ static int s3c_rtc_settime(struct device
 		return -EINVAL;
 	}
 
-	clk_enable(rtc_clk);
-	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
-	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
-	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
-	writeb(bin2bcd(tm->tm_mday), base + S3C2410_RTCDATE);
-	writeb(bin2bcd(tm->tm_mon + 1), base + S3C2410_RTCMON);
-	writeb(bin2bcd(year), base + S3C2410_RTCYEAR);
-	clk_disable(rtc_clk);
+	clk_enable(info->rtc_clk);
+
+	writeb(bin2bcd(tm->tm_sec),  info->base + S3C2410_RTCSEC);
+	writeb(bin2bcd(tm->tm_min),  info->base + S3C2410_RTCMIN);
+	writeb(bin2bcd(tm->tm_hour), info->base + S3C2410_RTCHOUR);
+	writeb(bin2bcd(tm->tm_mday), info->base + S3C2410_RTCDATE);
+	writeb(bin2bcd(tm->tm_mon + 1), info->base + S3C2410_RTCMON);
+	writeb(bin2bcd(year), info->base + S3C2410_RTCYEAR);
+
+	clk_disable(info->rtc_clk);
 
 	return 0;
 }
 
 static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	struct rtc_time *alm_tm = &alrm->time;
-	void __iomem *base = s3c_rtc_base;
 	unsigned int alm_en;
 
-	clk_enable(rtc_clk);
-	alm_tm->tm_sec  = readb(base + S3C2410_ALMSEC);
-	alm_tm->tm_min  = readb(base + S3C2410_ALMMIN);
-	alm_tm->tm_hour = readb(base + S3C2410_ALMHOUR);
-	alm_tm->tm_mon  = readb(base + S3C2410_ALMMON);
-	alm_tm->tm_mday = readb(base + S3C2410_ALMDATE);
-	alm_tm->tm_year = readb(base + S3C2410_ALMYEAR);
+	clk_enable(info->rtc_clk);
+	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
+	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
+	alm_tm->tm_hour = readb(info->base + S3C2410_ALMHOUR);
+	alm_tm->tm_mon  = readb(info->base + S3C2410_ALMMON);
+	alm_tm->tm_mday = readb(info->base + S3C2410_ALMDATE);
+	alm_tm->tm_year = readb(info->base + S3C2410_ALMYEAR);
 
-	alm_en = readb(base + S3C2410_RTCALM);
+	alm_en = readb(info->base + S3C2410_RTCALM);
 
 	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
 
@@ -297,65 +307,67 @@ static int s3c_rtc_getalarm(struct devic
 	else
 		alm_tm->tm_year = -1;
 
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 	return 0;
 }
 
 static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	struct rtc_time *tm = &alrm->time;
-	void __iomem *base = s3c_rtc_base;
 	unsigned int alrm_en;
 
-	clk_enable(rtc_clk);
+	clk_enable(info->rtc_clk);
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
-	alrm_en = readb(base + S3C2410_RTCALM) & S3C2410_RTCALM_ALMEN;
-	writeb(0x00, base + S3C2410_RTCALM);
+	alrm_en = readb(info->base + S3C2410_RTCALM) & S3C2410_RTCALM_ALMEN;
+	writeb(0x00, info->base + S3C2410_RTCALM);
 
 	if (tm->tm_sec < 60 && tm->tm_sec >= 0) {
 		alrm_en |= S3C2410_RTCALM_SECEN;
-		writeb(bin2bcd(tm->tm_sec), base + S3C2410_ALMSEC);
+		writeb(bin2bcd(tm->tm_sec), info->base + S3C2410_ALMSEC);
 	}
 
 	if (tm->tm_min < 60 && tm->tm_min >= 0) {
 		alrm_en |= S3C2410_RTCALM_MINEN;
-		writeb(bin2bcd(tm->tm_min), base + S3C2410_ALMMIN);
+		writeb(bin2bcd(tm->tm_min), info->base + S3C2410_ALMMIN);
 	}
 
 	if (tm->tm_hour < 24 && tm->tm_hour >= 0) {
 		alrm_en |= S3C2410_RTCALM_HOUREN;
-		writeb(bin2bcd(tm->tm_hour), base + S3C2410_ALMHOUR);
+		writeb(bin2bcd(tm->tm_hour), info->base + S3C2410_ALMHOUR);
 	}
 
 	dev_dbg(dev, "setting S3C2410_RTCALM to %08x\n", alrm_en);
 
-	writeb(alrm_en, base + S3C2410_RTCALM);
+	writeb(alrm_en, info->base + S3C2410_RTCALM);
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
+
 	return 0;
 }
 
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int ticnt;
 
-	clk_enable(rtc_clk);
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		ticnt = readw(s3c_rtc_base + S3C2410_RTCCON);
+	clk_enable(info->rtc_clk);
+	if (info->cpu_type == TYPE_S3C64XX) {
+		ticnt = readw(info->base + S3C2410_RTCCON);
 		ticnt &= S3C64XX_RTCCON_TICEN;
 	} else {
-		ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
+		ticnt = readb(info->base + S3C2410_TICNT);
 		ticnt &= S3C2410_TICNT_ENABLE;
 	}
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 	return 0;
 }
 
@@ -368,63 +380,64 @@ static const struct rtc_class_ops s3c_rt
 	.alarm_irq_enable = s3c_rtc_setaie,
 };
 
-static void s3c_rtc_enable(struct platform_device *pdev, int en)
+static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 {
-	void __iomem *base = s3c_rtc_base;
 	unsigned int tmp;
 
-	if (s3c_rtc_base == NULL)
+	if (!info->base)
 		return;
 
-	clk_enable(rtc_clk);
+	clk_enable(info->rtc_clk);
 	if (!en) {
-		tmp = readw(base + S3C2410_RTCCON);
-		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
+		tmp = readw(info->base + S3C2410_RTCCON);
+		if (info->cpu_type == TYPE_S3C64XX)
 			tmp &= ~S3C64XX_RTCCON_TICEN;
 		tmp &= ~S3C2410_RTCCON_RTCEN;
-		writew(tmp, base + S3C2410_RTCCON);
+		writew(tmp, info->base + S3C2410_RTCCON);
 
-		if (s3c_rtc_cpu_type != TYPE_S3C64XX) {
-			tmp = readb(base + S3C2410_TICNT);
+		if (info->cpu_type != TYPE_S3C64XX) {
+			tmp = readb(info->base + S3C2410_TICNT);
 			tmp &= ~S3C2410_TICNT_ENABLE;
-			writeb(tmp, base + S3C2410_TICNT);
+			writeb(tmp, info->base + S3C2410_TICNT);
 		}
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((readw(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
-			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
+			dev_info(info->dev, "rtc disabled, re-enabling\n");
 
-			tmp = readw(base + S3C2410_RTCCON);
+			tmp = readw(info->base + S3C2410_RTCCON);
 			writew(tmp | S3C2410_RTCCON_RTCEN,
-				base + S3C2410_RTCCON);
+				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
-			dev_info(&pdev->dev, "removing RTCCON_CNTSEL\n");
+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
-			tmp = readw(base + S3C2410_RTCCON);
+			tmp = readw(info->base + S3C2410_RTCCON);
 			writew(tmp & ~S3C2410_RTCCON_CNTSEL,
-				base + S3C2410_RTCCON);
+				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
-			dev_info(&pdev->dev, "removing RTCCON_CLKRST\n");
+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
-			tmp = readw(base + S3C2410_RTCCON);
+			tmp = readw(info->base + S3C2410_RTCCON);
 			writew(tmp & ~S3C2410_RTCCON_CLKRST,
-				base + S3C2410_RTCCON);
+				info->base + S3C2410_RTCCON);
 		}
 	}
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 }
 
-static int s3c_rtc_remove(struct platform_device *dev)
+static int s3c_rtc_remove(struct platform_device *pdev)
 {
-	s3c_rtc_setaie(&dev->dev, 0);
+	struct s3c_rtc *info = platform_get_drvdata(pdev);
+
+	s3c_rtc_setaie(info->dev, 0);
 
-	clk_unprepare(rtc_clk);
-	rtc_clk = NULL;
+	clk_unprepare(info->rtc_clk);
+	info->rtc_clk = NULL;
 
 	return 0;
 }
@@ -447,73 +460,85 @@ static inline int s3c_rtc_get_driver_dat
 
 static int s3c_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
+	struct s3c_rtc *info = NULL;
 	struct rtc_time rtc_tm;
 	struct resource *res;
 	int ret;
 	int tmp;
 
-	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
 
 	/* find the IRQs */
-
-	s3c_rtc_tickno = platform_get_irq(pdev, 1);
-	if (s3c_rtc_tickno < 0) {
+	info->irq_tick = platform_get_irq(pdev, 1);
+	if (info->irq_tick < 0) {
 		dev_err(&pdev->dev, "no irq for rtc tick\n");
-		return s3c_rtc_tickno;
+		return info->irq_tick;
 	}
 
-	s3c_rtc_alarmno = platform_get_irq(pdev, 0);
-	if (s3c_rtc_alarmno < 0) {
+	info->dev = &pdev->dev;
+	info->cpu_type = s3c_rtc_get_driver_data(pdev);
+	spin_lock_init(&info->pie_lock);
+	spin_lock_init(&info->alarm_clk_lock);
+
+	platform_set_drvdata(pdev, info);
+
+	info->irq_alarm = platform_get_irq(pdev, 0);
+	if (info->irq_alarm < 0) {
 		dev_err(&pdev->dev, "no irq for alarm\n");
-		return s3c_rtc_alarmno;
+		return info->irq_alarm;
 	}
 
 	dev_dbg(&pdev->dev, "s3c2410_rtc: tick irq %d, alarm irq %d\n",
-		 s3c_rtc_tickno, s3c_rtc_alarmno);
+		 info->irq_tick, info->irq_alarm);
 
 	/* get the memory region */
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	s3c_rtc_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(s3c_rtc_base))
-		return PTR_ERR(s3c_rtc_base);
+	info->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->base))
+		return PTR_ERR(info->base);
 
-	rtc_clk = devm_clk_get(&pdev->dev, "rtc");
-	if (IS_ERR(rtc_clk)) {
+	info->rtc_clk = devm_clk_get(&pdev->dev, "rtc");
+	if (IS_ERR(info->rtc_clk)) {
 		dev_err(&pdev->dev, "failed to find rtc clock source\n");
-		ret = PTR_ERR(rtc_clk);
-		rtc_clk = NULL;
-		return ret;
+		return PTR_ERR(info->rtc_clk);
 	}
-
-	clk_prepare_enable(rtc_clk);
+	clk_prepare_enable(info->rtc_clk);
 
 	/* check to see if everything is setup correctly */
-
-	s3c_rtc_enable(pdev, 1);
+	s3c_rtc_enable(info, 1);
 
 	dev_dbg(&pdev->dev, "s3c2410_rtc: RTCCON=%02x\n",
-		 readw(s3c_rtc_base + S3C2410_RTCCON));
+		 readw(info->base + S3C2410_RTCCON));
 
 	device_init_wakeup(&pdev->dev, 1);
 
 	/* register RTC and exit */
-
-	rtc = devm_rtc_device_register(&pdev->dev, "s3c", &s3c_rtcops,
+	info->rtc = devm_rtc_device_register(&pdev->dev, "s3c", &s3c_rtcops,
 				  THIS_MODULE);
-
-	if (IS_ERR(rtc)) {
+	if (IS_ERR(info->rtc)) {
 		dev_err(&pdev->dev, "cannot attach rtc\n");
-		ret = PTR_ERR(rtc);
+		ret = PTR_ERR(info->rtc);
 		goto err_nortc;
 	}
 
-	s3c_rtc_cpu_type = s3c_rtc_get_driver_data(pdev);
+	ret = devm_request_irq(&pdev->dev, info->irq_alarm, s3c_rtc_alarmirq,
+			  0,  "s3c2410-rtc alarm", info);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", info->irq_alarm, ret);
+		goto err_nortc;
+	}
 
-	/* Check RTC Time */
+	ret = devm_request_irq(&pdev->dev, info->irq_tick, s3c_rtc_tickirq,
+			  0,  "s3c2410-rtc tick", info);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", info->irq_tick, ret);
+		goto err_nortc;
+	}
 
-	s3c_rtc_gettime(NULL, &rtc_tm);
+	/* Check RTC Time */
+	s3c_rtc_gettime(&pdev->dev, &rtc_tm);
 
 	if (rtc_valid_tm(&rtc_tm)) {
 		rtc_tm.tm_year	= 100;
@@ -528,106 +553,85 @@ static int s3c_rtc_probe(struct platform
 		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
 	}
 
-	if (s3c_rtc_cpu_type != TYPE_S3C2410)
-		rtc->max_user_freq = 32768;
+	if (info->cpu_type != TYPE_S3C2410)
+		info->rtc->max_user_freq = 32768;
 	else
-		rtc->max_user_freq = 128;
+		info->rtc->max_user_freq = 128;
 
-	if (s3c_rtc_cpu_type == TYPE_S3C2416 || s3c_rtc_cpu_type == TYPE_S3C2443) {
-		tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
+	if (info->cpu_type == TYPE_S3C2416 || info->cpu_type == TYPE_S3C2443) {
+		tmp = readw(info->base + S3C2410_RTCCON);
 		tmp |= S3C2443_RTCCON_TICSEL;
-		writew(tmp, s3c_rtc_base + S3C2410_RTCCON);
-	}
-
-	platform_set_drvdata(pdev, rtc);
-
-	s3c_rtc_setfreq(&pdev->dev, 1);
-
-	ret = devm_request_irq(&pdev->dev, s3c_rtc_alarmno, s3c_rtc_alarmirq,
-			  0,  "s3c2410-rtc alarm", rtc);
-	if (ret) {
-		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
-		goto err_nortc;
+		writew(tmp, info->base + S3C2410_RTCCON);
 	}
 
-	ret = devm_request_irq(&pdev->dev, s3c_rtc_tickno, s3c_rtc_tickirq,
-			  0,  "s3c2410-rtc tick", rtc);
-	if (ret) {
-		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		goto err_nortc;
-	}
+	s3c_rtc_setfreq(info, 1);
 
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 
 	return 0;
 
  err_nortc:
-	s3c_rtc_enable(pdev, 0);
-	clk_disable_unprepare(rtc_clk);
+	s3c_rtc_enable(info, 0);
+	clk_disable_unprepare(info->rtc_clk);
 
 	return ret;
 }
 
 #ifdef CONFIG_PM_SLEEP
-/* RTC Power management control */
-
-static int ticnt_save, ticnt_en_save;
-static bool wake_en;
 
 static int s3c_rtc_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 
-	clk_enable(rtc_clk);
+	clk_enable(info->rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		ticnt_en_save = readw(s3c_rtc_base + S3C2410_RTCCON);
-		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
-		ticnt_save = readl(s3c_rtc_base + S3C2410_TICNT);
+	if (info->cpu_type == TYPE_S3C64XX) {
+		info->ticnt_en_save = readw(info->base + S3C2410_RTCCON);
+		info->ticnt_en_save &= S3C64XX_RTCCON_TICEN;
+		info->ticnt_save = readl(info->base + S3C2410_TICNT);
 	} else {
-		ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
+		info->ticnt_save = readb(info->base + S3C2410_TICNT);
 	}
-	s3c_rtc_enable(pdev, 0);
+	s3c_rtc_enable(info, 0);
 
-	if (device_may_wakeup(dev) && !wake_en) {
-		if (enable_irq_wake(s3c_rtc_alarmno) == 0)
-			wake_en = true;
+	if (device_may_wakeup(dev) && !info->wake_en) {
+		if (enable_irq_wake(info->irq_alarm) == 0)
+			info->wake_en = true;
 		else
 			dev_err(dev, "enable_irq_wake failed\n");
 	}
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 
 	return 0;
 }
 
 static int s3c_rtc_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
+	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int tmp;
 
-	clk_enable(rtc_clk);
-	s3c_rtc_enable(pdev, 1);
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		writel(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
-		if (ticnt_en_save) {
-			tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
-			writew(tmp | ticnt_en_save,
-					s3c_rtc_base + S3C2410_RTCCON);
+	clk_enable(info->rtc_clk);
+	s3c_rtc_enable(info, 1);
+	if (info->cpu_type == TYPE_S3C64XX) {
+		writel(info->ticnt_save, info->base + S3C2410_TICNT);
+		if (info->ticnt_en_save) {
+			tmp = readw(info->base + S3C2410_RTCCON);
+			writew(tmp | info->ticnt_en_save,
+					info->base + S3C2410_RTCCON);
 		}
 	} else {
-		writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
+		writeb(info->ticnt_save, info->base + S3C2410_TICNT);
 	}
 
-	if (device_may_wakeup(dev) && wake_en) {
-		disable_irq_wake(s3c_rtc_alarmno);
-		wake_en = false;
+	if (device_may_wakeup(dev) && info->wake_en) {
+		disable_irq_wake(info->irq_alarm);
+		info->wake_en = false;
 	}
-	clk_disable(rtc_clk);
+	clk_disable(info->rtc_clk);
 
 	return 0;
 }
 #endif
