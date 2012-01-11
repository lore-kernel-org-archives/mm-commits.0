From: akpm@linux-foundation.org
Subject: [merged] mm-more-intensive-memory-corruption-debug.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:58 -0800
Message-ID: <20120111212658.C198F10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58471 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab2AKV07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:59 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so136887ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more intensive memory corruption debugging
has been removed from the -mm tree.  Its filename was
     mm-more-intensive-memory-corruption-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: mm: more intensive memory corruption debugging

With CONFIG_DEBUG_PAGEALLOC configured, the CPU will generate an exception
on access (read,write) to an unallocated page, which permits us to catch
code which corrupts memory.  However the kernel is trying to maximise
memory usage, hence there are usually few free pages in the system and
buggy code usually corrupts some crucial data.

This patch changes the buddy allocator to keep more free/protected pages
and to interlace free/protected and allocated pages to increase the
probability of catching corruption.

When the kernel is compiled with CONFIG_DEBUG_PAGEALLOC,
debug_guardpage_minorder defines the minimum order used by the page
allocator to grant a request.  The requested size will be returned with
the remaining pages used as guard pages.

The default value of debug_guardpage_minorder is zero: no change from
current behaviour.

[akpm@linux-foundation.org: tweak documentation, s/flg/flag/]
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   19 ++++++
 include/linux/mm.h                  |   17 +++++
 include/linux/page-debug-flags.h    |    4 +
 mm/Kconfig.debug                    |    5 +
 mm/page_alloc.c                     |   75 +++++++++++++++++++++++---
 5 files changed, 113 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-more-intensive-memory-corruption-debug Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-more-intensive-memory-corruption-debug
+++ a/Documentation/kernel-parameters.txt
@@ -628,6 +628,25 @@ bytes respectively. Such letter suffixes
 	no_debug_objects
 			[KNL] Disable object debugging
 
+	debug_guardpage_minorder=
+			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
+			parameter allows control of the order of pages that will
+			be intentionally kept free (and hence protected) by the
+			buddy allocator. Bigger value increase the probability
+			of catching random memory corruption, but reduce the
+			amount of memory for normal system use. The maximum
+			possible value is MAX_ORDER/2.  Setting this parameter
+			to 1 or 2 should be enough to identify most random
+			memory corruption problems caused by bugs in kernel or
+			driver code when a CPU writes to (or reads from) a
+			random memory location. Note that there exists a class
+			of memory corruptions problems caused by buggy H/W or
+			F/W or by drivers badly programing DMA (basically when
+			memory is written at bus level and the CPU MMU is
+			bypassed) which are not detectable by
+			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
+			tracking down these problems.
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
diff -puN include/linux/mm.h~mm-more-intensive-memory-corruption-debug include/linux/mm.h
--- a/include/linux/mm.h~mm-more-intensive-memory-corruption-debug
+++ a/include/linux/mm.h
@@ -1618,5 +1618,22 @@ extern void copy_user_huge_page(struct p
 				unsigned int pages_per_huge_page);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+extern unsigned int _debug_guardpage_minorder;
+
+static inline unsigned int debug_guardpage_minorder(void)
+{
+	return _debug_guardpage_minorder;
+}
+
+static inline bool page_is_guard(struct page *page)
+{
+	return test_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+}
+#else
+static inline unsigned int debug_guardpage_minorder(void) { return 0; }
+static inline bool page_is_guard(struct page *page) { return false; }
+#endif /* CONFIG_DEBUG_PAGEALLOC */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN include/linux/page-debug-flags.h~mm-more-intensive-memory-corruption-debug include/linux/page-debug-flags.h
--- a/include/linux/page-debug-flags.h~mm-more-intensive-memory-corruption-debug
+++ a/include/linux/page-debug-flags.h
@@ -13,6 +13,7 @@
 
 enum page_debug_flags {
 	PAGE_DEBUG_FLAG_POISON,		/* Page is poisoned */
+	PAGE_DEBUG_FLAG_GUARD,
 };
 
 /*
@@ -21,7 +22,8 @@ enum page_debug_flags {
  */
 
 #ifdef CONFIG_WANT_PAGE_DEBUG_FLAGS
