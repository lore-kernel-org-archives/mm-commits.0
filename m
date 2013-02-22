From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-imxdi-use-devm_clk_get.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:44 -0800
Message-ID: <20130222204444.9686D31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55608 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380Ab3BVUop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:45 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so103945yen.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-imxdi: use devm_clk_get()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-imxdi-use-devm_clk_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-imxdi: use devm_clk_get()

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-use-devm_clk_get drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-use-devm_clk_get
+++ a/drivers/rtc/rtc-imxdi.c
@@ -406,7 +406,7 @@ static int dryice_rtc_probe(struct platf
 
 	mutex_init(&imxdi->write_mutex);
 
-	imxdi->clk = clk_get(&pdev->dev, NULL);
+	imxdi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imxdi->clk))
 		return PTR_ERR(imxdi->clk);
 	clk_prepare_enable(imxdi->clk);
@@ -475,7 +475,6 @@ static int dryice_rtc_probe(struct platf
 
 err:
 	clk_disable_unprepare(imxdi->clk);
-	clk_put(imxdi->clk);
 
 	return rc;
 }
@@ -492,7 +491,6 @@ static int dryice_rtc_remove(struct plat
 	rtc_device_unregister(imxdi->rtc);
 
 	clk_disable_unprepare(imxdi->clk);
-	clk_put(imxdi->clk);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

