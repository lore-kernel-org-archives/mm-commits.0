From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:18 -0700
Message-ID: <20120801201918.E8ED81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:39454 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:20 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5414806obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/rtc-88pm80x: assign ret only when rtc_register_driver fails
has been removed from the -mm tree.  Its filename was
     rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch

