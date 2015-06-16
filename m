From: akpm@linux-foundation.org
Subject: [merged] mips-use-for_each_sg.patch removed from -mm tree
Date: Tue, 16 Jun 2015 12:00:36 -0700
Message-ID: <55807254.VvZHdBxJcYB7+agU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbbFPTAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 15:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     mips-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mips: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since mips doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/dma-default.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -puN arch/mips/mm/dma-default.c~mips-use-for_each_sg arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~mips-use-for_each_sg
+++ a/arch/mips/mm/dma-default.c
@@ -262,12 +262,13 @@ static void mips_dma_unmap_page(struct d
 	plat_unmap_dma_mem(dev, dma_addr, size, direction);
 }
 
-static int mips_dma_map_sg(struct device *dev, struct scatterlist *sg,
+static int mips_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; i++, sg++) {
+	for_each_sg(sglist, sg, nents, i) {
 		if (!plat_device_is_coherent(dev))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
@@ -291,13 +292,14 @@ static dma_addr_t mips_dma_map_page(stru
 	return plat_map_dma_mem_page(dev, page) + offset;
 }
 
-static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	int nhwentries, enum dma_data_direction direction,
 	struct dma_attrs *attrs)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nhwentries; i++, sg++) {
+	for_each_sg(sglist, sg, nhwentries, i) {
 		if (!plat_device_is_coherent(dev) &&
 		    direction != DMA_TO_DEVICE)
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
@@ -324,26 +326,34 @@ static void mips_dma_sync_single_for_dev
 }
 
 static void mips_dma_sync_sg_for_cpu(struct device *dev,
-	struct scatterlist *sg, int nelems, enum dma_data_direction direction)
+	struct scatterlist *sglist, int nelems,
+	enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	if (cpu_needs_post_dma_flush(dev))
-		for (i = 0; i < nelems; i++, sg++)
+	if (cpu_needs_post_dma_flush(dev)) {
+		for_each_sg(sglist, sg, nelems, i) {
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
+		}
+	}
 	plat_post_dma_flush(dev);
 }
 
 static void mips_dma_sync_sg_for_device(struct device *dev,
-	struct scatterlist *sg, int nelems, enum dma_data_direction direction)
+	struct scatterlist *sglist, int nelems,
+	enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	if (!plat_device_is_coherent(dev))
-		for (i = 0; i < nelems; i++, sg++)
+	if (!plat_device_is_coherent(dev)) {
+		for_each_sg(sglist, sg, nelems, i) {
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
+		}
+	}
 }
 
 int mips_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

metag-use-for_each_sg.patch
powerpc-use-for_each_sg.patch
parisc-use-for_each_sg.patch
sparc-use-for_each_sg.patch
xtensa-use-for_each_sg.patch
frv-use-for_each_sg.patch
avr32-use-for_each_sg.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

