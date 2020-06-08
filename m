From: akpm@linux-foundation.org
Subject: [merged] sh-implement-flush_icache_user_range.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 15:33:14 -0700
Message-ID: <20200608223314.y9oNftHYI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, hch@lst.de, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: implement flush_icache_user_range
has been removed from the -mm tree.  Its filename was
     sh-implement-flush_icache_user_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sh: implement flush_icache_user_range

The SuperH implementation of flush_icache_range seems to be able to
cope with user addresses.  Just define flush_icache_user_range to
flush_icache_range.

Link: http://lkml.kernel.org/r/20200515143646.3857579-22-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/cacheflush.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/include/asm/cacheflush.h~sh-implement-flush_icache_user_range
+++ a/arch/sh/include/asm/cacheflush.h
@@ -46,6 +46,7 @@ extern void flush_cache_range(struct vm_
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 extern void flush_icache_range(unsigned long start, unsigned long end);
+#define flush_icache_user_range flush_icache_range
 extern void flush_icache_page(struct vm_area_struct *vma,
 				 struct page *page);
 extern void flush_cache_sigtramp(unsigned long address);
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
