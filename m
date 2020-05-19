From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-use-asm-generic-cacheflushh.patch added to -mm
 tree
Date: Mon, 18 May 2020 18:13:12 -0700
Message-ID: <20200519011312.jGcpu6VFQ%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgESBNO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 21:13:14 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, hch@lst.de, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org


The patch titled
     Subject: powerpc: use asm-generic/cacheflush.h
has been added to the -mm tree.  Its filename is
     powerpc-use-asm-generic-cacheflushh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-use-asm-generic-cacheflushh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-use-asm-generic-cacheflushh.patch

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
Subject: powerpc: use asm-generic/cacheflush.h

Power needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Also remove the pointless __KERNEL__ ifdef while we're at it.

Link: http://lkml.kernel.org/r/20200515143646.3857579-17-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/cacheflush.h |   42 +++++-------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

--- a/arch/powerpc/include/asm/cacheflush.h~powerpc-use-asm-generic-cacheflushh
+++ a/arch/powerpc/include/asm/cacheflush.h
@@ -4,23 +4,9 @@
 #ifndef _ASM_POWERPC_CACHEFLUSH_H
 #define _ASM_POWERPC_CACHEFLUSH_H
 
-#ifdef __KERNEL__
-
 #include <linux/mm.h>
 #include <asm/cputable.h>
 
-/*
- * No cache flushing is required when address mappings are changed,
- * because the caches on PowerPCs are physically addressed.
- */
-#define flush_cache_all()			do { } while (0)
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_dup_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-#define flush_icache_page(vma, page)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
-
 #ifdef CONFIG_PPC_BOOK3S_64
 /*
  * Book3s has no ptesync after setting a pte, so without this ptesync it's
@@ -33,20 +19,20 @@ static inline void flush_cache_vmap(unsi
 {
 	asm volatile("ptesync" ::: "memory");
 }
-#else
-static inline void flush_cache_vmap(unsigned long start, unsigned long end) { }
-#endif
+#define flush_cache_vmap flush_cache_vmap
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
 void flush_icache_range(unsigned long start, unsigned long stop);
-extern void flush_icache_user_range(struct vm_area_struct *vma,
-				    struct page *page, unsigned long addr,
-				    int len);
-extern void flush_dcache_icache_page(struct page *page);
+#define flush_icache_range flush_icache_range
+
+void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+		unsigned long addr, int len);
+#define flush_icache_user_range flush_icache_user_range
+
+void flush_dcache_icache_page(struct page *page);
 void __flush_dcache_icache(void *page);
 
 /**
@@ -111,14 +97,6 @@ static inline void invalidate_dcache_ran
 	mb();	/* sync */
 }
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	do { \
-		memcpy(dst, src, len); \
-		flush_icache_user_range(vma, page, vaddr, len); \
-	} while (0)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-
-#endif /* __KERNEL__ */
+#include <asm-generic/cacheflush.h>
 
 #endif /* _ASM_POWERPC_CACHEFLUSH_H */
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
