From: akpm@linux-foundation.org
Subject: [merged]
 ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:05 -0700
Message-ID: <53e3dbb5.92txmtuRrynmvj2q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63269 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaHGUEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:06 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so606534vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: PPC, KVM, CMA: use general CMA reserved area management framework
has been removed from the -mm tree.  Its filename was
     ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: PPC, KVM, CMA: use general CMA reserved area management framework

Now, we have general CMA reserved area management framework, so use it for
future maintainabilty.  There is no functional change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/Makefile            |    1 
 arch/powerpc/kvm/book3s_64_mmu_hv.c  |    4 
 arch/powerpc/kvm/book3s_hv_builtin.c |   19 +
 arch/powerpc/kvm/book3s_hv_cma.c     |  240 -------------------------
 arch/powerpc/kvm/book3s_hv_cma.h     |   27 --
 5 files changed, 14 insertions(+), 277 deletions(-)

diff -puN arch/powerpc/kvm/Makefile~ppc-kvm-cma-use-general-cma-reserved-area-management-framework arch/powerpc/kvm/Makefile
--- a/arch/powerpc/kvm/Makefile~ppc-kvm-cma-use-general-cma-reserved-area-management-framework
+++ a/arch/powerpc/kvm/Makefile
@@ -90,7 +90,6 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_
 	book3s_hv_rm_mmu.o \
 	book3s_hv_ras.o \
 	book3s_hv_builtin.o \
-	book3s_hv_cma.o \
 	$(kvm-book3s_64-builtin-xics-objs-y)
 endif
 
diff -puN arch/powerpc/kvm/book3s_64_mmu_hv.c~ppc-kvm-cma-use-general-cma-reserved-area-management-framework arch/powerpc/kvm/book3s_64_mmu_hv.c
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c~ppc-kvm-cma-use-general-cma-reserved-area-management-framework
+++ a/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -37,8 +37,6 @@
 #include <asm/ppc-opcode.h>
 #include <asm/cputable.h>
 
-#include "book3s_hv_cma.h"
-
 /* POWER7 has 10-bit LPIDs, PPC970 has 6-bit LPIDs */
 #define MAX_LPID_970	63
 
@@ -64,10 +62,10 @@ long kvmppc_alloc_hpt(struct kvm *kvm, u
 	}
 
 	kvm->arch.hpt_cma_alloc = 0;
-	VM_BUG_ON(order < KVM_CMA_CHUNK_ORDER);
 	page = kvm_alloc_hpt(1 << (order - PAGE_SHIFT));
 	if (page) {
 		hpt = (unsigned long)pfn_to_kaddr(page_to_pfn(page));
+		memset((void *)hpt, 0, (1 << order));
 		kvm->arch.hpt_cma_alloc = 1;
 	}
 
diff -puN arch/powerpc/kvm/book3s_hv_builtin.c~ppc-kvm-cma-use-general-cma-reserved-area-management-framework arch/powerpc/kvm/book3s_hv_builtin.c
--- a/arch/powerpc/kvm/book3s_hv_builtin.c~ppc-kvm-cma-use-general-cma-reserved-area-management-framework
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -16,12 +16,14 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/sizes.h>
+#include <linux/cma.h>
 
 #include <asm/cputable.h>
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 
-#include "book3s_hv_cma.h"
+#define KVM_CMA_CHUNK_ORDER	18
+
 /*
  * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
  * should be power of 2.
@@ -43,6 +45,8 @@ static unsigned long kvm_cma_resv_ratio
 unsigned long kvm_rma_pages = (1 << 27) >> PAGE_SHIFT;	/* 128MB */
 EXPORT_SYMBOL_GPL(kvm_rma_pages);
 
+static struct cma *kvm_cma;
+
 /* Work out RMLS (real mode limit selector) field value for a given RMA size.
    Assumes POWER7 or PPC970. */
 static inline int lpcr_rmls(unsigned long rma_size)
@@ -97,7 +101,7 @@ struct kvm_rma_info *kvm_alloc_rma()
 	ri = kmalloc(sizeof(struct kvm_rma_info), GFP_KERNEL);
 	if (!ri)
 		return NULL;
-	page = kvm_alloc_cma(kvm_rma_pages, kvm_rma_pages);
+	page = cma_alloc(kvm_cma, kvm_rma_pages, get_order(kvm_rma_pages));
 	if (!page)
 		goto err_out;
 	atomic_set(&ri->use_count, 1);
@@ -112,7 +116,7 @@ EXPORT_SYMBOL_GPL(kvm_alloc_rma);
 void kvm_release_rma(struct kvm_rma_info *ri)
 {
 	if (atomic_dec_and_test(&ri->use_count)) {
-		kvm_release_cma(pfn_to_page(ri->base_pfn), kvm_rma_pages);
+		cma_release(kvm_cma, pfn_to_page(ri->base_pfn), kvm_rma_pages);
 		kfree(ri);
 	}
 }
