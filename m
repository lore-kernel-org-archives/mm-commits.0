From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-consolidate-dma_supported.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:14:07 -0700
Message-ID: <55f319ef.QVRLKlNDK/H0bjUQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbbIKSOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, andy.shevchenko@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, jcmvbkbc@gmail.com, jonas@southpole.se, linux@arm.linux.org.uk, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, tglx@linutronix.de, will.deacon@arm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: consolidate dma_supported
has been removed from the -mm tree.  Its filename was
     dma-mapping-consolidate-dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: consolidate dma_supported

Most architectures just call into ->dma_supported, but some also return 1
if the method is not present, or 0 if no dma ops are present (although
that should never happeb). Consolidate this more broad version into
common code.

Also fix h8300 which inorrectly always returned 0, which would have been
a problem if it's dma_set_mask implementation wasn't a similarly buggy
noop.

As a few architectures have much more elaborate implementations, we
still allow for arch overrides.

[jcmvbkbc@gmail.com: fix xtensa]
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
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/dma-mapping.h      |    5 -----
 arch/arm/include/asm/dma-mapping.h        |    6 +++---
 arch/arm64/include/asm/dma-mapping.h      |    6 ------
 arch/h8300/include/asm/dma-mapping.h      |    5 -----
 arch/hexagon/include/asm/dma-mapping.h    |    1 +
 arch/ia64/include/asm/dma-mapping.h       |    6 ------
 arch/microblaze/include/asm/dma-mapping.h |   13 +------------
 arch/mips/include/asm/dma-mapping.h       |    6 ------
 arch/openrisc/include/asm/dma-mapping.h   |    5 +++--
 arch/powerpc/include/asm/dma-mapping.h    |   11 -----------
 arch/s390/include/asm/dma-mapping.h       |    9 ---------
 arch/sh/include/asm/dma-mapping.h         |   10 ----------
 arch/sparc/include/asm/dma-mapping.h      |    1 +
 arch/tile/include/asm/dma-mapping.h       |    6 ------
 arch/unicore32/include/asm/dma-mapping.h  |   10 ----------
 arch/x86/include/asm/dma-mapping.h        |    4 +++-
 arch/xtensa/include/asm/dma-mapping.h     |    6 ------
 include/asm-generic/dma-mapping-common.h  |   13 +++++++++++++
 18 files changed, 25 insertions(+), 98 deletions(-)

diff -puN arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/alpha/include/asm/dma-mapping.h
--- a/arch/alpha/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/alpha/include/asm/dma-mapping.h
@@ -12,11 +12,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	return get_dma_ops(dev)->dma_supported(dev, mask);
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 	return get_dma_ops(dev)->set_dma_mask(dev, mask);
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -38,12 +38,14 @@ static inline void set_dma_ops(struct de
 	dev->archdata.dma_ops = ops;
 }
 
+#define HAVE_ARCH_DMA_SUPPORTED 1
+extern int dma_supported(struct device *dev, u64 mask);
+
 /*
  * Note that while the generic code provides dummy dma_{alloc,free}_noncoherent
  * implementations, we don't provide a dma_cache_sync function so drivers using
  * this API are highlighted with build warnings.
  */
-
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_set_mask(struct device *dev, u64 mask)
@@ -172,8 +174,6 @@ static inline bool dma_capable(struct de
 
 static inline void dma_mark_clean(void *addr, size_t size) { }
 
-extern int dma_supported(struct device *dev, u64 mask);
-
 extern int arm_dma_set_mask(struct device *dev, u64 dma_mask);
 
 /**
diff -puN arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/arm64/include/asm/dma-mapping.h
--- a/arch/arm64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/arm64/include/asm/dma-mapping.h
@@ -84,12 +84,6 @@ static inline phys_addr_t dma_to_phys(st
 	return (phys_addr_t)dev_addr;
 }
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	return ops->dma_supported(dev, mask);
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
diff -puN arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/h8300/include/asm/dma-mapping.h
--- a/arch/h8300/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/h8300/include/asm/dma-mapping.h
@@ -10,11 +10,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	return 0;
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 	return 0;
diff -puN arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/hexagon/include/asm/dma-mapping.h
--- a/arch/hexagon/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/hexagon/include/asm/dma-mapping.h
@@ -43,6 +43,7 @@ static inline struct dma_map_ops *get_dm
 	return dma_ops;
 }
 
+#define HAVE_ARCH_DMA_SUPPORTED 1
 extern int dma_supported(struct device *dev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 extern int dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -27,12 +27,6 @@ extern void machvec_dma_sync_sg(struct d
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->dma_supported(dev, mask);
-}
-
 static inline int
 dma_set_mask (struct device *dev, u64 mask)
 {
diff -puN arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/microblaze/include/asm/dma-mapping.h
--- a/arch/microblaze/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/microblaze/include/asm/dma-mapping.h
@@ -44,16 +44,7 @@ static inline struct dma_map_ops *get_dm
 	return &dma_direct_ops;
 }
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (unlikely(!ops))
-		return 0;
-	if (!ops->dma_supported)
-		return 1;
-	return ops->dma_supported(dev, mask);
-}
+#include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
@@ -69,8 +60,6 @@ static inline int dma_set_mask(struct de
 	return 0;
 }
 
-#include <asm-generic/dma-mapping-common.h>
-
 static inline void __dma_sync(unsigned long paddr,
 			      size_t size, enum dma_data_direction direction)
 {
diff -puN arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/mips/include/asm/dma-mapping.h
--- a/arch/mips/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/mips/include/asm/dma-mapping.h
@@ -31,12 +31,6 @@ static inline void dma_mark_clean(void *
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	return ops->dma_supported(dev, mask);
-}
-
 static inline int
 dma_set_mask(struct device *dev, u64 mask)
 {
diff -puN arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -35,14 +35,15 @@ static inline struct dma_map_ops *get_dm
 	return &or1k_dma_map_ops;
 }
 
-#include <asm-generic/dma-mapping-common.h>
-
+#define HAVE_ARCH_DMA_SUPPORTED 1
 static inline int dma_supported(struct device *dev, u64 dma_mask)
 {
 	/* Support 32 bit DMA mask exclusively */
 	return dma_mask == DMA_BIT_MASK(32);
 }
 
