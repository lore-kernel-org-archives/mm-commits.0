From: akpm@linux-foundation.org
Subject: [patch 011/114] arch/arm: add option to skip sync on DMA map and
 unmap
Date: Wed, 14 Dec 2016 15:04:32 -0800
Message-ID: <5851d000.7Oj4oNgEw8qPjKBR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754682AbcLNXEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, linux@armlinux.org.uk

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/arm: add option to skip sync on DMA map and unmap

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113424.76501.2715.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/dmabounce.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/arm/common/dmabounce.c~arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap arch/arm/common/dmabounce.c
--- a/arch/arm/common/dmabounce.c~arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap
+++ a/arch/arm/common/dmabounce.c
@@ -243,7 +243,8 @@ static int needs_bounce(struct device *d
 }
 
 static inline dma_addr_t map_single(struct device *dev, void *ptr, size_t size,
-		enum dma_data_direction dir)
+				    enum dma_data_direction dir,
+				    unsigned long attrs)
 {
 	struct dmabounce_device_info *device_info = dev->archdata.dmabounce;
 	struct safe_buffer *buf;
@@ -262,7 +263,8 @@ static inline dma_addr_t map_single(stru
 		__func__, buf->ptr, virt_to_dma(dev, buf->ptr),
 		buf->safe, buf->safe_dma_addr);
 
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL) {
+	if ((dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL) &&
+	    !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		dev_dbg(dev, "%s: copy unsafe %p to safe %p, size %d\n",
 			__func__, ptr, buf->safe, size);
 		memcpy(buf->safe, ptr, size);
@@ -272,7 +274,8 @@ static inline dma_addr_t map_single(stru
 }
 
 static inline void unmap_single(struct device *dev, struct safe_buffer *buf,
-		size_t size, enum dma_data_direction dir)
+				size_t size, enum dma_data_direction dir,
+				unsigned long attrs)
 {
 	BUG_ON(buf->size != size);
 	BUG_ON(buf->direction != dir);
@@ -283,7 +286,8 @@ static inline void unmap_single(struct d
 
 	DO_STATS(dev->archdata.dmabounce->bounce_count++);
 
-	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL) {
+	if ((dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL) &&
+	    !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		void *ptr = buf->ptr;
 
 		dev_dbg(dev, "%s: copy back safe %p to unsafe %p size %d\n",
@@ -334,7 +338,7 @@ static dma_addr_t dmabounce_map_page(str
 		return DMA_ERROR_CODE;
 	}
 
-	return map_single(dev, page_address(page) + offset, size, dir);
+	return map_single(dev, page_address(page) + offset, size, dir, attrs);
 }
 
 /*
@@ -357,7 +361,7 @@ static void dmabounce_unmap_page(struct
 		return;
 	}
 
-	unmap_single(dev, buf, size, dir);
+	unmap_single(dev, buf, size, dir, attrs);
 }
 
 static int __dmabounce_sync_for_cpu(struct device *dev, dma_addr_t addr,
_
