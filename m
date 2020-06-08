From: akpm@linux-foundation.org
Subject: [merged]
 armsparcunicore32-remove-flush_icache_user_range.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 15:33:07 -0700
Message-ID: <20200608223307.NefLiTKen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, gxt@pku.edu.cn, hch@lst.de, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm,sparc,unicore32: remove flush_icache_user_range
has been removed from the -mm tree.  Its filename was
     armsparcunicore32-remove-flush_icache_user_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arm,sparc,unicore32: remove flush_icache_user_range

flush_icache_user_range is only used by <asm-generic/cacheflush.h>, so
remove it from the architectures that implement it, but don't use
<asm-generic/cacheflush.h>.

Link: http://lkml.kernel.org/r/20200515143646.3857579-19-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h       |    3 ---
 arch/sparc/include/asm/cacheflush_32.h  |    2 --
 arch/sparc/include/asm/cacheflush_64.h  |    1 -
 arch/unicore32/include/asm/cacheflush.h |    3 ---
 4 files changed, 9 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/arm/include/asm/cacheflush.h
@@ -318,9 +318,6 @@ extern void flush_kernel_dcache_page(str
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
 
-#define flush_icache_user_range(vma,page,addr,len) \
-	flush_dcache_page(page)
-
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
  * duplicate cache flushing elsewhere performed by flush_dcache_page().
--- a/arch/sparc/include/asm/cacheflush_32.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/sparc/include/asm/cacheflush_32.h
@@ -17,8 +17,6 @@
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma, pg)		do { } while (0)
 
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
-
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {							\
 		flush_cache_page(vma, vaddr, page_to_pfn(page));\
--- a/arch/sparc/include/asm/cacheflush_64.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/sparc/include/asm/cacheflush_64.h
@@ -49,7 +49,6 @@ void __flush_dcache_range(unsigned long
 void flush_dcache_page(struct page *page);
 
 #define flush_icache_page(vma, pg)	do { } while(0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
 
 void flush_ptrace_access(struct vm_area_struct *, struct page *,
 			 unsigned long uaddr, void *kaddr,
--- a/arch/unicore32/include/asm/cacheflush.h~armsparcunicore32-remove-flush_icache_user_range
+++ a/arch/unicore32/include/asm/cacheflush.h
@@ -162,9 +162,6 @@ extern void flush_dcache_page(struct pag
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
-#define flush_icache_user_range(vma, page, addr, len)	\
-	flush_dcache_page(page)
-
 /*
  * We don't appear to need to do anything here.  In fact, if we did, we'd
  * duplicate cache flushing elsewhere performed by flush_dcache_page().
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
