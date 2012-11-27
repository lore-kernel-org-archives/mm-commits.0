From: akpm@linux-foundation.org
Subject: + rtc-rtc-davinci-use-devm_kzalloc.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:33:16 -0800
Message-ID: <20121127203317.573E282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49154 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2K0UdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:33:20 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so680425qab.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:33:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, miguel.aguilar@ridgerun.com


The patch titled
     Subject: rtc: rtc-davinci: use devm_kzalloc()
has been added to the -mm tree.  Its filename is
     rtc-rtc-davinci-use-devm_kzalloc.patch

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
Subject: rtc: rtc-davinci: use devm_kzalloc()

Use devm_kzalloc() and remove the error path free and the unload free as
devm functions take care of freeing resources.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_kzalloc drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_kzalloc
+++ a/drivers/rtc/rtc-davinci.c
@@ -485,7 +485,7 @@ static int __init davinci_rtc_probe(stru
 	struct resource *res, *mem;
 	int ret = 0;
 
-	davinci_rtc = kzalloc(sizeof(struct davinci_rtc), GFP_KERNEL);
+	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
 	if (!davinci_rtc) {
 		dev_dbg(dev, "could not allocate memory for private data\n");
 		return -ENOMEM;
@@ -494,15 +494,13 @@ static int __init davinci_rtc_probe(stru
 	davinci_rtc->irq = platform_get_irq(pdev, 0);
 	if (davinci_rtc->irq < 0) {
 		dev_err(dev, "no RTC irq\n");
-		ret = davinci_rtc->irq;
-		goto fail1;
+		return davinci_rtc->irq;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "no mem resource\n");
-		ret = -EINVAL;
-		goto fail1;
+		return -EINVAL;
 	}
 
 	davinci_rtc->pbase = res->start;
@@ -513,8 +511,7 @@ static int __init davinci_rtc_probe(stru
 	if (!mem) {
 		dev_err(dev, "RTC registers at %08x are not free\n",
 			davinci_rtc->pbase);
-		ret = -EBUSY;
-		goto fail1;
+		return -EBUSY;
 	}
 
 	davinci_rtc->base = ioremap(davinci_rtc->pbase, davinci_rtc->base_size);
@@ -567,9 +564,6 @@ fail3:
 	iounmap(davinci_rtc->base);
 fail2:
 	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
-fail1:
-	kfree(davinci_rtc);
-
 	return ret;
 }
 
@@ -590,8 +584,6 @@ static int __devexit davinci_rtc_remove(
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(davinci_rtc);
