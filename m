From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:06 -0800
Message-ID: <20121218200807.2B74C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:52004 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2LRUIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:09 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so63376eek.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, miguel.aguilar@ridgerun.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: return correct error code if rtc_device_register() fails
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: rtc: rtc-davinci: return correct error code if rtc_device_register() fails

rtc_device_register() returns a pointer containing error code in case
of error.  Use that in the error return.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails
+++ a/drivers/rtc/rtc-davinci.c
@@ -529,8 +529,9 @@ static int __init davinci_rtc_probe(stru
 	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
-		dev_err(dev, "unable to register RTC device, err %ld\n",
-				PTR_ERR(davinci_rtc->rtc));
+		ret = PTR_ERR(davinci_rtc->rtc);
+		dev_err(dev, "unable to register RTC device, err %d\n",
+				ret);
 		goto fail3;
 	}
 
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch

