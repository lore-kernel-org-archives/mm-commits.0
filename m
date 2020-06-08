From: akpm@linux-foundation.org
Subject: [merged] openrisc-use-asm-generic-cacheflushh.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 15:32:59 -0700
Message-ID: <20200608223259.XngcSb1KX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jonas@southpole.se, mm-commits@vger.kernel.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi


The patch titled
     Subject: openrisc: use asm-generic/cacheflush.h
has been removed from the -mm tree.  Its filename was
     openrisc-use-asm-generic-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: openrisc: use asm-generic/cacheflush.h

OpenRISC needs almost no cache flushing routines of its own.  Rely on
asm-generic/cacheflush.h for the defaults.

Link: http://lkml.kernel.org/r/20200515143646.3857579-16-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/cacheflush.h |   31 ++++-------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/arch/openrisc/include/asm/cacheflush.h~openrisc-use-asm-generic-cacheflushh
+++ a/arch/openrisc/include/asm/cacheflush.h
@@ -62,31 +62,12 @@ static inline void flush_dcache_page(str
 	clear_bit(PG_dc_clean, &page->flags);
 }
 
-/*
- * Other interfaces are not required since we do not have virtually
- * indexed or tagged caches. So we can use the default here.
- */
-#define flush_cache_all()				do { } while (0)
-#define flush_cache_mm(mm)				do { } while (0)
-#define flush_cache_dup_mm(mm)				do { } while (0)
-#define flush_cache_range(vma, start, end)		do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)		do { } while (0)
-#define flush_dcache_mmap_lock(mapping)			do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)		do { } while (0)
-#define flush_icache_range(start, end)			do { } while (0)
-#define flush_icache_page(vma, pg)			do { } while (0)
-#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
-#define flush_cache_vmap(start, end)			do { } while (0)
-#define flush_cache_vunmap(start, end)			do { } while (0)
+#define flush_icache_user_range(vma, page, addr, len)	\
+do {							\
+	if (vma->vm_flags & VM_EXEC)			\
+		sync_icache_dcache(page);		\
+} while (0)
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len)           \
-	do {                                                         \
-		memcpy(dst, src, len);                               \
-		if (vma->vm_flags & VM_EXEC)                         \
-			sync_icache_dcache(page);                    \
-	} while (0)
-
-#define copy_from_user_page(vma, page, vaddr, dst, src, len)         \
-	memcpy(dst, src, len)
+#include <asm-generic/cacheflush.h>
 
 #endif /* __ASM_CACHEFLUSH_H */
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
