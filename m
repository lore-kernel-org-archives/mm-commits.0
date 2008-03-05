From: akpm@linux-foundation.org
Subject: - iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:18 -0800
Message-ID: <200803050746.m257kI2O021759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760867AbYCEHtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     iommu: parisc: make the IOMMUs respect the segment boundary limits
has been removed from the -mm tree.  Its filename was
     iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu: parisc: make the IOMMUs respect the segment boundary limits
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Make PARISC's two IOMMU implementations not allocate a memory area spanning
LLD's segment boundary.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/Kconfig     |    5 +++
 drivers/parisc/ccio-dma.c  |   23 +++++++++++-----
 drivers/parisc/sba_iommu.c |   48 ++++++++++++++++++++++++++---------
 3 files changed, 58 insertions(+), 18 deletions(-)

diff -puN drivers/parisc/Kconfig~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits drivers/parisc/Kconfig
--- a/drivers/parisc/Kconfig~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits
+++ a/drivers/parisc/Kconfig
@@ -103,6 +103,11 @@ config IOMMU_SBA
 	depends on PCI_LBA
 	default PCI_LBA
 
+config IOMMU_HELPER
+	bool
+	depends on IOMMU_SBA || IOMMU_CCIO
+	default y
+
 #config PCI_EPIC
 #	bool "EPIC/SAGA PCI support"
 #	depends on PCI
diff -puN drivers/parisc/ccio-dma.c~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits
+++ a/drivers/parisc/ccio-dma.c
@@ -43,6 +43,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/byteorder.h>
 #include <asm/cache.h>		/* for L1_CACHE_BYTES */
@@ -302,13 +303,17 @@ static int ioc_count;
 */
 #define CCIO_SEARCH_LOOP(ioc, res_idx, mask, size)  \
        for(; res_ptr < res_end; ++res_ptr) { \
-               if(0 == (*res_ptr & mask)) { \
-                       *res_ptr |= mask; \
-                       res_idx = (unsigned int)((unsigned long)res_ptr - (unsigned long)ioc->res_map); \
-                       ioc->res_hint = res_idx + (size >> 3); \
-                       goto resource_found; \
-               } \
-       }
+		int ret;\
+		unsigned int idx;\
+		idx = (unsigned int)((unsigned long)res_ptr - (unsigned long)ioc->res_map); \
+		ret = iommu_is_span_boundary(idx << 3, pages_needed, 0, boundary_size);\
+		if ((0 == (*res_ptr & mask)) && !ret) { \
+			*res_ptr |= mask; \
+			res_idx = idx;\
+			ioc->res_hint = res_idx + (size >> 3); \
+			goto resource_found; \
+		} \
+	}
 
 #define CCIO_FIND_FREE_MAPPING(ioa, res_idx, mask, size) \
        u##size *res_ptr = (u##size *)&((ioc)->res_map[ioa->res_hint & ~((size >> 3) - 1)]); \
