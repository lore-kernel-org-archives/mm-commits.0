From: akpm@linux-foundation.org
Subject: + memstick-remove-deprecated-use-of-pci-api.patch added to -mm
 tree
Date: Thu, 23 Apr 2015 15:17:31 -0700
Message-ID: <55396f7b.p69MFeFS/FZZ7qyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbbDWWRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lambert.quentin@gmail.com, greg@kroah.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: remove deprecated use of pci api
has been added to the -mm tree.  Its filename is
     memstick-remove-deprecated-use-of-pci-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-remove-deprecated-use-of-pci-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-remove-deprecated-use-of-pci-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: memstick: remove deprecated use of pci api

Replace occurences of the pci api by appropriate call to the dma api.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr)

@deprecated@
idexpression id;
position p;
@@

(
  pci_dma_supported@p ( id, ...)
|
  pci_alloc_consistent@p ( id, ...)
)

@bad1@
idexpression id;
position deprecated.p;
@@
...when != &id->dev
   when != pci_get_drvdata ( id )
   when != pci_enable_device ( id )
(
  pci_dma_supported@p ( id, ...)
|
  pci_alloc_consistent@p ( id, ...)
)

@depends on !bad1@
idexpression id;
expression direction;
position deprecated.p;
@@

(
- pci_dma_supported@p ( id,
+ dma_supported ( &id->dev,
...
+ , GFP_ATOMIC
  )
|
- pci_alloc_consistent@p ( id,
+ dma_alloc_coherent ( &id->dev,
...
+ , GFP_ATOMIC
  )
)

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   12 ++++++------
 drivers/memstick/host/r592.c      |   10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-remove-deprecated-use-of-pci-api drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-remove-deprecated-use-of-pci-api
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -419,10 +419,10 @@ static int jmb38x_ms_issue_cmd(struct me
 	}
 
 	if (host->cmd_flags & DMA_DATA) {
-		if (1 != pci_map_sg(host->chip->pdev, &host->req->sg, 1,
+		if (1 != dma_map_sg(&host->chip->pdev->dev, &host->req->sg, 1,
 				    host->req->data_dir == READ
-				    ? PCI_DMA_FROMDEVICE
-				    : PCI_DMA_TODEVICE)) {
+				    ? DMA_FROM_DEVICE
+				    : DMA_TO_DEVICE)) {
 			host->req->error = -ENOMEM;
 			return host->req->error;
 		}
@@ -487,9 +487,9 @@ static void jmb38x_ms_complete_cmd(struc
 	writel(0, host->addr + DMA_CONTROL);
 
 	if (host->cmd_flags & DMA_DATA) {
-		pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
+		dma_unmap_sg(&host->chip->pdev->dev, &host->req->sg, 1,
 			     host->req->data_dir == READ
-			     ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
+			     ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
 		t_val = readl(host->addr + INT_STATUS_ENABLE);
 		if (host->req->data_dir == READ)
@@ -925,7 +925,7 @@ static int jmb38x_ms_probe(struct pci_de
 	int pci_dev_busy = 0;
 	int rc, cnt;
 
-	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (rc)
 		return rc;
 
diff -puN drivers/memstick/host/r592.c~memstick-remove-deprecated-use-of-pci-api drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-remove-deprecated-use-of-pci-api
+++ a/drivers/memstick/host/r592.c
@@ -754,7 +754,7 @@ static int r592_probe(struct pci_dev *pd
 		goto error2;
 
 	pci_set_master(pdev);
-	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	error = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (error)
 		goto error3;
 
@@ -787,8 +787,8 @@ static int r592_probe(struct pci_dev *pd
 	}
 
 	/* This is just a precation, so don't fail */
-	dev->dummy_dma_page = pci_alloc_consistent(pdev, PAGE_SIZE,
-		&dev->dummy_dma_page_physical_address);
+	dev->dummy_dma_page = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+		&dev->dummy_dma_page_physical_address, GFP_KERNEL);
 	r592_stop_dma(dev , 0);
 
 	if (request_irq(dev->irq, &r592_irq, IRQF_SHARED,
@@ -805,7 +805,7 @@ error7:
 	free_irq(dev->irq, dev);
 error6:
 	if (dev->dummy_dma_page)
-		pci_free_consistent(pdev, PAGE_SIZE, dev->dummy_dma_page,
+		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->dummy_dma_page,
 			dev->dummy_dma_page_physical_address);
 
 	kthread_stop(dev->io_thread);
@@ -845,7 +845,7 @@ static void r592_remove(struct pci_dev *
 	memstick_free_host(dev->host);
 
 	if (dev->dummy_dma_page)
-		pci_free_consistent(pdev, PAGE_SIZE, dev->dummy_dma_page,
+		dma_free_coherent(&pdev->dev, PAGE_SIZE, dev->dummy_dma_page,
 			dev->dummy_dma_page_physical_address);
 }
 
_

Patches currently in -mm which might be from lambert.quentin@gmail.com are

origin.patch
memstick-remove-deprecated-use-of-pci-api.patch

