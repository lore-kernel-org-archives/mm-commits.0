From: akpm@linux-foundation.org
Subject: + dma-mapping-consolidate-dma_allocfree_attrscoherent.patch added to -mm tree
Date: Mon, 17 Aug 2015 14:25:30 -0700
Message-ID: <55d2514a.4+/42rHa9Zzq+GL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbHQVZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 17:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, jonas@southpole.se, linux@arm.linux.org.uk, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: consolidate dma_{alloc,free}_{attrs,coherent}
has been added to the -mm tree.  Its filename is
     dma-mapping-consolidate-dma_allocfree_attrscoherent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-consolidate-dma_allocfree_attrscoherent.patch

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
Subject: dma-mapping: consolidate dma_{alloc,free}_{attrs,coherent}

Since 2009 we have a nice asm-generic header implementing lots of DMA API
functions for architectures using struct dma_map_ops, but unfortunately
it's still missing a lot of APIs that all architectures still have to
duplicate.

This series consolidates the remaining functions, although we still need
arch opt outs for two of them as a few architectures have very
non-standard implementations.



This patch (of 5):

The coherent DMA allocator works the same over all architectures supporting
dma_map operations.

This patch consolidates them and converges the minor differences:

 - the debug_dma helpers are now called from all architectures, including
   those that were previously missing them
 - dma_alloc_from_coherent and dma_release_from_coherent are now always
   called from the generic alloc/free routines instead of the ops
   dma-mapping-common.h always includes dma-coherent.h to get the defintions
   for them, or the stubs if the architecture doesn't support this feature
 - checks for ->alloc / ->free presence are removed.  There is only one
   magic instead of dma_map_ops without them (mic_dma_ops) and that one
   is x86 only anyway.

Besides that only x86 needs special treatment to replace a default devices
if none is passed and tweak the gfp_flags.  An optional arch hook is provided
for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h      |   18 ------
 arch/arm/include/asm/dma-mapping.h        |   29 ----------
 arch/arm/mm/dma-mapping.c                 |   12 ----
 arch/arm64/include/asm/dma-mapping.h      |   33 -----------
 arch/h8300/include/asm/dma-mapping.h      |   26 --------
 arch/hexagon/include/asm/dma-mapping.h    |   33 -----------
 arch/ia64/include/asm/dma-mapping.h       |   25 --------
 arch/microblaze/include/asm/dma-mapping.h |   31 ----------
 arch/mips/cavium-octeon/dma-octeon.c      |    8 --
 arch/mips/include/asm/dma-mapping.h       |   31 ----------
 arch/mips/loongson64/common/dma-swiotlb.c |    8 --
 arch/mips/mm/dma-default.c                |    7 --
 arch/mips/netlogic/common/nlm-dma.c       |    8 --
 arch/openrisc/include/asm/dma-mapping.h   |   30 ----------
 arch/powerpc/include/asm/dma-mapping.h    |   33 -----------
 arch/s390/include/asm/dma-mapping.h       |   31 ----------
 arch/sh/include/asm/dma-mapping.h         |   37 ------------
 arch/sparc/include/asm/dma-mapping.h      |   26 --------
 arch/tile/include/asm/dma-mapping.h       |   27 ---------
 arch/unicore32/include/asm/dma-mapping.h  |   24 --------
 arch/x86/include/asm/dma-mapping.h        |   16 +----
 arch/x86/kernel/pci-dma.c                 |   49 +++-------------
 drivers/xen/swiotlb-xen.c                 |    6 --
 include/asm-generic/dma-mapping-common.h  |   58 ++++++++++++++++++++
 24 files changed, 70 insertions(+), 536 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -12,24 +12,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	return get_dma_ops(dev)->alloc(dev, size, dma_handle, gfp, attrs);
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	get_dma_ops(dev)->free(dev, size, vaddr, dma_handle, attrs);
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -8,7 +8,6 @@
 #include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 
-#include <asm-generic/dma-coherent.h>
 #include <asm/memory.h>
 
 #include <xen/xen.h>
