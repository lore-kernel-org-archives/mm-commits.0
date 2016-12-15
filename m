From: akpm@linux-foundation.org
Subject: [merged] arch-frv-add-option-to-skip-sync-on-dma-map.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:30 -0800
Message-ID: <5852e4ca.Tv2JNb1oiFknV2EW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcLOSpb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv: add option to skip sync on DMA map
has been removed from the -mm tree.  Its filename was
     arch-frv-add-option-to-skip-sync-on-dma-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/frv: add option to skip sync on DMA map

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113447.76501.93160.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-dma-nommu.c |   14 ++++++++++----
 arch/frv/mb93090-mb00/pci-dma.c       |    9 +++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~arch-frv-add-option-to-skip-sync-on-dma-map arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~arch-frv-add-option-to-skip-sync-on-dma-map
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -109,16 +109,19 @@ static int frv_dma_map_sg(struct device
 		int nents, enum dma_data_direction direction,
 		unsigned long attrs)
 {
-	int i;
 	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(direction == DMA_NONE);
+
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return nents;
 
 	for_each_sg(sglist, sg, nents, i) {
 		frv_cache_wback_inv(sg_dma_address(sg),
 				    sg_dma_address(sg) + sg_dma_len(sg));
 	}
 
-	BUG_ON(direction == DMA_NONE);
-
 	return nents;
 }
 
@@ -127,7 +130,10 @@ static dma_addr_t frv_dma_map_page(struc
 		enum dma_data_direction direction, unsigned long attrs)
 {
 	BUG_ON(direction == DMA_NONE);
-	flush_dcache_page(page);
+
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		flush_dcache_page(page);
+
 	return (dma_addr_t) page_to_phys(page) + offset;
 }
 
diff -puN arch/frv/mb93090-mb00/pci-dma.c~arch-frv-add-option-to-skip-sync-on-dma-map arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~arch-frv-add-option-to-skip-sync-on-dma-map
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -40,13 +40,16 @@ static int frv_dma_map_sg(struct device
 		int nents, enum dma_data_direction direction,
 		unsigned long attrs)
 {
+	struct scatterlist *sg;
 	unsigned long dampr2;
 	void *vaddr;
 	int i;
-	struct scatterlist *sg;
 
 	BUG_ON(direction == DMA_NONE);
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return nents;
+
 	dampr2 = __get_DAMPR(2);
 
 	for_each_sg(sglist, sg, nents, i) {
@@ -70,7 +73,9 @@ static dma_addr_t frv_dma_map_page(struc
 		unsigned long offset, size_t size,
 		enum dma_data_direction direction, unsigned long attrs)
 {
-	flush_dcache_page(page);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		flush_dcache_page(page);
+
 	return (dma_addr_t) page_to_phys(page) + offset;
 }
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


