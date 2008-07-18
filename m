From: akpm@linux-foundation.org
Subject: + sh_keysc-remove-request_mem_region-and-release_mem_region.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:49:50 -0700
Message-ID: <200807182149.m6ILnoxN032594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759328AbYGRVuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mukawa@igel.co.jp, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     sh_keysc: remove request_mem_region() and release_mem_region()
has been added to the -mm tree.  Its filename is
     sh_keysc-remove-request_mem_region-and-release_mem_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh_keysc: remove request_mem_region() and release_mem_region()
From: Tetsuya Mukawa <mukawa@igel.co.jp>

Remove request_mem_region() and release_mem_region() from sh_keysc driver.
Those functions can find resource conflict, but it is already checked in
platform_device_add().

Signed-off-by: Tetsuya Mukawa <mukawa@igel.co.jp>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/sh_keysc.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff -puN drivers/input/keyboard/sh_keysc.c~sh_keysc-remove-request_mem_region-and-release_mem_region drivers/input/keyboard/sh_keysc.c
--- a/drivers/input/keyboard/sh_keysc.c~sh_keysc-remove-request_mem_region-and-release_mem_region
+++ a/drivers/input/keyboard/sh_keysc.c
@@ -158,25 +158,18 @@ static int __devinit sh_keysc_probe(stru
 	memcpy(&priv->pdata, pdev->dev.platform_data, sizeof(priv->pdata));
 	pdata = &priv->pdata;
 
-	res = request_mem_region(res->start, res_size(res), pdev->name);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto err1;
-	}
-
 	priv->iomem_base = ioremap_nocache(res->start, res_size(res));
 	if (priv->iomem_base == NULL) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
 		error = -ENXIO;
-		goto err2;
+		goto err1;
 	}
 
 	priv->input = input_allocate_device();
 	if (!priv->input) {
 		dev_err(&pdev->dev, "failed to allocate input device\n");
 		error = -ENOMEM;
-		goto err3;
+		goto err2;
 	}
 
 	input = priv->input;
@@ -194,7 +187,7 @@ static int __devinit sh_keysc_probe(stru
 	error = request_irq(irq, sh_keysc_isr, 0, pdev->name, pdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
-		goto err4;
+		goto err3;
 	}
 
 	for (i = 0; i < SH_KEYSC_MAXKEYS; i++) {
@@ -206,7 +199,7 @@ static int __devinit sh_keysc_probe(stru
 	error = input_register_device(input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto err5;
+		goto err4;
 	}
 
 	iowrite16((sh_keysc_mode[pdata->mode].kymd << 8) |
@@ -214,14 +207,12 @@ static int __devinit sh_keysc_probe(stru
 	iowrite16(0, priv->iomem_base + KYOUTDR_OFFS);
 	iowrite16(KYCR2_IRQ_LEVEL, priv->iomem_base + KYCR2_OFFS);
 	return 0;
- err5:
-	free_irq(irq, pdev);
  err4:
-	input_free_device(input);
+	free_irq(irq, pdev);
  err3:
-	iounmap(priv->iomem_base);
+	input_free_device(input);
  err2:
-	release_mem_region(res->start, res_size(res));
+	iounmap(priv->iomem_base);
  err1:
 	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
@@ -232,7 +223,6 @@ static int __devinit sh_keysc_probe(stru
 static int __devexit sh_keysc_remove(struct platform_device *pdev)
 {
 	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
-	struct resource *res;
 
 	iowrite16(KYCR2_IRQ_DISABLED, priv->iomem_base + KYCR2_OFFS);
 
@@ -240,9 +230,6 @@ static int __devexit sh_keysc_remove(str
 	free_irq(platform_get_irq(pdev, 0), pdev);
 	iounmap(priv->iomem_base);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res_size(res));
