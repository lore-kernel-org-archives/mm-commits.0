From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tps6586x-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:47 -0800
Message-ID: <20130222204447.8F3505A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:58720 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab3BVUos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:48 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so103948yen.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tps6586x: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tps6586x-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tps6586x: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tps6586x.c~rtc-rtc-tps6586x-use-devm_request_threaded_irq drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-rtc-tps6586x-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -282,7 +282,8 @@ static int tps6586x_rtc_probe(struct pla
 		goto fail_rtc_register;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, tps6586x_rtc_irq,
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				tps6586x_rtc_irq,
 				IRQF_ONESHOT | IRQF_EARLY_RESUME,
 				dev_name(&pdev->dev), rtc);
 	if (ret < 0) {
@@ -311,7 +312,6 @@ static int tps6586x_rtc_remove(struct pl
 	tps6586x_update(tps_dev, RTC_CTRL, 0,
 		RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
 	rtc_device_unregister(rtc->rtc);
-	free_irq(rtc->irq, rtc);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

