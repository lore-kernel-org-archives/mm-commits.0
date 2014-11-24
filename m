From: akpm@linux-foundation.org
Subject: +
 mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch added
 to -mm tree
Date: Mon, 24 Nov 2014 14:58:31 -0800
Message-ID: <5473b817.nz4tRvsgoTQt7WRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKXW6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: make debug-pagealloc boottime configurable
has been added to the -mm tree.  Its filename is
     mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch

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
Subject: mm/debug-pagealloc: make debug-pagealloc boottime configurable

Now, we have prepared to avoid using debug-pagealloc in boottime.  So
introduce new kernel-parameter to disable debug-pagealloc in boottime, and
makes related functions to be disabled in this case.

Only non-intuitive part is change of guard page functions.  Because guard
page is effective only if debug-pagealloc is enabled, turning off
according to debug-pagealloc is reasonable thing to do.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++++++
 arch/powerpc/mm/hash_utils_64.c     |    2 +-
 arch/powerpc/mm/pgtable_32.c        |    2 +-
 arch/s390/mm/pageattr.c             |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c              |    2 +-
 include/linux/mm.h                  |   17 ++++++++++++++++-
 mm/debug-pagealloc.c                |    8 +++++++-
 mm/page_alloc.c                     |   16 ++++++++++++++++
 9 files changed, 52 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/Documentation/kernel-parameters.txt
@@ -858,6 +858,14 @@ bytes respectively. Such letter suffixes
 			causing system reset or hang due to sending
 			INIT from AP to BSP.
 
+	disable_debug_pagealloc
+			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
+			parameter allows user to disable it at boot time.
+			With this parameter, we can avoid allocating huge
+			chunk of memory for debug pagealloc and then
+			the system will work mostly same with the kernel
+			built without CONFIG_DEBUG_PAGEALLOC.
+
 	disable_ddw     [PPC/PSERIES]
 			Disable Dynamic DMA Window support. Use this if
 			to workaround buggy firmware.
diff -puN arch/powerpc/mm/hash_utils_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -1432,7 +1432,7 @@ static void kernel_unmap_linear_page(uns
 			       mmu_kernel_ssize, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long flags, vaddr, lmi;
 	int i;
diff -puN arch/powerpc/mm/pgtable_32.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -430,7 +430,7 @@ static int change_page_attr(struct page 
 }
 
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff -puN arch/s390/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/s390/mm/pageattr.c
--- a/arch/s390/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/s390/mm/pageattr.c
@@ -120,7 +120,7 @@ static void ipte_range(pte_t *pte, unsig
 	}
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long address;
 	int nr, i, j;
diff -puN arch/sparc/mm/init_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/sparc/mm/init_64.c
@@ -1621,7 +1621,7 @@ static void __init kernel_physical_mappi
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long phys_start = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long phys_end = phys_start + (numpages * PAGE_SIZE);
diff -puN arch/x86/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/x86/mm/pageattr.c
@@ -1801,7 +1801,7 @@ static int __set_pages_np(struct page *p
 	return __change_page_attr_set_clr(&cpa, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff -puN include/linux/mm.h~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable include/linux/mm.h
--- a/include/linux/mm.h~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/include/linux/mm.h
@@ -2044,7 +2044,22 @@ static inline void vm_stat_account(struc
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
+extern bool _debug_pagealloc_enabled;
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
+static inline bool debug_pagealloc_enabled(void)
+{
+	return _debug_pagealloc_enabled;
+}
+
+static inline void
+kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	if (!debug_pagealloc_enabled())
+		return;
+
+	__kernel_map_pages(page, numpages, enable);
+}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
diff -puN mm/debug-pagealloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/mm/debug-pagealloc.c
@@ -10,11 +10,17 @@ static bool page_poisoning_enabled __rea
 
 static bool need_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	page_poisoning_enabled = true;
 }
 
@@ -119,7 +125,7 @@ static void unpoison_pages(struct page *
 		unpoison_page(page + i);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!page_poisoning_enabled)
 		return;
diff -puN mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/mm/page_alloc.c
@@ -425,15 +425,31 @@ static inline void prep_zero_page(struct
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
+bool _debug_pagealloc_enabled __read_mostly = true;
 bool _debug_guardpage_enabled __read_mostly;
 
+static int __init early_disable_debug_pagealloc(char *buf)
+{
+	_debug_pagealloc_enabled = false;
+
+	return 0;
+}
+early_param("disable_debug_pagealloc", early_disable_debug_pagealloc);
+
 static bool need_debug_guardpage(void)
 {
+	/* If we don't use debug_pagealloc, we don't need guard page */
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_debug_guardpage(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	_debug_guardpage_enabled = true;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch

