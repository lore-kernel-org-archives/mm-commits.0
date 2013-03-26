From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max8907c-remove-redundant-code.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:22:39 -0700
Message-ID: <20130326192239.D5D5F31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:59653 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:22:41 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so213447ves.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:22:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max8907.c: remove redundant code
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8907c-remove-redundant-code.patch

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
Subject: drivers/rtc/rtc-max8907.c: remove redundant code

Remove unnecessary goto statements to simplify the code. 
devm_request_threaded_irq returns 0 upon success, hence explicit return 0
is not necessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Laxman dewangan <ldewangan@nvidia.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8907.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-max8907.c~drivers-rtc-rtc-max8907c-remove-redundant-code drivers/rtc/rtc-max8907.c
--- a/drivers/rtc/rtc-max8907.c~drivers-rtc-rtc-max8907c-remove-redundant-code
+++ a/drivers/rtc/rtc-max8907.c
@@ -200,23 +200,16 @@ static int max8907_rtc_probe(struct plat
 
 	rtc->irq = regmap_irq_get_virq(max8907->irqc_rtc,
 				       MAX8907_IRQ_RTC_ALARM0);
-	if (rtc->irq < 0) {
-		ret = rtc->irq;
-		goto err_unregister;
-	}
+	if (rtc->irq < 0)
+		return rtc->irq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
 				max8907_irq_handler,
 				IRQF_ONESHOT, "max8907-alarm0", rtc);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request IRQ%d: %d\n",
 			rtc->irq, ret);
-		goto err_unregister;
-	}
 
-	return 0;
