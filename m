From: akpm@linux-foundation.org
Subject: + arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
 added to -mm tree
Date: Fri, 18 Nov 2016 15:30:20 -0800
Message-ID: <582f8f0c.fY1CXuB5TKv/FDJJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753596AbcKRXaV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm: add option to skip sync on DMA map and unmap
has been added to the -mm tree.  Its filename is
     arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch

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

