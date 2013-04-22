From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap.patch added to -mm tree
Date: Mon, 22 Apr 2013 16:16:45 -0700
Message-ID: <20130422231645.6EDA331C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50277 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3DVXQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 19:16:46 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so2048qcs.3
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 16:16:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, nicolas.ferre@atmel.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: fix missing iounmap
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: drivers/rtc/rtc-at91rm9200.c: fix missing iounmap

Add missing iounmap to probe error path and remove.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-missing-iounmap drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-missing-iounmap
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -299,7 +299,7 @@ static int __init at91_rtc_probe(struct
 				"at91_rtc", pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
-		return ret;
+		goto err_unmap;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -311,13 +311,20 @@ static int __init at91_rtc_probe(struct
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		free_irq(irq, pdev);
-		return PTR_ERR(rtc);
+		ret = PTR_ERR(rtc);
+		goto err_free_irq;
 	}
 	platform_set_drvdata(pdev, rtc);
 
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
+
+err_free_irq:
+	free_irq(irq, pdev);
+err_unmap:
+	iounmap(at91_rtc_regs);
+
+	return ret;
 }
 
 /*
@@ -334,6 +341,7 @@ static int __exit at91_rtc_remove(struct
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
+	iounmap(at91_rtc_regs);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from jhovold@gmail.com are

linux-next.patch
drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap.patch