@@ -131,16 +135,18 @@ struct page *kvm_alloc_hpt(unsigned long
 {
 	unsigned long align_pages = HPT_ALIGN_PAGES;
 
+	VM_BUG_ON(get_order(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
+
 	/* Old CPUs require HPT aligned on a multiple of its size */
 	if (!cpu_has_feature(CPU_FTR_ARCH_206))
 		align_pages = nr_pages;
-	return kvm_alloc_cma(nr_pages, align_pages);
+	return cma_alloc(kvm_cma, nr_pages, get_order(align_pages));
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_hpt);
 
 void kvm_release_hpt(struct page *page, unsigned long nr_pages)
 {
-	kvm_release_cma(page, nr_pages);
+	cma_release(kvm_cma, page, nr_pages);
 }
 EXPORT_SYMBOL_GPL(kvm_release_hpt);
 
@@ -179,7 +185,8 @@ void __init kvm_cma_reserve(void)
 			align_size = HPT_ALIGN_PAGES << PAGE_SHIFT;
 
 		align_size = max(kvm_rma_pages << PAGE_SHIFT, align_size);
-		kvm_cma_declare_contiguous(selected_size, align_size);
+		cma_declare_contiguous(selected_size, 0, 0, align_size,
+			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, &kvm_cma, false);
 	}
 }
 
diff -puN arch/powerpc/kvm/book3s_hv_cma.c~ppc-kvm-cma-use-general-cma-reserved-area-management-framework /dev/null
--- a/arch/powerpc/kvm/book3s_hv_cma.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Contiguous Memory Allocator for ppc KVM hash pagetable  based on CMA
- * for DMA mapping framework
- *
- * Copyright IBM Corporation, 2013
- * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License or (at your optional) any later version of the license.
- *
- */
-#define pr_fmt(fmt) "kvm_cma: " fmt
-
-#ifdef CONFIG_CMA_DEBUG
-#ifndef DEBUG
-#  define DEBUG
-#endif
-#endif
-
-#include <linux/memblock.h>
-#include <linux/mutex.h>
-#include <linux/sizes.h>
-#include <linux/slab.h>
-
-#include "book3s_hv_cma.h"
-
-struct kvm_cma {
-	unsigned long	base_pfn;
-	unsigned long	count;
-	unsigned long	*bitmap;
-};
-
-static DEFINE_MUTEX(kvm_cma_mutex);
-static struct kvm_cma kvm_cma_area;
-
-/**
- * kvm_cma_declare_contiguous() - reserve area for contiguous memory handling
- *			          for kvm hash pagetable
- * @size:  Size of the reserved memory.
- * @alignment:  Alignment for the contiguous memory area
- *
- * This function reserves memory for kvm cma area. It should be
- * called by arch code when early allocator (memblock or bootmem)
- * is still activate.
- */
-long __init kvm_cma_declare_contiguous(phys_addr_t size, phys_addr_t alignment)
-{
-	long base_pfn;
-	phys_addr_t addr;
-	struct kvm_cma *cma = &kvm_cma_area;
-
-	pr_debug("%s(size %lx)\n", __func__, (unsigned long)size);
-
-	if (!size)
-		return -EINVAL;
-	/*
-	 * Sanitise input arguments.
-	 * We should be pageblock aligned for CMA.
-	 */
-	alignment = max(alignment, (phys_addr_t)(PAGE_SIZE << pageblock_order));
-	size = ALIGN(size, alignment);
-	/*
-	 * Reserve memory
-	 * Use __memblock_alloc_base() since
-	 * memblock_alloc_base() panic()s.
-	 */
-	addr = __memblock_alloc_base(size, alignment, 0);
-	if (!addr) {
-		base_pfn = -ENOMEM;
-		goto err;
-	} else
-		base_pfn = PFN_DOWN(addr);
-
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	cma->base_pfn = base_pfn;
-	cma->count    = size >> PAGE_SHIFT;
-	pr_info("CMA: reserved %ld MiB\n", (unsigned long)size / SZ_1M);
-	return 0;
-err:
-	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
-	return base_pfn;
-}
-
-/**
- * kvm_alloc_cma() - allocate pages from contiguous area
- * @nr_pages: Requested number of pages.
- * @align_pages: Requested alignment in number of pages
- *
- * This function allocates memory buffer for hash pagetable.
- */
-struct page *kvm_alloc_cma(unsigned long nr_pages, unsigned long align_pages)
-{
-	int ret;
-	struct page *page = NULL;
-	struct kvm_cma *cma = &kvm_cma_area;
-	unsigned long chunk_count, nr_chunk;
-	unsigned long mask, pfn, pageno, start = 0;
-
-
-	if (!cma || !cma->count)
-		return NULL;
-
-	pr_debug("%s(cma %p, count %lu, align pages %lu)\n", __func__,
-		 (void *)cma, nr_pages, align_pages);
-
-	if (!nr_pages)
-		return NULL;
-	/*
-	 * align mask with chunk size. The bit tracks pages in chunk size
-	 */
-	VM_BUG_ON(!is_power_of_2(align_pages));
-	mask = (align_pages >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT)) - 1;
-	BUILD_BUG_ON(PAGE_SHIFT > KVM_CMA_CHUNK_ORDER);
-
-	chunk_count = cma->count >>  (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
-	nr_chunk = nr_pages >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
-
-	mutex_lock(&kvm_cma_mutex);
-	for (;;) {
-		pageno = bitmap_find_next_zero_area(cma->bitmap, chunk_count,
-						    start, nr_chunk, mask);
-		if (pageno >= chunk_count)
-			break;
-
-		pfn = cma->base_pfn + (pageno << (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT));
-		ret = alloc_contig_range(pfn, pfn + nr_pages, MIGRATE_CMA);
-		if (ret == 0) {
-			bitmap_set(cma->bitmap, pageno, nr_chunk);
-			page = pfn_to_page(pfn);
-			memset(pfn_to_kaddr(pfn), 0, nr_pages << PAGE_SHIFT);
-			break;
-		} else if (ret != -EBUSY) {
-			break;
-		}
-		pr_debug("%s(): memory range at %p is busy, retrying\n",
-			 __func__, pfn_to_page(pfn));
-		/* try again with a bit different memory target */
-		start = pageno + mask + 1;
-	}
-	mutex_unlock(&kvm_cma_mutex);
-	pr_debug("%s(): returned %p\n", __func__, page);
-	return page;
-}
-
-/**
- * kvm_release_cma() - release allocated pages for hash pagetable
- * @pages: Allocated pages.
- * @nr_pages: Number of allocated pages.
- *
- * This function releases memory allocated by kvm_alloc_cma().
- * It returns false when provided pages do not belong to contiguous area and
- * true otherwise.
- */
-bool kvm_release_cma(struct page *pages, unsigned long nr_pages)
-{
-	unsigned long pfn;
-	unsigned long nr_chunk;
-	struct kvm_cma *cma = &kvm_cma_area;
-
-	if (!cma || !pages)
-		return false;
-
-	pr_debug("%s(page %p count %lu)\n", __func__, (void *)pages, nr_pages);
-
-	pfn = page_to_pfn(pages);
-
-	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
-		return false;
-
-	VM_BUG_ON(pfn + nr_pages > cma->base_pfn + cma->count);
-	nr_chunk = nr_pages >>  (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
-
-	mutex_lock(&kvm_cma_mutex);
-	bitmap_clear(cma->bitmap,
-		     (pfn - cma->base_pfn) >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT),
-		     nr_chunk);
-	free_contig_range(pfn, nr_pages);
-	mutex_unlock(&kvm_cma_mutex);
-
-	return true;
-}
-
-static int __init kvm_cma_activate_area(unsigned long base_pfn,
-					unsigned long count)
-{
-	unsigned long pfn = base_pfn;
-	unsigned i = count >> pageblock_order;
-	struct zone *zone;
-
-	WARN_ON_ONCE(!pfn_valid(pfn));
-	zone = page_zone(pfn_to_page(pfn));
-	do {
-		unsigned j;
-		base_pfn = pfn;
-		for (j = pageblock_nr_pages; j; --j, pfn++) {
-			WARN_ON_ONCE(!pfn_valid(pfn));
-			/*
-			 * alloc_contig_range requires the pfn range
-			 * specified to be in the same zone. Make this
-			 * simple by forcing the entire CMA resv range
-			 * to be in the same zone.
-			 */
-			if (page_zone(pfn_to_page(pfn)) != zone)
-				return -EINVAL;
-		}
-		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
-	} while (--i);
-	return 0;
-}
-
-static int __init kvm_cma_init_reserved_areas(void)
-{
-	int bitmap_size, ret;
-	unsigned long chunk_count;
-	struct kvm_cma *cma = &kvm_cma_area;
-
-	pr_debug("%s()\n", __func__);
-	if (!cma->count)
-		return 0;
-	chunk_count = cma->count >> (KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
-	bitmap_size = BITS_TO_LONGS(chunk_count) * sizeof(long);
-	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!cma->bitmap)
-		return -ENOMEM;
-
-	ret = kvm_cma_activate_area(cma->base_pfn, cma->count);
-	if (ret)
-		goto error;
-	return 0;
-
-error:
-	kfree(cma->bitmap);
-	return ret;
-}
-core_initcall(kvm_cma_init_reserved_areas);
diff -puN arch/powerpc/kvm/book3s_hv_cma.h~ppc-kvm-cma-use-general-cma-reserved-area-management-framework /dev/null
--- a/arch/powerpc/kvm/book3s_hv_cma.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Contiguous Memory Allocator for ppc KVM hash pagetable  based on CMA
- * for DMA mapping framework
- *
- * Copyright IBM Corporation, 2013
- * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License or (at your optional) any later version of the license.
- *
- */
-
-#ifndef __POWERPC_KVM_CMA_ALLOC_H__
-#define __POWERPC_KVM_CMA_ALLOC_H__
-/*
- * Both RMA and Hash page allocation will be multiple of 256K.
- */
-#define KVM_CMA_CHUNK_ORDER	18
