From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-use-devm_-functions.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:45:14 -0800
Message-ID: <20130222204514.94BA431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51274 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3BVUpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:15 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103807vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-davinci: use devm_*() functions

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_-functions drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_-functions
+++ a/drivers/rtc/rtc-davinci.c
@@ -506,19 +506,19 @@ static int __init davinci_rtc_probe(stru
 	davinci_rtc->pbase = res->start;
 	davinci_rtc->base_size = resource_size(res);
 
-	mem = request_mem_region(davinci_rtc->pbase, davinci_rtc->base_size,
-				 pdev->name);
+	mem = devm_request_mem_region(dev, davinci_rtc->pbase,
+				davinci_rtc->base_size, pdev->name);
 	if (!mem) {
 		dev_err(dev, "RTC registers at %08x are not free\n",
 			davinci_rtc->pbase);
 		return -EBUSY;
 	}
 
-	davinci_rtc->base = ioremap(davinci_rtc->pbase, davinci_rtc->base_size);
+	davinci_rtc->base = devm_ioremap(dev, davinci_rtc->pbase,
+					davinci_rtc->base_size);
 	if (!davinci_rtc->base) {
 		dev_err(dev, "unable to ioremap MEM resource\n");
-		ret = -ENOMEM;
-		goto fail2;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, davinci_rtc);
@@ -529,7 +529,7 @@ static int __init davinci_rtc_probe(stru
 		ret = PTR_ERR(davinci_rtc->rtc);
 		dev_err(dev, "unable to register RTC device, err %d\n",
 				ret);
-		goto fail3;
+		goto fail1;
 	}
 
 	rtcif_write(davinci_rtc, PRTCIF_INTFLG_RTCSS, PRTCIF_INTFLG);
@@ -539,11 +539,11 @@ static int __init davinci_rtc_probe(stru
 	rtcss_write(davinci_rtc, 0, PRTCSS_RTC_CTRL);
 	rtcss_write(davinci_rtc, 0, PRTCSS_RTC_CCTRL);
 
-	ret = request_irq(davinci_rtc->irq, davinci_rtc_interrupt,
+	ret = devm_request_irq(dev, davinci_rtc->irq, davinci_rtc_interrupt,
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail4;
+		goto fail2;
 	}
 
 	/* Enable interrupts */
@@ -557,13 +557,10 @@ static int __init davinci_rtc_probe(stru
 
 	return 0;
 
-fail4:
+fail2:
 	rtc_device_unregister(davinci_rtc->rtc);
-fail3:
+fail1:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(davinci_rtc->base);
-fail2:
-	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
 	return ret;
 }
 
@@ -575,13 +572,8 @@ static int davinci_rtc_remove(struct pla
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	free_irq(davinci_rtc->irq, davinci_rtc);
-
 	rtc_device_unregister(davinci_rtc->rtc);
 
-	iounmap(davinci_rtc->base);
-	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
