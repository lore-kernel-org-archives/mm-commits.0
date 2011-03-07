From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-fix-prototype-for-s3c_rtc_setaie.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:30:55 -0800
Message-ID: <201103072131.p27LVc9H028054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab1CGVcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-s3c.c: fix prototype for s3c_rtc_setaie()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-fix-prototype-for-s3c_rtc_setaie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-s3c.c: fix prototype for s3c_rtc_setaie()
From: Axel Lin <axel.lin@gmail.com>

Fix s3c_rtc_setaie() prototype to eliminate below compile warning.
drivers/rtc/rtc-s3c.c:383: warning: initialization from incompatible pointer type

(akpm: the rtc_class_ops.alarm_irq_enable() handler is being passed two
arguments where it expects just one, presumably with undesired effects)

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-prototype-for-s3c_rtc_setaie drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-prototype-for-s3c_rtc_setaie
+++ a/drivers/rtc/rtc-s3c.c
@@ -77,18 +77,20 @@ static irqreturn_t s3c_rtc_tickirq(int i
 }
 
 /* Update control registers */
-static void s3c_rtc_setaie(int to)
+static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, to);
+	pr_debug("%s: aie=%d\n", __func__, enabled);
 
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
-	if (to)
+	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
+
+	return 0;
 }
 
 static int s3c_rtc_setpie(struct device *dev, int enabled)
@@ -308,7 +310,7 @@ static int s3c_rtc_setalarm(struct devic
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
-	s3c_rtc_setaie(alrm->enabled);
+	s3c_rtc_setaie(dev, alrm->enabled);
 
 	return 0;
 }
@@ -440,7 +442,7 @@ static int __devexit s3c_rtc_remove(stru
 	rtc_device_unregister(rtc);
 
 	s3c_rtc_setpie(&dev->dev, 0);
-	s3c_rtc_setaie(0);
+	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_disable(rtc_clk);
 	clk_put(rtc_clk);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

