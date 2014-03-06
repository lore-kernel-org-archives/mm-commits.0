From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:40 -0800
Message-ID: <5318dc94.qGqRIIVtYH0897w3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaCFUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vikas.sajjan@samsung.com, robh+dt@kernel.org, grant.likely@linaro.org, vikas.sajjan@linaro.org

Subject: [merged] drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch removed from -mm tree
To: vikas.sajjan@linaro.org,grant.likely@linaro.org,robh+dt@kernel.org,vikas.sajjan@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:40 -0800


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix incorrect way of save/restore of S3C2410_TICNT for TYPE_S3C64XX
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: fix incorrect way of save/restore of S3C2410_TICNT for TYPE_S3C64XX

On exynos5250, exynos5420 and exynos5260 it was observed that, after 1
cycle of S2R, the rtc-tick occurs at a very fast rate as compared to the
rtc-tick occuring before S2R.

This patch fixes the above issue by correcting the wrong way of
save/restore of S3C2410_TICNT for TYPE_S3C64XX.

Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx
+++ a/drivers/rtc/rtc-s3c.c
@@ -580,10 +580,12 @@ static int s3c_rtc_suspend(struct device
 
 	clk_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
-	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
 		ticnt_en_save = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
+		ticnt_save = readl(s3c_rtc_base + S3C2410_TICNT);
+	} else {
+		ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	}
 	s3c_rtc_enable(pdev, 0);
 
@@ -605,10 +607,15 @@ static int s3c_rtc_resume(struct device
 
 	clk_enable(rtc_clk);
 	s3c_rtc_enable(pdev, 1);
-	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
-		tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
-		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		writel(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
+		if (ticnt_en_save) {
+			tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
+			writew(tmp | ticnt_en_save,
+					s3c_rtc_base + S3C2410_RTCCON);
+		}
+	} else {
+		writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	}
 
 	if (device_may_wakeup(dev) && wake_en) {
_

Patches currently in -mm which might be from vikas.sajjan@linaro.org are

origin.patch

