From: akpm@linux-foundation.org
Subject: +
 mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
 added to -mm tree
Date: Tue, 09 Dec 2014 13:00:04 -0800
Message-ID: <548762d4.hpJHrVBbv4uy7JD6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLIVAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 16:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mingo@kernel.org, rmk@arm.linux.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/CMA: fix boot regression due to physical address of high_memory
has been added to the -mm tree.  Its filename is
     mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/CMA: fix boot regression due to physical address of high_memory

high_memory isn't direct mapped memory so retrieving it's physical address
isn't appropriate.  But, it would be useful to check physical address of
highmem boundary so it's justfiable to get physical address from it.  In
x86, there is a validation check if CONFIG_DEBUG_VIRTUAL and it triggers
following boot failure reported by Ingo.

...
BUG: Int 6: CR2 00f06f53
     EDI   (null)  ESI 0665b000  EBP c1ed7edc  EBX 40000000
     ESP c1ed7ed8   ES 0000007b   DS 0000007b
     EDX c2022c18  ECX 37d34000  EAX   (null)
     vec 00000006  err   (null)  EIP c102b62e   CS 00000060  flg 00210013
...
Call Trace:
 [<c1902dfd>] dump_stack+0x41/0x52
 [<c1fad1f7>] early_idt_handler+0x6b/0x6b
 [<c102b62e>] ? __phys_addr+0x16/0x68
 [<c1fccd26>] cma_declare_contiguous+0x33/0x212
 [<c1fe9b6e>] dma_contiguous_reserve_area+0x31/0x4e
 [<c1fe9ca8>] dma_contiguous_reserve+0x11d/0x125
 [<c1faf2c8>] ? setup_real_mode+0x98/0xa3
 [<c1fb00c8>] setup_arch+0x7b5/0xb63
 [<c1fad802>] start_kernel+0xb8/0x3e6
 [<c1fad2cb>] i386_start_kernel+0x79/0x7d

To fix boot regression, this patch implements workaround to avoid
validation check in x86 when retrieving physical address of high_memory. 
__pa_nodebug() used by this patch is implemented only in x86 so there is
no choice but to use dirty #ifdef.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory mm/cma.c
--- a/mm/cma.c~mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory
+++ a/mm/cma.c
@@ -215,9 +215,22 @@ int __init cma_declare_contiguous(phys_a
 			bool fixed, struct cma **res_cma)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start = __pa(high_memory);
+	phys_addr_t highmem_start;
 	int ret = 0;
 
+#ifdef CONFIG_X86
+	/*
+	 * high_memory isn't direct mapped memory so retrieving it's
+	 * physical address isn't appropriate. But, it would be useful
+	 * to check physical address of highmem boundary so it's
+	 * justfiable to get physical address from it. In x86, there is
+	 * a validation check for this case, so following workaround is
+	 * needed to avoid it.
+	 */
+	highmem_start = __pa_nodebug(high_memory);
+#else
+	highmem_start = __pa(high_memory);
+#endif
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix.patch
mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
fix-memory-ordering-bug-in-mm-vmallocc.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

