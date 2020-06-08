From: akpm@linux-foundation.org
Subject: [merged]
 mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:33:09 -0700
Message-ID: <20200608223309.U22t5Ncuy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, alexander.shishkin@linux.intel.com, aou@eecs.berkeley.edu, arnd@arndb.de, benh@kernel.crashing.org, deanbo422@gmail.com, fenghua.yu@intel.com, geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de, ink@jurassic.park.msu.ru, jolsa@redhat.com, jonas@southpole.se, mark.rutland@arm.com, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, namhyung@kernel.org, palmer@sifive.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, rth@twiddle.net, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, tony.luck@intel.com


The patch titled
     Subject: mm: rename flush_icache_user_range to flush_icache_user_page
has been removed from the -mm tree.  Its filename was
     mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -740,7 +740,7 @@ ipi_flush_icache_page(void *x)
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
@@ -577,7 +577,7 @@ void copy_user_page(void *vto, void *vfr
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

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
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
