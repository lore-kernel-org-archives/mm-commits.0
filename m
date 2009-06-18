From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-add-asm-generic-dma-mapping-commonh.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:12 -0700
Message-ID: <200906182248.n5IMmC6w007321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759224AbZFRW6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, catalin.marinas@arm.com, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel


The patch titled
     dma-mapping: add asm-generic/dma-mapping-common.h
has been removed from the -mm tree.  Its filename was
     dma-mapping-add-asm-generic-dma-mapping-commonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: add asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

We unified x86 and IA64's handling of multiple dma mapping operations
(struct dma_map_ops in linux/dma-mapping.h) so we can remove duplication
in their arch/include/asm/dma-mapping.h.

This patchset adds include/asm-generic/dma-mapping-common.h that provides
some generic dma mapping function definitions for the users of struct
dma_map_ops.  This enables us to remove about 100 lines.  This also
enables us to easily add CONFIG_DMA_API_DEBUG support, which only x86
supports for now.  The 4th patch adds CONFIG_DMA_API_DEBUG support to IA64
by adding only 8 lines.


This patch:

This header file provides some mapping function definitions that the users
of struct dma_map_ops can use.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |  190 +++++++++++++++++++++
 1 file changed, 190 insertions(+)

diff -puN /dev/null include/asm-generic/dma-mapping-common.h
--- /dev/null
+++ a/include/asm-generic/dma-mapping-common.h
@@ -0,0 +1,190 @@
+#ifndef _ASM_GENERIC_DMA_MAPPING_H
+#define _ASM_GENERIC_DMA_MAPPING_H
+
+#include <linux/kmemcheck.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
+#include <linux/dma-attrs.h>
+
+static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
+					      size_t size,
+					      enum dma_data_direction dir,
+					      struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	dma_addr_t addr;
+
+	kmemcheck_mark_initialized(ptr, size);
+	BUG_ON(!valid_dma_direction(dir));
+	addr = ops->map_page(dev, virt_to_page(ptr),
+			     (unsigned long)ptr & ~PAGE_MASK, size,
+			     dir, attrs);
+	debug_dma_map_page(dev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   dir, addr, true);
+	return addr;
+}
+
+static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
+					  size_t size,
+					  enum dma_data_direction dir,
+					  struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->unmap_page)
+		ops->unmap_page(dev, addr, size, dir, attrs);
+	debug_dma_unmap_page(dev, addr, size, dir, true);
+}
+
+static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
+				   int nents, enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	int i, ents;
+	struct scatterlist *s;
+
+	for_each_sg(sg, s, nents, i)
+		kmemcheck_mark_initialized(sg_virt(s), s->length);
+	BUG_ON(!valid_dma_direction(dir));
+	ents = ops->map_sg(dev, sg, nents, dir, attrs);
+	debug_dma_map_sg(dev, sg, nents, ents, dir);
+
+	return ents;
+}
+
+static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg,
+				      int nents, enum dma_data_direction dir,
+				      struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	debug_dma_unmap_sg(dev, sg, nents, dir);
+	if (ops->unmap_sg)
+		ops->unmap_sg(dev, sg, nents, dir, attrs);
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	dma_addr_t addr;
+
+	kmemcheck_mark_initialized(page_address(page) + offset, size);
+	BUG_ON(!valid_dma_direction(dir));
+	addr = ops->map_page(dev, page, offset, size, dir, NULL);
+	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
+
+	return addr;
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
+				  size_t size, enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->unmap_page)
+		ops->unmap_page(dev, addr, size, dir, NULL);
+	debug_dma_unmap_page(dev, addr, size, dir, false);
+}
+
+static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
+					   size_t size,
+					   enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(dev, addr, size, dir);
+	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
+	flush_write_buffers();
+}
+
+static inline void dma_sync_single_for_device(struct device *dev,
+					      dma_addr_t addr, size_t size,
+					      enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(dev, addr, size, dir);
+	debug_dma_sync_single_for_device(dev, addr, size, dir);
+	flush_write_buffers();
+}
+
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+						 dma_addr_t addr,
+						 unsigned long offset,
+						 size_t size,
+						 enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_range_for_cpu) {
+		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
+		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
+
+		flush_write_buffers();
+	} else
+		dma_sync_single_for_cpu(dev, addr, size, dir);
+}
+
+static inline void dma_sync_single_range_for_device(struct device *dev,
+						    dma_addr_t addr,
+						    unsigned long offset,
+						    size_t size,
+						    enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_range_for_device) {
+		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
+		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
+
+		flush_write_buffers();
+	} else
+		dma_sync_single_for_device(dev, addr, size, dir);
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+		    int nelems, enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_sg_for_cpu)
+		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
+	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
+	flush_write_buffers();
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+		       int nelems, enum dma_data_direction dir)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_sg_for_device)
+		ops->sync_sg_for_device(dev, sg, nelems, dir);
+	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
+
+	flush_write_buffers();
+}
+
+#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
+#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
+#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
+#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
+
+#endif
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

