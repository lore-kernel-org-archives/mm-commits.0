From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:23 -0700
Message-ID: <20121005201723.A45291E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2JEURY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:24 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236805vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix return value in s3c_rtc_probe()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-fix-return-value-in-s3c_rtc_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
memcg-cleanup-kmem-tcp-ifdefs.patch
memcg-move-mem_cgroup_is_root-upwards.patch

