From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-tidy-up-dma_parms-default-handling.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:47 -0800
Message-ID: <5640fe7b.p93K6yHAgQFRcz1/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbKIUNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: tidy up dma_parms default handling
has been removed from the -mm tree.  Its filename was
     dma-mapping-tidy-up-dma_parms-default-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Murphy <robin.murphy@arm.com>
Subject: dma-mapping: tidy up dma_parms default handling

Many DMA controllers and other devices set max_segment_size to
indicate their scatter-gather capability, but have no interest in
segment_boundary_mask. However, the existence of a dma_parms structure
precludes the use of any default value, leaving them as zeros (assuming
a properly kzalloc'ed structure). If a well-behaved IOMMU (or SWIOTLB)
then tries to respect this by ensuring a mapped segment does not cross
a zero-byte boundary, hilarity ensues.

Since zero is a nonsensical value for either parameter, treat it as an
indicator for "default", as might be expected. In the process, clean up
a bit by replacing the bare constants with slightly more meaningful
macros and removing the superfluous "else" statements.

[akpm@linux-foundation.org: dma-mapping.h needs sizes.h for SZ_64K]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling
+++ a/include/linux/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -145,7 +146,9 @@ static inline void arch_teardown_dma_ops
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
-	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+	if (dev->dma_parms && dev->dma_parms->max_segment_size)
+		return dev->dma_parms->max_segment_size;
+	return SZ_64K;
 }
 
 static inline unsigned int dma_set_max_seg_size(struct device *dev,
@@ -154,14 +157,15 @@ static inline unsigned int dma_set_max_s
 	if (dev->dma_parms) {
 		dev->dma_parms->max_segment_size = size;
 		return 0;
-	} else
-		return -EIO;
+	}
+	return -EIO;
 }
 
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
-	return dev->dma_parms ?
-		dev->dma_parms->segment_boundary_mask : 0xffffffff;
+	if (dev->dma_parms && dev->dma_parms->segment_boundary_mask)
+		return dev->dma_parms->segment_boundary_mask;
+	return DMA_BIT_MASK(32);
 }
 
 static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
@@ -169,8 +173,8 @@ static inline int dma_set_seg_boundary(s
 	if (dev->dma_parms) {
 		dev->dma_parms->segment_boundary_mask = mask;
 		return 0;
-	} else
-		return -EIO;
+	}
+	return -EIO;
 }
 
 #ifndef dma_max_pfn
_

Patches currently in -mm which might be from robin.murphy@arm.com are

dma-debug-allow-poisoning-nonzero-allocations.patch

