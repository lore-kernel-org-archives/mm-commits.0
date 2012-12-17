From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-rtc-spear-use-devm_-routines-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:46:26 -0800
Message-ID: <20121217234627.5780582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:35060 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQXq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:46:28 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so694277vba.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:46:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rtc-spear-use-devm_-routines-fix
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-use-devm_-routines-fix.patch

This patch was dropped because it was folded into rtc-rtc-spear-use-devm_-routines.patch

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: rtc-rtc-spear-use-devm_-routines-fix


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines-fix drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines-fix
+++ a/drivers/rtc/rtc-spear.c
@@ -363,11 +363,6 @@ static int __devinit spear_rtc_probe(str
 		dev_err(&pdev->dev, "no resource defined\n");
 		return -EBUSY;
 	}
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				pdev->name)) {
-		dev_err(&pdev->dev, "rtc region already claimed\n");
-		return -EBUSY;
-	}
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
@@ -390,10 +385,9 @@ static int __devinit spear_rtc_probe(str
 		return status;
 	}
 
-	config->ioaddr = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
+	config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
 	if (!config->ioaddr) {
-		dev_err(&pdev->dev, "ioremap fail\n");
+		dev_err(&pdev->dev, "request-ioremap fail\n");
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are

origin.patch
dmatest-implement-two-helpers-to-unmap-dma-memory.patch
dmatest-check-for-dma-mapping-error.patch
rtc-rtc-spear-use-devm_-routines.patch
rtc-rtc-spear-add-clk_unprepare-support.patch
rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode.patch

