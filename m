From: akpm@linux-foundation.org
Subject: [patch 010/114] arch/arc: add option to skip sync on DMA mapping
Date: Wed, 14 Dec 2016 15:04:29 -0800
Message-ID: <5851cffd.bJJ/GFSJVb67a19C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754657AbcLNXEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, vgupta@synopsys.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/arc: add option to skip sync on DMA mapping

Patch series "Add support for DMA writable pages being writable by the
network stack", v3.

The first 19 patches in the set add support for the DMA attribute
DMA_ATTR_SKIP_CPU_SYNC on multiple platforms/architectures.  This is
needed so that we can flag the calls to dma_map/unmap_page so that we do
not invalidate cache lines that do not currently belong to the device. 
Instead we have to take care of this in the driver via a call to
sync_single_range_for_cpu prior to freeing the Rx page.

Patch 20 adds support for dma_map_page_attrs and dma_unmap_page_attrs so
that we can unmap and map a page using the DMA_ATTR_SKIP_CPU_SYNC
attribute.

Patch 21 adds support for freeing a page that has multiple references
being held by a single caller.  This way we can free page fragments that
were allocated by a given driver.

The last 2 patches use these updates in the igb driver, and lay the
groundwork to allow for us to reimplement the use of build_skb.



This patch (of 23):

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
later via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113419.76501.38491.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/dma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/arc/mm/dma.c~arch-arc-add-option-to-skip-sync-on-dma-mapping arch/arc/mm/dma.c
--- a/arch/arc/mm/dma.c~arch-arc-add-option-to-skip-sync-on-dma-mapping
+++ a/arch/arc/mm/dma.c
@@ -158,7 +158,10 @@ static dma_addr_t arc_dma_map_page(struc
 		unsigned long attrs)
 {
 	phys_addr_t paddr = page_to_phys(page) + offset;
-	_dma_cache_sync(paddr, size, dir);
+
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		_dma_cache_sync(paddr, size, dir);
+
 	return plat_phys_to_dma(dev, paddr);
 }
 
_
