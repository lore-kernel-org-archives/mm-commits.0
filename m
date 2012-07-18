From: akpm@linux-foundation.org
Subject: + rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch added to -mm tree
Date: Wed, 18 Jul 2012 13:57:22 -0700
Message-ID: <20120718205723.2F0C21E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48268 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2GRU5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 16:57:24 -0400
Received: by qcqs25 with SMTP id s25so216301qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 13:57:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com


The patch titled
     Subject: rtc/rtc-da9052: remove unneed devm_kfree call
has been added to the -mm tree.  Its filename is
     rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: rtc/rtc-da9052: remove unneed devm_kfree call

Freeing will trigger when driver unloads, so using devm_kfree() is not
needed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-remove-unneed-devm_kfree-call drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-remove-unneed-devm_kfree-call
+++ a/drivers/rtc/rtc-da9052.c
@@ -245,7 +245,7 @@ static int __devinit da9052_rtc_probe(st
 				   "ALM", rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
-		goto err_mem;
+		return ret;
 	}
 
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
@@ -259,8 +259,6 @@ static int __devinit da9052_rtc_probe(st
 
 err_free_irq:
 	free_irq(rtc->irq, rtc);
-err_mem:
-	devm_kfree(&pdev->dev, rtc);
 	return ret;
 }
 
@@ -271,7 +269,6 @@ static int __devexit da9052_rtc_remove(s
 	rtc_device_unregister(rtc->rtc);
 	free_irq(rtc->irq, rtc);
 	platform_set_drvdata(pdev, NULL);
-	devm_kfree(&pdev->dev, rtc);
 
 	return 0;
 }
_
Subject: Subject: rtc/rtc-da9052: remove unneed devm_kfree call

Patches currently in -mm which might be from devendra.aaru@gmail.com are

linux-next.patch
drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch
rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch
rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch
pps-return-ptr_err-on-error-in-device_create.patch

