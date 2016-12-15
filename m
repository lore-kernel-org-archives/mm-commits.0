From: akpm@linux-foundation.org
Subject: [merged]
 arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:45:57 -0800
Message-ID: <5852e4e5.2WU7zpvbcHKD2Lk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754555AbcLOSqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/xtensa: add option to skip DMA sync as a part of mapping
has been removed from the -mm tree.  Its filename was
     arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/xtensa: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113555.76501.52536.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/pci-dma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/xtensa/kernel/pci-dma.c~arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/xtensa/kernel/pci-dma.c
--- a/arch/xtensa/kernel/pci-dma.c~arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/xtensa/kernel/pci-dma.c
@@ -189,7 +189,9 @@ static dma_addr_t xtensa_map_page(struct
 {
 	dma_addr_t dma_handle = page_to_phys(page) + offset;
 
-	xtensa_sync_single_for_device(dev, dma_handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		xtensa_sync_single_for_device(dev, dma_handle, size, dir);
+
 	return dma_handle;
 }
 
@@ -197,7 +199,8 @@ static void xtensa_unmap_page(struct dev
 			      size_t size, enum dma_data_direction dir,
 			      unsigned long attrs)
 {
-	xtensa_sync_single_for_cpu(dev, dma_handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		xtensa_sync_single_for_cpu(dev, dma_handle, size, dir);
 }
 
 static int xtensa_map_sg(struct device *dev, struct scatterlist *sg,
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


