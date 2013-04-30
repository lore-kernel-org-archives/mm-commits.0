From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:54 -0700
Message-ID: <20130430185854.8425B31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:36425 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab3D3S64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:56 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so87058yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: fix incorrect return value on error
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max77686.c: fix incorrect return value on error

'ret' was not initialized to error code before returning. While
at it also remove some redundant code and cleanup.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error
+++ a/drivers/rtc/rtc-max77686.c
@@ -551,17 +551,17 @@ static int max77686_rtc_probe(struct pla
 		goto err_rtc;
 	}
 	virq = irq_create_mapping(max77686->irq_domain, MAX77686_RTCIRQ_RTCA1);
-	if (!virq)
+	if (!virq) {
+		ret = -ENXIO;
 		goto err_rtc;
+	}
 	info->virq = virq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
 				max77686_rtc_alarm_irq, 0, "rtc-alarm0", info);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
-		goto err_rtc;
-	}
 
 err_rtc:
 	return ret;
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

