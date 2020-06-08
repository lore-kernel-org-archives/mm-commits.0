From: akpm@linux-foundation.org
Subject: [merged] alpha-use-asm-generic-cacheflushh.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:32:43 -0700
Message-ID: <20200608223243.nBQHdkq6I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWcp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ink@jurassic.park.msu.ru, mattst88@gmail.com, mm-commits@vger.kernel.org, rth@twiddle.net


The patch titled
     Subject: alpha: use asm-generic/cacheflush.h
has been removed from the -mm tree.  Its filename was
     alpha-use-asm-generic-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: alpha: use asm-generic/cacheflush.h

Alpha needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h |   28 +++++---------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

--- a/arch/alpha/include/asm/cacheflush.h~alpha-use-asm-generic-cacheflushh
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -4,19 +4,6 @@
 
 #include <linux/mm.h>
 
-/* Caches aren't brain-dead on the Alpha. */
-#define flush_cache_all()			do { } while (0)
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_dup_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
-#define flush_dcache_page(page)			do { } while (0)
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_cache_vmap(start, end)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
-
 /* Note that the following two definitions are _highly_ dependent
    on the contexts in which they are used in the kernel.  I personally
    think it is criminal how loosely defined these macros are.  */
@@ -59,20 +46,17 @@ flush_icache_user_range(struct vm_area_s
 			mm->context[smp_processor_id()] = 0;
 	}
 }
-#else
+#define flush_icache_user_range flush_icache_user_range
+#else /* CONFIG_SMP */
 extern void flush_icache_user_range(struct vm_area_struct *vma,
 		struct page *page, unsigned long addr, int len);
-#endif
+#define flush_icache_user_range flush_icache_user_range
+#endif /* CONFIG_SMP */
 
 /* This is used only in __do_fault and do_swap_page.  */
 #define flush_icache_page(vma, page) \
-  flush_icache_user_range((vma), (page), 0, 0)
+	flush_icache_user_range((vma), (page), 0, 0)
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-do { memcpy(dst, src, len); \
-     flush_icache_user_range(vma, page, vaddr, len); \
-} while (0)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+#include <asm-generic/cacheflush.h>
 
 #endif /* _ALPHA_CACHEFLUSH_H */
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