@@ -209,21 +208,6 @@ extern int arm_dma_set_mask(struct devic
 extern void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			   gfp_t gfp, struct dma_attrs *attrs);
 
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *cpu_addr;
-	BUG_ON(!ops);
-
-	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-	return cpu_addr;
-}
-
 /**
  * arm_dma_free - free memory allocated by arm_dma_alloc
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -241,19 +225,6 @@ static inline void *dma_alloc_attrs(stru
 extern void arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
 			 dma_addr_t handle, struct dma_attrs *attrs);
 
-#define dma_free_coherent(d, s, c, h) dma_free_attrs(d, s, c, h, NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	BUG_ON(!ops);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 /**
  * arm_dma_mmap - map a coherent DMA allocation into user space
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
diff -puN arch/arm/mm/dma-mapping.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/arm/mm/dma-mapping.c
@@ -676,10 +676,6 @@ void *arm_dma_alloc(struct device *dev,
 		    gfp_t gfp, struct dma_attrs *attrs)
 {
 	pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
-	void *memory;
-
-	if (dma_alloc_from_coherent(dev, size, handle, &memory))
-		return memory;
 
 	return __dma_alloc(dev, size, handle, gfp, prot, false,
 			   attrs, __builtin_return_address(0));
@@ -688,11 +684,6 @@ void *arm_dma_alloc(struct device *dev,
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
 	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
 {
-	void *memory;
-
-	if (dma_alloc_from_coherent(dev, size, handle, &memory))
-		return memory;
-
 	return __dma_alloc(dev, size, handle, gfp, PAGE_KERNEL, true,
 			   attrs, __builtin_return_address(0));
 }
@@ -752,9 +743,6 @@ static void __arm_dma_free(struct device
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
 	bool want_vaddr = !dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs);
 
-	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
-		return;
-
 	size = PAGE_ALIGN(size);
 
 	if (nommu()) {
diff -puN arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/arm64/include/asm/dma-mapping.h
--- a/arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/arm64/include/asm/dma-mapping.h
@@ -22,8 +22,6 @@
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
-#include <asm-generic/dma-coherent.h>
-
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 
@@ -120,37 +118,6 @@ static inline void dma_mark_clean(void *
 {
 }
 
-#define dma_alloc_coherent(d, s, h, f)	dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_coherent(d, s, h, f)	dma_free_attrs(d, s, h, f, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *vaddr;
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &vaddr))
-		return vaddr;
-
-	vaddr = ops->alloc(dev, size, dma_handle, flags, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, vaddr);
-	return vaddr;
-}
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *vaddr, dma_addr_t dev_addr,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (dma_release_from_coherent(dev, get_order(size), vaddr))
-		return;
-
-	debug_dma_free_coherent(dev, size, vaddr, dev_addr);
-	ops->free(dev, size, vaddr, dev_addr, attrs);
-}
-
 /*
  * There is no dma_cache_sync() implementation, so just return NULL here.
  */
diff -puN arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/h8300/include/asm/dma-mapping.h
--- a/arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/h8300/include/asm/dma-mapping.h
@@ -1,8 +1,6 @@
 #ifndef _H8300_DMA_MAPPING_H
 #define _H8300_DMA_MAPPING_H
 
-#include <asm-generic/dma-coherent.h>
-
 extern struct dma_map_ops h8300_dma_map_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
@@ -25,30 +23,6 @@ static inline int dma_set_mask(struct de
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *memory;
-
-	memory = ops->alloc(dev, size, dma_handle, flag, attrs);
-	return memory;
-}
-
-#define dma_free_coherent(d, s, c, h) dma_free_attrs(d, s, c, h, NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -70,37 +70,4 @@ static inline int dma_mapping_error(stru
 	return (dma_addr == bad_dma_address);
 }
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	void *ret;
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!dma_ops);
-
-	ret = ops->alloc(dev, size, dma_handle, flag, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
-
-	return ret;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	BUG_ON(!dma_ops);
-
-	dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-}
-
 #endif
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -23,31 +23,6 @@ extern void machvec_dma_sync_single(stru
 extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
 				enum dma_data_direction);
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *daddr, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	void *caddr;
-
-	caddr = ops->alloc(dev, size, daddr, gfp, attrs);
-	debug_dma_alloc_coherent(dev, size, *daddr, caddr);
-	return caddr;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *caddr, dma_addr_t daddr,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	debug_dma_free_coherent(dev, size, caddr, daddr);
-	ops->free(dev, size, caddr, daddr, attrs);
-}
-
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -27,7 +27,6 @@
 #include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>
 #include <asm/io.h>
