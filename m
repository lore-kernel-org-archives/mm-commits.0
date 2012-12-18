From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-vt8500c-convert-to-use-devm_kzalloc.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:44 -0800
Message-ID: <20121218200745.1AA77200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50922 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:47 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63350bkc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, alchark@gmail.com, linux@prisktech.co.nz, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: convert to use devm_kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-vt8500c-convert-to-use-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/rtc/rtc-vt8500.c: convert to use devm_kzalloc

Replace the kzalloc() and kfree() calls with devm_kzalloc().

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexey Charkov <alchark@gmail.com>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-convert-to-use-devm_kzalloc drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-convert-to-use-devm_kzalloc
+++ a/drivers/rtc/rtc-vt8500.c
@@ -210,7 +210,8 @@ static int __devinit vt8500_rtc_probe(st
 	struct vt8500_rtc *vt8500_rtc;
 	int ret;
 
-	vt8500_rtc = kzalloc(sizeof(struct vt8500_rtc), GFP_KERNEL);
+	vt8500_rtc = devm_kzalloc(&pdev->dev,
+			   sizeof(struct vt8500_rtc), GFP_KERNEL);
 	if (!vt8500_rtc)
 		return -ENOMEM;
 
@@ -220,15 +221,13 @@ static int __devinit vt8500_rtc_probe(st
 	vt8500_rtc->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!vt8500_rtc->res) {
 		dev_err(&pdev->dev, "No I/O memory resource defined\n");
-		ret = -ENXIO;
-		goto err_free;
+		return -ENXIO;
 	}
 
 	vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (vt8500_rtc->irq_alarm < 0) {
 		dev_err(&pdev->dev, "No alarm IRQ resource defined\n");
-		ret = -ENXIO;
-		goto err_free;
+		return -ENXIO;
 	}
 
 	vt8500_rtc->res = request_mem_region(vt8500_rtc->res->start,
@@ -236,8 +235,7 @@ static int __devinit vt8500_rtc_probe(st
 					     "vt8500-rtc");
 	if (vt8500_rtc->res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto err_free;
+		return -EBUSY;
 	}
 
 	vt8500_rtc->regbase = ioremap(vt8500_rtc->res->start,
@@ -278,8 +276,6 @@ err_unmap:
 err_release:
 	release_mem_region(vt8500_rtc->res->start,
 			   resource_size(vt8500_rtc->res));
-err_free:
-	kfree(vt8500_rtc);
 	return ret;
 }
 
@@ -297,7 +293,6 @@ static int __devexit vt8500_rtc_remove(s
 	release_mem_region(vt8500_rtc->res->start,
 			   resource_size(vt8500_rtc->res));
 
-	kfree(vt8500_rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch

