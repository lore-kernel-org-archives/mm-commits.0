From: akpm@linux-foundation.org
Subject: - dma-add-dma_map_attrs-interfaces.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:32 -0700
Message-ID: <200804300543.m3U5hWMC029326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760144AbYD3GMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akepner@sgi.com, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com, markn@au1.ibm.


The patch titled
     dma: add dma_*map*_attrs() interfaces
has been removed from the -mm tree.  Its filename was
     dma-add-dma_map_attrs-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma: add dma_*map*_attrs() interfaces
From: Arthur Kepner <akepner@sgi.com>

Introduce new interfaces, dma_*map*_attrs(), for passing architecture-specific
attributes when memory is mapped and unmapped for DMA.  Give the interfaces
default implementations which ignore attributes.  Also introduce the
dma_{set|get}_attr() interfaces for setting and retrieving individual
attributes.  Define one attribute, DMA_ATTR_WRITE_BARRIER, in anticipation of
its use by ia64/sn.  Select whether architectures implement arch-specific
versions of the dma_*map*_attrs() interfaces via HAVE_DMA_ATTRS in Kconfig.

[markn@au1.ibm.com: dma_{set,get}_attr() have to be static inline]
Signed-off-by: Arthur Kepner <akepner@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                |    3 +
 arch/ia64/Kconfig           |    1 
 include/linux/dma-attrs.h   |   74 ++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |   17 +++++++
 4 files changed, 95 insertions(+)

diff -puN arch/Kconfig~dma-add-dma_map_attrs-interfaces arch/Kconfig
--- a/arch/Kconfig~dma-add-dma_map_attrs-interfaces
+++ a/arch/Kconfig
@@ -36,3 +36,6 @@ config HAVE_KPROBES
 
 config HAVE_KRETPROBES
 	def_bool n
+
+config HAVE_DMA_ATTRS
+	def_bool n
diff -puN arch/ia64/Kconfig~dma-add-dma_map_attrs-interfaces arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~dma-add-dma_map_attrs-interfaces
+++ a/arch/ia64/Kconfig
@@ -19,6 +19,7 @@ config IA64
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_DMA_ATTRS
 	select HAVE_KVM
 	default y
 	help
diff -puN include/linux/dma-attrs.h~dma-add-dma_map_attrs-interfaces include/linux/dma-attrs.h
--- a/include/linux/dma-attrs.h~dma-add-dma_map_attrs-interfaces
+++ a/include/linux/dma-attrs.h
@@ -0,0 +1,74 @@
+#ifndef _DMA_ATTR_H
+#define _DMA_ATTR_H
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
+
+/**
+ * an enum dma_attr represents an attribute associated with a DMA
+ * mapping. The semantics of each attribute should be defined in
+ * Documentation/DMA-attributes.txt.
+ */
+enum dma_attr {
+	DMA_ATTR_WRITE_BARRIER,
+	DMA_ATTR_MAX,
+};
+
+#define __DMA_ATTRS_LONGS BITS_TO_LONGS(DMA_ATTR_MAX)
+
+/**
+ * struct dma_attrs - an opaque container for DMA attributes
+ * @flags - bitmask representing a collection of enum dma_attr
+ */
+struct dma_attrs {
+	unsigned long flags[__DMA_ATTRS_LONGS];
+};
+
+#define DEFINE_DMA_ATTRS(x) 					\
+	struct dma_attrs x = {					\
+		.flags = { [0 ... __DMA_ATTRS_LONGS-1] = 0 },	\
+	}
+
+static inline void init_dma_attrs(struct dma_attrs *attrs)
+{
+	bitmap_zero(attrs->flags, __DMA_ATTRS_LONGS);
+}
+
+#ifdef CONFIG_HAVE_DMA_ATTRS
+/**
+ * dma_set_attr - set a specific attribute
+ * @attr: attribute to set
+ * @attrs: struct dma_attrs (may be NULL)
+ */
+static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	if (attrs == NULL)
+		return;
+	BUG_ON(attr >= DMA_ATTR_MAX);
+	__set_bit(attr, attrs->flags);
+}
+
+/**
+ * dma_get_attr - check for a specific attribute
+ * @attr: attribute to set
+ * @attrs: struct dma_attrs (may be NULL)
+ */
+static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	if (attrs == NULL)
+		return 0;
+	BUG_ON(attr >= DMA_ATTR_MAX);
+	return test_bit(attr, attrs->flags);
+}
+#else /* !CONFIG_HAVE_DMA_ATTRS */
+static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+}
+
+static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_DMA_ATTRS */
+#endif /* _DMA_ATTR_H */
diff -puN include/linux/dma-mapping.h~dma-add-dma_map_attrs-interfaces include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-add-dma_map_attrs-interfaces
+++ a/include/linux/dma-mapping.h
@@ -146,4 +146,21 @@ static inline void dmam_release_declared
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef CONFIG_HAVE_DMA_ATTRS
+struct dma_attrs;
+
+#define dma_map_single_attrs(dev, cpu_addr, size, dir, attrs) \
+	dma_map_single(dev, cpu_addr, size, dir)
+
+#define dma_unmap_single_attrs(dev, dma_addr, size, dir, attrs) \
+	dma_unmap_single(dev, dma_addr, size, dir)
+
+#define dma_map_sg_attrs(dev, sgl, nents, dir, attrs) \
+	dma_map_sg(dev, sgl, nents, dir)
+
+#define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
+	dma_unmap_sg(dev, sgl, nents, dir)
+
+#endif /* CONFIG_HAVE_DMA_ATTRS */
+
 #endif
_

Patches currently in -mm which might be from akepner@sgi.com are

origin.patch

