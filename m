From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2.patch
 removed from -mm tree
Date: Thu, 28 Aug 2014 14:59:03 -0700
Message-ID: <53ffa627.vGIiB7DLfLmhHYqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36806 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaH1V7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:59:05 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so271782qap.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:59:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2
has been removed from the -mm tree.  Its filename was
     rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2 drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables-v2
+++ a/drivers/rtc/rtc-s3c.c
@@ -121,6 +121,9 @@ static int s3c_rtc_setaie(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int tmp;
 
+	if (!info->base)
+		return -EINVAL;
+
 	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(info->rtc_clk);
@@ -180,6 +183,9 @@ static int s3c_rtc_gettime(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int have_retried = 0;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
  retry_get_time:
 	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
@@ -224,6 +230,9 @@ static int s3c_rtc_settime(struct device
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	int year = tm->tm_year - 100;
 
+	if (!info->base)
+		return -EINVAL;
+
 	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -255,6 +264,9 @@ static int s3c_rtc_getalarm(struct devic
 	struct rtc_time *alm_tm = &alrm->time;
 	unsigned int alm_en;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
@@ -317,6 +329,9 @@ static int s3c_rtc_setalarm(struct devic
 	struct rtc_time *tm = &alrm->time;
 	unsigned int alrm_en;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
@@ -357,6 +372,9 @@ static int s3c_rtc_proc(struct device *d
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 	unsigned int ticnt;
 
+	if (!info->base)
+		return -EINVAL;
+
 	clk_enable(info->rtc_clk);
 	if (info->cpu_type == TYPE_S3C64XX) {
 		ticnt = readw(info->base + S3C2410_RTCCON);
@@ -548,7 +566,7 @@ static int s3c_rtc_probe(struct platform
 		rtc_tm.tm_min	= 0;
 		rtc_tm.tm_sec	= 0;
 
-		s3c_rtc_settime(NULL, &rtc_tm);
+		s3c_rtc_settime(&pdev->dev, &rtc_tm);
 
 		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
 	}
_

Patches currently in -mm which might be from cw00.choi@samsung.com are

rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch
rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script.patch
rtc-s3c-add-s3c_rtc_data-structure-to-use-variant-data-instead-of-s3c_cpu_type.patch
rtc-s3c-add-support-for-rtc-of-exynos3250-soc.patch
arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch
linux-next.patch

