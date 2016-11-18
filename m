From: akpm@linux-foundation.org
Subject: +
 arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch added
 to -mm tree
Date: Fri, 18 Nov 2016 15:30:43 -0800
Message-ID: <582f8f23.WbXTtapy8vA06UvB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42476 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753969AbcKRXao (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/openrisc: add option to skip DMA sync as a part of mapping
has been added to the -mm tree.  Its filename is
     arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

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
Subject: arch/openrisc: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113524.76501.87966.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/dma.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/openrisc/kernel/dma.c~arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/openrisc/kernel/dma.c
--- a/arch/openrisc/kernel/dma.c~arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/openrisc/kernel/dma.c
@@ -141,6 +141,9 @@ or1k_map_page(struct device *dev, struct
 	unsigned long cl;
 	dma_addr_t addr = page_to_phys(page) + offset;
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return addr;
+
 	switch (dir) {
 	case DMA_TO_DEVICE:
 		/* Flush the dcache for the requested range */
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

