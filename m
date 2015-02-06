From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs.patch
 removed from -mm tree
Date: Fri, 06 Feb 2015 14:02:40 -0800
Message-ID: <54d53a00.8NtHueORva6Wqg94%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbbBFWCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 17:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, davem@davemloft.net, dhowells@redhat.com, heiko.carstens@de.ibm.com, kim.phillips@freescale.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_pagealloc: fix build failure on ppc and some other archs
has been removed from the -mm tree.  Its filename was
     mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug_pagealloc: fix build failure on ppc and some other archs

Kim Phillips reported following build failure.

  LD      init/built-in.o
  mm/built-in.o: In function `free_pages_prepare':
  mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
  mm/built-in.o: In function `prep_new_page':
  mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
  mm/built-in.o: In function `map_pages':
  mm/compaction.c:61: undefined reference to `.kernel_map_pages'
  make: *** [vmlinux] Error 1

Reason for this problem is that commit 031bc5743f15 ("mm/debug-pagealloc:
make debug-pagealloc boottime configurable") forgot to remove old
declaration of kernel_map_pages() in some architectures.  This patch
removes them to fix build failure.

Reported-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/cacheflush.h  |    7 -------
 arch/powerpc/include/asm/cacheflush.h  |    7 -------
 arch/s390/include/asm/cacheflush.h     |    4 ----
 arch/sparc/include/asm/cacheflush_64.h |    5 -----
 4 files changed, 23 deletions(-)

diff -puN arch/mn10300/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs arch/mn10300/include/asm/cacheflush.h
--- a/arch/mn10300/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs
+++ a/arch/mn10300/include/asm/cacheflush.h
@@ -159,13 +159,6 @@ extern void flush_icache_range(unsigned
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-/*
- * Internal debugging function
- */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_CACHEFLUSH_H */
diff -puN arch/powerpc/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs arch/powerpc/include/asm/cacheflush.h
--- a/arch/powerpc/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs
+++ a/arch/powerpc/include/asm/cacheflush.h
@@ -60,13 +60,6 @@ extern void flush_dcache_phys_range(unsi
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-/* internal debugging function */
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_CACHEFLUSH_H */
diff -puN arch/s390/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs arch/s390/include/asm/cacheflush.h
--- a/arch/s390/include/asm/cacheflush.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs
+++ a/arch/s390/include/asm/cacheflush.h
@@ -4,10 +4,6 @@
 /* Caches aren't brain-dead on the s390. */
 #include <asm-generic/cacheflush.h>
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
diff -puN arch/sparc/include/asm/cacheflush_64.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs arch/sparc/include/asm/cacheflush_64.h
--- a/arch/sparc/include/asm/cacheflush_64.h~mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs
+++ a/arch/sparc/include/asm/cacheflush_64.h
@@ -74,11 +74,6 @@ void flush_ptrace_access(struct vm_area_
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-/* internal debugging function */
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _SPARC64_CACHEFLUSH_H */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch
sparc32-fix-broken-set_pte.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch

