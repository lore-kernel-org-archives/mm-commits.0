From: akpm@linux-foundation.org
Subject: [merged] parisc-use-for_each_sg.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:57 -0700
Message-ID: <5591ac69.sa+uIUedz4Qq4FhB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2Ug6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     parisc-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: parisc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since parisc doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~parisc-use-for_each_sg arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~parisc-use-for_each_sg
+++ a/arch/parisc/kernel/pci-dma.c
@@ -478,14 +478,16 @@ static void pa11_dma_unmap_single(struct
 static int pa11_dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents, enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
 	BUG_ON(direction == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sglist++ ) {
-		unsigned long vaddr = (unsigned long)sg_virt(sglist);
-		sg_dma_address(sglist) = (dma_addr_t) virt_to_phys(vaddr);
-		sg_dma_len(sglist) = sglist->length;
-		flush_kernel_dcache_range(vaddr, sglist->length);
+	for_each_sg(sglist, sg, nents, i) {
+		unsigned long vaddr = (unsigned long)sg_virt(sg);
+
+		sg_dma_address(sg) = (dma_addr_t) virt_to_phys(vaddr);
+		sg_dma_len(sg) = sg->length;
+		flush_kernel_dcache_range(vaddr, sg->length);
 	}
 	return nents;
 }
@@ -493,6 +495,7 @@ static int pa11_dma_map_sg(struct device
 static void pa11_dma_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents, enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -501,8 +504,8 @@ static void pa11_dma_unmap_sg(struct dev
 
 	/* once we do combining we'll need to use phys_to_virt(sg_dma_address(sglist)) */
 
-	for (i = 0; i < nents; i++, sglist++ )
-		flush_kernel_vmap_range(sg_virt(sglist), sglist->length);
+	for_each_sg(sglist, sg, nents, i)
+		flush_kernel_vmap_range(sg_virt(sg), sg->length);
 	return;
 }
 
@@ -523,21 +526,23 @@ static void pa11_dma_sync_single_for_dev
 static void pa11_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist, int nents, enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
 	/* once we do combining we'll need to use phys_to_virt(sg_dma_address(sglist)) */
 
-	for (i = 0; i < nents; i++, sglist++ )
-		flush_kernel_vmap_range(sg_virt(sglist), sglist->length);
+	for_each_sg(sglist, sg, nents, i)
+		flush_kernel_vmap_range(sg_virt(sg), sg->length);
 }
 
 static void pa11_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist, int nents, enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
 	/* once we do combining we'll need to use phys_to_virt(sg_dma_address(sglist)) */
 
-	for (i = 0; i < nents; i++, sglist++ )
-		flush_kernel_vmap_range(sg_virt(sglist), sglist->length);
+	for_each_sg(sglist, sg, nents, i)
+		flush_kernel_vmap_range(sg_virt(sg), sg->length);
 }
 
 struct hppa_dma_ops pcxl_dma_ops = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

