From: akpm@linux-foundation.org
Subject: + drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch added to -mm tree
Date: Thu, 15 Nov 2012 15:15:17 -0800
Message-ID: <20121115231517.B02FC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35465 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2KOXPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 18:15:19 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so239048vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 15:15:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, balbi@ti.com, greg@kroah.com


The patch titled
     Subject: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() with NULL dev
has been added to the -mm tree.  Its filename is
     drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() with NULL dev

Calling dma_pool_create() with dev==NULL will oops on a NUMA machine. 
Rather than changing dma_pool_create() we wish to disallow passing
dev==NULL.  This requires fixing up the small number of drivers which are
passing in dev==NULL.

Use &dev->pdev->dev instead of NULL.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/usb/gadget/amd5536udc.c~usb-amd5536udc-avoid-calling-dma_pool_create-with-null-dev drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~usb-amd5536udc-avoid-calling-dma_pool_create-with-null-dev
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3133,7 +3133,7 @@ static int init_dma_pools(struct udc *de
 	}
 
 	/* DMA setup */
-	dev->data_requests = dma_pool_create("data_requests", NULL,
+	dev->data_requests = dma_pool_create("data_requests", &dev->pdev->dev,
 		sizeof(struct udc_data_dma), 0, 0);
 	if (!dev->data_requests) {
 		DBG(dev, "can't get request data pool\n");
@@ -3145,7 +3145,7 @@ static int init_dma_pools(struct udc *de
 	dev->ep[UDC_EP0IN_IX].dma = &dev->regs->ctl;
 
 	/* dma desc for setup data */
-	dev->stp_requests = dma_pool_create("setup requests", NULL,
+	dev->stp_requests = dma_pool_create("setup requests", &dev->pdev->dev,
 		sizeof(struct udc_stp_dma), 0, 0);
 	if (!dev->stp_requests) {
 		DBG(dev, "can't get stp request pool\n");
@@ -3266,6 +3266,12 @@ static int udc_pci_probe(
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
+	dev->phys_addr = resource;
+	dev->irq = pdev->irq;
+	dev->pdev = pdev;
+	dev->gadget.dev.parent = &pdev->dev;
+	dev->gadget.dev.dma_mask = pdev->dev.dma_mask;
+
 	/* init dma pools */
 	if (use_dma) {
 		retval = init_dma_pools(dev);
@@ -3273,12 +3279,6 @@ static int udc_pci_probe(
 			goto finished;
 	}
 
-	dev->phys_addr = resource;
-	dev->irq = pdev->irq;
-	dev->pdev = pdev;
-	dev->gadget.dev.parent = &pdev->dev;
-	dev->gadget.dev.dma_mask = pdev->dev.dma_mask;
