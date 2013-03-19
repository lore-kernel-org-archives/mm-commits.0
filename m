From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:04:27 -0700
Message-ID: <20130319210427.6DB1431C272@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56438 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3CSVE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:04:28 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so92290vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:04:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ashish.jangam@kpitcummins.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: fix for rtc device registration
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch

