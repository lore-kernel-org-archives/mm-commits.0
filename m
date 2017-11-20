From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:22:49 -0800
Message-ID: <20171120212249.39-p9jG2v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752816AbdKTVWu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm, compaction: persistently skip hugetlbfs pageblocks
has been removed from the -mm tree.  Its filename was
     mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: persistently skip hugetlbfs pageblocks

It is pointless to migrate hugetlb memory as part of memory compaction if
the hugetlb size is equal to the pageblock order.  No defragmentation is
occurring in this condition.

It is also pointless to for the freeing scanner to scan a pageblock where
a hugetlb page is pinned.  Unconditionally skip these pageblocks, and do
so peristently so that they are not rescanned until it is observed that
these hugepages are no longer pinned.

It would also be possible to do this by involving the hugetlb subsystem in
marking pageblocks to no longer be skipped when they hugetlb pages are
freed.  This is a simple solution that doesn't involve any additional
subsystems in pageblock skip manipulation.

[rientjes@google.com: fix build]
  Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708201734390.117182@chino.kir.corp.google.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708151639130.106658@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |   11 ++++++
 mm/compaction.c                 |   54 +++++++++++++++++++++++-------
 2 files changed, 54 insertions(+), 11 deletions(-)

diff -puN include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-compaction-persistently-skip-hugetlbfs-pageblocks
+++ a/include/linux/pageblock-flags.h
@@ -96,6 +96,17 @@ void set_pfnblock_flags_mask(struct page
 #define set_pageblock_skip(page) \
 			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
 							PB_migrate_skip)
+#else
+static inline bool get_pageblock_skip(struct page *page)
+{
+	return false;
+}
+static inline void clear_pageblock_skip(struct page *page)
+{
+}
+static inline void set_pageblock_skip(struct page *page)
+{
+}
 #endif /* CONFIG_COMPACTION */
 
 #endif	/* PAGEBLOCK_FLAGS_H */
diff -puN mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks mm/compaction.c
--- a/mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks
+++ a/mm/compaction.c
@@ -219,6 +219,20 @@ static void reset_cached_positions(struc
 }
 
 /*
+ * Hugetlbfs pages should consistenly be skipped until updated by the hugetlb
+ * subsystem.  It is always pointless to compact pages of pageblock_order and
+ * the free scanner can reconsider when no longer huge.
+ */
+static bool pageblock_skip_persistent(struct page *page, unsigned int order)
+{
+	if (!PageHuge(page))
+		return false;
+	if (order != pageblock_order)
+		return false;
+	return true;
+}
+
+/*
  * This function is called to clear all cached information on pageblocks that
  * should be skipped for page isolation when the migrate and free page scanner
  * meet.
@@ -242,6 +256,8 @@ static void __reset_isolation_suitable(s
 			continue;
 		if (zone != page_zone(page))
 			continue;
+		if (pageblock_skip_persistent(page, compound_order(page)))
+			continue;
 
 		clear_pageblock_skip(page);
 	}
@@ -307,7 +323,13 @@ static inline bool isolation_suitable(st
 	return true;
 }
 
-static void update_pageblock_skip(struct compact_control *cc,
+static inline bool pageblock_skip_persistent(struct page *page,
+					     unsigned int order)
+{
+	return false;
+}
+
+static inline void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
 			bool migrate_scanner)
 {
@@ -449,13 +471,15 @@ static unsigned long isolate_freepages_b
 		 * and the only danger is skipping too much.
 		 */
 		if (PageCompound(page)) {
-			unsigned int comp_order = compound_order(page);
+			const unsigned int order = compound_order(page);
 
-			if (likely(comp_order < MAX_ORDER)) {
-				blockpfn += (1UL << comp_order) - 1;
-				cursor += (1UL << comp_order) - 1;
+			if (pageblock_skip_persistent(page, order)) {
+				set_pageblock_skip(page);
+				blockpfn = end_pfn;
+			} else if (likely(order < MAX_ORDER)) {
+				blockpfn += (1UL << order) - 1;
+				cursor += (1UL << order) - 1;
 			}
-
 			goto isolate_fail;
 		}
 
@@ -772,11 +796,13 @@ isolate_migratepages_block(struct compac
 		 * danger is skipping too much.
 		 */
 		if (PageCompound(page)) {
-			unsigned int comp_order = compound_order(page);
-
-			if (likely(comp_order < MAX_ORDER))
-				low_pfn += (1UL << comp_order) - 1;
+			const unsigned int order = compound_order(page);
 
+			if (pageblock_skip_persistent(page, order)) {
+				set_pageblock_skip(page);
+				low_pfn = end_pfn;
+			} else if (likely(order < MAX_ORDER))
+				low_pfn += (1UL << order) - 1;
 			goto isolate_fail;
 		}
 
@@ -838,7 +864,13 @@ isolate_migratepages_block(struct compac
 			 * is safe to read and it's 0 for tail pages.
 			 */
 			if (unlikely(PageCompound(page))) {
-				low_pfn += (1UL << compound_order(page)) - 1;
+				const unsigned int order = compound_order(page);
+
+				if (pageblock_skip_persistent(page, order)) {
+					set_pageblock_skip(page);
+					low_pfn = end_pfn;
+				} else
+					low_pfn += (1UL << order) - 1;
 				goto isolate_fail;
 			}
 		}
_

Patches currently in -mm which might be from rientjes@google.com are


