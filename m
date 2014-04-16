From: akpm@linux-foundation.org
Subject: + cma-add-placement-specifier-for-cma=-kernel-parameter.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 12:44:50 -0700
Message-ID: <534eddb2.i/tmhl6Su0paM1QS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbaDPTow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: + cma-add-placement-specifier-for-cma=-kernel-parameter.patch added to -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:44:50 -0700


The patch titled
     Subject: cma: add placement specifier for "cma=" kernel parameter
has been added to the -mm tree.  Its filename is
     cma-add-placement-specifier-for-cma=-kernel-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-add-placement-specifier-for-cma=-kernel-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-add-placement-specifier-for-cma=-kernel-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: cma: add placement specifier for "cma=" kernel parameter

Currently, "cma=" kernel parameter is used to specify the size of CMA, but
we can't specify where it is located.  We want to locate CMA below 4GB for
devices only supporting 32-bit addressing on 64-bit systems without iommu.

This enables to specify the placement of CMA by extending "cma=" kernel
parameter.

Examples:
1. locate 64MB CMA below 4GB by "cma=64M@0-4G"
2. locate 64MB CMA exact at 512MB by "cma=64M@512M"

Note that the DMA contiguous memory allocator on x86 assumes that
page_address() works for the pages to allocate.  So this change requires
to limit end address of contiguous memory area upto max_pfn_mapped to
prevent from locating it on highmem area by the argument of
dma_contiguous_reserve().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++-
 arch/x86/kernel/setup.c             |    2 -
 drivers/base/dma-contiguous.c       |   42 +++++++++++++++++++-------
 include/linux/dma-contiguous.h      |    9 +++--
 4 files changed, 44 insertions(+), 16 deletions(-)

diff -puN Documentation/kernel-parameters.txt~cma-add-placement-specifier-for-cma=-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cma-add-placement-specifier-for-cma=-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -617,8 +617,11 @@ bytes respectively. Such letter suffixes
 			Also note the kernel might malfunction if you disable
 			some critical bits.
 
-	cma=nn[MG]	[ARM,KNL]
-			Sets the size of kernel global memory area for contiguous
+	cma=nn[MG]@[start[MG][-end[MG]]]
+			[ARM,X86,KNL]
+			Sets the size of kernel global memory area for
+			contiguous memory allocations and optionally the
+			placement constraint by the physical address range of
 			memory allocations. For more information, see
 			include/linux/dma-contiguous.h
 
diff -puN arch/x86/kernel/setup.c~cma-add-placement-specifier-for-cma=-kernel-parameter arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~cma-add-placement-specifier-for-cma=-kernel-parameter
+++ a/arch/x86/kernel/setup.c
@@ -1119,7 +1119,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_real_mode();
 
 	memblock_set_current_limit(get_max_mapped());
-	dma_contiguous_reserve(0);
+	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
diff -puN drivers/base/dma-contiguous.c~cma-add-placement-specifier-for-cma=-kernel-parameter drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~cma-add-placement-specifier-for-cma=-kernel-parameter
+++ a/drivers/base/dma-contiguous.c
@@ -59,11 +59,22 @@ struct cma *dma_contiguous_default_area;
  */
 static const phys_addr_t size_bytes = CMA_SIZE_MBYTES * SZ_1M;
 static phys_addr_t size_cmdline = -1;
+static phys_addr_t base_cmdline;
+static phys_addr_t limit_cmdline;
 
 static int __init early_cma(char *p)
 {
 	pr_debug("%s(%s)\n", __func__, p);
 	size_cmdline = memparse(p, &p);
+	if (*p != '@')
+		return 0;
+	base_cmdline = memparse(p + 1, &p);
+	if (*p != '-') {
+		limit_cmdline = base_cmdline + size_cmdline;
+		return 0;
+	}
+	limit_cmdline = memparse(p + 1, &p);
+
 	return 0;
 }
 early_param("cma", early_cma);
