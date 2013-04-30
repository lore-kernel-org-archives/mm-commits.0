From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:31 -0700
Message-ID: <20130430190131.74A4B31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:42848 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3D3TBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:32 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so87554yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, nicolas.ferre@atmel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: fix missing iounmap
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

diff -puN drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-fix-missing-iounmap
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

origin.patch
linux-next.patch

