From: akpm@linux-foundation.org
Subject: [patch 029/114] dma: add calls for dma_map_page_attrs and
 dma_unmap_page_attrs
Date: Wed, 14 Dec 2016 15:05:23 -0800
Message-ID: <5851d033.Ohb1zGIjU9zVUUaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933546AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: dma: add calls for dma_map_page_attrs and dma_unmap_page_attrs

Add support for mapping and unmapping a page with attributes.  The primary
use for this is currently to allow for us to pass the
DMA_ATTR_SKIP_CPU_SYNC attribute when mapping and unmapping a page.  On
some architectures such as ARM the synchronization has significant
overhead and if we are already taking care of the sync_for_cpu and
sync_for_device from the driver there isn't much need to handle this in
the map/unmap calls as well.

Link: http://lkml.kernel.org/r/20161110113601.76501.46095.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs
+++ a/include/linux/dma-mapping.h
@@ -243,29 +243,33 @@ static inline void dma_unmap_sg_attrs(st
 		ops->unmap_sg(dev, sg, nents, dir, attrs);
 }
 
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      size_t offset, size_t size,
-				      enum dma_data_direction dir)
+static inline dma_addr_t dma_map_page_attrs(struct device *dev,
+					    struct page *page,
+					    size_t offset, size_t size,
+					    enum dma_data_direction dir,
+					    unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
 	BUG_ON(!valid_dma_direction(dir));
-	addr = ops->map_page(dev, page, offset, size, dir, 0);
+	addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
 
 	return addr;
 }
 
-static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, enum dma_data_direction dir)
+static inline void dma_unmap_page_attrs(struct device *dev,
+					dma_addr_t addr, size_t size,
+					enum dma_data_direction dir,
+					unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, dir, 0);
+		ops->unmap_page(dev, addr, size, dir, attrs);
 	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
 
@@ -385,6 +389,8 @@ dma_sync_sg_for_device(struct device *de
 #define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
 #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, 0)
+#define dma_map_page(d, p, o, s, r) dma_map_page_attrs(d, p, o, s, r, 0)
+#define dma_unmap_page(d, a, s, r) dma_unmap_page_attrs(d, a, s, r, 0)
 
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
_
