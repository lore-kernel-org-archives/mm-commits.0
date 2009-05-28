From: akpm@linux-foundation.org
Subject: + dma-mapping-add-asm-generic-dma-mapping-commonh.patch added to -mm tree
Date: Thu, 28 May 2009 00:20:36 -0700
Message-ID: <200905280720.n4S7KajR008369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219AbZE1HUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com


The patch titled
     dma-mapping: add asm-generic/dma-mapping-common.h
has been added to the -mm tree.  Its filename is
     dma-mapping-add-asm-generic-dma-mapping-commonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc; "David S. Miller" <davem@davemloft.net>
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

linux-next.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

