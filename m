From: akpm@linux-foundation.org
Subject: - avr32-dma-mappingh.patch removed from -mm tree
Date: Thu, 15 Mar 2007 19:01:01 -0800
Message-ID: <200703160301.l2G311mb001079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50903 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXCPDB3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zambrano@broadcom.com, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: dma-mapping.h
has been removed from the -mm tree.  Its filename was
     avr32-dma-mappingh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avr32: dma-mapping.h
From: "Gary Zambrano" <zambrano@broadcom.com>

Added dma_sync_single_range_for_cpu/device to dma-mapping.h in asm-avr32 to
call dma_sync_single_for_cpu/device.  This patch enables b44 to compile on
systems with these cpus.  This patch was created with the assumption that
another method of dma_sync_single_range_for_cpu/device does not exist on these
architectures.

Signed-off by: Gary Zambrano <zambrano@broadcom.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/dma-mapping.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+)

diff -puN include/asm-avr32/dma-mapping.h~avr32-dma-mappingh include/asm-avr32/dma-mapping.h
--- a/include/asm-avr32/dma-mapping.h~avr32-dma-mappingh
+++ a/include/asm-avr32/dma-mapping.h
@@ -242,6 +242,24 @@ dma_unmap_sg(struct device *dev, struct 
 {
 
 }
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
+
 
 /**
  * dma_sync_single_for_cpu
_

Patches currently in -mm which might be from zambrano@broadcom.com are

origin.patch
arm-dma-mappingh.patch
avr32-dma-mappingh.patch
