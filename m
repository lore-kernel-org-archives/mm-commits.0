From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-add-a-flush_icache_user_range-stub.patch removed from -mm tree
Date: Mon, 08 Jun 2020 15:33:12 -0700
Message-ID: <20200608223312.NqeonvLku%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: add a flush_icache_user_range stub
has been removed from the -mm tree.  Its filename was
     asm-generic-add-a-flush_icache_user_range-stub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: asm-generic: add a flush_icache_user_range stub

Define flush_icache_user_range to flush_icache_range unless the
architecture provides its own implementation.

Link: http://lkml.kernel.org/r/20200515143646.3857579-21-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/asm-generic/cacheflush.h~asm-generic-add-a-flush_icache_user_range-stub
+++ a/include/asm-generic/cacheflush.h
@@ -66,6 +66,10 @@ static inline void flush_icache_range(un
 }
 #endif
 
+#ifndef flush_icache_user_range
+#define flush_icache_user_range flush_icache_range
+#endif
+
 #ifndef flush_icache_page
 static inline void flush_icache_page(struct vm_area_struct *vma,
 				     struct page *page)
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
