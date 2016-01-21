From: akpm@linux-foundation.org
Subject: [merged] sparc-use-generic-dma_set_mask.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 15:29:08 -0800
Message-ID: <56a169c4.FDn0R2iynr4Wqb04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcAUX3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, davem@davemloft.net, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: use generic dma_set_mask
has been removed from the -mm tree.  Its filename was
     sparc-use-generic-dma_set_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sparc: use generic dma_set_mask

Sparc already uses the same code as the generic code for the PCI
implementation but just fails the call sbus.  This moves to the
generic implemenation which eventually return -EIO due to the NULL
dma_mask pointer in the device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
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
