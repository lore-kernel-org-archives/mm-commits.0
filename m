From: akpm@linux-foundation.org
Subject: +
 dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch added
 to -mm tree
Date: Fri, 18 Nov 2016 15:30:57 -0800
Message-ID: <582f8f31.1EROdP1mAvVxJhQ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753752AbcKRXa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma: add calls for dma_map_page_attrs and dma_unmap_page_attrs
has been added to the -mm tree.  Its filename is
     dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch

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

