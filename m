From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:52:37 -0700
Message-ID: <20130411225237.6CA785A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36059 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3DKWwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:52:38 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so195818yhf.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:52:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use devm_regmap_init_i2c()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch

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

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch

