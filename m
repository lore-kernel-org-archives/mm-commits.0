From: akpm@linux-foundation.org
Subject: [patch 006/123] m32r: add simple dma
Date: Mon, 12 Dec 2016 16:40:54 -0800
Message-ID: <584f4396.1y8JGsIfwovvluwc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbcLMAkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: add simple dma

Some builds of m32r were failing as it tried to build few drivers which
needed dma but m32r is not having dma support.  Objections were raised
when it was tried to make those drivers depend on HAS_DMA.  So the next
best thing is to add dma support to m32r.  dma_noop is a very simple dma
with 1:1 memory mapping.

Link: http://lkml.kernel.org/r/1475949198-31623-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig                   |    2 -
 arch/m32r/include/asm/device.h      |    6 ++++
 arch/m32r/include/asm/dma-mapping.h |   32 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff -puN arch/m32r/Kconfig~m32r-add-simple-dma arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-add-simple-dma
+++ a/arch/m32r/Kconfig
@@ -34,7 +34,7 @@ config NO_IOPORT_MAP
 	def_bool y
 
 config NO_DMA
-	def_bool y
+	def_bool n
 
 config HZ
 	int
diff -puN arch/m32r/include/asm/device.h~m32r-add-simple-dma arch/m32r/include/asm/device.h
--- a/arch/m32r/include/asm/device.h~m32r-add-simple-dma
+++ a/arch/m32r/include/asm/device.h
@@ -3,5 +3,9 @@
  *
  * This file is released under the GPLv2
  */
-#include <asm-generic/device.h>
+struct dev_archdata {
+	struct dma_map_ops *dma_ops;
+};
 
+struct pdev_archdata {
+};
diff -puN /dev/null arch/m32r/include/asm/dma-mapping.h
--- /dev/null
+++ a/arch/m32r/include/asm/dma-mapping.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_M32R_DMA_MAPPING_H
+#define _ASM_M32R_DMA_MAPPING_H
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
+#include <linux/io.h>
+
+#define DMA_ERROR_CODE (~(dma_addr_t)0x0)
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (dev && dev->archdata.dma_ops)
+		return dev->archdata.dma_ops;
+	return &dma_noop_ops;
+}
+
+static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+				  enum dma_data_direction direction)
+{
+}
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return false;
+	return addr + size - 1 <= *dev->dma_mask;
+}
+
+#endif /* _ASM_M32R_DMA_MAPPING_H */
_
