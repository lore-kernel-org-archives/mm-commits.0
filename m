From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch added to
 -mm tree
Date: Mon, 18 May 2020 18:13:19 -0700
Message-ID: <20200519011319.enXki-nbt%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgESBNW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 21:13:22 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, alexander.shishkin@linux.intel.com, aou@eecs.berkeley.edu, arnd@arndb.de, benh@kernel.crashing.org, deanbo422@gmail.com, fenghua.yu@intel.com, geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de, ink@jurassic.park.msu.ru, jolsa@redhat.com, jonas@southpole.se, mark.rutland@arm.com, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, namhyung@kernel.org, palmer@sifive.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, rth@twiddle.net, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, tony.luck@intel.com


The patch titled
     Subject: mm: rename flush_icache_user_range to flush_icache_user_page
has been added to the -mm tree.  Its filename is
     mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch

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
Subject: mm: rename flush_icache_user_range to flush_icache_user_page

The function currently known as flush_icache_user_range only operates
on a single page.  Rename it to flush_icache_user_page as we'll need
the name flush_icache_user_range for something else soon.

Link: http://lkml.kernel.org/r/20200515143646.3857579-20-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h    |   10 +++++-----
 arch/alpha/kernel/smp.c                |    2 +-
 arch/ia64/include/asm/cacheflush.h     |    2 +-
 arch/m68k/include/asm/cacheflush_mm.h  |    4 ++--
 arch/m68k/mm/cache.c                   |    2 +-
 arch/nds32/include/asm/cacheflush.h    |    4 ++--
 arch/nds32/mm/cacheflush.c             |    2 +-
 arch/openrisc/include/asm/cacheflush.h |    2 +-
 arch/powerpc/include/asm/cacheflush.h  |    4 ++--
 arch/powerpc/mm/mem.c                  |    2 +-
 arch/riscv/include/asm/cacheflush.h    |    3 ++-
 include/asm-generic/cacheflush.h       |    6 +++---
 kernel/events/uprobes.c                |    2 +-
 13 files changed, 23 insertions(+), 22 deletions(-)

--- a/arch/alpha/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -35,7 +35,7 @@ extern void smp_imb(void);
 
 extern void __load_new_mm_context(struct mm_struct *);
 static inline void
-flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			unsigned long addr, int len)
 {
 	if (vma->vm_flags & VM_EXEC) {
@@ -46,16 +46,16 @@ flush_icache_user_range(struct vm_area_s
 			mm->context[smp_processor_id()] = 0;
 	}
 }
-#define flush_icache_user_range flush_icache_user_range
+#define flush_icache_user_page flush_icache_user_page
 #else /* CONFIG_SMP */
-extern void flush_icache_user_range(struct vm_area_struct *vma,
+extern void flush_icache_user_page(struct vm_area_struct *vma,
 		struct page *page, unsigned long addr, int len);
-#define flush_icache_user_range flush_icache_user_range
+#define flush_icache_user_page flush_icache_user_page
 #endif /* CONFIG_SMP */
 
 /* This is used only in __do_fault and do_swap_page.  */
 #define flush_icache_page(vma, page) \
-	flush_icache_user_range((vma), (page), 0, 0)
+	flush_icache_user_page((vma), (page), 0, 0)
 
 #include <asm-generic/cacheflush.h>
 
--- a/arch/alpha/kernel/smp.c~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/alpha/kernel/smp.c
@@ -739,7 +739,7 @@ ipi_flush_icache_page(void *x)
 }
 
 void
-flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			unsigned long addr, int len)
 {
 	struct mm_struct *mm = vma->vm_mm;
--- a/arch/ia64/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/ia64/include/asm/cacheflush.h
@@ -22,7 +22,7 @@ extern void flush_icache_range(unsigned
 #define flush_icache_range flush_icache_range
 extern void clflush_cache_range(void *addr, int size);
 
-#define flush_icache_user_range(vma, page, user_addr, len)					\
+#define flush_icache_user_page(vma, page, user_addr, len)					\
 do {												\
 	unsigned long _addr = (unsigned long) page_address(page) + ((user_addr) & ~PAGE_MASK);	\
 	flush_icache_range(_addr, _addr + (len));						\
--- a/arch/m68k/include/asm/cacheflush_mm.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/m68k/include/asm/cacheflush_mm.h
@@ -254,7 +254,7 @@ static inline void __flush_page_to_ram(v
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_page(vma, page)	__flush_page_to_ram(page_address(page))
 
-extern void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+extern void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 				    unsigned long addr, int len);
 extern void flush_icache_range(unsigned long address, unsigned long endaddr);
 
@@ -264,7 +264,7 @@ static inline void copy_to_user_page(str
 {
 	flush_cache_page(vma, vaddr, page_to_pfn(page));
 	memcpy(dst, src, len);
-	flush_icache_user_range(vma, page, vaddr, len);
+	flush_icache_user_page(vma, page, vaddr, len);
 }
 static inline void copy_from_user_page(struct vm_area_struct *vma,
 				       struct page *page, unsigned long vaddr,
--- a/arch/m68k/mm/cache.c~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/m68k/mm/cache.c
@@ -106,7 +106,7 @@ void flush_icache_range(unsigned long ad
 }
 EXPORT_SYMBOL(flush_icache_range);
 
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			     unsigned long addr, int len)
 {
 	if (CPU_IS_COLDFIRE) {
--- a/arch/nds32/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/nds32/include/asm/cacheflush.h
@@ -44,9 +44,9 @@ void invalidate_kernel_vmap_range(void *
 #define flush_dcache_mmap_unlock(mapping) xa_unlock_irq(&(mapping)->i_pages)
 
 #else
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 	                     unsigned long addr, int len);
-#define flush_icache_user_range flush_icache_user_range
+#define flush_icache_user_page flush_icache_user_page
 
 #include <asm-generic/cacheflush.h>
 #endif
--- a/arch/nds32/mm/cacheflush.c~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/nds32/mm/cacheflush.c
@@ -36,7 +36,7 @@ void flush_icache_page(struct vm_area_st
 	local_irq_restore(flags);
 }
 
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 	                     unsigned long addr, int len)
 {
 	unsigned long kaddr;
--- a/arch/openrisc/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/openrisc/include/asm/cacheflush.h
@@ -62,7 +62,7 @@ static inline void flush_dcache_page(str
 	clear_bit(PG_dc_clean, &page->flags);
 }
 
-#define flush_icache_user_range(vma, page, addr, len)	\
+#define flush_icache_user_page(vma, page, addr, len)	\
 do {							\
 	if (vma->vm_flags & VM_EXEC)			\
 		sync_icache_dcache(page);		\
--- a/arch/powerpc/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/powerpc/include/asm/cacheflush.h
@@ -28,9 +28,9 @@ extern void flush_dcache_page(struct pag
 void flush_icache_range(unsigned long start, unsigned long stop);
 #define flush_icache_range flush_icache_range
 
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 		unsigned long addr, int len);
-#define flush_icache_user_range flush_icache_user_range
+#define flush_icache_user_page flush_icache_user_page
 
 void flush_dcache_icache_page(struct page *page);
 void __flush_dcache_icache(void *page);
--- a/arch/powerpc/mm/mem.c~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/powerpc/mm/mem.c
@@ -574,7 +574,7 @@ void copy_user_page(void *vto, void *vfr
 	flush_dcache_page(pg);
 }
 
-void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			     unsigned long addr, int len)
 {
 	unsigned long maddr;
--- a/arch/riscv/include/asm/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/arch/riscv/include/asm/cacheflush.h
@@ -27,7 +27,8 @@ static inline void flush_dcache_page(str
  * so instead we just flush the whole thing.
  */
 #define flush_icache_range(start, end) flush_icache_all()
-#define flush_icache_user_range(vma, pg, addr, len) flush_icache_mm(vma->vm_mm, 0)
+#define flush_icache_user_page(vma, pg, addr, len) \
+	flush_icache_mm(vma->vm_mm, 0)
 
 #ifndef CONFIG_SMP
 
--- a/include/asm-generic/cacheflush.h~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/include/asm-generic/cacheflush.h
@@ -73,8 +73,8 @@ static inline void flush_icache_page(str
 }
 #endif
 
-#ifndef flush_icache_user_range
-static inline void flush_icache_user_range(struct vm_area_struct *vma,
+#ifndef flush_icache_user_page
+static inline void flush_icache_user_page(struct vm_area_struct *vma,
 					   struct page *page,
 					   unsigned long addr, int len)
 {
@@ -97,7 +97,7 @@ static inline void flush_cache_vunmap(un
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
 	do { \
 		memcpy(dst, src, len); \
-		flush_icache_user_range(vma, page, vaddr, len); \
+		flush_icache_user_page(vma, page, vaddr, len); \
 	} while (0)
 #endif
 
--- a/kernel/events/uprobes.c~mm-rename-flush_icache_user_range-to-flush_icache_user_page
+++ a/kernel/events/uprobes.c
@@ -1668,7 +1668,7 @@ void __weak arch_uprobe_copy_ixol(struct
 	copy_to_page(page, vaddr, src, len);
 
 	/*
-	 * We probably need flush_icache_user_range() but it needs vma.
+	 * We probably need flush_icache_user_page() but it needs vma.
 	 * This should work on most of architectures by default. If
 	 * architecture needs to do something different it can define
 	 * its own version of the function.
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
