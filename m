From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch added to -mm
 tree
Date: Tue, 14 Apr 2020 21:47:20 -0700
Message-ID: <20200415044720.QNd_yiT8U%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393123AbgDOErX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:47:23 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: mm: remove vmap_page_range_noflush and vunmap_page_range
has been added to the -mm tree.  Its filename is
     mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch

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
Subject: mm: remove vmap_page_range_noflush and vunmap_page_range

These have non-static aliases called map_kernel_range_noflush and
unmap_kernel_range_noflush that just differ slightly in the calling
conventions that pass addr + size instead of an end.

Link: http://lkml.kernel.org/r/20200414131348.444715-14-hch@lst.de
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

 mm/vmalloc.c |   98 ++++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 58 deletions(-)

--- a/mm/vmalloc.c~mm-remove-vmap_page_range_noflush-and-vunmap_page_range
+++ a/mm/vmalloc.c
@@ -127,10 +127,24 @@ static void vunmap_p4d_range(pgd_t *pgd,
 	} while (p4d++, addr = next, addr != end);
 }
 
-static void vunmap_page_range(unsigned long addr, unsigned long end)
+/**
+ * unmap_kernel_range_noflush - unmap kernel VM area
+ * @addr: start of the VM area to unmap
+ * @size: size of the VM area to unmap
+ *
+ * Unmap PFN_UP(@size) pages at @addr.  The VM area @addr and @size specify
+ * should have been allocated using get_vm_area() and its friends.
+ *
+ * NOTE:
+ * This function does NOT do any cache flushing.  The caller is responsible
+ * for calling flush_cache_vunmap() on to-be-mapped areas before calling this
+ * function and flush_tlb_kernel_range() after.
+ */
+void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
 {
-	pgd_t *pgd;
+	unsigned long end = addr + size;
 	unsigned long next;
+	pgd_t *pgd;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset_k(addr);
@@ -219,18 +233,30 @@ static int vmap_p4d_range(pgd_t *pgd, un
 	return 0;
 }
 
-/*
- * Set up page tables in kva (addr, end). The ptes shall have prot "prot", and
- * will have pfns corresponding to the "pages" array.
+/**
+ * map_kernel_range_noflush - map kernel VM area with the specified pages
+ * @addr: start of the VM area to map
+ * @size: size of the VM area to map
+ * @prot: page protection flags to use
+ * @pages: pages to map
  *
- * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
+ * Map PFN_UP(@size) pages at @addr.  The VM area @addr and @size specify should
+ * have been allocated using get_vm_area() and its friends.
+ *
+ * NOTE:
+ * This function does NOT do any cache flushing.  The caller is responsible for
+ * calling flush_cache_vmap() on to-be-mapped areas before calling this
+ * function.
+ *
+ * RETURNS:
+ * The number of pages mapped on success, -errno on failure.
  */
-static int vmap_page_range_noflush(unsigned long start, unsigned long end,
-				   pgprot_t prot, struct page **pages)
+int map_kernel_range_noflush(unsigned long addr, unsigned long size,
+			     pgprot_t prot, struct page **pages)
 {
-	pgd_t *pgd;
+	unsigned long end = addr + size;
 	unsigned long next;
-	unsigned long addr = start;
+	pgd_t *pgd;
 	int err = 0;
 	int nr = 0;
 
@@ -251,7 +277,7 @@ static int vmap_page_range(unsigned long
 {
 	int ret;
 
-	ret = vmap_page_range_noflush(start, end, prot, pages);
+	ret = map_kernel_range_noflush(start, end - start, prot, pages);
 	flush_cache_vmap(start, end);
 	return ret;
 }
@@ -1226,7 +1252,7 @@ EXPORT_SYMBOL_GPL(unregister_vmap_purge_
  */
 static void unmap_vmap_area(struct vmap_area *va)
 {
-	vunmap_page_range(va->va_start, va->va_end);
+	unmap_kernel_range_noflush(va->va_start, va->va_end - va->va_start);
 }
 
 /*
@@ -1686,7 +1712,7 @@ static void vb_free(unsigned long addr,
 	rcu_read_unlock();
 	BUG_ON(!vb);
 
-	vunmap_page_range(addr, addr + size);
+	unmap_kernel_range_noflush(addr, size);
 
 	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(addr, addr + size);
@@ -1985,50 +2011,6 @@ void __init vmalloc_init(void)
 }
 
 /**
- * map_kernel_range_noflush - map kernel VM area with the specified pages
- * @addr: start of the VM area to map
- * @size: size of the VM area to map
- * @prot: page protection flags to use
- * @pages: pages to map
- *
- * Map PFN_UP(@size) pages at @addr.  The VM area @addr and @size
- * specify should have been allocated using get_vm_area() and its
- * friends.
- *
- * NOTE:
- * This function does NOT do any cache flushing.  The caller is
- * responsible for calling flush_cache_vmap() on to-be-mapped areas
- * before calling this function.
- *
- * RETURNS:
- * The number of pages mapped on success, -errno on failure.
- */
-int map_kernel_range_noflush(unsigned long addr, unsigned long size,
-			     pgprot_t prot, struct page **pages)
-{
-	return vmap_page_range_noflush(addr, addr + size, prot, pages);
-}
-
-/**
- * unmap_kernel_range_noflush - unmap kernel VM area
- * @addr: start of the VM area to unmap
- * @size: size of the VM area to unmap
- *
- * Unmap PFN_UP(@size) pages at @addr.  The VM area @addr and @size
- * specify should have been allocated using get_vm_area() and its
- * friends.
- *
- * NOTE:
- * This function does NOT do any cache flushing.  The caller is
- * responsible for calling flush_cache_vunmap() on to-be-mapped areas
- * before calling this function and flush_tlb_kernel_range() after.
- */
-void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
-{
-	vunmap_page_range(addr, addr + size);
-}
-
-/**
  * unmap_kernel_range - unmap kernel VM area and flush cache and TLB
  * @addr: start of the VM area to unmap
  * @size: size of the VM area to unmap
@@ -2041,7 +2023,7 @@ void unmap_kernel_range(unsigned long ad
 	unsigned long end = addr + size;
 
 	flush_cache_vunmap(addr, end);
-	vunmap_page_range(addr, end);
+	unmap_kernel_range_noflush(addr, size);
 	flush_tlb_kernel_range(addr, end);
 }
 
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
