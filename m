From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch added to -mm tree
Date: Fri, 21 Feb 2014 14:08:52 -0800
Message-ID: <5307ce74.fOo6GhxH90Pz07go%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaBUWIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vikas.sajjan@samsung.com, robh+dt@kernel.org, grant.likely@linaro.org, vikas.sajjan@linaro.org

Subject: + drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch added to -mm tree
To: vikas.sajjan@linaro.org,grant.likely@linaro.org,robh+dt@kernel.org,vikas.sajjan@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:08:52 -0800


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix incorrect way of save/restore of S3C2410_TICNT for TYPE_S3C64XX
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-rtc-s3cc-fix-incorrect-way-of-save-restore-of-s3c2410_ticnt-for-type_s3c64xx.patch

