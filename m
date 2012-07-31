From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:45 -0700
Message-ID: <20120731185246.21E595C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64859 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:48 -0400
Received: by bkcjc3 with SMTP id jc3so293484bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/rtc-da9052: remove unneed devm_kfree call
has been removed from the -mm tree.  Its filename was
     rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch
rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch
linux-next.patch

