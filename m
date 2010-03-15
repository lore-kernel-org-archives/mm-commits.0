From: akpm@linux-foundation.org
Subject: [merged] documentation-fix-block-biodoctxt-dma-mapping-description.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:26 -0400
Message-ID: <201003150653.o2F6qxnP015964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Documentation: fix block/biodoc.txt dma mapping description
has been removed from the -mm tree.  Its filename was
     documentation-fix-block-biodoctxt-dma-mapping-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: fix block/biodoc.txt dma mapping description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- It looks incorrect to use blk_rq_map_sg with pci_map_page here about
  DMA mappings. dma_map_sg?

- better to use dma_map_page instead of pci_map_page.
  http://marc.info/?l=linux-kernel&m=126596737604808&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/biodoc.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/block/biodoc.txt~documentation-fix-block-biodoctxt-dma-mapping-description Documentation/block/biodoc.txt
--- a/Documentation/block/biodoc.txt~documentation-fix-block-biodoctxt-dma-mapping-description
+++ a/Documentation/block/biodoc.txt
@@ -1162,8 +1162,8 @@ where a driver received a request ala th
 
 As mentioned, there is no virtual mapping of a bio. For DMA, this is
 not a problem as the driver probably never will need a virtual mapping.
-Instead it needs a bus mapping (pci_map_page for a single segment or
-use blk_rq_map_sg for scatter gather) to be able to ship it to the driver. For
+Instead it needs a bus mapping (dma_map_page for a single segment or
+use dma_map_sg for scatter gather) to be able to ship it to the driver. For
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

