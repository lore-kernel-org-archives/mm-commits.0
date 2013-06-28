From: akpm@linux-foundation.org
Subject: +
 drivers-dma-remove-unused-support-for-memset-operations-v3.patch added to
 -mm tree
Date: Fri, 28 Jun 2013 15:31:08 -0700
Message-ID: <51ce0eac.l8zSdvtdp+qxG3bl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3F1WbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 18:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, t.figa@samsung.com, olof@lixom.net, kyungmin.park@samsung.com, khilman@linaro.org, herbert@gondor.apana.org.au, djbw@fb.com, b.zolnierkie@samsung.com

Subject: + drivers-dma-remove-unused-support-for-memset-operations-v3.patch added to -mm tree
To: b.zolnierkie@samsung.com,djbw@fb.com,herbert@gondor.apana.org.au,khilman@linaro.org,kyungmin.park@samsung.com,olof@lixom.net,t.figa@samsung.com,vinod.koul@intel.com
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 15:31:08 -0700


The patch titled
     Subject: drivers-dma-remove-unused-support-for-memset-operations-v3
has been added to the -mm tree.  Its filename is
     drivers-dma-remove-unused-support-for-memset-operations-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-dma-remove-unused-support-for-memset-operations-v3.patch

