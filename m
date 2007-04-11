From: akpm@linux-foundation.org
Subject: - git-md-accel-arm-fix.patch removed from -mm tree
Date: Wed, 11 Apr 2007 00:06:42 -0700
Message-ID: <200704110706.l3B76gKw031004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXDKHGq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 03:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-md-accel arm fix
has been removed from the -mm tree.  Its filename was
     git-md-accel-arm-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-md-accel arm fix
From: "Williams, Dan J" <dan.j.williams@intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/dma-mapping.h |   36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN include/asm-arm/dma-mapping.h~git-md-accel-arm-fix include/asm-arm/dma-mapping.h
--- a/include/asm-arm/dma-mapping.h~git-md-accel-arm-fix
+++ a/include/asm-arm/dma-mapping.h
@@ -311,24 +311,6 @@ extern void dma_unmap_sg(struct device *
 #endif
 
 #ifndef CONFIG_DMABOUNCE
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
-}
-
 /**
  * dma_sync_single_for_cpu
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -361,6 +343,24 @@ dma_sync_single_for_device(struct device
 	if (!arch_is_coherent())
 		consistent_sync((void *)dma_to_virt(dev, handle), size, dir);
 }
+
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
+}
 #else
 extern void dma_sync_single_range_for_cpu(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
 extern void dma_sync_single_range_for_device(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-md-accel.patch
git-md-accel-arm-fix.patch
git-ioat-vs-git-md-accel.patch
