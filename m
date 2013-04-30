From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:45 -0700
Message-ID: <20130430185845.750BD31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:62735 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab3D3S6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:46 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87094qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps6586x.c: remove incorrect use of rtc_device_unregister
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-tps6586x.c: remove incorrect use of rtc_device_unregister

Device managed functions do not need explicit freeing/unregistering. 
Moreover in this case it was done using non-device managed function which
is incorrect.  Hence remove it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman dewangan <ldewangan@nvidia.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-tps6586x.c~drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -289,15 +289,12 @@ static int tps6586x_rtc_probe(struct pla
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request IRQ(%d) failed with ret %d\n",
 				rtc->irq, ret);
-		goto fail_req_irq;
+		goto fail_rtc_register;
 	}
 	disable_irq(rtc->irq);
 	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 
-fail_req_irq:
-	rtc_device_unregister(rtc->rtc);
