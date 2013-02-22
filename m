From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:02 -0800
Message-ID: <20130222204402.8EE885A4286@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:60510 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab3BVUoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:03 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103867yen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: use dev_dbg() instaed of pr_debug()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: use dev_dbg() instaed of pr_debug()

Use dev_dbg() instaed of pr_debug() to be consistent.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug
+++ a/drivers/rtc/rtc-s3c.c
@@ -115,7 +115,7 @@ static int s3c_rtc_setaie(struct device 
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
@@ -203,7 +203,7 @@ static int s3c_rtc_gettime(struct device
 
 	rtc_tm->tm_year += 100;
 
-	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
@@ -218,7 +218,7 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -259,7 +259,7 @@ static int s3c_rtc_getalarm(struct devic
 
 	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
 
-	pr_debug("read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alm_en,
 		 1900 + alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
@@ -310,7 +310,7 @@ static int s3c_rtc_setalarm(struct devic
 	unsigned int alrm_en;
 
 	clk_enable(rtc_clk);
-	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -333,7 +333,7 @@ static int s3c_rtc_setalarm(struct devic
 		writeb(bin2bcd(tm->tm_hour), base + S3C2410_ALMHOUR);
 	}
 
-	pr_debug("setting S3C2410_RTCALM to %08x\n", alrm_en);
+	dev_dbg(dev, "setting S3C2410_RTCALM to %08x\n", alrm_en);
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
@@ -459,7 +459,7 @@ static int s3c_rtc_probe(struct platform
 	int ret;
 	int tmp;
 
-	pr_debug("%s: probe=%p\n", __func__, pdev);
+	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 
@@ -475,7 +475,7 @@ static int s3c_rtc_probe(struct platform
 		return s3c_rtc_alarmno;
 	}
 
-	pr_debug("s3c2410_rtc: tick irq %d, alarm irq %d\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: tick irq %d, alarm irq %d\n",
 		 s3c_rtc_tickno, s3c_rtc_alarmno);
 
 	/* get the memory region */
@@ -506,7 +506,7 @@ static int s3c_rtc_probe(struct platform
 
 	s3c_rtc_enable(pdev, 1);
 
-	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: RTCCON=%02x\n",
 		 readw(s3c_rtc_base + S3C2410_RTCCON));
 
 	device_init_wakeup(&pdev->dev, 1);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

