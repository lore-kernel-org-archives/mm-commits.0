From: akpm@linux-foundation.org
Subject: + mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
 added to -mm tree
Date: Mon, 24 Nov 2014 14:58:28 -0800
Message-ID: <5473b814.SPcX3YkmE5e5IZR6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaKXW6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: prepare boottime configurable on/off
has been added to the -mm tree.  Its filename is
     mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch

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
Subject: mm/debug-pagealloc: prepare boottime configurable on/off

Until now, debug-pagealloc needs extra flags in struct page, so we need to
recompile whole source code when we decide to use it.  This is really
painful, because it takes some time to recompile and sometimes rebuild is
not possible due to third party module depending on struct page.  So, we
can't use this good feature in many cases.

Now, we have the page extension feature that allows us to insert extra
flags to outside of struct page.  This gets rid of third party module
issue mentioned above.  And, this allows us to determine if we need extra
memory for this page extension in boottime.  With these property, we can
avoid using debug-pagealloc in boottime with low computational overhead in
the kernel built with CONFIG_DEBUG_PAGEALLOC.  This will help our
development process greatly.

This patch is the preparation step to achive above goal.  debug-pagealloc
originally uses extra field of struct page, but, after this patch, it will
use field of struct page_ext.  Because memory for page_ext is allocated
later than initialization of page allocator in CONFIG_SPARSEMEM, we should
disable debug-pagealloc feature temporarily until initialization of
page_ext.  This patch implements this.

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

 include/linux/mm.h               |   19 +++++++++++++-
 include/linux/mm_types.h         |    4 ---
 include/linux/page-debug-flags.h |   32 ------------------------
 include/linux/page_ext.h         |   15 +++++++++++
 mm/Kconfig.debug                 |    1 
 mm/debug-pagealloc.c             |   37 +++++++++++++++++++++++++---
 mm/page_alloc.c                  |   38 ++++++++++++++++++++++++++---
 mm/page_ext.c                    |    4 +++
 8 files changed, 106 insertions(+), 44 deletions(-)

diff -puN include/linux/mm.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off include/linux/mm.h
--- a/include/linux/mm.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/include/linux/mm.h
@@ -19,6 +19,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/shrinker.h>
 #include <linux/resource.h>
+#include <linux/page_ext.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -2138,20 +2139,36 @@ extern void copy_user_huge_page(struct p
 				unsigned int pages_per_huge_page);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+extern struct page_ext_operations debug_guardpage_ops;
+extern struct page_ext_operations page_poisoning_ops;
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern unsigned int _debug_guardpage_minorder;
+extern bool _debug_guardpage_enabled;
 
 static inline unsigned int debug_guardpage_minorder(void)
 {
 	return _debug_guardpage_minorder;
 }
 
+static inline bool debug_guardpage_enabled(void)
+{
+	return _debug_guardpage_enabled;
+}
+
 static inline bool page_is_guard(struct page *page)
 {
-	return test_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	if (!debug_guardpage_enabled())
+		return false;
+
+	page_ext = lookup_page_ext(page);
+	return test_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
 }
 #else
 static inline unsigned int debug_guardpage_minorder(void) { return 0; }
+static inline bool debug_guardpage_enabled(void) { return false; }
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
diff -puN include/linux/mm_types.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/include/linux/mm_types.h
@@ -10,7 +10,6 @@
 #include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
-#include <linux/page-debug-flags.h>
 #include <linux/uprobes.h>
 #include <linux/page-flags-layout.h>
 #include <asm/page.h>
