From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:28 -0700
Message-ID: <20130430185928.7197631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56764 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab3D3S73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:29 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87278vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use devm_regmap_init_i2c()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max77686.c: use devm_regmap_init_i2c()

This driver already uses other devm_* APIs.
Convert regmap_init_i2c too.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c
+++ a/drivers/rtc/rtc-max77686.c
@@ -514,7 +514,7 @@ static int max77686_rtc_probe(struct pla
 	info->dev = &pdev->dev;
 	info->max77686 = max77686;
 	info->rtc = max77686->rtc;
-	info->max77686->rtc_regmap = regmap_init_i2c(info->max77686->rtc,
+	info->max77686->rtc_regmap = devm_regmap_init_i2c(info->max77686->rtc,
 					 &max77686_rtc_regmap_config);
 	if (IS_ERR(info->max77686->rtc_regmap)) {
 		ret = PTR_ERR(info->max77686->rtc_regmap);
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

