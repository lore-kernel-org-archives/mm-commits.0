From: akpm@linux-foundation.org
Subject: [-]
 drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch removed from -mm tree
Date: Wed, 10 Jul 2013 13:25:05 -0700
Message-ID: <51ddc321.YPmc9NLcGbvH+YIk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJUZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 16:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, balbi@ti.com, xi.wang@gmail.com

Subject: [-] drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch removed from -mm tree
To: xi.wang@gmail.com,balbi@ti.com,greg@kroah.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 13:25:05 -0700


The patch titled
     Subject: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() with NULL dev
has been removed from the -mm tree.  Its filename was
     drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch

This patch was dropped because it has gone stale

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

 drivers/usb/gadget/amd5536udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/amd5536udc.c~drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3099,7 +3099,7 @@ static int init_dma_pools(struct udc *de
 	}
 
 	/* DMA setup */
-	dev->data_requests = dma_pool_create("data_requests", NULL,
+	dev->data_requests = dma_pool_create("data_requests", &dev->pdev->dev,
 		sizeof(struct udc_data_dma), 0, 0);
 	if (!dev->data_requests) {
 		DBG(dev, "can't get request data pool\n");
@@ -3111,7 +3111,7 @@ static int init_dma_pools(struct udc *de
 	dev->ep[UDC_EP0IN_IX].dma = &dev->regs->ctl;
 
 	/* dma desc for setup data */
-	dev->stp_requests = dma_pool_create("setup requests", NULL,
+	dev->stp_requests = dma_pool_create("setup requests", &dev->pdev->dev,
 		sizeof(struct udc_stp_dma), 0, 0);
 	if (!dev->stp_requests) {
 		DBG(dev, "can't get stp request pool\n");
_

Patches currently in -mm which might be from xi.wang@gmail.com are

mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

