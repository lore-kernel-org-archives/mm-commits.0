Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80445C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjFSXYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjFSXXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0A7E7E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C709360FE5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121D9C433C8;
        Mon, 19 Jun 2023 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216950;
        bh=uRGgBWawLW+jWLvjr8JBvmPDoDEY6cr1cJhR+CpRjOQ=;
        h=Date:To:From:Subject:From;
        b=X4ZRsrR1omckWp2Aiu56sOlAYo2WkVkXk1BdxrIwA+VQQXm3XMxDB+oxR7nuMIRY2
         tGo4iKeaEfsz8WTOmVLocR/XzCog+ekdzIgFKJjztMuhHa2w1gokG9WG9vMW4hpJUK
         2TJq5ldxw/go1MT5S7iuZIDC6eDe2Ta7g1k+MEEg=
Date:   Mon, 19 Jun 2023 16:22:29 -0700
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
Subject: [merged mm-stable] dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned.patch removed from -mm tree
Message-Id: <20230619232230.121D9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned
has been removed from the -mm tree.  Its filename was
     dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned
Date: Mon, 12 Jun 2023 16:31:58 +0100

For direct DMA, if the size is small enough to have originated from a
kmalloc() cache below ARCH_DMA_MINALIGN, check its alignment against
dma_get_cache_alignment() and bounce if necessary.  For larger sizes, it
is the responsibility of the DMA API caller to ensure proper alignment.

At this point, the kmalloc() caches are properly aligned but this will
change in a subsequent patch.

Architectures can opt in by selecting DMA_BOUNCE_UNALIGNED_KMALLOC.

Link: https://lkml.kernel.org/r/20230612153201.554742-15-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
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

 include/linux/dma-map-ops.h |   61 ++++++++++++++++++++++++++++++++++
 kernel/dma/Kconfig          |    4 ++
 kernel/dma/direct.h         |    3 +
 3 files changed, 67 insertions(+), 1 deletion(-)

--- a/include/linux/dma-map-ops.h~dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned
+++ a/include/linux/dma-map-ops.h
@@ -8,6 +8,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/pgtable.h>
+#include <linux/slab.h>
 
 struct cma;
 
@@ -277,6 +278,66 @@ static inline bool dev_is_dma_coherent(s
 }
 #endif /* CONFIG_ARCH_HAS_DMA_COHERENCE_H */
 
+/*
+ * Check whether potential kmalloc() buffers are safe for non-coherent DMA.
+ */
+static inline bool dma_kmalloc_safe(struct device *dev,
+				    enum dma_data_direction dir)
+{
+	/*
+	 * If DMA bouncing of kmalloc() buffers is disabled, the kmalloc()
+	 * caches have already been aligned to a DMA-safe size.
+	 */
+	if (!IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC))
+		return true;
+
+	/*
+	 * kmalloc() buffers are DMA-safe irrespective of size if the device
+	 * is coherent or the direction is DMA_TO_DEVICE (non-desctructive
+	 * cache maintenance and benign cache line evictions).
+	 */
+	if (dev_is_dma_coherent(dev) || dir == DMA_TO_DEVICE)
+		return true;
+
+	return false;
+}
+
+/*
+ * Check whether the given size, assuming it is for a kmalloc()'ed buffer, is
+ * sufficiently aligned for non-coherent DMA.
+ */
+static inline bool dma_kmalloc_size_aligned(size_t size)
+{
+	/*
+	 * Larger kmalloc() sizes are guaranteed to be aligned to
+	 * ARCH_DMA_MINALIGN.
+	 */
+	if (size >= 2 * ARCH_DMA_MINALIGN ||
+	    IS_ALIGNED(kmalloc_size_roundup(size), dma_get_cache_alignment()))
+		return true;
+
+	return false;
+}
+
+/*
+ * Check whether the given object size may have originated from a kmalloc()
+ * buffer with a slab alignment below the DMA-safe alignment and needs
+ * bouncing for non-coherent DMA. The pointer alignment is not considered and
+ * in-structure DMA-safe offsets are the responsibility of the caller. Such
+ * code should use the static ARCH_DMA_MINALIGN for compiler annotations.
+ *
+ * The heuristics can have false positives, bouncing unnecessarily, though the
+ * buffers would be small. False negatives are theoretically possible if, for
+ * example, multiple small kmalloc() buffers are coalesced into a larger
+ * buffer that passes the alignment check. There are no such known constructs
+ * in the kernel.
+ */
+static inline bool dma_kmalloc_needs_bounce(struct device *dev, size_t size,
+					    enum dma_data_direction dir)
+{
+	return !dma_kmalloc_safe(dev, dir) && !dma_kmalloc_size_aligned(size);
+}
+
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
--- a/kernel/dma/direct.h~dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned
+++ a/kernel/dma/direct.h
@@ -94,7 +94,8 @@ static inline dma_addr_t dma_direct_map_
 		return swiotlb_map(dev, phys, size, dir, attrs);
 	}
 
-	if (unlikely(!dma_capable(dev, dma_addr, size, true))) {
+	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
+	    dma_kmalloc_needs_bounce(dev, size, dir)) {
 		if (is_pci_p2pdma_page(page))
 			return DMA_MAPPING_ERROR;
 		if (is_swiotlb_active(dev))
--- a/kernel/dma/Kconfig~dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned
+++ a/kernel/dma/Kconfig
@@ -90,6 +90,10 @@ config SWIOTLB
 	bool
 	select NEED_DMA_MAP_STATE
 
+config DMA_BOUNCE_UNALIGNED_KMALLOC
+	bool
+	depends on SWIOTLB
+
 config DMA_RESTRICTED_POOL
 	bool "DMA Restricted Pool"
 	depends on OF && OF_RESERVED_MEM && SWIOTLB
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


