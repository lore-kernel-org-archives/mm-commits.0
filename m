From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch added to -mm tree
Date: Tue, 26 Mar 2013 12:22:31 -0700
Message-ID: <20130326192231.B75DC5A409A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:53629 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3CZTWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 15:22:33 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so232514yen.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 12:22:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, jonghwa3.lee@samsung.com, ldewangan@nvidia.com, vbyravarasu@nvidia.com, woong.byun@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-tps6586x.c: remove incorrect use of rtc_device_unregister
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch

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
