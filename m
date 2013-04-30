From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:25 -0700
Message-ID: <20130430185925.75E9A5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45037 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab3D3S70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:26 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86922yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.abraham@linaro.org, gautam.vivek@samsung.com, jg1.han@samsung.com, kgene.kim@samsung.com, s.nawrocki@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: use clk_prepare_enable and clk_disable_unprepare
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Abraham <thomas.abraham@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: use clk_prepare_enable and clk_disable_unprepare

Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
calls as required by common clock framework.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare
+++ a/drivers/rtc/rtc-s3c.c
@@ -426,6 +426,7 @@ static int s3c_rtc_remove(struct platfor
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
+	clk_unprepare(rtc_clk);
 	rtc_clk = NULL;
 
 	return 0;
@@ -494,7 +495,7 @@ static int s3c_rtc_probe(struct platform
 		return ret;
 	}
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 
 	/* check to see if everything is setup correctly */
 
@@ -573,7 +574,7 @@ static int s3c_rtc_probe(struct platform
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return ret;
 }
_

Patches currently in -mm which might be from thomas.abraham@linaro.org are

origin.patch
linux-next.patch

