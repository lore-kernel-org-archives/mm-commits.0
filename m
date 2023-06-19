Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB588EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjFSXYm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjFSXXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9937210C1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CF060FC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F50C433C8;
        Mon, 19 Jun 2023 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216951;
        bh=C8fSkKdA3xLGSGerUDrWWHl6tRVdec0yBMct2jEt8hI=;
        h=Date:To:From:Subject:From;
        b=RNBqM8LThBmsqm79AnJXHhuU4iGkCnQcRntofOsdXdNHahRsSzLy+z1gja9Q2dOZm
         aLOtUuoo7/TlKX8zPx8Rll0ttPgqbBsAHr1rjDs/Z+po0ly2hDTUgEOANfxDEaxo9H
         5WWj5YtqezO3bHmRrJeoykDvJkkgc/zbiNpThsVQ=
Date:   Mon, 19 Jun 2023 16:22:31 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        snitzer@kernel.org, saravanak@google.com, robin.murphy@arm.com,
        rafael@kernel.org, maz@kernel.org, logang@deltatee.com,
        lars@metafoo.de, jsnitsel@redhat.com, joro@8bytes.org,
        Jonathan.Cameron@huawei.com, jic23@kernel.org,
        isaacmanjarres@google.com, herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch, broonie@kernel.org,
        arnd@arndb.de, ardb@kernel.org, agk@redhat.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned.patch removed from -mm tree
Message-Id: <20230619232231.82F50C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iommu/dma: force bouncing if the size is not cacheline-aligned
has been removed from the -mm tree.  Its filename was
     iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: iommu/dma: force bouncing if the size is not cacheline-aligned
Date: Mon, 12 Jun 2023 16:31:59 +0100

Similarly to the direct DMA, bounce small allocations as they may have
originated from a kmalloc() cache not safe for DMA. Unlike the direct
DMA, iommu_dma_map_sg() cannot call iommu_dma_map_sg_swiotlb() for all
non-coherent devices as this would break some cases where the iova is
expected to be contiguous (dmabuf). Instead, scan the scatterlist for
any small sizes and only go the swiotlb path if any element of the list
needs bouncing (note that iommu_dma_map_page() would still only bounce
those buffers which are not DMA-aligned).

To avoid scanning the scatterlist on the 'sync' operations, introduce an
SG_DMA_SWIOTLB flag set by iommu_dma_map_sg_swiotlb(). The
dev_use_swiotlb() function together with the newly added
dev_use_sg_swiotlb() now check for both untrusted devices and unaligned
kmalloc() buffers (suggested by Robin Murphy).

Link: https://lkml.kernel.org/r/20230612153201.554742-16-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/Kconfig       |    1 
 drivers/iommu/dma-iommu.c   |   50 +++++++++++++++++++++++++++-------
 include/linux/scatterlist.h |   41 ++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 11 deletions(-)

--- a/drivers/iommu/dma-iommu.c~iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned
+++ a/drivers/iommu/dma-iommu.c
@@ -520,9 +520,38 @@ static bool dev_is_untrusted(struct devi
 	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
 }
 
-static bool dev_use_swiotlb(struct device *dev)
+static bool dev_use_swiotlb(struct device *dev, size_t size,
+			    enum dma_data_direction dir)
 {
-	return IS_ENABLED(CONFIG_SWIOTLB) && dev_is_untrusted(dev);
+	return IS_ENABLED(CONFIG_SWIOTLB) &&
+		(dev_is_untrusted(dev) ||
+		 dma_kmalloc_needs_bounce(dev, size, dir));
+}
+
+static bool dev_use_sg_swiotlb(struct device *dev, struct scatterlist *sg,
+			       int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SWIOTLB))
+		return false;
+
+	if (dev_is_untrusted(dev))
+		return true;
+
+	/*
+	 * If kmalloc() buffers are not DMA-safe for this device and
+	 * direction, check the individual lengths in the sg list. If any
+	 * element is deemed unsafe, use the swiotlb for bouncing.
+	 */
+	if (!dma_kmalloc_safe(dev, dir)) {
+		for_each_sg(sg, s, nents, i)
+			if (!dma_kmalloc_size_aligned(s->length))
+				return true;
+	}
+
+	return false;
 }
 
 /**
@@ -922,7 +951,7 @@ static void iommu_dma_sync_single_for_cp
 {
 	phys_addr_t phys;
 
-	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
+	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev, size, dir))
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
@@ -938,7 +967,7 @@ static void iommu_dma_sync_single_for_de
 {
 	phys_addr_t phys;
 
-	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
+	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev, size, dir))
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
@@ -956,7 +985,7 @@ static void iommu_dma_sync_sg_for_cpu(st
 	struct scatterlist *sg;
 	int i;
 
-	if (dev_use_swiotlb(dev))
+	if (sg_dma_is_swiotlb(sgl))
 		for_each_sg(sgl, sg, nelems, i)
 			iommu_dma_sync_single_for_cpu(dev, sg_dma_address(sg),
 						      sg->length, dir);
@@ -972,7 +1001,7 @@ static void iommu_dma_sync_sg_for_device
 	struct scatterlist *sg;
 	int i;
 
-	if (dev_use_swiotlb(dev))
+	if (sg_dma_is_swiotlb(sgl))
 		for_each_sg(sgl, sg, nelems, i)
 			iommu_dma_sync_single_for_device(dev,
 							 sg_dma_address(sg),
@@ -998,7 +1027,8 @@ static dma_addr_t iommu_dma_map_page(str
 	 * If both the physical buffer start address and size are
 	 * page aligned, we don't need to use a bounce page.
 	 */
