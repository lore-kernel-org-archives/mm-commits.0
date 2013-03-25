From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:10 -0700
Message-ID: <20130325194510.70DAC31C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:32953 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3CYTpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:11 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so172273ghr.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashish.jangam@kpitcummins.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: fix for rtc device registration
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: drivers/rtc/rtc-da9052.c: fix for rtc device registration

Add support for the virtual irq since now MFD only handles virtual irq
Without this patch rtc device will fail in registration.

(akpm: Ashish has a different version whcih will be needed for 3.8.x and
earlier kernels)

Signed-off-by: Ashish <ashish.jangam@kpitcummins.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration
+++ a/drivers/rtc/rtc-da9052.c
@@ -239,11 +239,9 @@ static int da9052_rtc_probe(struct platf
 
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->irq = platform_get_irq_byname(pdev, "ALM");
-	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
-				da9052_rtc_irq,
-				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				"ALM", rtc);
+	rtc->irq =  DA9052_IRQ_ALARM;
+	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
+				da9052_rtc_irq, rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
 		return ret;
_

Patches currently in -mm which might be from ashish.jangam@kpitcummins.com are


