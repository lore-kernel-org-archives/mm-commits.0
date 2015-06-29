From: akpm@linux-foundation.org
Subject: [merged] frv-use-for_each_sg.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:45 -0700
Message-ID: <5591aeb5.SH5oJi+tHQ7Ydh/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbbF2Uqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     frv-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: frv: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since frv doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-dma-nommu.c |   10 ++++++----
 arch/frv/mb93090-mb00/pci-dma.c       |    7 ++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-use-for_each_sg arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-use-for_each_sg
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -119,14 +119,16 @@ dma_addr_t dma_map_single(struct device
 
 EXPORT_SYMBOL(dma_map_single);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	       enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i=0; i<nents; i++)
-		frv_cache_wback_inv(sg_dma_address(&sg[i]),
-				    sg_dma_address(&sg[i]) + sg_dma_len(&sg[i]));
+	for_each_sg(sglist, sg, nents, i) {
+		frv_cache_wback_inv(sg_dma_address(sg),
+				    sg_dma_address(sg) + sg_dma_len(sg));
+	}
 
 	BUG_ON(direction == DMA_NONE);
 
diff -puN arch/frv/mb93090-mb00/pci-dma.c~frv-use-for_each_sg arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~frv-use-for_each_sg
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -50,19 +50,20 @@ dma_addr_t dma_map_single(struct device
 
 EXPORT_SYMBOL(dma_map_single);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	       enum dma_data_direction direction)
 {
 	unsigned long dampr2;
 	void *vaddr;
 	int i;
+	struct scatterlist *sg;
 
 	BUG_ON(direction == DMA_NONE);
 
 	dampr2 = __get_DAMPR(2);
 
-	for (i = 0; i < nents; i++) {
-		vaddr = kmap_atomic_primary(sg_page(&sg[i]));
+	for_each_sg(sglist, sg, nents, i) {
+		vaddr = kmap_atomic_primary(sg_page(sg));
 
 		frv_dcache_writeback((unsigned long) vaddr,
 				     (unsigned long) vaddr + PAGE_SIZE);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

