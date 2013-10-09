From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch added to
 -mm tree
Date: Wed, 09 Oct 2013 15:57:41 -0700
Message-ID: <5255df65.aPUCaSk+4Me9WSEf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JIW5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Oct 2013 18:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, michal.simek@xilinx.com

Subject: + drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch added to -mm tree
To: michal.simek@xilinx.com,linus.walleij@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 09 Oct 2013 15:57:41 -0700


The patch titled
     Subject: drivers/rtc/rtc-pl03x.c: remove unnecessary amba_set_drvdata()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: drivers/rtc/rtc-pl03x.c: remove unnecessary amba_set_drvdata()

Driver core clears the driver data to NULL after device_release or on
probe failure, so just remove it from here.

The relevant driver core change was 0998d063100128 ("device-core: Ensure
drvdata = NULL when no driver is bound").

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl030.c |    2 --
 drivers/rtc/rtc-pl031.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN drivers/rtc/rtc-pl030.c~drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata drivers/rtc/rtc-pl030.c
--- a/drivers/rtc/rtc-pl030.c~drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata
+++ a/drivers/rtc/rtc-pl030.c
@@ -153,8 +153,6 @@ static int pl030_remove(struct amba_devi
 {
 	struct pl030_rtc *rtc = amba_get_drvdata(dev);
 
-	amba_set_drvdata(dev, NULL);
-
 	writel(0, rtc->base + RTC_CR);
 
 	free_irq(dev->irq[0], rtc);
diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata
+++ a/drivers/rtc/rtc-pl031.c
@@ -305,7 +305,6 @@ static int pl031_remove(struct amba_devi
 {
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
 
-	amba_set_drvdata(adev, NULL);
 	free_irq(adev->irq[0], ldata);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
@@ -392,7 +391,6 @@ out_no_irq:
 	rtc_device_unregister(ldata->rtc);
 out_no_rtc:
 	iounmap(ldata->base);
-	amba_set_drvdata(adev, NULL);
 out_no_remap:
 	kfree(ldata);
 out:
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

drivers-rtc-rtc-pl03xc-remove-unnecessary-amba_set_drvdata.patch
linux-next.patch

