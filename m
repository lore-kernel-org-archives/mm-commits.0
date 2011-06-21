From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-support-clock-gating.patch added to -mm tree
Date: Mon, 20 Jun 2011 17:08:39 -0700
Message-ID: <201106210008.p5L08dc0031553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab1FUAJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 20:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg77.kim@samsung.com, a.zummo@towertech.it, ben@fluff.org, kyungmin.park@samsung.com, myungjoo.ham@samsung.com


The patch titled
     drivers/rtc/rtc-s3c.c: support clock gating
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-support-clock-gating.patch

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
Subject: drivers/rtc/rtc-s3c.c: support clock gating
From: Donggeun Kim <dg77.kim@samsung.com>

Add support for clock gating.  Power consumption can be reduced by setting
rtc_clk disabled state except for when RTC related registers are accessed.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ben Dooks <ben@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-support-clock-gating drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-support-clock-gating
+++ a/drivers/rtc/rtc-s3c.c
@@ -57,11 +57,13 @@ static irqreturn_t s3c_rtc_alarmirq(int 
 {
 	struct rtc_device *rdev = id;
 
+	clk_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
 
+	clk_disable(rtc_clk);
 	return IRQ_HANDLED;
 }
 
@@ -69,11 +71,13 @@ static irqreturn_t s3c_rtc_tickirq(int i
 {
 	struct rtc_device *rdev = id;
 
+	clk_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_TIC, s3c_rtc_base + S3C2410_INTP);
 
+	clk_disable(rtc_clk);
 	return IRQ_HANDLED;
 }
 
@@ -84,12 +88,14 @@ static int s3c_rtc_setaie(struct device 
 
 	pr_debug("%s: aie=%d\n", __func__, enabled);
 
+	clk_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -103,6 +109,7 @@ static int s3c_rtc_setfreq(struct device
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
+	clk_enable(rtc_clk);
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C2410) {
@@ -114,6 +121,7 @@ static int s3c_rtc_setfreq(struct device
 
 	writel(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -125,6 +133,7 @@ static int s3c_rtc_gettime(struct device
 	unsigned int have_retried = 0;
 	void __iomem *base = s3c_rtc_base;
 
+	clk_enable(rtc_clk);
  retry_get_time:
 	rtc_tm->tm_min  = readb(base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(base + S3C2410_RTCHOUR);
@@ -157,6 +166,7 @@ static int s3c_rtc_gettime(struct device
 	rtc_tm->tm_year += 100;
 	rtc_tm->tm_mon -= 1;
 
+	clk_disable(rtc_clk);
 	return rtc_valid_tm(rtc_tm);
 }
 
@@ -165,6 +175,7 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
+	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -182,6 +193,7 @@ static int s3c_rtc_settime(struct device
 	writeb(bin2bcd(tm->tm_mday), base + S3C2410_RTCDATE);
 	writeb(bin2bcd(tm->tm_mon + 1), base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), base + S3C2410_RTCYEAR);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -192,6 +204,7 @@ static int s3c_rtc_getalarm(struct devic
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alm_en;
 
+	clk_enable(rtc_clk);
 	alm_tm->tm_sec  = readb(base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(base + S3C2410_ALMHOUR);
@@ -243,6 +256,7 @@ static int s3c_rtc_getalarm(struct devic
 	else
 		alm_tm->tm_year = -1;
 
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -252,6 +266,7 @@ static int s3c_rtc_setalarm(struct devic
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alrm_en;
 
+	clk_enable(rtc_clk);
 	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
@@ -282,6 +297,7 @@ static int s3c_rtc_setalarm(struct devic
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -289,6 +305,7 @@ static int s3c_rtc_proc(struct device *d
 {
 	unsigned int ticnt;
 
+	clk_enable(rtc_clk);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
 		ticnt = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt &= S3C64XX_RTCCON_TICEN;
@@ -298,6 +315,7 @@ static int s3c_rtc_proc(struct device *d
 	}
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -360,6 +378,7 @@ static void s3c_rtc_enable(struct platfo
 	if (s3c_rtc_base == NULL)
 		return;
 
+	clk_enable(rtc_clk);
 	if (!en) {
 		tmp = readw(base + S3C2410_RTCCON);
 		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
@@ -399,6 +418,7 @@ static void s3c_rtc_enable(struct platfo
 				base + S3C2410_RTCCON);
 		}
 	}
+	clk_disable(rtc_clk);
 }
 
 static int __devexit s3c_rtc_remove(struct platform_device *dev)
@@ -410,7 +430,6 @@ static int __devexit s3c_rtc_remove(stru
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
-	clk_disable(rtc_clk);
 	clk_put(rtc_clk);
 	rtc_clk = NULL;
 
@@ -529,6 +548,8 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	clk_disable(rtc_clk);
+
 	return 0;
 
  err_nortc:
@@ -554,6 +575,7 @@ static int ticnt_save, ticnt_en_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	clk_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
@@ -568,6 +590,7 @@ static int s3c_rtc_suspend(struct platfo
 		else
 			dev_err(&pdev->dev, "enable_irq_wake failed\n");
 	}
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -576,6 +599,7 @@ static int s3c_rtc_resume(struct platfor
 {
 	unsigned int tmp;
 
+	clk_enable(rtc_clk);
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
@@ -587,6 +611,7 @@ static int s3c_rtc_resume(struct platfor
 		disable_irq_wake(s3c_rtc_alarmno);
 		wake_en = false;
 	}
+	clk_disable(rtc_clk);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dg77.kim@samsung.com are

drivers-rtc-rtc-s3cc-support-clock-gating.patch

