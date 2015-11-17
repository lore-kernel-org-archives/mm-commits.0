From: akpm@linux-foundation.org
Subject: + dma-mapping-remove-asm-generic-dma-coherenth.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:12 -0800
Message-ID: <564b9e44.K2Rx4i+SfIhptjk8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbKQViN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, a-jacquiot@ti.com, cmetcalf@ezchip.com, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, hskinnemoen@gmail.com, james.hogan@imgtec.com, jesper.nilsson@axis.com, lftan@altera.com, msalter@redhat.com, realmz6@gmail.com, starvik@axis.com, vgupta@synopsys.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: remove <asm-generic/dma-coherent.h>
has been added to the -mm tree.  Its filename is
     dma-mapping-remove-asm-generic-dma-coherenth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-remove-asm-generic-dma-coherenth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-remove-asm-generic-dma-coherenth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: remove <asm-generic/dma-coherent.h>

This wasn't an asm-generic header to start with, and can be merged into
dma-mapping.h trivially.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Helge Deller <deller@gmx.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/dma-mapping.h |    2 -
 drivers/base/dma-mapping.c            |    3 --
 include/asm-generic/dma-coherent.h    |   32 ----------------------
 include/linux/dma-mapping.h           |   34 +++++++++++++++++++-----
 4 files changed, 29 insertions(+), 42 deletions(-)

diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-remove-asm-generic-dma-coherenth arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-remove-asm-generic-dma-coherenth
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -13,8 +13,6 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 
-#include <asm-generic/dma-coherent.h>
-
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 
diff -puN drivers/base/dma-mapping.c~dma-mapping-remove-asm-generic-dma-coherenth drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~dma-mapping-remove-asm-generic-dma-coherenth
+++ a/drivers/base/dma-mapping.c
@@ -12,7 +12,6 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <asm-generic/dma-coherent.h>
 
 /*
  * Managed DMA API
@@ -167,7 +166,7 @@ void dmam_free_noncoherent(struct device
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
 
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 
 static void dmam_coherent_decl_release(struct device *dev, void *res)
 {
diff -puN include/asm-generic/dma-coherent.h~dma-mapping-remove-asm-generic-dma-coherenth /dev/null
--- a/include/asm-generic/dma-coherent.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef DMA_COHERENT_H
-#define DMA_COHERENT_H
-
-#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
-/*
- * These three functions are only for dma allocator.
- * Don't use them in device drivers.
- */
-int dma_alloc_from_coherent(struct device *dev, ssize_t size,
-				       dma_addr_t *dma_handle, void **ret);
-int dma_release_from_coherent(struct device *dev, int order, void *vaddr);
-
-int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
-			    void *cpu_addr, size_t size, int *ret);
-/*
- * Standard interface
- */
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
-				dma_addr_t device_addr, size_t size, int flags);
-
-void dma_release_declared_memory(struct device *dev);
-
-void *dma_mark_declared_memory_occupied(struct device *dev,
-					dma_addr_t device_addr, size_t size);
-#else
-#define dma_alloc_from_coherent(dev, size, handle, ret) (0)
-#define dma_release_from_coherent(dev, order, vaddr) (0)
-#define dma_mmap_from_coherent(dev, vma, vaddr, order, ret) (0)
-#endif
-
-#endif
diff -puN include/linux/dma-mapping.h~dma-mapping-remove-asm-generic-dma-coherenth include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-remove-asm-generic-dma-coherenth
+++ a/include/linux/dma-mapping.h
@@ -11,7 +11,6 @@
 #include <linux/scatterlist.h>
 #include <linux/kmemcheck.h>
 #include <linux/bug.h>
-#include <asm-generic/dma-coherent.h>
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
@@ -87,6 +86,23 @@ static inline int is_device_dma_capable(
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
+/*
+ * These three functions are only for dma allocator.
+ * Don't use them in device drivers.
+ */
+int dma_alloc_from_coherent(struct device *dev, ssize_t size,
+				       dma_addr_t *dma_handle, void **ret);
+int dma_release_from_coherent(struct device *dev, int order, void *vaddr);
+
+int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
+			    void *cpu_addr, size_t size, int *ret);
+#else
+#define dma_alloc_from_coherent(dev, size, handle, ret) (0)
+#define dma_release_from_coherent(dev, order, vaddr) (0)
+#define dma_mmap_from_coherent(dev, vma, vaddr, order, ret) (0)
+#endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
@@ -568,7 +584,13 @@ static inline int dma_get_cache_alignmen
 #define DMA_MEMORY_INCLUDES_CHILDREN	0x04
 #define DMA_MEMORY_EXCLUSIVE		0x08
 
-#ifndef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
+int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
+				dma_addr_t device_addr, size_t size, int flags);
+void dma_release_declared_memory(struct device *dev);
+void *dma_mark_declared_memory_occupied(struct device *dev,
+					dma_addr_t device_addr, size_t size);
+#else
 static inline int
 dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 			    dma_addr_t device_addr, size_t size, int flags)
@@ -587,7 +609,7 @@ dma_mark_declared_memory_occupied(struct
 {
 	return ERR_PTR(-EBUSY);
 }
-#endif
+#endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
 
 /*
  * Managed DMA API
@@ -600,13 +622,13 @@ extern void *dmam_alloc_noncoherent(stru
 				    dma_addr_t *dma_handle, gfp_t gfp);
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 extern int dmam_declare_coherent_memory(struct device *dev,
 					phys_addr_t phys_addr,
 					dma_addr_t device_addr, size_t size,
 					int flags);
 extern void dmam_release_declared_memory(struct device *dev);
-#else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
+#else /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
 static inline int dmam_declare_coherent_memory(struct device *dev,
 				phys_addr_t phys_addr, dma_addr_t device_addr,
 				size_t size, gfp_t gfp)
@@ -617,7 +639,7 @@ static inline int dmam_declare_coherent_
 static inline void dmam_release_declared_memory(struct device *dev)
 {
 }
-#endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
+#endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
 
 static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
 					   dma_addr_t *dma_addr, gfp_t gfp)
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

