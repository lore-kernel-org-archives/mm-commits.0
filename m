From: akpm@linux-foundation.org
Subject: [merged] dmaengine-mv_xor-use-offset_in_page-macro.patch
 removed from -mm tree
Date: Wed, 26 Apr 2017 14:45:07 -0700
Message-ID: <20170426214507.1wGcivG81%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031020AbdDZVpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 17:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, geliangtang@gmail.com, mm-commits@vger.kernel.org, vinod.koul@intel.com


The patch titled
     Subject: drivers/dma/mv_xor.c: use offset_in_page() macro
has been removed from the -mm tree.  Its filename was
     dmaengine-mv_xor-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: drivers/dma/mv_xor.c: use offset_in_page() macro

Use offset_in_page() macro instead of open-coding.

Link: http://lkml.kernel.org/r/517217f3a0e0c85f745054ad1f00d5de90ea9650.1492757182.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/mv_xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/mv_xor.c~dmaengine-mv_xor-use-offset_in_page-macro drivers/dma/mv_xor.c
--- a/drivers/dma/mv_xor.c~dmaengine-mv_xor-use-offset_in_page-macro
+++ a/drivers/dma/mv_xor.c
@@ -960,7 +960,7 @@ static int mv_chan_memcpy_self_test(stru
 	}
 
 	src_dma = dma_map_page(dma_chan->device->dev, virt_to_page(src),
-			       (size_t)src & ~PAGE_MASK, PAGE_SIZE,
+			       offset_in_page(src), PAGE_SIZE,
 			       DMA_TO_DEVICE);
 	unmap->addr[0] = src_dma;
 
@@ -972,7 +972,7 @@ static int mv_chan_memcpy_self_test(stru
 	unmap->to_cnt = 1;
 
 	dest_dma = dma_map_page(dma_chan->device->dev, virt_to_page(dest),
-				(size_t)dest & ~PAGE_MASK, PAGE_SIZE,
+				offset_in_page(dest), PAGE_SIZE,
 				DMA_FROM_DEVICE);
 	unmap->addr[1] = dest_dma;
 
_

Patches currently in -mm which might be from geliangtang@gmail.com are

fs-ocfs2-cluster-use-setup_timer.patch
fs-ocfs2-cluster-use-offset_in_page-macro.patch
writeback-use-setup_deferrable_timer.patch

