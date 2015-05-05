From: akpm@linux-foundation.org
Subject: [merged] m68k-use-for_each_sg.patch removed from -mm tree
Date: Tue, 05 May 2015 11:24:21 -0700
Message-ID: <55490ad5.F6aM/VMg+fqEQUhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbbEESYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 14:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     m68k-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: m68k: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since m68k doesn't
select ARCH_HAS_SG_CHAIN, it is not necessary to use for_each_sg() in
order to loop over each sg element.  But this can help find problems with
drivers that do not properly initialize their sg tables when
CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/dma.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/m68k/kernel/dma.c~m68k-use-for_each_sg arch/m68k/kernel/dma.c
--- a/arch/m68k/kernel/dma.c~m68k-use-for_each_sg
+++ a/arch/m68k/kernel/dma.c
@@ -120,13 +120,16 @@ void dma_sync_single_for_device(struct d
 }
 EXPORT_SYMBOL(dma_sync_single_for_device);
 
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents,
-			    enum dma_data_direction dir)
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
+			    int nents, enum dma_data_direction dir)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; sg++, i++)
-		dma_sync_single_for_device(dev, sg->dma_address, sg->length, dir);
+	for_each_sg(sglist, sg, nents, i) {
+		dma_sync_single_for_device(dev, sg->dma_address, sg->length,
+					   dir);
+	}
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
 
@@ -151,14 +154,16 @@ dma_addr_t dma_map_page(struct device *d
 }
 EXPORT_SYMBOL(dma_map_page);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	       enum dma_data_direction dir)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; sg++, i++) {
+	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		dma_sync_single_for_device(dev, sg->dma_address, sg->length, dir);
+		dma_sync_single_for_device(dev, sg->dma_address, sg->length,
+					   dir);
 	}
 	return nents;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

metag-use-for_each_sg.patch
powerpc-use-for_each_sg.patch
mips-use-for_each_sg.patch
parisc-use-for_each_sg.patch
sparc-use-for_each_sg.patch
xtensa-use-for_each_sg.patch
frv-use-for_each_sg.patch
avr32-use-for_each_sg.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