@@ -107,11 +118,18 @@ static inline __maybe_unused phys_addr_t
 void __init dma_contiguous_reserve(phys_addr_t limit)
 {
 	phys_addr_t selected_size = 0;
+	phys_addr_t selected_base = 0;
+	phys_addr_t selected_limit = limit;
+	bool fixed = false;
 
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
 	if (size_cmdline != -1) {
 		selected_size = size_cmdline;
+		selected_base = base_cmdline;
+		selected_limit = min_not_zero(limit_cmdline, limit);
+		if (base_cmdline + size_cmdline == limit_cmdline)
+			fixed = true;
 	} else {
 #ifdef CONFIG_CMA_SIZE_SEL_MBYTES
 		selected_size = size_bytes;
@@ -128,10 +146,12 @@ void __init dma_contiguous_reserve(phys_
 		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
 			 (unsigned long)selected_size / SZ_1M);
 
-		dma_contiguous_reserve_area(selected_size, 0, limit,
-					    &dma_contiguous_default_area);
+		dma_contiguous_reserve_area(selected_size, selected_base,
+					    selected_limit,
+					    &dma_contiguous_default_area,
+					    fixed);
 	}
-};
+}
 
 static DEFINE_MUTEX(cma_mutex);
 
@@ -187,15 +207,20 @@ core_initcall(cma_init_reserved_areas);
  * @base: Base address of the reserved area optional, use 0 for any
  * @limit: End address of the reserved memory (optional, 0 for any).
  * @res_cma: Pointer to store the created cma region.
+ * @fixed: hint about where to place the reserved area
  *
  * This function reserves memory from early allocator. It should be
  * called by arch specific code once the early allocator (memblock or bootmem)
  * has been activated and all other subsystems have already allocated/reserved
  * memory. This function allows to create custom reserved areas for specific
  * devices.
+ *
+ * If @fixed is true, reserve contiguous area at exactly @base.  If false,
+ * reserve in range from @base to @limit.
  */
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
-				       phys_addr_t limit, struct cma **res_cma)
+				       phys_addr_t limit, struct cma **res_cma,
+				       bool fixed)
 {
 	struct cma *cma = &cma_areas[cma_area_count];
 	phys_addr_t alignment;
@@ -221,18 +246,15 @@ int __init dma_contiguous_reserve_area(p
 	limit &= ~(alignment - 1);
 
 	/* Reserve memory */
-	if (base) {
+	if (base && fixed) {
 		if (memblock_is_region_reserved(base, size) ||
 		    memblock_reserve(base, size) < 0) {
 			ret = -EBUSY;
 			goto err;
 		}
 	} else {
-		/*
-		 * Use __memblock_alloc_base() since
-		 * memblock_alloc_base() panic()s.
-		 */
-		phys_addr_t addr = __memblock_alloc_base(size, alignment, limit);
+		phys_addr_t addr = memblock_alloc_range(size, alignment, base,
+							limit);
 		if (!addr) {
 			ret = -ENOMEM;
 			goto err;
diff -puN include/linux/dma-contiguous.h~cma-add-placement-specifier-for-cma=-kernel-parameter include/linux/dma-contiguous.h
--- a/include/linux/dma-contiguous.h~cma-add-placement-specifier-for-cma=-kernel-parameter
+++ a/include/linux/dma-contiguous.h
@@ -88,7 +88,8 @@ static inline void dma_contiguous_set_de
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
-				       phys_addr_t limit, struct cma **res_cma);
+				       phys_addr_t limit, struct cma **res_cma,
+				       bool fixed);
 
 /**
  * dma_declare_contiguous() - reserve area for contiguous memory handling
@@ -108,7 +109,7 @@ static inline int dma_declare_contiguous
 {
 	struct cma *cma;
 	int ret;
-	ret = dma_contiguous_reserve_area(size, base, limit, &cma);
+	ret = dma_contiguous_reserve_area(size, base, limit, &cma, true);
 	if (ret == 0)
 		dev_set_cma_area(dev, cma);
 
@@ -136,7 +137,9 @@ static inline void dma_contiguous_set_de
 static inline void dma_contiguous_reserve(phys_addr_t limit) { }
 
 static inline int dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
-				       phys_addr_t limit, struct cma **res_cma) {
+				       phys_addr_t limit, struct cma **res_cma,
+				       bool fixed)
+{
 	return -ENOSYS;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch

