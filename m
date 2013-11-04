From: akpm@linux-foundation.org
Subject: +
 drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch added to -mm tree
Date: Mon, 04 Nov 2013 14:17:13 -0800
Message-ID: <52781ce9.BXP4niKgVOmGtsJE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3KDWRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hjk@hansjkoch.de, gregkh@linuxfoundation.org, b42378@freescale.com

Subject: + drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch added to -mm tree
To: b42378@freescale.com,gregkh@linuxfoundation.org,hjk@hansjkoch.de
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:13 -0800


The patch titled
     Subject: drivers/uio/uio_pruss.c: use gen_pool_dma_alloc() to allocate sram memory
has been added to the -mm tree.  Its filename is
     drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch

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
Subject: drivers/uio/uio_pruss.c: use gen_pool_dma_alloc() to allocate sram memory

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uio/uio_pruss.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/uio/uio_pruss.c~drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory drivers/uio/uio_pruss.c
--- a/drivers/uio/uio_pruss.c~drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory
+++ a/drivers/uio/uio_pruss.c
@@ -158,14 +158,12 @@ static int pruss_probe(struct platform_d
 	if (pdata->sram_pool) {
 		gdev->sram_pool = pdata->sram_pool;
 		gdev->sram_vaddr =
-			gen_pool_alloc(gdev->sram_pool, sram_pool_sz);
+			(unsigned long)gen_pool_dma_alloc(gdev->sram_pool,
+					sram_pool_sz, &gdev->sram_paddr);
 		if (!gdev->sram_vaddr) {
 			dev_err(&dev->dev, "Could not allocate SRAM pool\n");
 			goto out_free;
 		}
-		gdev->sram_paddr =
-			gen_pool_virt_to_phys(gdev->sram_pool,
-					      gdev->sram_vaddr);
 	}
 
 	gdev->ddr_vaddr = dma_alloc_coherent(&dev->dev, extram_pool_sz,
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

