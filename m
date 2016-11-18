From: akpm@linux-foundation.org
Subject: + arch-avr32-add-option-to-skip-sync-on-dma-map.patch added to
 -mm tree
Date: Fri, 18 Nov 2016 15:30:22 -0800
Message-ID: <582f8f0e.ghaQik6JbtQTmqHd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbcKRXaX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, egtvedt@samfundet.no, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/avr32: add option to skip sync on DMA map
has been added to the -mm tree.  Its filename is
     arch-avr32-add-option-to-skip-sync-on-dma-map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-avr32-add-option-to-skip-sync-on-dma-map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-avr32-add-option-to-skip-sync-on-dma-map.patch

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
Subject: arch/avr32: add option to skip sync on DMA map

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113430.76501.79737.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/dma-coherent.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/avr32/mm/dma-coherent.c~arch-avr32-add-option-to-skip-sync-on-dma-map arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~arch-avr32-add-option-to-skip-sync-on-dma-map
+++ a/arch/avr32/mm/dma-coherent.c
@@ -146,7 +146,8 @@ static dma_addr_t avr32_dma_map_page(str
 {
 	void *cpu_addr = page_address(page) + offset;
 
-	dma_cache_sync(dev, cpu_addr, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_cache_sync(dev, cpu_addr, size, direction);
 	return virt_to_bus(cpu_addr);
 }
 
@@ -162,6 +163,10 @@ static int avr32_dma_map_sg(struct devic
 
 		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
 		virt = sg_virt(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		dma_cache_sync(dev, virt, sg->length, direction);
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

