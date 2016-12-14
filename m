From: akpm@linux-foundation.org
Subject: [patch 028/114] arch/xtensa: add option to skip DMA sync as a
 part of mapping
Date: Wed, 14 Dec 2016 15:05:21 -0800
Message-ID: <5851d031.MApxZbTXt9b7+RYt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933597AbcLNXF2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, jcmvbkbc@gmail.com

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
