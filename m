From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch.patch added to
 -mm tree
Date: Sat, 25 Apr 2020 20:04:40 -0700
Message-ID: <20200426030440.r7jzhNvoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgDZDEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 23:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jaewon31.kim@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org, shli@fb.com, ytk.lee@samsung.com


The patch titled
     Subject: mm/vmscan: count layzfree pages and fix nr_isolated_* mismatch
has been added to the -mm tree.  Its filename is
     mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm/vmscan: count layzfree pages and fix nr_isolated_* mismatch

Fix an nr_isolate_* mismatch problem between cma and dirty lazyfree pages.

If try_to_unmap_one is used for reclaim and it detects a dirty lazyfree
page, then the lazyfree page is changed to a normal anon page having
SwapBacked by commit 802a3a92ad7a ("mm: reclaim MADV_FREE pages").  Even
with the change, reclaim context correctly counts isolated files because
it uses is_file_lru to distinguish file.  And the change to anon is not
happened if try_to_unmap_one is used for migration.  So migration context
like compaction also correctly counts isolated files even though it uses
page_is_file_lru insted of is_file_lru.  Recently page_is_file_cache was
renamed to page_is_file_lru by commit 9de4f22a60f7 ("mm: code cleanup for
MADV_FREE").

But the nr_isolate_* mismatch problem happens on cma alloc.  There is
reclaim_clean_pages_from_list which is being used only by cma.  It was
introduced by commit 02c6de8d757c ("mm: cma: discard clean pages during
contiguous allocation instead of migration") to reclaim clean file pages
without migration.  The cma alloc uses both reclaim_clean_pages_from_list
and migrate_pages, and it uses page_is_file_lru to count isolated files. 
If there are dirty lazyfree pages allocated from cma memory region, the
pages are counted as isolated file at the beginging but are counted as
isolated anon after finished.

Mem-Info:
Node 0 active_anon:3045904kB inactive_anon:611448kB active_file:14892kB inactive_file:205636kB unevictable:10416kB isolated(anon):0kB isolated(file):37664kB mapped:630216kB dirty:384kB writeback:0kB shmem:42576kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no

Like log above, there were too much isolated files, 37664kB, which
triggers too_many_isolated in reclaim even when there is no actually
isolated file in system wide.  It could be reproducible by running two
programs, writing on MADV_FREE page and doing cma alloc, respectively. 
Although isolated anon is 0, I found that the internal value of isolated
anon was the negative value of isolated file.

Fix this by compensating the isolated count for both LRU lists.  Count
non-discarded lazyfree pages in shrink_page_list, then compensate the
counted number in reclaim_clean_pages_from_list.

Link: http://lkml.kernel.org/r/20200426011718.30246-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    1 +
 mm/vmscan.c            |   26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/include/linux/vmstat.h~mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch
+++ a/include/linux/vmstat.h
@@ -29,6 +29,7 @@ struct reclaim_stat {
 	unsigned nr_activate[2];
 	unsigned nr_ref_keep;
 	unsigned nr_unmap_fail;
+	unsigned nr_lazyfree_fail;
 };
 
 enum writeback_stat_item {
--- a/mm/vmscan.c~mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch
+++ a/mm/vmscan.c
@@ -1295,11 +1295,15 @@ static unsigned long shrink_page_list(st
 		 */
 		if (page_mapped(page)) {
 			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH;
+			bool was_swapbacked = PageSwapBacked(page);
 
 			if (unlikely(PageTransHuge(page)))
 				flags |= TTU_SPLIT_HUGE_PMD;
+
 			if (!try_to_unmap(page, flags)) {
 				stat->nr_unmap_fail += nr_pages;
+				if (!was_swapbacked && PageSwapBacked(page))
+					stat->nr_lazyfree_fail += nr_pages;
 				goto activate_locked;
 			}
 		}
@@ -1491,8 +1495,8 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	struct reclaim_stat dummy_stat;
-	unsigned long ret;
+	struct reclaim_stat stat;
+	unsigned long nr_reclaimed;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1504,11 +1508,21 @@ unsigned long reclaim_clean_pages_from_l
 		}
 	}
 
-	ret = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_IGNORE_ACCESS, &dummy_stat, true);
+	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
+			TTU_IGNORE_ACCESS, &stat, true);
 	list_splice(&clean_pages, page_list);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -ret);
-	return ret;
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
+	/*
+	 * Since lazyfree pages are isolated from file LRU from the beginning,
+	 * they will rotate back to anonymous LRU in the end if it failed to
+	 * discard so isolated count will be mismatched.
+	 * Compensate the isolated count for both LRU lists.
+	 */
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_ANON,
+			    stat.nr_lazyfree_fail);
+	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
+			    -stat.nr_lazyfree_fail);
+	return nr_reclaimed;
 }
 
 /*
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

mm-vmscan-count-layzfree-pages-and-fix-nr_isolated_-mismatch.patch
