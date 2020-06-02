From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:41:56 -0700
Message-ID: <20200602214156.i8b32m3ZQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFBVmA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: mm: remove vmap_page_range_noflush and vunmap_page_range
has been removed from the -mm tree.  Its filename was
     mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -128,10 +128,24 @@ static void vunmap_p4d_range(pgd_t *pgd,
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
@@ -220,18 +234,30 @@ static int vmap_p4d_range(pgd_t *pgd, un
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
 
@@ -252,7 +278,7 @@ static int vmap_page_range(unsigned long
 {
 	int ret;
 
-	ret = vmap_page_range_noflush(start, end, prot, pages);
+	ret = map_kernel_range_noflush(start, end - start, prot, pages);
 	flush_cache_vmap(start, end);
 	return ret;
 }
@@ -1227,7 +1253,7 @@ EXPORT_SYMBOL_GPL(unregister_vmap_purge_
  */
 static void unmap_vmap_area(struct vmap_area *va)
 {
-	vunmap_page_range(va->va_start, va->va_end);
+	unmap_kernel_range_noflush(va->va_start, va->va_end - va->va_start);
 }
 
 /*
@@ -1687,7 +1713,7 @@ static void vb_free(unsigned long addr,
 	rcu_read_unlock();
 	BUG_ON(!vb);
 
-	vunmap_page_range(addr, addr + size);
+	unmap_kernel_range_noflush(addr, size);
 
 	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(addr, addr + size);
@@ -1986,50 +2012,6 @@ void __init vmalloc_init(void)
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
@@ -2042,7 +2024,7 @@ void unmap_kernel_range(unsigned long ad
 	unsigned long end = addr + size;
 
 	flush_cache_vunmap(addr, end);
-	vunmap_page_range(addr, end);
+	unmap_kernel_range_noflush(addr, size);
 	flush_tlb_kernel_range(addr, end);
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch
nds32-unexport-flush_icache_page.patch
powerpc-unexport-flush_icache_user_range.patch
unicore32-remove-flush_cache_user_range.patch
asm-generic-fix-the-inclusion-guards-for-cacheflushh.patch
asm-generic-dont-include-linux-mmh-in-cacheflushh.patch
asm-generic-dont-include-linux-mmh-in-cacheflushh-fix.patch
asm-generic-improve-the-flush_dcache_page-stub.patch
alpha-use-asm-generic-cacheflushh.patch
arm64-use-asm-generic-cacheflushh.patch
c6x-use-asm-generic-cacheflushh.patch
hexagon-use-asm-generic-cacheflushh.patch
ia64-use-asm-generic-cacheflushh.patch
microblaze-use-asm-generic-cacheflushh.patch
m68knommu-use-asm-generic-cacheflushh.patch
openrisc-use-asm-generic-cacheflushh.patch
powerpc-use-asm-generic-cacheflushh.patch
riscv-use-asm-generic-cacheflushh.patch
armsparcunicore32-remove-flush_icache_user_range.patch
mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch
asm-generic-add-a-flush_icache_user_range-stub.patch
sh-implement-flush_icache_user_range.patch
xtensa-implement-flush_icache_user_range.patch
arm-rename-flush_cache_user_range-to-flush_icache_user_range.patch
m68k-implement-flush_icache_user_range.patch
exec-only-build-read_code-when-needed.patch
exec-use-flush_icache_user_range-in-read_code.patch
binfmt_flat-use-flush_icache_user_range.patch
nommu-use-flush_icache_user_range-in-brk-and-mmap.patch
module-move-the-set_fs-hack-for-flush_icache_range-to-m68k.patch
maccess-unexport-probe_kernel_write-and-probe_user_write.patch
maccess-remove-various-unused-weak-aliases.patch
maccess-remove-duplicate-kerneldoc-comments.patch
maccess-clarify-kerneldoc-comments.patch
maccess-update-the-top-of-file-comment.patch
maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault.patch
maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault.patch
maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault.patch
maccess-remove-probe_read_common-and-probe_write_common.patch
maccess-unify-the-probe-kernel-arch-hooks.patch
bpf-factor-out-a-bpf_trace_copy_string-helper.patch
bpf-handle-the-compat-string-in-bpf_trace_copy_string-better.patch
bpf-rework-the-compat-kernel-probe-handling.patch
tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch
maccess-remove-strncpy_from_unsafe.patch
maccess-always-use-strict-semantics-for-probe_kernel_read.patch
maccess-move-user-access-routines-together.patch
maccess-allow-architectures-to-provide-kernel-probing-directly.patch
x86-use-non-set_fs-based-maccess-routines.patch
maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails.patch
