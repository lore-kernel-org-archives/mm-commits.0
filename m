From: akpm@linux-foundation.org
Subject: +
 mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
 added to -mm tree
Date: Thu, 21 Aug 2014 15:22:09 -0700
Message-ID: <53f67111.q3qeUGC4KYru6r9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:36735 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaHUWWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:11 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so1513107obc.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:22:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip buddy pages by their order in the migrate scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: skip buddy pages by their order in the migrate scanner

The migration scanner skips PageBuddy pages, but does not consider their
order as checking page_order() is generally unsafe without holding the
zone->lock, and acquiring the lock just for the check wouldn't be a good
tradeoff.

Still, this could avoid some iterations over the rest of the buddy page,
and if we are careful, the race window between PageBuddy() check and
page_order() is small, and the worst thing that can happen is that we skip
too much and miss some isolation candidates.  This is not that bad, as
compaction can already fail for many other reasons like parallel
allocations, and those have much larger race window.

This patch therefore makes the migration scanner obtain the buddy page
order and use it to skip the whole buddy page, if the order appears to be
in the valid range.

It's important that the page_order() is read only once, so that the value
used in the checks and in the pfn calculation is the same.  But in theory
the compiler can replace the local variable by multiple inlines of
page_order().  Therefore, the patch introduces page_order_unsafe() that
uses ACCESS_ONCE to prevent this.

Testing with stress-highalloc from mmtests shows a 15% reduction in number
of pages scanned by migration scanner.  The reduction is >60% with
__GFP_NO_KSWAPD allocations, along with success rates better by few
percent.  This change is also a prerequisite for a later patch which is
detecting when a cc->order block of pages contains non-buddy pages that
cannot be isolated, and the scanner should thus skip to the next block
immediately.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   36 +++++++++++++++++++++++++++++++-----
 mm/internal.h   |   16 +++++++++++++++-
 2 files changed, 46 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner
+++ a/mm/compaction.c
@@ -313,8 +313,15 @@ static inline bool compact_should_abort(
 static bool suitable_migration_target(struct page *page)
 {
 	/* If the page is a large free page, then disallow migration */
-	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return false;
+	if (PageBuddy(page)) {
+		/*
+		 * We are checking page_order without zone->lock taken. But
+		 * the only small danger is that we skip a potentially suitable
+		 * pageblock, so it's not worth to check order for valid range.
+		 */
+		if (page_order_unsafe(page) >= pageblock_order)
+			return false;
+	}
 
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
 	if (migrate_async_suitable(get_pageblock_migratetype(page)))
@@ -611,11 +618,23 @@ isolate_migratepages_block(struct compac
 			valid_page = page;
 
 		/*
-		 * Skip if free. page_order cannot be used without zone->lock
-		 * as nothing prevents parallel allocations or buddy merging.
+		 * Skip if free. We read page order here without zone lock
+		 * which is generally unsafe, but the race window is small and
+		 * the worst thing that can happen is that we skip some
+		 * potential isolation targets.
 		 */
-		if (PageBuddy(page))
+		if (PageBuddy(page)) {
+			unsigned long freepage_order = page_order_unsafe(page);
+
+			/*
+			 * Without lock, we cannot be sure that what we got is
+			 * a valid page order. Consider only values in the
+			 * valid order range to prevent low_pfn overflow.
+			 */
+			if (freepage_order > 0 && freepage_order < MAX_ORDER)
+				low_pfn += (1UL << freepage_order) - 1;
 			continue;
+		}
 
 		/*
 		 * Check may be lockless but that's ok as we recheck later.
@@ -701,6 +720,13 @@ isolate_success:
 		}
 	}
 
+	/*
+	 * The PageBuddy() check could have potentially brought us outside
+	 * the range to be scanned.
+	 */
+	if (unlikely(low_pfn > end_pfn))
+		low_pfn = end_pfn;
+
 	acct_isolated(zone, locked, cc);
 
 	if (locked)
diff -puN mm/internal.h~mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner mm/internal.h
--- a/mm/internal.h~mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner
+++ a/mm/internal.h
@@ -164,7 +164,8 @@ isolate_migratepages_range(struct compac
  * general, page_zone(page)->lock must be held by the caller to prevent the
  * page from being allocated in parallel and returning garbage as the order.
  * If a caller does not hold page_zone(page)->lock, it must guarantee that the
- * page cannot be allocated or merged in parallel.
+ * page cannot be allocated or merged in parallel. Alternatively, it must
+ * handle invalid values gracefully, and use page_order_unsafe() below.
  */
 static inline unsigned long page_order(struct page *page)
 {
@@ -172,6 +173,19 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+/*
+ * Like page_order(), but for callers who cannot afford to hold the zone lock.
+ * PageBuddy() should be checked first by the caller to minimize race window,
+ * and invalid values must be handled gracefully.
+ *
+ * ACCESS_ONCE is used so that if the caller assigns the result into a local
+ * variable and e.g. tests it for valid range before using, the compiler cannot
+ * decide to remove the variable and inline the page_private(page) multiple
+ * times, potentially observing different values in the tests and the actual
+ * use of the result.
+ */
+#define page_order_unsafe(page)		ACCESS_ONCE(page_private(page))
+
 static inline bool is_cow_mapping(vm_flags_t flags)
 {
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch

