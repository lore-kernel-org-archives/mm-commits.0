From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:48 -0700
Message-ID: <20130430185848.84E8D31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:39464 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3D3S6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:50 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so87038vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: fix incorrect return value on error
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drivers-rtc-rtc-pxac-use-devm_-apis.patch