@@ -345,6 +350,7 @@ ccio_alloc_range(struct ioc *ioc, struct
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 	unsigned int res_idx;
+	unsigned long boundary_size;
 #ifdef CCIO_SEARCH_TIME
 	unsigned long cr_start = mfctl(16);
 #endif
@@ -360,6 +366,9 @@ ccio_alloc_range(struct ioc *ioc, struct
 	** ggg sacrifices another 710 to the computer gods.
 	*/
 
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
+	boundary_size >>= IOVP_SHIFT;
+
 	if (pages_needed <= 8) {
 		/*
 		 * LAN traffic will not thrash the TLB IFF the same NIC
diff -puN drivers/parisc/sba_iommu.c~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits
+++ a/drivers/parisc/sba_iommu.c
@@ -29,6 +29,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -313,6 +314,12 @@ sba_dump_sg( struct ioc *ioc, struct sca
 #define RESMAP_MASK(n)    (~0UL << (BITS_PER_LONG - (n)))
 #define RESMAP_IDX_MASK   (sizeof(unsigned long) - 1)
 
+unsigned long ptr_to_pide(struct ioc *ioc, unsigned long *res_ptr,
+			  unsigned int bitshiftcnt)
+{
+	return (((unsigned long)res_ptr - (unsigned long)ioc->res_map) << 3)
+		+ bitshiftcnt;
+}
 
 /**
  * sba_search_bitmap - find free space in IO PDIR resource bitmap
@@ -324,19 +331,36 @@ sba_dump_sg( struct ioc *ioc, struct sca
  * Cool perf optimization: search for log2(size) bits at a time.
  */
 static SBA_INLINE unsigned long
-sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
+sba_search_bitmap(struct ioc *ioc, struct device *dev,
+		  unsigned long bits_wanted)
 {
 	unsigned long *res_ptr = ioc->res_hint;
 	unsigned long *res_end = (unsigned long *) &(ioc->res_map[ioc->res_size]);
-	unsigned long pide = ~0UL;
+	unsigned long pide = ~0UL, tpide;
+	unsigned long boundary_size;
+	unsigned long shift;
+	int ret;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
+	boundary_size >>= IOVP_SHIFT;
+
+#if defined(ZX1_SUPPORT)
+	BUG_ON(ioc->ibase & ~IOVP_MASK);
+	shift = ioc->ibase >> IOVP_SHIFT;
+#else
+	shift = 0;
+#endif
 
 	if (bits_wanted > (BITS_PER_LONG/2)) {
 		/* Search word at a time - no mask needed */
 		for(; res_ptr < res_end; ++res_ptr) {
-			if (*res_ptr == 0) {
+			tpide = ptr_to_pide(ioc, res_ptr, 0);
+			ret = iommu_is_span_boundary(tpide, bits_wanted,
+						     shift,
+						     boundary_size);
+			if ((*res_ptr == 0) && !ret) {
 				*res_ptr = RESMAP_MASK(bits_wanted);
-				pide = ((unsigned long)res_ptr - (unsigned long)ioc->res_map);
-				pide <<= 3;	/* convert to bit address */
+				pide = tpide;
 				break;
 			}
 		}
@@ -365,11 +389,13 @@ sba_search_bitmap(struct ioc *ioc, unsig
 		{ 
 			DBG_RES("    %p %lx %lx\n", res_ptr, mask, *res_ptr);
 			WARN_ON(mask == 0);
-			if(((*res_ptr) & mask) == 0) {
+			tpide = ptr_to_pide(ioc, res_ptr, bitshiftcnt);
+			ret = iommu_is_span_boundary(tpide, bits_wanted,
+						     shift,
+						     boundary_size);
+			if ((((*res_ptr) & mask) == 0) && !ret) {
 				*res_ptr |= mask;     /* mark resources busy! */
-				pide = ((unsigned long)res_ptr - (unsigned long)ioc->res_map);
-				pide <<= 3;	/* convert to bit address */
-				pide += bitshiftcnt;
+				pide = tpide;
 				break;
 			}
 			mask >>= o;
@@ -412,9 +438,9 @@ sba_alloc_range(struct ioc *ioc, struct 
 #endif
 	unsigned long pide;
 
-	pide = sba_search_bitmap(ioc, pages_needed);
+	pide = sba_search_bitmap(ioc, dev, pages_needed);
 	if (pide >= (ioc->res_size << 3)) {
-		pide = sba_search_bitmap(ioc, pages_needed);
+		pide = sba_search_bitmap(ioc, dev, pages_needed);
 		if (pide >= (ioc->res_size << 3))
 			panic("%s: I/O MMU @ %p is out of mapping resources\n",
 			      __FILE__, ioc->ioc_hpa);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

parisc-fix-a-overflow-bug-on-32bit-architectures.patch
git-scsi-misc.patch
mpt-fusion-dont-oops-if-numphys==0.patch

