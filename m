From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-use-asm-generic-cacheflushh.patch added to -mm
 tree
Date: Mon, 18 May 2020 18:13:02 -0700
Message-ID: <20200519011302.i9ZXPLVQL%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgESBNE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 21:13:04 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: use asm-generic/cacheflush.h
has been added to the -mm tree.  Its filename is
     hexagon-use-asm-generic-cacheflushh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexagon-use-asm-generic-cacheflushh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexagon-use-asm-generic-cacheflushh.patch

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
Subject: hexagon: use asm-generic/cacheflush.h

Hexagon needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Brian Cain <bcain@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/cacheflush.h |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/arch/hexagon/include/asm/cacheflush.h~hexagon-use-asm-generic-cacheflushh
+++ a/arch/hexagon/include/asm/cacheflush.h
@@ -25,29 +25,17 @@
 #define LINESIZE	32
 #define LINEBITS	5
 
-#define flush_cache_all()			do { } while (0)
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_dup_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define flush_dcache_page(page)			do { } while (0)
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_icache_page(vma, pg)		do { } while (0)
-#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
-#define flush_cache_vmap(start, end)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
-
 /*
  * Flush Dcache range through current map.
  */
 extern void flush_dcache_range(unsigned long start, unsigned long end);
+#define flush_dcache_range flush_dcache_range
 
 /*
  * Flush Icache range through current map.
  */
 extern void flush_icache_range(unsigned long start, unsigned long end);
+#define flush_icache_range flush_icache_range
 
 /*
  * Memory-management related flushes are there to ensure in non-physically
@@ -78,6 +66,7 @@ static inline void update_mmu_cache(stru
 
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long vaddr, void *dst, void *src, int len);
+#define copy_to_user_page copy_to_user_page
 
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
@@ -85,4 +74,6 @@ void copy_to_user_page(struct vm_area_st
 extern void hexagon_inv_dcache_range(unsigned long start, unsigned long end);
 extern void hexagon_clean_dcache_range(unsigned long start, unsigned long end);
 
+#include <asm-generic/cacheflush.h>
+
 #endif
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
