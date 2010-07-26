From: akpm@linux-foundation.org
Subject: + dma-mapping-remove-dma_is_consistent-api.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:30:28 -0700
Message-ID: <201007262130.o6QLUS6T010902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab0GZVbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, konrad.wilk@oracle.com, linux-arch@vger.kernel.org


The patch titled
     dma-mapping: remove dma_is_consistent API
has been added to the -mm tree.  Its filename is
     dma-mapping-remove-dma_is_consistent-api.patch

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
Subject: dma-mapping: remove dma_is_consistent API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Architectures implement dma_is_consistent() in different ways (some
misinterpret the definition of API in DMA-API.txt).  So it hasn't been so
useful for drivers.  We have only one user of the API in tree.  Unlikely
out-of-tree drivers use the API.

Even if we fix dma_is_consistent() in some architectures, it doesn't look
useful at all.  It was invented long ago for some old systems that can't
allocate coherent memory at all.  It's better to export only APIs that are
definitely necessary for drivers.

Let's remove this API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt                 |    6 ------
 arch/alpha/include/asm/dma-mapping.h      |    1 -
 arch/arm/include/asm/dma-mapping.h        |    5 -----
 arch/avr32/include/asm/dma-mapping.h      |    5 -----
 arch/blackfin/include/asm/dma-mapping.h   |    1 -
 arch/cris/include/asm/dma-mapping.h       |    2 --
 arch/frv/include/asm/dma-mapping.h        |    2 --
 arch/ia64/include/asm/dma-mapping.h       |    2 --
 arch/m68k/include/asm/dma-mapping.h       |    5 -----
 arch/microblaze/include/asm/dma-mapping.h |    1 -
 arch/mips/include/asm/dma-mapping.h       |    2 --
 arch/mips/mm/dma-default.c                |    7 -------
 arch/mn10300/include/asm/dma-mapping.h    |    2 --
 arch/parisc/include/asm/dma-mapping.h     |    6 ------
 arch/powerpc/include/asm/dma-mapping.h    |    5 -----
 arch/sh/include/asm/dma-mapping.h         |    6 ------
 arch/sparc/include/asm/dma-mapping.h      |    1 -
 arch/tile/include/asm/dma-mapping.h       |    2 --
 arch/um/include/asm/dma-mapping.h         |    1 -
 arch/x86/include/asm/dma-mapping.h        |    1 -
 arch/xtensa/include/asm/dma-mapping.h     |    2 --
 include/asm-generic/dma-mapping-broken.h  |    3 ---
 22 files changed, 68 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-remove-dma_is_consistent-api Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-remove-dma_is_consistent-api
+++ a/Documentation/DMA-API.txt
@@ -456,12 +456,6 @@ be identical to those passed in (and ret
 dma_alloc_noncoherent()).
 
 int
-dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
-
-Returns true if the device dev is performing consistent DMA on the memory
-area pointed to by the dma_handle.
-
-int
 dma_get_cache_alignment(void)
 
 Returns the processor cache alignment.  This is the absolute minimum
diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -41,7 +41,6 @@ static inline int dma_set_mask(struct de
 
 #define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)			(1)
 
 #define dma_cache_sync(dev, va, size, dir)		  ((void)0)
 
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -144,11 +144,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
-{
-	return !!arch_is_coherent();
-}
-
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
diff -puN arch/avr32/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/avr32/include/asm/dma-mapping.h
--- a/arch/avr32/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/avr32/include/asm/dma-mapping.h
@@ -336,9 +336,4 @@ dma_sync_sg_for_device(struct device *de
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return 1;
-}
-
 #endif /* __ASM_AVR32_DMA_MAPPING_H */
diff -puN arch/blackfin/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/blackfin/include/asm/dma-mapping.h
--- a/arch/blackfin/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/blackfin/include/asm/dma-mapping.h
@@ -21,7 +21,6 @@ void dma_free_coherent(struct device *de
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_supported(d, m)         (1)
-#define dma_is_consistent(d, h)     (1)
 
 static inline int
 dma_set_mask(struct device *dev, u64 dma_mask)
diff -puN arch/cris/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/cris/include/asm/dma-mapping.h
--- a/arch/cris/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/cris/include/asm/dma-mapping.h
@@ -152,8 +152,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff -puN arch/frv/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/frv/include/asm/dma-mapping.h
--- a/arch/frv/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/frv/include/asm/dma-mapping.h
@@ -125,8 +125,6 @@ int dma_set_mask(struct device *dev, u64
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -97,6 +97,4 @@ dma_cache_sync (struct device *dev, void
 	mb();
 }
 
-#define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
-
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff -puN arch/m68k/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/m68k/include/asm/dma-mapping.h
--- a/arch/m68k/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/m68k/include/asm/dma-mapping.h
@@ -16,11 +16,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
 extern void *dma_alloc_coherent(struct device *, size_t,
 				dma_addr_t *, gfp_t);
 extern void dma_free_coherent(struct device *, size_t,
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -106,7 +106,6 @@ static inline int dma_mapping_error(stru
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flag)
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -62,8 +62,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
-
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
diff -puN arch/mips/mm/dma-default.c~dma-mapping-remove-dma_is_consistent-api arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/mips/mm/dma-default.c
@@ -357,13 +357,6 @@ int dma_supported(struct device *dev, u6
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return plat_device_is_coherent(dev);
-}
-
-EXPORT_SYMBOL(dma_is_consistent);
-
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
 {
diff -puN arch/mn10300/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/mn10300/include/asm/dma-mapping.h
--- a/arch/mn10300/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/mn10300/include/asm/dma-mapping.h
@@ -161,8 +161,6 @@ int dma_set_mask(struct device *dev, u64
 	return 0;
 }
 
-#define dma_is_consistent(d)	(1)
-
 static inline
 void dma_cache_sync(void *vaddr, size_t size,
 		    enum dma_data_direction direction)
diff -puN arch/parisc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/parisc/include/asm/dma-mapping.h
--- a/arch/parisc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/parisc/include/asm/dma-mapping.h
@@ -184,12 +184,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-static inline int
-dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
-{
-	return (hppa_dma_ops->dma_sync_single_for_cpu == NULL);
-}
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -209,11 +209,6 @@ static inline phys_addr_t dma_to_phys(st
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#ifdef CONFIG_NOT_COHERENT_CACHE
-#define dma_is_consistent(d, h)	(0)
-#else
-#define dma_is_consistent(d, h)	(1)
-#endif
 
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		enum dma_data_direction direction)
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -42,12 +42,6 @@ void dma_cache_sync(struct device *dev, 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-#ifdef CONFIG_DMA_COHERENT
-#define dma_is_consistent(d, h) (1)
-#else
-#define dma_is_consistent(d, h) (0)
-#endif
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -11,7 +11,6 @@ extern int dma_supported(struct device *
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 extern struct dma_map_ops *dma_ops, pci32_dma_ops;
 extern struct bus_type pci_bus_type;
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -90,6 +90,4 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 #endif /* _ASM_TILE_DMA_MAPPING_H */
diff -puN arch/um/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/um/include/asm/dma-mapping.h
--- a/arch/um/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/um/include/asm/dma-mapping.h
@@ -94,7 +94,6 @@ dma_sync_sg_for_cpu(struct device *dev, 
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h) (1)
 
 static inline int
 dma_get_cache_alignment(void)
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -54,7 +54,6 @@ static inline int dma_mapping_error(stru
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
 
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-remove-dma_is_consistent-api
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -161,8 +161,6 @@ dma_set_mask(struct device *dev, u64 mas
 	return 0;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff -puN include/asm-generic/dma-mapping-broken.h~dma-mapping-remove-dma_is_consistent-api include/asm-generic/dma-mapping-broken.h
--- a/include/asm-generic/dma-mapping-broken.h~dma-mapping-remove-dma_is_consistent-api
+++ a/include/asm-generic/dma-mapping-broken.h
@@ -72,9 +72,6 @@ dma_set_mask(struct device *dev, u64 mas
 extern int
 dma_get_cache_alignment(void);
 
-extern int
-dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
