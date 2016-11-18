From: akpm@linux-foundation.org
Subject: +
 arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 15:30:41 -0800
Message-ID: <582f8f21.QUO+sRrZ4yy3lDos%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753969AbcKRXam (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, lftan@altera.com, tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/nios2: add option to skip DMA sync as a part of map and unmap
has been added to the -mm tree.  Its filename is
     arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/nios2: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113518.76501.52225.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/mm/dma-mapping.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN arch/nios2/mm/dma-mapping.c~arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/nios2/mm/dma-mapping.c
--- a/arch/nios2/mm/dma-mapping.c~arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/nios2/mm/dma-mapping.c
@@ -98,13 +98,17 @@ static int nios2_dma_map_sg(struct devic
 	int i;
 
 	for_each_sg(sg, sg, nents, i) {
-		void *addr;
+		void *addr = sg_virt(sg);
 
-		addr = sg_virt(sg);
-		if (addr) {
-			__dma_sync_for_device(addr, sg->length, direction);
-			sg->dma_address = sg_phys(sg);
-		}
+		if (!addr)
+			continue;
+
+		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
+		__dma_sync_for_device(addr, sg->length, direction);
 	}
 
 	return nents;
@@ -117,7 +121,9 @@ static dma_addr_t nios2_dma_map_page(str
 {
 	void *addr = page_address(page) + offset;
 
-	__dma_sync_for_device(addr, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync_for_device(addr, size, direction);
+
 	return page_to_phys(page) + offset;
 }
 
@@ -125,7 +131,8 @@ static void nios2_dma_unmap_page(struct
 		size_t size, enum dma_data_direction direction,
 		unsigned long attrs)
 {
-	__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
 static void nios2_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
@@ -138,6 +145,9 @@ static void nios2_dma_unmap_sg(struct de
 	if (direction == DMA_TO_DEVICE)
 		return;
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	for_each_sg(sg, sg, nhwentries, i) {
 		addr = sg_virt(sg);
 		if (addr)
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

arch-arc-add-option-to-skip-sync-on-dma-mapping.patch
arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-avr32-add-option-to-skip-sync-on-dma-map.patch
arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-frv-add-option-to-skip-sync-on-dma-map.patch
arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch
mm-add-support-for-releasing-multiple-instances-of-a-page.patch
igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
igb-update-code-to-better-handle-incrementing-page-count.patch

