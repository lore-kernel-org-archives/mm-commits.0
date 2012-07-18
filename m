From: akpm@linux-foundation.org
Subject: + rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch added to -mm tree
Date: Wed, 18 Jul 2012 13:57:18 -0700
Message-ID: <20120718205719.BEA1A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42990 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2GRU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 16:57:22 -0400
Received: by eaao13 with SMTP id o13so107364eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 13:57:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com


The patch titled
     Subject: rtc/rtc-88pm80x: remove unneed devm_kfree
has been added to the -mm tree.  Its filename is
     rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch

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
Subject: rtc/rtc-88pm80x: remove unneed devm_kfree

devm_kzalloc() doesn't need a matching devm_kfree(), the freeing mechanism
will trigger when driver unloads.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unneed-devm_kfree drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unneed-devm_kfree
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -339,7 +339,6 @@ static int __devinit pm80x_rtc_probe(str
 out_rtc:
 	pm80x_free_irq(chip, info->irq, info);
 out:
-	devm_kfree(&pdev->dev, info);
 	return ret;
 }
 
@@ -349,7 +348,6 @@ static int __devexit pm80x_rtc_remove(st
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
-	devm_kfree(&pdev->dev, info);
 	return 0;
 }
 
_
Subject: Subject: rtc/rtc-88pm80x: remove unneed devm_kfree

Patches currently in -mm which might be from devendra.aaru@gmail.com are

linux-next.patch
drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch
rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch
rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch
pps-return-ptr_err-on-error-in-device_create.patch

