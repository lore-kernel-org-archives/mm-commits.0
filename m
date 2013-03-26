From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:22:35 -0700
Message-ID: <20130326192235.D23CF31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64556 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3CZTWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:22:37 -0400
Received: by mail-ve0-f201.google.com with SMTP id ox1so75520veb.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:22:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max8997.c: fix incorrect return value on error
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch

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
