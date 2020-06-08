From: akpm@linux-foundation.org
Subject: [merged] arm64-use-asm-generic-cacheflushh.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:32:45 -0700
Message-ID: <20200608223245.cTi06irxn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWcq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, hch@lst.de, mm-commits@vger.kernel.org, will@kernel.org


The patch titled
     Subject: arm64: use asm-generic/cacheflush.h
has been removed from the -mm tree.  Its filename was
     arm64-use-asm-generic-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arm64: use asm-generic/cacheflush.h

ARM64 needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |   46 ++------------------------
 1 file changed, 5 insertions(+), 41 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~arm64-use-asm-generic-cacheflushh
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -94,20 +94,7 @@ static inline void flush_icache_range(un
 
 	kick_all_cpus_sync();
 }
-
-static inline void flush_cache_mm(struct mm_struct *mm)
-{
-}
-
-static inline void flush_cache_page(struct vm_area_struct *vma,
-				    unsigned long user_addr, unsigned long pfn)
-{
-}
-
-static inline void flush_cache_range(struct vm_area_struct *vma,
-				     unsigned long start, unsigned long end)
-{
-}
+#define flush_icache_range flush_icache_range
 
 /*
  * Cache maintenance functions used by the DMA API. No to be used directly.
@@ -123,12 +110,7 @@ extern void __dma_flush_area(const void
  */
 extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 	unsigned long, void *, const void *, unsigned long);
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	do {							\
-		memcpy(dst, src, len);				\
-	} while (0)
-
-#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+#define copy_to_user_page copy_to_user_page
 
 /*
  * flush_dcache_page is used when the kernel has written to the page
@@ -154,29 +136,11 @@ static __always_inline void __flush_icac
 	dsb(ish);
 }
 
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-
-/*
- * We don't appear to need to do anything here.  In fact, if we did, we'd
- * duplicate cache flushing elsewhere performed by flush_dcache_page().
- */
-#define flush_icache_page(vma,page)	do { } while (0)
-
-/*
- * Not required on AArch64 (PIPT or VIPT non-aliasing D-cache).
- */
-static inline void flush_cache_vmap(unsigned long start, unsigned long end)
-{
-}
-
-static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
-{
-}
-
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 
-#endif
+#include <asm-generic/cacheflush.h>
+
+#endif /* __ASM_CACHEFLUSH_H */
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
