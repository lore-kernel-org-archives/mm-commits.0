From: akpm@linux-foundation.org
Subject: - dma-mapping-prevent-dma-dependent-code-from-linking-on.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:23 -0700
Message-ID: <200707162055.l6GKtNgd001909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759113AbXGPViu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, James.Bottomley@SteelEye.com, cornelia.huck@de.ibm.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, htejun@gmail.com, jeff@garzik.org, kyle@parisc-linux.org, linville@tuxdriver.com, schwidefsky@de.ibm.com, spyro@f2s.com, ysato@users.sourceforge.jp, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: prevent dma dependent code from linking on !HAS_DMA archs
has been removed from the -mm tree.  Its filename was
     dma-mapping-prevent-dma-dependent-code-from-linking-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma-mapping: prevent dma dependent code from linking on !HAS_DMA archs
From: Dan Williams <dan.j.williams@intel.com>

Continuing the work started in 411f0f3edc141a582190d3605cadd1d993abb6df ...

This enables code with a dma path, that compiles away, to build without
requiring additional code factoring.  It also prevents code that calls
dma_alloc_coherent and dma_free_coherent from linking whereas previously
the code would hit a BUG() at run time.  Finally, it allows archs that set
!HAS_DMA to delete their asm/dma-mapping.h file.

Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <geert@linux-m68k.org>
Cc: <zippel@linux-m68k.org>
Cc: <spyro@f2s.com>
Cc: <ysato@users.sourceforge.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/Kconfig                       |    3 
 arch/h8300/Kconfig                       |    3 
 arch/m32r/Kconfig                        |    3 
 drivers/dma/Kconfig                      |    2 
 include/asm-arm26/dma-mapping.h          |    2 
 include/asm-generic/dma-mapping-broken.h |   82 +++++++++++++++++----
 include/asm-h8300/dma-mapping.h          |    1 
 include/asm-m32r/dma-mapping.h           |    6 -
 include/asm-s390/dma-mapping.h           |   12 ---
 include/linux/dma-mapping.h              |    4 +
 10 files changed, 84 insertions(+), 34 deletions(-)

diff -puN arch/arm26/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/arch/arm26/Kconfig
@@ -17,6 +17,9 @@ config MMU
 	bool
 	default y
 
+config NO_DMA
+	def_bool y
+
 config ARCH_ACORN
         bool
         default y
diff -puN arch/h8300/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/arch/h8300/Kconfig
@@ -68,6 +68,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 config ISA
 	bool
 	default y
diff -puN arch/m32r/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/arch/m32r/Kconfig
@@ -31,6 +31,9 @@ config GENERIC_IRQ_PROBE
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN drivers/dma/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/drivers/dma/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "DMA Engine support"
-	depends on !S390
+	depends on HAS_DMA
 
 config DMA_ENGINE
 	bool "Support for DMA engines"
diff -puN include/asm-arm26/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on /dev/null
--- a/include/asm-arm26/dma-mapping.h
+++ /dev/null
@@ -1,2 +0,0 @@
-#include <asm-generic/dma-mapping-broken.h>
-
diff -puN include/asm-generic/dma-mapping-broken.h~dma-mapping-prevent-dma-dependent-code-from-linking-on include/asm-generic/dma-mapping-broken.h
--- a/include/asm-generic/dma-mapping-broken.h~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/include/asm-generic/dma-mapping-broken.h
@@ -1,24 +1,82 @@
 #ifndef _ASM_GENERIC_DMA_MAPPING_H
 #define _ASM_GENERIC_DMA_MAPPING_H
 
-/* This is used for archs that do not support DMA */
+/* define the dma api to allow compilation but not linking of
+ * dma dependent code.  Code that depends on the dma-mapping
+ * API needs to set 'depends on HAS_DMA' in its Kconfig
+ */
 
-static inline void *
+struct scatterlist;
+
+extern void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	BUG();
-	return NULL;
-}
+		   gfp_t flag);
 
-static inline void
+extern void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_handle)
-{
-	BUG();
-}
+		    dma_addr_t dma_handle);
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
+extern dma_addr_t
+dma_map_single(struct device *dev, void *ptr, size_t size,
+	       enum dma_data_direction direction);
+
+extern void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		 enum dma_data_direction direction);
+
+extern int
+dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	   enum dma_data_direction direction);
+
+extern void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction);
+
+extern dma_addr_t
+dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+	     size_t size, enum dma_data_direction direction);
+
+extern void
+dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+	       enum dma_data_direction direction);
+
+extern void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction);
+
+extern void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction);
+
+extern void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction);
+
+#define dma_sync_single_for_device dma_sync_single_for_cpu
+#define dma_sync_single_range_for_device dma_sync_single_range_for_cpu
+#define dma_sync_sg_for_device dma_sync_sg_for_cpu
+
+extern int
+dma_mapping_error(dma_addr_t dma_addr);
+
+extern int
+dma_supported(struct device *dev, u64 mask);
+
+extern int
+dma_set_mask(struct device *dev, u64 mask);
+
+extern int
+dma_get_cache_alignment(void);
+
+extern int
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
+
+extern void
+dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+	       enum dma_data_direction direction);
+
 #endif /* _ASM_GENERIC_DMA_MAPPING_H */
diff -puN include/asm-h8300/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on /dev/null
--- a/include/asm-h8300/dma-mapping.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/dma-mapping-broken.h>
diff -puN include/asm-m32r/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on /dev/null
--- a/include/asm-m32r/dma-mapping.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_DMA_MAPPING_H
-#define _ASM_M32R_DMA_MAPPING_H
-
-#include <asm-generic/dma-mapping-broken.h>
-
-#endif /* _ASM_M32R_DMA_MAPPING_H */
diff -puN include/asm-s390/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on /dev/null
--- a/include/asm-s390/dma-mapping.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- *  include/asm-s390/dma-mapping.h
- *
- *  S390 version
- *
- *  This file exists so that #include <dma-mapping.h> doesn't break anything.
- */
-
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#endif /* _ASM_DMA_MAPPING_H */
diff -puN include/linux/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-prevent-dma-dependent-code-from-linking-on
+++ a/include/linux/dma-mapping.h
@@ -31,7 +31,11 @@ static inline int valid_dma_direction(in
 		(dma_direction == DMA_FROM_DEVICE));
 }
 
+#ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
+#else
+#include <asm-generic/dma-mapping-broken.h>
+#endif
 
 /* Backwards compat, remove in 2.7.x */
 #define dma_sync_single		dma_sync_single_for_cpu
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