-#include <asm-generic/dma-coherent.h>
 #include <asm/cacheflush.h>
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
@@ -102,36 +101,6 @@ static inline int dma_mapping_error(stru
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *memory;
-
-	BUG_ON(!ops);
-
-	memory = ops->alloc(dev, size, dma_handle, flag, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
-	return memory;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d, s, c, h, NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!ops);
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
 {
diff -puN arch/mips/cavium-octeon/dma-octeon.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/mips/cavium-octeon/dma-octeon.c
--- a/arch/mips/cavium-octeon/dma-octeon.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/mips/cavium-octeon/dma-octeon.c
@@ -161,9 +161,6 @@ static void *octeon_dma_alloc_coherent(s
 {
 	void *ret;
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
@@ -194,11 +191,6 @@ static void *octeon_dma_alloc_coherent(s
 static void octeon_dma_free_coherent(struct device *dev, size_t size,
 	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
-	int order = get_order(size);
-
-	if (dma_release_from_coherent(dev, order, vaddr))
-		return;
-
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -4,7 +4,6 @@
 #include <linux/scatterlist.h>
 #include <asm/dma-coherence.h>
 #include <asm/cache.h>
-#include <asm-generic/dma-coherent.h>
 
 #ifndef CONFIG_SGI_IP27 /* Kludge to fix 2.6.39 build for IP27 */
 #include <dma-coherence.h>
@@ -65,36 +64,6 @@ dma_set_mask(struct device *dev, u64 mas
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	void *ret;
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	ret = ops->alloc(dev, size, dma_handle, gfp, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
-
-	return ret;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	ops->free(dev, size, vaddr, dma_handle, attrs);
-
-	debug_dma_free_coherent(dev, size, vaddr, dma_handle);
-}
-
-
 void *dma_alloc_noncoherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flag);
 
diff -puN arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/mips/loongson64/common/dma-swiotlb.c
--- a/arch/mips/loongson64/common/dma-swiotlb.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/mips/loongson64/common/dma-swiotlb.c
@@ -14,9 +14,6 @@ static void *loongson_dma_alloc_coherent
 {
 	void *ret;
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
@@ -46,11 +43,6 @@ static void *loongson_dma_alloc_coherent
 static void loongson_dma_free_coherent(struct device *dev, size_t size,
 		void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
-	int order = get_order(size);
-
-	if (dma_release_from_coherent(dev, order, vaddr))
-		return;
-
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
diff -puN arch/mips/mm/dma-default.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/mips/mm/dma-default.c
@@ -137,9 +137,6 @@ static void *mips_dma_alloc_coherent(str
 	struct page *page = NULL;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
 	gfp = massage_gfp_flags(dev, gfp);
 
 	if (IS_ENABLED(CONFIG_DMA_CMA) && !(gfp & GFP_ATOMIC))
@@ -176,13 +173,9 @@ static void mips_dma_free_coherent(struc
 	dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	unsigned long addr = (unsigned long) vaddr;
-	int order = get_order(size);
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = NULL;
 
-	if (dma_release_from_coherent(dev, order, vaddr))
-		return;
-
 	plat_unmap_dma_mem(dev, dma_handle, size, DMA_BIDIRECTIONAL);
 
 	if (!plat_device_is_coherent(dev) && !hw_coherentio)
diff -puN arch/mips/netlogic/common/nlm-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/mips/netlogic/common/nlm-dma.c
--- a/arch/mips/netlogic/common/nlm-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/mips/netlogic/common/nlm-dma.c
@@ -49,9 +49,6 @@ static void *nlm_dma_alloc_coherent(stru
 {
 	void *ret;
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
@@ -69,11 +66,6 @@ static void *nlm_dma_alloc_coherent(stru
 static void nlm_dma_free_coherent(struct device *dev, size_t size,
 	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
-	int order = get_order(size);
-
-	if (dma_release_from_coherent(dev, order, vaddr))
-		return;
-
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
diff -puN arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -23,7 +23,6 @@
  */
 
 #include <linux/dma-debug.h>
-#include <asm-generic/dma-coherent.h>
 #include <linux/kmemcheck.h>
 #include <linux/dma-mapping.h>
 
@@ -38,35 +37,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-#define dma_alloc_coherent(d,s,h,f) dma_alloc_attrs(d,s,h,f,NULL) 
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *memory;
-
-	memory = ops->alloc(dev, size, dma_handle, gfp, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
-
-	return memory;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t gfp)
 {
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -137,39 +137,6 @@ extern int dma_set_mask(struct device *d
 extern int __dma_set_mask(struct device *dev, u64 dma_mask);
 extern u64 __dma_get_required_mask(struct device *dev);
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-	void *cpu_addr;
-
-	BUG_ON(!dma_ops);
-
-	cpu_addr = dma_ops->alloc(dev, size, dma_handle, flag, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-
-	return cpu_addr;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	BUG_ON(!dma_ops);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-
-	dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -56,35 +56,4 @@ static inline int dma_mapping_error(stru
 	return dma_addr == DMA_ERROR_CODE;
 }
 
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *cpu_addr;
-
-	BUG_ON(!ops);
-
-	cpu_addr = ops->alloc(dev, size, dma_handle, flags, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-
-	return cpu_addr;
-}
-
-#define dma_free_coherent(d, s, c, h) dma_free_attrs(d, s, c, h, NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!ops);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 #endif /* _ASM_S390_DMA_MAPPING_H */
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -9,7 +9,6 @@ static inline struct dma_map_ops *get_dm
 	return dma_ops;
 }
 
-#include <asm-generic/dma-coherent.h>
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_supported(struct device *dev, u64 mask)
@@ -53,42 +52,6 @@ static inline int dma_mapping_error(stru
 	return dma_addr == 0;
 }
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t gfp,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *memory;
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
-		return memory;
-	if (!ops->alloc)
-		return NULL;
-
-	memory = ops->alloc(dev, size, dma_handle, gfp, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
-
-	return memory;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (dma_release_from_coherent(dev, get_order(size), vaddr))
-		return;
-
-	debug_dma_free_coherent(dev, size, vaddr, dma_handle);
-	if (ops->free)
-		ops->free(dev, size, vaddr, dma_handle, attrs);
-}
-
 /* arch/sh/mm/consistent.c */
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -41,32 +41,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *cpu_addr;
-
-	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-	return cpu_addr;
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	debug_dma_mapping_error(dev, dma_addr);
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -116,34 +116,7 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-	void *cpu_addr;
-
-	cpu_addr = dma_ops->alloc(dev, size, dma_handle, flag, attrs);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
-
-	return cpu_addr;
-}
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-
-	dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
-#define dma_alloc_coherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_attrs(d, s, h, f, NULL)
-#define dma_free_coherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
 #define dma_free_noncoherent(d, s, v, h) dma_free_attrs(d, s, v, h, NULL)
 
 /*
diff -puN arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/unicore32/include/asm/dma-mapping.h
--- a/arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/unicore32/include/asm/dma-mapping.h
@@ -18,8 +18,6 @@
 #include <linux/scatterlist.h>
 #include <linux/swiotlb.h>
 
-#include <asm-generic/dma-coherent.h>
-
 #include <asm/memory.h>
 #include <asm/cacheflush.h>
 
@@ -82,28 +80,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flag,
-				    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	return dma_ops->alloc(dev, size, dma_handle, flag, attrs);
-}
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-static inline void dma_free_attrs(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	dma_ops->free(dev, size, cpu_addr, dma_handle, attrs);
-}
-
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -12,7 +12,6 @@
 #include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
-#include <asm-generic/dma-coherent.h>
 #include <linux/dma-contiguous.h>
 
 #ifdef CONFIG_ISA
@@ -41,6 +40,9 @@ static inline struct dma_map_ops *get_dm
 #endif
 }
 
+bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp);
+#define arch_dma_alloc_attrs arch_dma_alloc_attrs
+
 #include <asm-generic/dma-mapping-common.h>
 
 /* Make sure we keep the same behaviour */
@@ -125,16 +127,4 @@ static inline gfp_t dma_alloc_coherent_g
        return gfp;
 }
 
-#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-
-void *
-dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		gfp_t gfp, struct dma_attrs *attrs);
-
-#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
-
-void dma_free_attrs(struct device *dev, size_t size,
-		    void *vaddr, dma_addr_t bus,
-		    struct dma_attrs *attrs);
-
 #endif
diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/arch/x86/kernel/pci-dma.c
@@ -140,50 +140,19 @@ void dma_generic_free_coherent(struct de
 		free_pages((unsigned long)vaddr, get_order(size));
 }
 
-void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		      gfp_t gfp, struct dma_attrs *attrs)
+bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	void *memory;
+	*gfp = dma_alloc_coherent_gfp_flags(*dev, *gfp);
+	*gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	if (!*dev)
+		*dev = &x86_dma_fallback_dev;
+	if (!is_device_dma_capable(*dev))
+		return false;
+	return true;
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
-		return memory;
-
-	if (!dev)
-		dev = &x86_dma_fallback_dev;
-
-	if (!is_device_dma_capable(dev))
-		return NULL;
-
-	if (!ops->alloc)
-		return NULL;
-
-	memory = ops->alloc(dev, size, dma_handle,
-			    dma_alloc_coherent_gfp_flags(dev, gfp), attrs);
-	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
-
-	return memory;
-}
-EXPORT_SYMBOL(dma_alloc_attrs);
-
-void dma_free_attrs(struct device *dev, size_t size,
-		    void *vaddr, dma_addr_t bus,
-		    struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	WARN_ON(irqs_disabled());       /* for portability */
-
-	if (dma_release_from_coherent(dev, get_order(size), vaddr))
-		return;
-
-	debug_dma_free_coherent(dev, size, vaddr, bus);
-	if (ops->free)
-		ops->free(dev, size, vaddr, bus, attrs);
 }
-EXPORT_SYMBOL(dma_free_attrs);
+EXPORT_SYMBOL(arch_dma_alloc_attrs);
 
 /*
  * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
diff -puN drivers/xen/swiotlb-xen.c~dma-mapping-consolidate-dma_allocfree_attrscoherent drivers/xen/swiotlb-xen.c
--- a/drivers/xen/swiotlb-xen.c~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/drivers/xen/swiotlb-xen.c
@@ -311,9 +311,6 @@ xen_swiotlb_alloc_coherent(struct device
 	*/
 	flags &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (dma_alloc_from_coherent(hwdev, size, dma_handle, &ret))
-		return ret;
-
 	/* On ARM this function returns an ioremap'ped virtual address for
 	 * which virt_to_phys doesn't return the corresponding physical
 	 * address. In fact on ARM virt_to_phys only works for kernel direct
@@ -356,9 +353,6 @@ xen_swiotlb_free_coherent(struct device
 	phys_addr_t phys;
 	u64 dma_mask = DMA_BIT_MASK(32);
 
-	if (dma_release_from_coherent(hwdev, order, vaddr))
-		return;
-
 	if (hwdev && hwdev->coherent_dma_mask)
 		dma_mask = hwdev->coherent_dma_mask;
 
diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_allocfree_attrscoherent include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_allocfree_attrscoherent
+++ a/include/asm-generic/dma-mapping-common.h
@@ -6,6 +6,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>
+#include <asm-generic/dma-coherent.h>
 
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
@@ -237,4 +238,61 @@ dma_get_sgtable_attrs(struct device *dev
 
 #define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
 
+#ifndef arch_dma_alloc_attrs
+#define arch_dma_alloc_attrs(dev, flag)	(true)
+#endif
+
+static inline void *dma_alloc_attrs(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag,
+				       struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *cpu_addr;
+
+	BUG_ON(!ops);
+
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &cpu_addr))
+		return cpu_addr;
+
+	if (!arch_dma_alloc_attrs(&dev, &flag))
+		return NULL;
+	if (!ops->alloc)
+		return NULL;
+
+	cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+	return cpu_addr;
+}
+
+static inline void dma_free_attrs(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle,
+				     struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!ops);
+	WARN_ON(irqs_disabled());
+
+	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
+		return;
+
+	if (!ops->free)
+		return;
+
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	ops->free(dev, size, cpu_addr, dma_handle, attrs);
+}
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flag)
+{
+	return dma_alloc_attrs(dev, size, dma_handle, flag, NULL);
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle)
+{
+	return dma_free_attrs(dev, size, cpu_addr, dma_handle, NULL);
+}
+
 #endif
_

Patches currently in -mm which might be from hch@lst.de are

add-myself-to-get_maintainerignore.patch
mm-swap-zswap-maybe_preload-refactoring.patch
linux-next.patch
dma-mapping-consolidate-dma_allocfree_attrscoherent.patch
dma-mapping-consolidate-dma_allocfree_noncoherent.patch
dma-mapping-cosolidate-dma_mapping_error.patch
dma-mapping-consolidate-dma_supported.patch
dma-mapping-consolidate-dma_set_mask.patch