+#include <asm-generic/dma-mapping-common.h>
+
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -124,17 +124,6 @@ static inline void set_dma_offset(struct
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	if (unlikely(dma_ops == NULL))
-		return 0;
-	if (dma_ops->dma_supported == NULL)
-		return 1;
-	return dma_ops->dma_supported(dev, mask);
-}
-
 extern int dma_set_mask(struct device *dev, u64 dma_mask);
 extern int __dma_set_mask(struct device *dev, u64 dma_mask);
 extern u64 __dma_get_required_mask(struct device *dev);
diff -puN arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -27,15 +27,6 @@ static inline void dma_cache_sync(struct
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	if (dma_ops->dma_supported == NULL)
-		return 1;
-	return dma_ops->dma_supported(dev, mask);
-}
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff -puN arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -13,16 +13,6 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	if (ops->dma_supported)
-		return ops->dma_supported(dev, mask);
-
-	return 1;
-}
-
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff -puN arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -7,6 +7,7 @@
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
+#define HAVE_ARCH_DMA_SUPPORTED 1
 int dma_supported(struct device *dev, u64 mask);
 
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
diff -puN arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/tile/include/asm/dma-mapping.h
--- a/arch/tile/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/tile/include/asm/dma-mapping.h
@@ -75,12 +75,6 @@ static inline bool dma_capable(struct de
 }
 
 static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	return get_dma_ops(dev)->dma_supported(dev, mask);
-}
-
-static inline int
 dma_set_mask(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
diff -puN arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/unicore32/include/asm/dma-mapping.h
--- a/arch/unicore32/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/unicore32/include/asm/dma-mapping.h
@@ -28,16 +28,6 @@ static inline struct dma_map_ops *get_dm
 	return &swiotlb_dma_map_ops;
 }
 
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
-
-	if (unlikely(dma_ops == NULL))
-		return 0;
-
-	return dma_ops->dma_supported(dev, mask);
-}
-
 #include <asm-generic/dma-mapping-common.h>
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -43,9 +43,11 @@ static inline struct dma_map_ops *get_dm
 bool arch_dma_alloc_attrs(struct device **dev, gfp_t *gfp);
 #define arch_dma_alloc_attrs arch_dma_alloc_attrs
 
+#define HAVE_ARCH_DMA_SUPPORTED 1
+extern int dma_supported(struct device *hwdev, u64 mask);
+
 #include <asm-generic/dma-mapping-common.h>
 
-extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
diff -puN arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported arch/xtensa/include/asm/dma-mapping.h
--- a/arch/xtensa/include/asm/dma-mapping.h~dma-mapping-consolidate-dma_supported
+++ a/arch/xtensa/include/asm/dma-mapping.h
@@ -33,12 +33,6 @@ static inline struct dma_map_ops *get_dm
 #include <asm-generic/dma-mapping-common.h>
 
 static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-	return 1;
-}
-
-static inline int
 dma_set_mask(struct device *dev, u64 mask)
 {
 	if(!dev->dma_mask || !dma_supported(dev, mask))
diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_supported include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-consolidate-dma_supported
+++ a/include/asm-generic/dma-mapping-common.h
@@ -327,4 +327,17 @@ static inline int dma_mapping_error(stru
 #endif
 }
 
+#ifndef HAVE_ARCH_DMA_SUPPORTED
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (!ops)
+		return 0;
+	if (!ops->dma_supported)
+		return 1;
+	return ops->dma_supported(dev, mask);
+}
+#endif
+
 #endif
_

Patches currently in -mm which might be from hch@lst.de are


