From: akpm@linux-foundation.org
Subject: [merged] powerpc-use-for_each_sg.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:17 -0700
Message-ID: <5591ac41.4bqP6Sxu8AD0MvUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbbF2UgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     powerpc-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: powerpc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since powerpc does
select ARCH_HAS_SG_CHAIN, it is necessary to use for_each_sg() in order to
loop over each sg element.  This also help find problems with drivers that
do not properly initialize their sg tables when CONFIG_DEBUG_SG is
enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~powerpc-use-for_each_sg arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~powerpc-use-for_each_sg
+++ a/arch/powerpc/kernel/vio.c
@@ -557,11 +557,11 @@ static int vio_dma_iommu_map_sg(struct d
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
 	struct scatterlist *sgl;
-	int ret, count = 0;
+	int ret, count;
 	size_t alloc_size = 0;
 
 	tbl = get_iommu_table_base(dev);
-	for (sgl = sglist; count < nelems; count++, sgl++)
+	for_each_sg(sglist, sgl, nelems, count)
 		alloc_size += roundup(sgl->length, IOMMU_PAGE_SIZE(tbl));
 
 	if (vio_cmo_alloc(viodev, alloc_size)) {
@@ -577,7 +577,7 @@ static int vio_dma_iommu_map_sg(struct d
 		return ret;
 	}
 
-	for (sgl = sglist, count = 0; count < ret; count++, sgl++)
+	for_each_sg(sglist, sgl, ret, count)
 		alloc_size -= roundup(sgl->dma_length, IOMMU_PAGE_SIZE(tbl));
 	if (alloc_size)
 		vio_cmo_dealloc(viodev, alloc_size);
@@ -594,10 +594,10 @@ static void vio_dma_iommu_unmap_sg(struc
 	struct iommu_table *tbl;
 	struct scatterlist *sgl;
 	size_t alloc_size = 0;
-	int count = 0;
+	int count;
 
 	tbl = get_iommu_table_base(dev);
-	for (sgl = sglist; count < nelems; count++, sgl++)
+	for_each_sg(sglist, sgl, nelems, count)
 		alloc_size += roundup(sgl->dma_length, IOMMU_PAGE_SIZE(tbl));
 
 	dma_iommu_ops.unmap_sg(dev, sglist, nelems, direction, attrs);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

