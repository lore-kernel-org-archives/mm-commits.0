From: akpm@linux-foundation.org
Subject: [merged] arc-use-for_each_sg.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:18 -0700
Message-ID: <559adb46.t1qVLR/81WKIqCsk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbbGFTrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arc: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     arc-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: arc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since arc doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/dma-mapping.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/arc/include/asm/dma-mapping.h~arc-use-for_each_sg arch/arc/include/asm/dma-mapping.h
--- a/arch/arc/include/asm/dma-mapping.h~arc-use-for_each_sg
+++ a/arch/arc/include/asm/dma-mapping.h
@@ -157,22 +157,24 @@ dma_sync_single_range_for_device(struct
 }
 
 static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist, int nelems,
 		    enum dma_data_direction dir)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nelems; i++, sg++)
+	for_each_sg(sglist, sg, nelems, i)
 		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
 }
 
 static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		       enum dma_data_direction dir)
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
+		       int nelems, enum dma_data_direction dir)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nelems; i++, sg++)
+	for_each_sg(sglist, sg, nelems, i)
 		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are


