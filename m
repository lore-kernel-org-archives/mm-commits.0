From: akpm@linux-foundation.org
Subject: + mm-factor-out-memory-isolate-functions.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:02:06 -0700
Message-ID: <20120712210207.7464B1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59308 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2GLVCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:02:08 -0400
Received: by yenl3 with SMTP id l3so276961yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:02:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, m.szyprowski@samsung.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm: factor out memory isolate functions
has been added to the -mm tree.  Its filename is
     mm-factor-out-memory-isolate-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: factor out memory isolate functions

mm/page_alloc.c has some memory isolation functions but they are used only
when we enable CONFIG_{CMA|MEMORY_HOTPLUG|MEMORY_FAILURE}.  So let's make
it configurable by new CONFIG_MEMORY_ISOLATION so that it can reduce
binary size and we can check it simple by CONFIG_MEMORY_ISOLATION, not if
defined CONFIG_{CMA|MEMORY_HOTPLUG|MEMORY_FAILURE}.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig           |    1 
 include/linux/page-isolation.h |   13 +++--
 mm/Kconfig                     |    5 +
 mm/Makefile                    |    5 +
 mm/page_alloc.c                |   80 +------------------------------
 mm/page_isolation.c            |   71 +++++++++++++++++++++++++++
 6 files changed, 93 insertions(+), 82 deletions(-)

diff -puN drivers/base/Kconfig~mm-factor-out-memory-isolate-functions drivers/base/Kconfig
--- a/drivers/base/Kconfig~mm-factor-out-memory-isolate-functions
+++ a/drivers/base/Kconfig
@@ -196,6 +196,7 @@ config CMA
 	bool "Contiguous Memory Allocator (EXPERIMENTAL)"
 	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK && EXPERIMENTAL
 	select MIGRATION
+	select MEMORY_ISOLATION
 	help
 	  This enables the Contiguous Memory Allocator which allows drivers
 	  to allocate big physically-contiguous blocks of memory for use with
diff -puN include/linux/page-isolation.h~mm-factor-out-memory-isolate-functions include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-factor-out-memory-isolate-functions
+++ a/include/linux/page-isolation.h
@@ -1,6 +1,11 @@
 #ifndef __LINUX_PAGEISOLATION_H
 #define __LINUX_PAGEISOLATION_H
 
+
+bool has_unmovable_pages(struct zone *zone, struct page *page, int count);
+void set_pageblock_migratetype(struct page *page, int migratetype);
+int move_freepages_block(struct zone *zone, struct page *page,
+				int migratetype);
 /*
  * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
  * If specified range includes migrate types other than MOVABLE or CMA,
@@ -10,7 +15,7 @@
  * free all pages in the range. test_page_isolated() can be used for
  * test it.
  */
-extern int
+int
 start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			 unsigned migratetype);
 
@@ -18,7 +23,7 @@ start_isolate_page_range(unsigned long s
  * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
  * target range is [start_pfn, end_pfn)
  */
-extern int
+int
 undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned migratetype);
 
