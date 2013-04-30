From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:51 -0700
Message-ID: <20130430185851.86B385A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:32876 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab3D3S6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:53 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87025qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max8997.c: fix incorrect return value on error
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max8997.c: fix incorrect return value on error

'ret' was being returned without initializing it to error code.  While at
it also remove duplicate return statement.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8997.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-max8997.c~drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error drivers/rtc/rtc-max8997.c
--- a/drivers/rtc/rtc-max8997.c~drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error
+++ a/drivers/rtc/rtc-max8997.c
@@ -491,6 +491,7 @@ static int max8997_rtc_probe(struct plat
 	virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
 	if (!virq) {
 		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
+		ret = -ENXIO;
 		goto err_out;
 	}
 	info->virq = virq;
@@ -498,13 +499,9 @@ static int max8997_rtc_probe(struct plat
 	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
 				max8997_rtc_alarm_irq, 0,
 				"rtc-alarm0", info);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
-		goto err_out;
-	}
