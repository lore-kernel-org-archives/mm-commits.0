From: akpm@linux-foundation.org
Subject: + xtensa-use-for_each_sg.patch added to -mm tree
Date: Fri, 01 May 2015 14:40:18 -0700
Message-ID: <5543f2c2.hnTK2oy0tJ8Ighdu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbEAVkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 17:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, chris@zankel.net, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: use for_each_sg()
has been added to the -mm tree.  Its filename is
     xtensa-use-for_each_sg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-use-for_each_sg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-use-for_each_sg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: xtensa: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since xtensa doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~xtensa-use-for_each_sg arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~xtensa-use-for_each_sg
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -52,14 +52,15 @@ dma_unmap_single(struct device *dev, dma
 }
 
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
 	BUG_ON(direction == DMA_NONE);
 
-	for (i = 0; i < nents; i++, sg++ ) {
+	for_each_sg(sglist, sg, nents, i) {
 		BUG_ON(!sg_page(sg));
 
 		sg->dma_address = sg_phys(sg);
@@ -124,20 +125,24 @@ dma_sync_single_range_for_device(struct
 	consistent_sync((void *)bus_to_virt(dma_handle)+offset,size,direction);
 }
 static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist, int nelems,
 		 enum dma_data_direction dir)
 {
 	int i;
-	for (i = 0; i < nelems; i++, sg++)
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, nelems, i)
 		consistent_sync(sg_virt(sg), sg->length, dir);
 }
 
 static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		 enum dma_data_direction dir)
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
+		       int nelems, enum dma_data_direction dir)
 {
 	int i;
-	for (i = 0; i < nelems; i++, sg++)
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, nelems, i)
 		consistent_sync(sg_virt(sg), sg->length, dir);
 }
 static inline int
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch
m68k-use-for_each_sg.patch
arc-use-for_each_sg.patch
metag-use-for_each_sg.patch
xtensa-use-for_each_sg.patch
mips-use-for_each_sg.patch
frv-use-for_each_sg.patch
avr32-use-for_each_sg.patch
powerpc-use-for_each_sg.patch
sparc-use-for_each_sg.patch
parisc-use-for_each_sg.patch