@@ -30,8 +35,8 @@ int test_pages_isolated(unsigned long st
 /*
  * Internal functions. Changes pageblock's migrate type.
  */
-extern int set_migratetype_isolate(struct page *page);
-extern void unset_migratetype_isolate(struct page *page, unsigned migratetype);
+int set_migratetype_isolate(struct page *page);
+void unset_migratetype_isolate(struct page *page, unsigned migratetype);
 
 
 #endif
diff -puN mm/Kconfig~mm-factor-out-memory-isolate-functions mm/Kconfig
--- a/mm/Kconfig~mm-factor-out-memory-isolate-functions
+++ a/mm/Kconfig
@@ -140,9 +140,13 @@ config ARCH_DISCARD_MEMBLOCK
 config NO_BOOTMEM
 	boolean
 
+config MEMORY_ISOLATION
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
+	select MEMORY_ISOLATION
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
@@ -272,6 +276,7 @@ config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
+	select MEMORY_ISOLATION
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
diff -puN mm/Makefile~mm-factor-out-memory-isolate-functions mm/Makefile
--- a/mm/Makefile~mm-factor-out-memory-isolate-functions
+++ a/mm/Makefile
@@ -15,8 +15,8 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o mmu_context.o percpu.o \
-			   compaction.o slab_common.o $(mmu-y)
+			   mm_init.o mmu_context.o percpu.o slab_common.o \
+			   compaction.o $(mmu-y)
 
 obj-y += init-mm.o
 
@@ -56,3 +56,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoiso
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
diff -puN mm/page_alloc.c~mm-factor-out-memory-isolate-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-factor-out-memory-isolate-functions
+++ a/mm/page_alloc.c
@@ -51,7 +51,6 @@
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
-#include <linux/memory.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
@@ -219,7 +218,7 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
-static void set_pageblock_migratetype(struct page *page, int migratetype)
+void set_pageblock_migratetype(struct page *page, int migratetype)
 {
 
 	if (unlikely(page_group_by_mobility_disabled))
@@ -953,7 +952,7 @@ static int move_freepages(struct zone *z
 	return pages_moved;
 }
 
-static int move_freepages_block(struct zone *zone, struct page *page,
+int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype)
 {
 	unsigned long start_pfn, end_pfn;
@@ -5462,8 +5461,7 @@ void set_pageblock_flags_group(struct pa
  * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
  * expect this function should be exact.
  */
-static bool
-__has_unmovable_pages(struct zone *zone, struct page *page, int count)
+bool has_unmovable_pages(struct zone *zone, struct page *page, int count)
 {
 	unsigned long pfn, iter, found;
 	int mt;
@@ -5540,77 +5538,7 @@ bool is_pageblock_removable_nolock(struc
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
-	return !__has_unmovable_pages(zone, page, 0);
-}
-
-int set_migratetype_isolate(struct page *page)
-{
-	struct zone *zone;
-	unsigned long flags, pfn;
-	struct memory_isolate_notify arg;
-	int notifier_ret;
-	int ret = -EBUSY;
-
-	zone = page_zone(page);
-
-	spin_lock_irqsave(&zone->lock, flags);
-
-	pfn = page_to_pfn(page);
-	arg.start_pfn = pfn;
-	arg.nr_pages = pageblock_nr_pages;
-	arg.pages_found = 0;
-
-	/*
-	 * It may be possible to isolate a pageblock even if the
-	 * migratetype is not MIGRATE_MOVABLE. The memory isolation
-	 * notifier chain is used by balloon drivers to return the
-	 * number of pages in a range that are held by the balloon
-	 * driver to shrink memory. If all the pages are accounted for
-	 * by balloons, are free, or on the LRU, isolation can continue.
-	 * Later, for example, when memory hotplug notifier runs, these
-	 * pages reported as "can be isolated" should be isolated(freed)
-	 * by the balloon driver through the memory notifier chain.
-	 */
-	notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
-	notifier_ret = notifier_to_errno(notifier_ret);
-	if (notifier_ret)
-		goto out;
-	/*
-	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
-	 */
-	if (!__has_unmovable_pages(zone, page, arg.pages_found))
-		ret = 0;
-	/*
-	 * Unmovable means "not-on-lru" pages. If Unmovable pages are
-	 * larger than removable-by-driver pages reported by notifier,
-	 * we'll fail.
-	 */
-
-out:
-	if (!ret) {
-		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
-		move_freepages_block(zone, page, MIGRATE_ISOLATE);
-	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
-	if (!ret)
-		drain_all_pages();
-	return ret;
-}
-
-void unset_migratetype_isolate(struct page *page, unsigned migratetype)
-{
-	struct zone *zone;
-	unsigned long flags;
-	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
-		goto out;
-	set_pageblock_migratetype(page, migratetype);
-	move_freepages_block(zone, page, migratetype);
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
+	return !has_unmovable_pages(zone, page, 0);
 }
 
 #ifdef CONFIG_CMA
diff -puN mm/page_isolation.c~mm-factor-out-memory-isolate-functions mm/page_isolation.c
--- a/mm/page_isolation.c~mm-factor-out-memory-isolate-functions
+++ a/mm/page_isolation.c
@@ -5,8 +5,79 @@
 #include <linux/mm.h>
 #include <linux/page-isolation.h>
 #include <linux/pageblock-flags.h>
+#include <linux/memory.h>
 #include "internal.h"
 
+int set_migratetype_isolate(struct page *page)
+{
+	struct zone *zone;
+	unsigned long flags, pfn;
+	struct memory_isolate_notify arg;
+	int notifier_ret;
+	int ret = -EBUSY;
+
+	zone = page_zone(page);
+
+	spin_lock_irqsave(&zone->lock, flags);
+
+	pfn = page_to_pfn(page);
+	arg.start_pfn = pfn;
+	arg.nr_pages = pageblock_nr_pages;
+	arg.pages_found = 0;
+
+	/*
+	 * It may be possible to isolate a pageblock even if the
+	 * migratetype is not MIGRATE_MOVABLE. The memory isolation
+	 * notifier chain is used by balloon drivers to return the
+	 * number of pages in a range that are held by the balloon
+	 * driver to shrink memory. If all the pages are accounted for
+	 * by balloons, are free, or on the LRU, isolation can continue.
+	 * Later, for example, when memory hotplug notifier runs, these
+	 * pages reported as "can be isolated" should be isolated(freed)
+	 * by the balloon driver through the memory notifier chain.
+	 */
+	notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
+	notifier_ret = notifier_to_errno(notifier_ret);
+	if (notifier_ret)
+		goto out;
+	/*
+	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
+	 * We just check MOVABLE pages.
+	 */
+	if (!has_unmovable_pages(zone, page, arg.pages_found))
+		ret = 0;
+
+	/*
+	 * immobile means "not-on-lru" paes. If immobile is larger than
+	 * removable-by-driver pages reported by notifier, we'll fail.
+	 */
+
+out:
+	if (!ret) {
+		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
+		move_freepages_block(zone, page, MIGRATE_ISOLATE);
+	}
+
+	spin_unlock_irqrestore(&zone->lock, flags);
+	if (!ret)
+		drain_all_pages();
+	return ret;
+}
+
+void unset_migratetype_isolate(struct page *page, unsigned migratetype)
+{
+	struct zone *zone;
+	unsigned long flags;
+	zone = page_zone(page);
+	spin_lock_irqsave(&zone->lock, flags);
+	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
+		goto out;
+	set_pageblock_migratetype(page, migratetype);
+	move_freepages_block(zone, page, migratetype);
+out:
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
 static inline struct page *
 __first_valid_page(unsigned long pfn, unsigned long nr_pages)
 {
_
Subject: Subject: mm: factor out memory isolate functions

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
vmscan-remove-obsolete-shrink_control-comment.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch

