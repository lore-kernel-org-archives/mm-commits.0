From: akpm@linux-foundation.org
Subject: [merged] mm-remove-vmalloc_user_node_flags.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:42:40 -0700
Message-ID: <20200602214240.awXrPBt2g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgFBVmn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sfr@canb.auug.org.au, sthemmin@microsoft.com, sumit.semwal@linaro.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org


The patch titled
     Subject: mm: remove vmalloc_user_node_flags
has been removed from the -mm tree.  Its filename was
     mm-remove-vmalloc_user_node_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove vmalloc_user_node_flags

Open code it in __bpf_map_area_alloc, which is the only caller.  Also
clean up __bpf_map_area_alloc to have a single vmalloc call with slightly
different flags instead of the current two different calls.

For this to compile for the nommu case add a __vmalloc_node_range stub to
nommu.c.

[akpm@linux-foundation.org: fix nommu.c build]
Link: http://lkml.kernel.org/r/20200414131348.444715-27-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 -
 kernel/bpf/syscall.c    |   24 ++++++++++++++----------
 mm/nommu.c              |   14 ++++++++------
 mm/vmalloc.c            |   20 --------------------
 4 files changed, 22 insertions(+), 37 deletions(-)

--- a/include/linux/vmalloc.h~mm-remove-vmalloc_user_node_flags
+++ a/include/linux/vmalloc.h
@@ -106,7 +106,6 @@ extern void *vzalloc(unsigned long size)
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
 extern void *vzalloc_node(unsigned long size, int node);
-extern void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags);
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
--- a/kernel/bpf/syscall.c~mm-remove-vmalloc_user_node_flags
+++ a/kernel/bpf/syscall.c
@@ -25,6 +25,7 @@
 #include <linux/nospec.h>
 #include <linux/audit.h>
 #include <uapi/linux/btf.h>
+#include <asm/pgtable.h>
 #include <linux/bpf_lsm.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
@@ -281,26 +282,29 @@ static void *__bpf_map_area_alloc(u64 si
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
 
-	const gfp_t flags = __GFP_NOWARN | __GFP_ZERO;
+	const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO;
+	unsigned int flags = 0;
+	unsigned long align = 1;
 	void *area;
 
 	if (size >= SIZE_MAX)
 		return NULL;
 
 	/* kmalloc()'ed memory can't be mmap()'ed */
-	if (!mmapable && size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		area = kmalloc_node(size, GFP_USER | __GFP_NORETRY | flags,
+	if (mmapable) {
+		BUG_ON(!PAGE_ALIGNED(size));
+		align = SHMLBA;
+		flags = VM_USERMAP;
+	} else if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
+		area = kmalloc_node(size, gfp | GFP_USER | __GFP_NORETRY,
 				    numa_node);
 		if (area != NULL)
 			return area;
 	}
-	if (mmapable) {
-		BUG_ON(!PAGE_ALIGNED(size));
-		return vmalloc_user_node_flags(size, numa_node, GFP_KERNEL |
-					       __GFP_RETRY_MAYFAIL | flags);
-	}
-	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_RETRY_MAYFAIL | flags,
-			      numa_node, __builtin_return_address(0));
+
+	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
+			gfp | GFP_KERNEL | __GFP_RETRY_MAYFAIL, PAGE_KERNEL,
+			flags, numa_node, __builtin_return_address(0));
 }
 
 void *bpf_map_area_alloc(u64 size, int numa_node)
--- a/mm/nommu.c~mm-remove-vmalloc_user_node_flags
+++ a/mm/nommu.c
@@ -150,6 +150,14 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+void *__vmalloc_node_range(unsigned long size, unsigned long align,
+		unsigned long start, unsigned long end, gfp_t gfp_mask,
+		pgprot_t prot, unsigned long vm_flags, int node,
+		const void *caller)
+{
+	return __vmalloc(size, gfp_mask);
+}
+
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller)
 {
@@ -180,12 +188,6 @@ void *vmalloc_user(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc_user);
 
-void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
-{
-	return __vmalloc_user_flags(size, flags | __GFP_ZERO);
-}
-EXPORT_SYMBOL(vmalloc_user_node_flags);
-
 struct page *vmalloc_to_page(const void *addr)
 {
 	return virt_to_page(addr);
--- a/mm/vmalloc.c~mm-remove-vmalloc_user_node_flags
+++ a/mm/vmalloc.c
@@ -2660,26 +2660,6 @@ void *vzalloc_node(unsigned long size, i
 EXPORT_SYMBOL(vzalloc_node);
 
 /**
- * vmalloc_user_node_flags - allocate memory for userspace on a specific node
- * @size: allocation size
- * @node: numa node
- * @flags: flags for the page level allocator
- *
- * The resulting memory area is zeroed so it can be mapped to userspace
- * without leaking data.
- *
- * Return: pointer to the allocated memory or %NULL on error
- */
-void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
-{
-	return __vmalloc_node_range(size, SHMLBA,  VMALLOC_START, VMALLOC_END,
-				    flags | __GFP_ZERO, PAGE_KERNEL,
-				    VM_USERMAP, node,
-				    __builtin_return_address(0));
-}
-EXPORT_SYMBOL(vmalloc_user_node_flags);
-
-/**
  * vmalloc_exec - allocate virtually contiguous, executable memory
  * @size:	  allocation size
  *
_

Patches currently in -mm which might be from hch@lst.de are

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
asm-generic-dont-include-linux-mmh-in-cacheflushh-fix.patch
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
