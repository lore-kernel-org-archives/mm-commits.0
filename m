From: akpm@linux-foundation.org
Subject: [patch 014/114] arch/c6x: add option to skip sync on DMA map and
 unmap
Date: Wed, 14 Dec 2016 15:04:41 -0800
Message-ID: <5851d009.96WiS8YNy9SBwc1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754088AbcLNXEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, msalter@redhat.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/c6x: add option to skip sync on DMA map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
later via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113442.76501.7673.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/kernel/dma.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN arch/c6x/kernel/dma.c~arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap
+++ a/arch/c6x/kernel/dma.c
@@ -42,14 +42,17 @@ static dma_addr_t c6x_dma_map_page(struc
 {
 	dma_addr_t handle = virt_to_phys(page_address(page) + offset);
 
-	c6x_dma_sync(handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		c6x_dma_sync(handle, size, dir);
+
 	return handle;
 }
 
 static void c6x_dma_unmap_page(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	c6x_dma_sync(handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		c6x_dma_sync(handle, size, dir);
 }
 
 static int c6x_dma_map_sg(struct device *dev, struct scatterlist *sglist,
@@ -60,7 +63,8 @@ static int c6x_dma_map_sg(struct device
 
 	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		c6x_dma_sync(sg->dma_address, sg->length, dir);
+		if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			c6x_dma_sync(sg->dma_address, sg->length, dir);
 	}
 
 	return nents;
@@ -72,9 +76,11 @@ static void c6x_dma_unmap_sg(struct devi
 	struct scatterlist *sg;
 	int i;
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	for_each_sg(sglist, sg, nents, i)
 		c6x_dma_sync(sg_dma_address(sg), sg->length, dir);
