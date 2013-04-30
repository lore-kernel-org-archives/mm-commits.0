From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-bq4802-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:01 -0700
Message-ID: <20130430190001.67C0C31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:60299 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab3D3TAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:03 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87265qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-bq4802: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-bq4802-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-bq4802: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq4802.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-bq4802.c~rtc-rtc-bq4802-use-devm_-functions drivers/rtc/rtc-bq4802.c
--- a/drivers/rtc/rtc-bq4802.c~rtc-rtc-bq4802-use-devm_-functions
+++ a/drivers/rtc/rtc-bq4802.c
@@ -142,7 +142,7 @@ static const struct rtc_class_ops bq4802
 
 static int bq4802_probe(struct platform_device *pdev)
 {
-	struct bq4802 *p = kzalloc(sizeof(*p), GFP_KERNEL);
+	struct bq4802 *p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
 
 	if (!p)
@@ -155,54 +155,41 @@ static int bq4802_probe(struct platform_
 		p->r = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		err = -EINVAL;
 		if (!p->r)
-			goto out_free;
+			goto out;
 	}
 	if (p->r->flags & IORESOURCE_IO) {
 		p->ioport = p->r->start;
 		p->read = bq4802_read_io;
 		p->write = bq4802_write_io;
 	} else if (p->r->flags & IORESOURCE_MEM) {
-		p->regs = ioremap(p->r->start, resource_size(p->r));
+		p->regs = devm_ioremap(&pdev->dev, p->r->start,
+					resource_size(p->r));
 		p->read = bq4802_read_mem;
 		p->write = bq4802_write_mem;
 	} else {
 		err = -EINVAL;
-		goto out_free;
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, p);
 
-	p->rtc = rtc_device_register("bq4802", &pdev->dev,
-				     &bq4802_ops, THIS_MODULE);
+	p->rtc = devm_rtc_device_register(&pdev->dev, "bq4802",
+					&bq4802_ops, THIS_MODULE);
 	if (IS_ERR(p->rtc)) {
 		err = PTR_ERR(p->rtc);
-		goto out_iounmap;
+		goto out;
 	}
 
 	err = 0;
 out:
 	return err;
 
-out_iounmap:
-	if (p->r->flags & IORESOURCE_MEM)
-		iounmap(p->regs);
-out_free:
-	kfree(p);
-	goto out;
 }
 
 static int bq4802_remove(struct platform_device *pdev)
 {
-	struct bq4802 *p = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(p->rtc);
-	if (p->r->flags & IORESOURCE_MEM)
-		iounmap(p->regs);
-
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(p);
