From: akpm@linux-foundation.org
Subject: +
 drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch added to -mm tree
Date: Mon, 04 Nov 2013 14:17:12 -0800
Message-ID: <52781ce8.pHsZDbN/WYufz0nS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KDWRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob.herring@calxeda.com, m.chehab@samsung.com, grant.likely@linaro.org, b42378@freescale.com

Subject: + drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch added to -mm tree
To: b42378@freescale.com,grant.likely@linaro.org,m.chehab@samsung.com,rob.herring@calxeda.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:12 -0800


The patch titled
     Subject: drivers/media/platform/coda.c: use gen_pool_dma_alloc() to allocate iram buffer
has been added to the -mm tree.  Its filename is
     drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolin Chen <b42378@freescale.com>
Subject: drivers/media/platform/coda.c: use gen_pool_dma_alloc() to allocate iram buffer

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/coda.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/media/platform/coda.c~drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer drivers/media/platform/coda.c
--- a/drivers/media/platform/coda.c~drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer
+++ a/drivers/media/platform/coda.c
@@ -3298,13 +3298,12 @@ static int coda_probe(struct platform_de
 		dev->iram_size = CODA7_IRAM_SIZE;
 		break;
 	}
-	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
+	dev->iram_vaddr = (unsigned long)gen_pool_dma_alloc(dev->iram_pool,
+			dev->iram_size, (dma_addr_t *)&dev->iram_paddr);
 	if (!dev->iram_vaddr) {
 		dev_err(&pdev->dev, "unable to alloc iram\n");
 		return -ENOMEM;
 	}
-	dev->iram_paddr = gen_pool_virt_to_phys(dev->iram_pool,
-						dev->iram_vaddr);
 
 	platform_set_drvdata(pdev, dev);
 
_

Patches currently in -mm which might be from b42378@freescale.com are

linux-next.patch
lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch
arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch
drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch
drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch
sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch
sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch
sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

