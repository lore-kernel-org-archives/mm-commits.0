From: akpm@linux-foundation.org
Subject: - arm-dma-mappingh.patch removed from -mm tree
Date: Wed, 11 Apr 2007 00:06:37 -0700
Message-ID: <200704110706.l3B76bAf031001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXDKHGq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 03:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zambrano@broadcom.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: dma-mapping.h
has been removed from the -mm tree.  Its filename was
     arm-dma-mappingh.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: arm: dma-mapping.h
From: "Gary Zambrano" <zambrano@broadcom.com>

Added dma_sync_single_range_for_cpu/device to dma-mapping.h in asm-arm to call
dma_sync_single_for_cpu/device.  This patch enables b44 to compile on systems
with these cpus.  This patch was created with the assumption that another
method of dma_sync_single_range_for_cpu/device does not exist on these
architectures.

Signed-off by: Gary Zambrano <zambrano@broadcom.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/dma-mapping.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN include/asm-arm/dma-mapping.h~arm-dma-mappingh include/asm-arm/dma-mapping.h
--- a/include/asm-arm/dma-mapping.h~arm-dma-mappingh
+++ a/include/asm-arm/dma-mapping.h
@@ -310,6 +310,24 @@ dma_unmap_sg(struct device *dev, struct 
 extern void dma_unmap_sg(struct device *, struct scatterlist *, int, enum dma_data_direction);
 #endif
 
+#ifndef CONFIG_DMABOUNCE
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
 
 /**
  * dma_sync_single_for_cpu
@@ -328,7 +346,6 @@ extern void dma_unmap_sg(struct device *
  * must first the perform a dma_sync_for_device, and then the
  * device again owns the buffer.
  */
-#ifndef CONFIG_DMABOUNCE
 static inline void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle, size_t size,
 			enum dma_data_direction dir)
@@ -345,6 +362,8 @@ dma_sync_single_for_device(struct device
 		consistent_sync((void *)dma_to_virt(dev, handle), size, dir);
 }
 #else
+extern void dma_sync_single_range_for_cpu(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
+extern void dma_sync_single_range_for_device(struct device*, dma_addr_t, unsigned long, size_t, enum dma_data_direction);
 extern void dma_sync_single_for_cpu(struct device*, dma_addr_t, size_t, enum dma_data_direction);
 extern void dma_sync_single_for_device(struct device*, dma_addr_t, size_t, enum dma_data_direction);
 #endif
_

Patches currently in -mm which might be from zambrano@broadcom.com are

arm-dma-mappingh.patch
git-avr32.patch
