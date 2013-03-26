From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:22:33 -0700
Message-ID: <20130326192233.D9D3431C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63531 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:22:35 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so75530qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:22:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: fix incorrect return value on error
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch

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
Subject: drivers/rtc/rtc-tps65910.c: fix incorrect return value on error

'ret' was not initialized to correct error value before returning.  Since
'irq' is also being tested for 0, we cannot return irq itself as it means
function is success even though we are returning before completing the
probe.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error
+++ a/drivers/rtc/rtc-tps65910.c
@@ -263,7 +263,7 @@ static int tps65910_rtc_probe(struct pla
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
 			irq);
-		return ret;
+		return -ENXIO;
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
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