-	if (dev_use_swiotlb(dev) && iova_offset(iovad, phys | size)) {
+	if (dev_use_swiotlb(dev, size, dir) &&
+	    iova_offset(iovad, phys | size)) {
 		void *padding_start;
 		size_t padding_size, aligned_size;
 
@@ -1166,6 +1196,8 @@ static int iommu_dma_map_sg_swiotlb(stru
 	struct scatterlist *s;
 	int i;
 
+	sg_dma_mark_swiotlb(sg);
+
 	for_each_sg(sg, s, nents, i) {
 		sg_dma_address(s) = iommu_dma_map_page(dev, sg_page(s),
 				s->offset, s->length, dir, attrs);
@@ -1210,7 +1242,7 @@ static int iommu_dma_map_sg(struct devic
 			goto out;
 	}
 
-	if (dev_use_swiotlb(dev))
+	if (dev_use_sg_swiotlb(dev, sg, nents, dir))
 		return iommu_dma_map_sg_swiotlb(dev, sg, nents, dir, attrs);
 
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
@@ -1315,7 +1347,7 @@ static void iommu_dma_unmap_sg(struct de
 	struct scatterlist *tmp;
 	int i;
 
-	if (dev_use_swiotlb(dev)) {
+	if (sg_dma_is_swiotlb(sg)) {
 		iommu_dma_unmap_sg_swiotlb(dev, sg, nents, dir, attrs);
 		return;
 	}
--- a/drivers/iommu/Kconfig~iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned
+++ a/drivers/iommu/Kconfig
@@ -152,6 +152,7 @@ config IOMMU_DMA
 	select IOMMU_IOVA
 	select IRQ_MSI_IOMMU
 	select NEED_SG_DMA_LENGTH
+	select NEED_SG_DMA_FLAGS if SWIOTLB
 
 # Shared Virtual Addressing
 config IOMMU_SVA
--- a/include/linux/scatterlist.h~iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned
+++ a/include/linux/scatterlist.h
@@ -251,11 +251,13 @@ static inline void sg_unmark_end(struct
 /*
  * One 64-bit architectures there is a 4-byte padding in struct scatterlist
  * (assuming also CONFIG_NEED_SG_DMA_LENGTH is set). Use this padding for DMA
- * flags bits to indicate when a specific dma address is a bus address.
+ * flags bits to indicate when a specific dma address is a bus address or the
+ * buffer may have been bounced via SWIOTLB.
  */
 #ifdef CONFIG_NEED_SG_DMA_FLAGS
 
-#define SG_DMA_BUS_ADDRESS (1 << 0)
+#define SG_DMA_BUS_ADDRESS	(1 << 0)
+#define SG_DMA_SWIOTLB		(1 << 1)
 
 /**
  * sg_dma_is_bus_address - Return whether a given segment was marked
@@ -298,6 +300,34 @@ static inline void sg_dma_unmark_bus_add
 	sg->dma_flags &= ~SG_DMA_BUS_ADDRESS;
 }
 
+/**
+ * sg_dma_is_swiotlb - Return whether the scatterlist was marked for SWIOTLB
+ *			bouncing
+ * @sg:		SG entry
+ *
+ * Description:
+ *   Returns true if the scatterlist was marked for SWIOTLB bouncing. Not all
+ *   elements may have been bounced, so the caller would have to check
+ *   individual SG entries with is_swiotlb_buffer().
+ */
+static inline bool sg_dma_is_swiotlb(struct scatterlist *sg)
+{
+	return sg->dma_flags & SG_DMA_SWIOTLB;
+}
+
+/**
+ * sg_dma_mark_swiotlb - Mark the scatterlist for SWIOTLB bouncing
+ * @sg:		SG entry
+ *
+ * Description:
+ *   Marks a a scatterlist for SWIOTLB bounce. Not all SG entries may be
+ *   bounced.
+ */
+static inline void sg_dma_mark_swiotlb(struct scatterlist *sg)
+{
+	sg->dma_flags |= SG_DMA_SWIOTLB;
+}
+
 #else
 
 static inline bool sg_dma_is_bus_address(struct scatterlist *sg)
@@ -310,6 +340,13 @@ static inline void sg_dma_mark_bus_addre
 static inline void sg_dma_unmark_bus_address(struct scatterlist *sg)
 {
 }
+static inline bool sg_dma_is_swiotlb(struct scatterlist *sg)
+{
+	return false;
+}
+static inline void sg_dma_mark_swiotlb(struct scatterlist *sg)
+{
+}
 
 #endif	/* CONFIG_NEED_SG_DMA_FLAGS */
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


