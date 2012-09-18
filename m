From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch added to -mm tree
Date: Tue, 18 Sep 2012 12:51:37 -0700
Message-ID: <20120918195137.971601E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53339 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2IRTvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:51:38 -0400
Received: by vbis24 with SMTP id s24so34117vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:51:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix return value in s3c_rtc_probe()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: fix return value in s3c_rtc_probe()

Return the value returned by platform_get_irq() instead of -ENOENT;

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe
+++ a/drivers/rtc/rtc-s3c.c
@@ -476,13 +476,13 @@ static int __devinit s3c_rtc_probe(struc
 	s3c_rtc_tickno = platform_get_irq(pdev, 1);
 	if (s3c_rtc_tickno < 0) {
 		dev_err(&pdev->dev, "no irq for rtc tick\n");
-		return -ENOENT;
+		return s3c_rtc_tickno;
 	}
 
 	s3c_rtc_alarmno = platform_get_irq(pdev, 0);
 	if (s3c_rtc_alarmno < 0) {
 		dev_err(&pdev->dev, "no irq for alarm\n");
-		return -ENOENT;
+		return s3c_rtc_alarmno;
 	}
 
 	pr_debug("s3c2410_rtc: tick irq %d, alarm irq %d\n",
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch
proc-use-null-instead-of-0-for-pointer.patch

