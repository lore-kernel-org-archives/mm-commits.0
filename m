From: akpm@linux-foundation.org
Subject: [merged]
 arm-rename-flush_cache_user_range-to-flush_icache_user_range.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:33:18 -0700
Message-ID: <20200608223318.FOfSFXUjQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWdT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: rename flush_cache_user_range to flush_icache_user_range
has been removed from the -mm tree.  Its filename was
     arm-rename-flush_cache_user_range-to-flush_icache_user_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arm: rename flush_cache_user_range to flush_icache_user_range

flush_icache_user_range will be the name for a generic primitive.
Move the arm name so that arm already has an implementation.

Link: http://lkml.kernel.org/r/20200515143646.3857579-24-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h |    4 ++--
 arch/arm/kernel/traps.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h~arm-rename-flush_cache_user_range-to-flush_icache_user_range
+++ a/arch/arm/include/asm/cacheflush.h
@@ -258,11 +258,11 @@ extern void flush_cache_page(struct vm_a
 #define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 
 /*
- * flush_cache_user_range is used when we want to ensure that the
+ * flush_icache_user_range is used when we want to ensure that the
  * Harvard caches are synchronised for the user space address range.
  * This is used for the ARM private sys_cacheflush system call.
  */
-#define flush_cache_user_range(s,e)	__cpuc_coherent_user_range(s,e)
+#define flush_icache_user_range(s,e)	__cpuc_coherent_user_range(s,e)
 
 /*
  * Perform necessary cache operations to ensure that data previously
--- a/arch/arm/kernel/traps.c~arm-rename-flush_cache_user_range-to-flush_icache_user_range
+++ a/arch/arm/kernel/traps.c
@@ -566,7 +566,7 @@ __do_cache_op(unsigned long start, unsig
 		if (fatal_signal_pending(current))
 			return 0;
 
-		ret = flush_cache_user_range(start, start + chunk);
+		ret = flush_icache_user_range(start, start + chunk);
 		if (ret)
 			return ret;
 
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
