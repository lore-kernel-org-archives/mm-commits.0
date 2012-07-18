From: akpm@linux-foundation.org
Subject: + rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch added to -mm tree
Date: Wed, 18 Jul 2012 13:57:14 -0700
Message-ID: <20120718205715.8F5DA5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57955 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2GRU5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 16:57:18 -0400
Received: by weyr1 with SMTP id r1so106998wey.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 13:57:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com


The patch titled
     Subject: rtc/rtc-88pm80x: assign ret only when rtc_register_driver fails
has been added to the -mm tree.  Its filename is
     rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch

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
Subject: rtc/rtc-88pm80x: assign ret only when rtc_register_driver fails

At the probe we are assigning ret to return value of PTR_ERR right after
the rtc_register_drive()r, as we would have done it in the if
(IS_ERR(ptr)) check, since the function fails and goes inside that case

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -314,8 +314,8 @@ static int __devinit pm80x_rtc_probe(str
 
 	info->rtc_dev = rtc_device_register("88pm80x-rtc", &pdev->dev,
 					    &pm80x_rtc_ops, THIS_MODULE);
-	ret = PTR_ERR(info->rtc_dev);
 	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
 		goto out_rtc;
 	}
_
Subject: Subject: rtc/rtc-88pm80x: assign ret only when rtc_register_driver fails

Patches currently in -mm which might be from devendra.aaru@gmail.com are

linux-next.patch
drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch
rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch
rtc-rtc-da9052-remove-unneed-devm_kfree-call.patch
pps-return-ptr_err-on-error-in-device_create.patch

