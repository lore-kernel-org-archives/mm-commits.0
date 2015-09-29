From: akpm@linux-foundation.org
Subject: + dma-mapping-tidy-up-dma_parms-default-handling.patch added to
 -mm tree
Date: Tue, 29 Sep 2015 14:40:56 -0700
Message-ID: <560b0568.tRdmsxHAS2i5gbaR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbI2Vk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robin.murphy@arm.com, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: tidy up dma_parms default handling
has been added to the -mm tree.  Its filename is
     dma-mapping-tidy-up-dma_parms-default-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-tidy-up-dma_parms-default-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-tidy-up-dma_parms-default-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling
+++ a/include/linux/dma-mapping.h
@@ -145,7 +145,9 @@ static inline void arch_teardown_dma_ops
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
-	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;
+	if (dev->dma_parms && dev->dma_parms->max_segment_size)
+		return dev->dma_parms->max_segment_size;
+	return SZ_64K;
 }
 
 static inline unsigned int dma_set_max_seg_size(struct device *dev,
@@ -154,14 +156,15 @@ static inline unsigned int dma_set_max_s
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
@@ -169,8 +172,8 @@ static inline int dma_set_seg_boundary(s
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

dmapool-fix-overflow-condition-in-pool_find_page.patch
dma-mapping-tidy-up-dma_parms-default-handling.patch
dma-debug-check-nents-in-dma_sync_sg.patch
dma-debug-allow-poisoning-nonzero-allocations.patch