@@ -186,9 +185,6 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
-#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
-	unsigned long debug_flags;	/* Use atomic bitops on this */
-#endif
 
 #ifdef CONFIG_KMEMCHECK
 	/*
diff -puN include/linux/page-debug-flags.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off /dev/null
--- a/include/linux/page-debug-flags.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef LINUX_PAGE_DEBUG_FLAGS_H
-#define  LINUX_PAGE_DEBUG_FLAGS_H
-
-/*
- * page->debug_flags bits:
- *
- * PAGE_DEBUG_FLAG_POISON is set for poisoned pages. This is used to
- * implement generic debug pagealloc feature. The pages are filled with
- * poison patterns and set this flag after free_pages(). The poisoned
- * pages are verified whether the patterns are not corrupted and clear
- * the flag before alloc_pages().
- */
-
-enum page_debug_flags {
-	PAGE_DEBUG_FLAG_POISON,		/* Page is poisoned */
-	PAGE_DEBUG_FLAG_GUARD,
-};
-
-/*
- * Ensure that CONFIG_WANT_PAGE_DEBUG_FLAGS reliably
- * gets turned off when no debug features are enabling it!
- */
-
-#ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
-#if !defined(CONFIG_PAGE_POISONING) && \
-    !defined(CONFIG_PAGE_GUARD) \
-/* && !defined(CONFIG_PAGE_DEBUG_SOMETHING_ELSE) && ... */
-#error WANT_PAGE_DEBUG_FLAGS is turned on with no debug features!
-#endif
-#endif /* CONFIG_WANT_PAGE_DEBUG_FLAGS */
-
-#endif /* LINUX_PAGE_DEBUG_FLAGS_H */
diff -puN include/linux/page_ext.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/include/linux/page_ext.h
@@ -10,6 +10,21 @@ struct page_ext_operations {
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
+ * page_ext->flags bits:
+ *
+ * PAGE_EXT_DEBUG_POISON is set for poisoned pages. This is used to
+ * implement generic debug pagealloc feature. The pages are filled with
+ * poison patterns and set this flag after free_pages(). The poisoned
+ * pages are verified whether the patterns are not corrupted and clear
+ * the flag before alloc_pages().
+ */
+
+enum page_ext_flags {
+	PAGE_EXT_DEBUG_POISON,		/* Page is poisoned */
+	PAGE_EXT_DEBUG_GUARD,
+};
+
+/*
  * Page Extension can be considered as an extended mem_map.
  * A page_ext page is associated with every page descriptor. The
  * page_ext helps us add more information about the page.
diff -puN mm/Kconfig.debug~mm-debug-pagealloc-prepare-boottime-configurable-on-off mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/mm/Kconfig.debug
@@ -12,6 +12,7 @@ config DEBUG_PAGEALLOC
 	depends on DEBUG_KERNEL
 	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
 	depends on !KMEMCHECK
+	select PAGE_EXTENSION
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
diff -puN mm/debug-pagealloc.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/mm/debug-pagealloc.c
@@ -2,23 +2,49 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
-#include <linux/page-debug-flags.h>
+#include <linux/page_ext.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 
+static bool page_poisoning_enabled __read_mostly;
+
+static bool need_page_poisoning(void)
+{
+	return true;
+}
+
+static void init_page_poisoning(void)
+{
+	page_poisoning_enabled = true;
+}
+
+struct page_ext_operations page_poisoning_ops = {
+	.need = need_page_poisoning,
+	.init = init_page_poisoning,
+};
+
 static inline void set_page_poison(struct page *page)
 {
-	__set_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	__set_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
 static inline void clear_page_poison(struct page *page)
 {
-	__clear_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
 static inline bool page_poison(struct page *page)
 {
-	return test_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
 static void poison_page(struct page *page)
@@ -95,6 +121,9 @@ static void unpoison_pages(struct page *
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
+	if (!page_poisoning_enabled)
+		return;
+
 	if (enable)
 		unpoison_pages(page, numpages);
 	else
diff -puN mm/page_alloc.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/mm/page_alloc.c
@@ -56,7 +56,7 @@
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
-#include <linux/page-debug-flags.h>
+#include <linux/page_ext.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 
@@ -425,6 +425,22 @@ static inline void prep_zero_page(struct
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
+bool _debug_guardpage_enabled __read_mostly;
+
+static bool need_debug_guardpage(void)
+{
+	return true;
+}
+
+static void init_debug_guardpage(void)
+{
+	_debug_guardpage_enabled = true;
+}
+
+struct page_ext_operations debug_guardpage_ops = {
+	.need = need_debug_guardpage,
+	.init = init_debug_guardpage,
+};
 
 static int __init debug_guardpage_minorder_setup(char *buf)
 {
@@ -443,7 +459,14 @@ __setup("debug_guardpage_minorder=", deb
 static inline void set_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype)
 {
-	__set_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	if (!debug_guardpage_enabled())
+		return;
+
+	page_ext = lookup_page_ext(page);
+	__set_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
+
 	INIT_LIST_HEAD(&page->lru);
 	set_page_private(page, order);
 	/* Guard pages are not available for any usage */
@@ -453,12 +476,20 @@ static inline void set_page_guard(struct
 static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype)
 {
-	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	struct page_ext *page_ext;
+
+	if (!debug_guardpage_enabled())
+		return;
+
+	page_ext = lookup_page_ext(page);
+	__clear_bit(PAGE_EXT_DEBUG_GUARD, &page_ext->flags);
+
 	set_page_private(page, 0);
 	if (!is_migrate_isolate(migratetype))
 		__mod_zone_freepage_state(zone, (1 << order), migratetype);
 }
 #else
+struct page_ext_operations debug_guardpage_ops = { NULL, };
 static inline void set_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype) {}
 static inline void clear_page_guard(struct zone *zone, struct page *page,
@@ -870,6 +901,7 @@ static inline void expand(struct zone *z
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
 
 		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
+			debug_guardpage_enabled() &&
 			high < debug_guardpage_minorder()) {
 			/*
 			 * Mark as guard pages (or page), that will allow to
diff -puN mm/page_ext.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off mm/page_ext.c
--- a/mm/page_ext.c~mm-debug-pagealloc-prepare-boottime-configurable-on-off
+++ a/mm/page_ext.c
@@ -51,6 +51,10 @@
  */
 
 static struct page_ext_operations *page_ext_ops[] = {
+	&debug_guardpage_ops,
+#ifdef CONFIG_PAGE_POISONING
+	&page_poisoning_ops,
+#endif
 };
 
 static unsigned long total_usage;
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

