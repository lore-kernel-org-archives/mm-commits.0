From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-remove-unused-support-for-memset-operations-v3.patch removed
 from -mm tree
Date: Wed, 03 Jul 2013 14:38:30 -0700
Message-ID: <51d499d6.xhjn1/aV5i8Mh1M0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3GCVib (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:38:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, t.figa@samsung.com, olof@lixom.net, kyungmin.park@samsung.com, khilman@linaro.org, herbert@gondor.apana.org.au, djbw@fb.com, b.zolnierkie@samsung.com

Subject: [folded-merged] drivers-dma-remove-unused-support-for-memset-operations-v3.patch removed from -mm tree
To: b.zolnierkie@samsung.com,djbw@fb.com,herbert@gondor.apana.org.au,khilman@linaro.org,kyungmin.park@samsung.com,olof@lixom.net,t.figa@samsung.com,vinod.koul@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:38:30 -0700


The patch titled
     Subject: drivers-dma-remove-unused-support-for-memset-operations-v3
has been removed from the -mm tree.  Its filename was
     drivers-dma-remove-unused-support-for-memset-operations-v3.patch

This patch was dropped because it was folded into drivers-dma-remove-unused-support-for-memset-operations.patch

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: drivers-dma-remove-unused-support-for-memset-operations-v3

This is an old patch that I ported to current kernels.  I fixed rejects
and verified that it compiles for cases that hit rejects but unfortunately
I forgot to check for new code related to DMA_MEMSET functionality. 
Fortunately it seems that the problematic places are in
plat-orion/common.c and mv_xor.c.  They are fixed in the attached patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-orion/common.c |    5 -----
 drivers/dma/mv_xor.c         |    2 --
 2 files changed, 7 deletions(-)

diff -puN arch/arm/plat-orion/common.c~drivers-dma-remove-unused-support-for-memset-operations-v3 arch/arm/plat-orion/common.c
--- a/arch/arm/plat-orion/common.c~drivers-dma-remove-unused-support-for-memset-operations-v3
+++ a/arch/arm/plat-orion/common.c
@@ -727,14 +727,9 @@ void __init orion_xor1_init(unsigned lon
 	orion_xor1_shared_resources[3].start = irq_1;
 	orion_xor1_shared_resources[3].end = irq_1;
 
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
 	dma_cap_set(DMA_MEMCPY, orion_xor1_channels_data[0].cap_mask);
 	dma_cap_set(DMA_XOR, orion_xor1_channels_data[0].cap_mask);
 
-	dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
 	dma_cap_set(DMA_MEMCPY, orion_xor1_channels_data[1].cap_mask);
 	dma_cap_set(DMA_XOR, orion_xor1_channels_data[1].cap_mask);
 
diff -puN drivers/dma/mv_xor.c~drivers-dma-remove-unused-support-for-memset-operations-v3 drivers/dma/mv_xor.c
--- a/drivers/dma/mv_xor.c~drivers-dma-remove-unused-support-for-memset-operations-v3
+++ a/drivers/dma/mv_xor.c
@@ -1244,8 +1244,6 @@ static int mv_xor_probe(struct platform_
 				dma_cap_set(DMA_MEMCPY, cap_mask);
 			if (of_property_read_bool(np, "dmacap,xor"))
 				dma_cap_set(DMA_XOR, cap_mask);
-			if (of_property_read_bool(np, "dmacap,memset"))
-				dma_cap_set(DMA_MEMSET, cap_mask);
 			if (of_property_read_bool(np, "dmacap,interrupt"))
 				dma_cap_set(DMA_INTERRUPT, cap_mask);
 
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

drivers-dma-pl330c-fix-locking-in-pl330_free_chan_resources.patch
drivers-dma-remove-unused-support-for-memset-operations.patch
drivers-dma-remove-unused-support-for-memset-operations-v3-fix.patch

