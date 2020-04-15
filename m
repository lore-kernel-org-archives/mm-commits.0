From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-mapping-use-vmap-insted-of-reimplementing-it.patch
 added to -mm tree
Date: Tue, 14 Apr 2020 21:46:49 -0700
Message-ID: <20200415044649.TNJHuHs-p%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393112AbgDOEqx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:46:53 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: dma-mapping: use vmap insted of reimplementing it
has been added to the -mm tree.  Its filename is
     dma-mapping-use-vmap-insted-of-reimplementing-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-use-vmap-insted-of-reimplementing-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-use-vmap-insted-of-reimplementing-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: dma-mapping: use vmap insted of reimplementing it

Replace the open coded instance of vmap with the actual function.  In
the non-contiguous (IOMMU) case this requires an extra find_vm_area,
but given that this isn't a fast path function that is a small price
to pay.

Link: http://lkml.kernel.org/r/20200414131348.444715-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/remap.c |   48 ++++++++++---------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

--- a/kernel/dma/remap.c~dma-mapping-use-vmap-insted-of-reimplementing-it
+++ a/kernel/dma/remap.c
@@ -20,23 +20,6 @@ struct page **dma_common_find_pages(void
 	return area->pages;
 }
 
-static struct vm_struct *__dma_common_pages_remap(struct page **pages,
-			size_t size, pgprot_t prot, const void *caller)
-{
-	struct vm_struct *area;
-
-	area = get_vm_area_caller(size, VM_DMA_COHERENT, caller);
-	if (!area)
-		return NULL;
-
-	if (map_vm_area(area, prot, pages)) {
-		vunmap(area->addr);
-		return NULL;
-	}
-
-	return area;
-}
-
 /*
  * Remaps an array of PAGE_SIZE pages into another vm_area.
  * Cannot be used in non-sleeping contexts
@@ -44,15 +27,12 @@ static struct vm_struct *__dma_common_pa
 void *dma_common_pages_remap(struct page **pages, size_t size,
 			 pgprot_t prot, const void *caller)
 {
-	struct vm_struct *area;
+	void *vaddr;
 
-	area = __dma_common_pages_remap(pages, size, prot, caller);
-	if (!area)
-		return NULL;
-
-	area->pages = pages;
-
-	return area->addr;
+	vaddr = vmap(pages, size >> PAGE_SHIFT, VM_DMA_COHERENT, prot);
+	if (vaddr)
+		find_vm_area(vaddr)->pages = pages;
+	return vaddr;
 }
 
 /*
@@ -62,24 +42,20 @@ void *dma_common_pages_remap(struct page
 void *dma_common_contiguous_remap(struct page *page, size_t size,
 			pgprot_t prot, const void *caller)
 {
-	int i;
+	int count = size >> PAGE_SHIFT;
 	struct page **pages;
-	struct vm_struct *area;
+	void *vaddr;
+	int i;
 
-	pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
+	pages = kmalloc_array(count, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return NULL;
-
-	for (i = 0; i < (size >> PAGE_SHIFT); i++)
+	for (i = 0; i < count; i++)
 		pages[i] = nth_page(page, i);
-
-	area = __dma_common_pages_remap(pages, size, prot, caller);
-
+	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kfree(pages);
 
-	if (!area)
-		return NULL;
-	return area->addr;
+	return vaddr;
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
