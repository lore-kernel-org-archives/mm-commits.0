From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:33 -0400
Message-ID: <201003150704.o2F746bG016986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935979Ab0COHEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, benh@kernel.crashing.org, davem@davemloft.net, greg@kroah.com, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, kay.sievers@


The patch titled
     dma-mapping: sparc: unify 32bit and 64bit dma_set_mask
has been removed from the -mm tree.  Its filename was
     dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: sparc: unify 32bit and 64bit dma_set_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patchset transforms the PCI DMA API into the generic device model. 
It's one of the reasons why we introduced the generic DMA API long ago;
driver writers are always able to use the generic DMA API with any bus
instead of using bus specific DMA APIs such as pci_map_single,
sbus_map_single, etc (only two bus specific APIs exist now; pci and ssb).

Some of the PCI DMA API are already implented on the top of the generic
DMA API (include/asm-generic/pci-dma-compat.h).  But there are some
exceptions.  This patchset finishes the transformation.



This patch:

sparc has two dma_set_mask implementations for 32bit and 64bit.  They are
same except for the error returned value.  We can safely unify them since
the error returned value doesn't matter as long as it is negative (as
DMA-API.txt describes).

This patch also changes dma_set_mask not to call
pci_set_dma_mask. Instead, dma_set_mask does the same thing that
pci_set_dma_mask does. This change enables ut to change
pci_set_dma_mask to call dma_set_mask; we can implement
pci_set_dma_mask as pci-dma-compat.h does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Miller <davem@davemloft.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping.h |   14 +++++++++++++-
 arch/sparc/kernel/iommu.c            |   10 ----------
 arch/sparc/kernel/ioport.c           |   11 -----------
 3 files changed, 13 insertions(+), 22 deletions(-)

diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -8,7 +8,6 @@
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
 extern int dma_supported(struct device *dev, u64 mask);
-extern int dma_set_mask(struct device *dev, u64 dma_mask);
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
@@ -62,4 +61,17 @@ static inline int dma_get_cache_alignmen
 	return (1 << INTERNODE_CACHE_SHIFT);
 }
 
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type) {
+		if (!dev->dma_mask || !dma_supported(dev, mask))
+			return -EINVAL;
+		*dev->dma_mask = mask;
+		return 0;
+	}
+#endif
+	return -EINVAL;
+}
+
 #endif
diff -puN arch/sparc/kernel/iommu.c~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask
+++ a/arch/sparc/kernel/iommu.c
@@ -862,13 +862,3 @@ int dma_supported(struct device *dev, u6
 	return 0;
 }
 EXPORT_SYMBOL(dma_supported);
-
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EINVAL;
-}
-EXPORT_SYMBOL(dma_set_mask);
diff -puN arch/sparc/kernel/ioport.c~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask arch/sparc/kernel/ioport.c
--- a/arch/sparc/kernel/ioport.c~dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask
+++ a/arch/sparc/kernel/ioport.c
@@ -676,17 +676,6 @@ int dma_supported(struct device *dev, u6
 }
 EXPORT_SYMBOL(dma_supported);
 
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
