From: akpm@linux-foundation.org
Subject: + avr32-use-for_each_sg.patch added to -mm tree
Date: Fri, 01 May 2015 14:40:24 -0700
Message-ID: <5543f2c8.UxKtyEwMEV6b8nXl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbEAVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 17:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: use for_each_sg()
has been added to the -mm tree.  Its filename is
     avr32-use-for_each_sg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/avr32-use-for_each_sg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/avr32-use-for_each_sg.patch

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
Subject: avr32: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since avr32 doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/dma-mapping.h |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/avr32/include/asm/dma-mapping.h~avr32-use-for_each_sg arch/avr32/include/asm/dma-mapping.h
--- a/arch/avr32/include/asm/dma-mapping.h~avr32-use-for_each_sg
+++ a/arch/avr32/include/asm/dma-mapping.h
@@ -209,17 +209,18 @@ dma_unmap_page(struct device *dev, dma_a
  * the same here.
  */
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; i++) {
+	for_each_sg(sglist, sg, nents, i) {
 		char *virt;
 
-		sg[i].dma_address = page_to_bus(sg_page(&sg[i])) + sg[i].offset;
-		virt = sg_virt(&sg[i]);
-		dma_cache_sync(dev, virt, sg[i].length, direction);
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
+		virt = sg_virt(sg);
+		dma_cache_sync(dev, virt, sg->length, direction);
 	}
 
 	return nents;
@@ -321,14 +322,14 @@ dma_sync_sg_for_cpu(struct device *dev,
 }
 
 static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
 		       int nents, enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; i++) {
-		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, direction);
-	}
+	for_each_sg(sglist, sg, nents, i)
+		dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
 }
 
 /* Now for the API extensions over the pci_ one */
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

