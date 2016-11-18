From: akpm@linux-foundation.org
Subject: + arch-blackfin-add-option-to-skip-sync-on-dma-map.patch added to -mm tree
Date: Fri, 18 Nov 2016 15:30:24 -0800
Message-ID: <582f8f10.OwarcondnSB8xkyp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbcKRXaZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, realmz6@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/blackfin: add option to skip sync on DMA map
has been added to the -mm tree.  Its filename is
     arch-blackfin-add-option-to-skip-sync-on-dma-map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-blackfin-add-option-to-skip-sync-on-dma-map.patch

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
Subject: arch/blackfin: add option to skip sync on DMA map

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113436.76501.13386.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/dma-mapping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/blackfin/kernel/dma-mapping.c~arch-blackfin-add-option-to-skip-sync-on-dma-map arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~arch-blackfin-add-option-to-skip-sync-on-dma-map
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -118,6 +118,10 @@ static int bfin_dma_map_sg(struct device
 
 	for_each_sg(sg_list, sg, nents, i) {
 		sg->dma_address = (dma_addr_t) sg_virt(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		__dma_sync(sg_dma_address(sg), sg_dma_len(sg), direction);
 	}
 
@@ -143,7 +147,9 @@ static dma_addr_t bfin_dma_map_page(stru
 {
 	dma_addr_t handle = (dma_addr_t)(page_address(page) + offset);
 
-	_dma_sync(handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		_dma_sync(handle, size, dir);
+
 	return handle;
 }
 
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