-#if !defined(CONFIG_PAGE_POISONING) \
+#if !defined(CONFIG_PAGE_POISONING) && \
+    !defined(CONFIG_PAGE_GUARD) \
 /* && !defined(CONFIG_PAGE_DEBUG_SOMETHING_ELSE) && ... */
 #error WANT_PAGE_DEBUG_FLAGS is turned on with no debug features!
 #endif
diff -puN mm/Kconfig.debug~mm-more-intensive-memory-corruption-debug mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-more-intensive-memory-corruption-debug
+++ a/mm/Kconfig.debug
@@ -4,6 +4,7 @@ config DEBUG_PAGEALLOC
 	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
 	depends on !KMEMCHECK
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
@@ -22,3 +23,7 @@ config WANT_PAGE_DEBUG_FLAGS
 config PAGE_POISONING
 	bool
 	select WANT_PAGE_DEBUG_FLAGS
+
+config PAGE_GUARD
+	bool
+	select WANT_PAGE_DEBUG_FLAGS
diff -puN mm/page_alloc.c~mm-more-intensive-memory-corruption-debug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-intensive-memory-corruption-debug
+++ a/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/page-debug-flags.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -388,6 +389,37 @@ static inline void prep_zero_page(struct
 		clear_highpage(page + i);
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+unsigned int _debug_guardpage_minorder;
+
+static int __init debug_guardpage_minorder_setup(char *buf)
+{
+	unsigned long res;
+
+	if (kstrtoul(buf, 10, &res) < 0 ||  res > MAX_ORDER / 2) {
+		printk(KERN_ERR "Bad debug_guardpage_minorder value\n");
+		return 0;
+	}
+	_debug_guardpage_minorder = res;
+	printk(KERN_INFO "Setting debug_guardpage_minorder to %lu\n", res);
+	return 0;
+}
+__setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
+
+static inline void set_page_guard_flag(struct page *page)
+{
+	__set_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+}
+
+static inline void clear_page_guard_flag(struct page *page)
+{
+	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+}
+#else
+static inline void set_page_guard_flag(struct page *page) { }
+static inline void clear_page_guard_flag(struct page *page) { }
+#endif
+
 static inline void set_page_order(struct page *page, int order)
 {
 	set_page_private(page, order);
@@ -445,6 +477,11 @@ static inline int page_is_buddy(struct p
 	if (page_zone_id(page) != page_zone_id(buddy))
 		return 0;
 
+	if (page_is_guard(buddy) && page_order(buddy) == order) {
+		VM_BUG_ON(page_count(buddy) != 0);
+		return 1;
+	}
+
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
 		VM_BUG_ON(page_count(buddy) != 0);
 		return 1;
@@ -501,11 +538,19 @@ static inline void __free_one_page(struc
 		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
 			break;
-
-		/* Our buddy is free, merge with it and move up one order. */
-		list_del(&buddy->lru);
-		zone->free_area[order].nr_free--;
-		rmv_page_order(buddy);
+		/*
+		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
+		 * merge with it and move up one order.
+		 */
+		if (page_is_guard(buddy)) {
+			clear_page_guard_flag(buddy);
+			set_page_private(page, 0);
+			__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
+		} else {
+			list_del(&buddy->lru);
+			zone->free_area[order].nr_free--;
+			rmv_page_order(buddy);
+		}
 		combined_idx = buddy_idx & page_idx;
 		page = page + (combined_idx - page_idx);
 		page_idx = combined_idx;
@@ -731,6 +776,23 @@ static inline void expand(struct zone *z
 		high--;
 		size >>= 1;
 		VM_BUG_ON(bad_range(zone, &page[size]));
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+		if (high < debug_guardpage_minorder()) {
+			/*
+			 * Mark as guard pages (or page), that will allow to
+			 * merge back to allocator when buddy will be freed.
+			 * Corresponding page table entries will not be touched,
+			 * pages will stay not present in virtual address space
+			 */
+			INIT_LIST_HEAD(&page[size].lru);
+			set_page_guard_flag(&page[size]);
+			set_page_private(&page[size], high);
+			/* Guard pages are not available for any usage */
+			__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << high));
+			continue;
+		}
+#endif
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
@@ -1754,7 +1816,8 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
+	    debug_guardpage_minorder() > 0)
 		return;
 
 	/*
_

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch

