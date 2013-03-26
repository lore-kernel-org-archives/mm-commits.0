From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:22:37 -0700
Message-ID: <20130326192237.D5E5531C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37670 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:22:39 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so755755vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:22:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: fix incorrect return value on error
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch

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
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch

