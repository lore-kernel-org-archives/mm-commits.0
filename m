From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-m48t59-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:28 -0700
Message-ID: <51db1408.KoPWqvBxD3zvzlyd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3GHTdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-m48t59-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:28 -0700


The patch titled
     Subject: rtc: rtc-m48t59: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-m48t59-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-m48t59: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |   53 +++++++++++--------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-rtc-m48t59-use-devm_-functions drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-rtc-m48t59-use-devm_-functions
+++ a/drivers/rtc/rtc-m48t59.c
@@ -409,7 +409,8 @@ static int m48t59_rtc_probe(struct platf
 	} else if (res->flags & IORESOURCE_MEM) {
 		/* we are memory-mapped */
 		if (!pdata) {
-			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+			pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata),
+						GFP_KERNEL);
 			if (!pdata)
 				return -ENOMEM;
 			/* Ensure we only kmalloc platform data once */
@@ -425,7 +426,7 @@ static int m48t59_rtc_probe(struct platf
 			pdata->read_byte = m48t59_mem_readb;
 	}
 
-	m48t59 = kzalloc(sizeof(*m48t59), GFP_KERNEL);
+	m48t59 = devm_kzalloc(&pdev->dev, sizeof(*m48t59), GFP_KERNEL);
 	if (!m48t59)
 		return -ENOMEM;
 
@@ -433,9 +434,10 @@ static int m48t59_rtc_probe(struct platf
 
 	if (!m48t59->ioaddr) {
 		/* ioaddr not mapped externally */
-		m48t59->ioaddr = ioremap(res->start, resource_size(res));
+		m48t59->ioaddr = devm_ioremap(&pdev->dev, res->start,
+						resource_size(res));
 		if (!m48t59->ioaddr)
-			goto out;
+			return ret;
 	}
 
 	/* Try to get irq number. We also can work in
@@ -446,10 +448,11 @@ static int m48t59_rtc_probe(struct platf
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
-		ret = request_irq(m48t59->irq, m48t59_rtc_interrupt,
-			IRQF_SHARED, "rtc-m48t59", &pdev->dev);
+		ret = devm_request_irq(&pdev->dev, m48t59->irq,
+				m48t59_rtc_interrupt, IRQF_SHARED,
+				"rtc-m48t59", &pdev->dev);
 		if (ret)
-			goto out;
+			return ret;
 	}
 	switch (pdata->type) {
 	case M48T59RTC_TYPE_M48T59:
@@ -469,51 +472,29 @@ static int m48t59_rtc_probe(struct platf
 		break;
 	default:
 		dev_err(&pdev->dev, "Unknown RTC type\n");
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	spin_lock_init(&m48t59->lock);
 	platform_set_drvdata(pdev, m48t59);
 
-	m48t59->rtc = rtc_device_register(name, &pdev->dev, ops, THIS_MODULE);
-	if (IS_ERR(m48t59->rtc)) {
-		ret = PTR_ERR(m48t59->rtc);
-		goto out;
-	}
+	m48t59->rtc = devm_rtc_device_register(&pdev->dev, name, ops,
+						THIS_MODULE);
+	if (IS_ERR(m48t59->rtc))
+		return PTR_ERR(m48t59->rtc);
 
 	m48t59_nvram_attr.size = pdata->offset;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (ret) {
-		rtc_device_unregister(m48t59->rtc);
-		goto out;
-	}
+	if (ret)
+		return ret;
 
 	return 0;
-
-out:
-	if (m48t59->irq != NO_IRQ)
-		free_irq(m48t59->irq, &pdev->dev);
-	if (m48t59->ioaddr)
-		iounmap(m48t59->ioaddr);
-		kfree(m48t59);
-	return ret;
 }
 
 static int m48t59_rtc_remove(struct platform_device *pdev)
 {
-	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
