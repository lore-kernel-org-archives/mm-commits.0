From: akpm@linux-foundation.org
Subject: + sparc-use-generic-dma_set_mask.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:09 -0800
Message-ID: <564b9e41.LQq9wrnK8oNi1Usj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbbKQViJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: use generic dma_set_mask
has been added to the -mm tree.  Its filename is
     sparc-use-generic-dma_set_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-use-generic-dma_set_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-use-generic-dma_set_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sparc: use generic dma_set_mask

Sparc already uses the same code as the generic code for the PCI
implementation but just fails the call sbus.  This moves to the
generic implemenation which eventually return -EIO due to the NULL
dma_mask pointer in the device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN arch/sparc/include/asm/dma-mapping.h~sparc-use-generic-dma_set_mask arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~sparc-use-generic-dma_set_mask
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -37,21 +37,6 @@ static inline struct dma_map_ops *get_dm
 	return dma_ops;
 }
 
-#define HAVE_ARCH_DMA_SET_MASK 1
-
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		if (!dev->dma_mask || !dma_supported(dev, mask))
-			return -EINVAL;
-		*dev->dma_mask = mask;
-		return 0;
-	}
-#endif
-	return -EINVAL;
-}
