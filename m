From: akpm@linux-foundation.org
Subject: + mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 15:53:24 -0700
Message-ID: <59961e64.n2ebHPPnf+o11cgB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753271AbdHQWxZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: persistently skip hugetlbfs pageblocks
has been added to the -mm tree.  Its filename is
     mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708151639130.106658@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff -puN mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks mm/compaction.c
--- a/mm/compaction.c~mm-compaction-persistently-skip-hugetlbfs-pageblocks
+++ a/mm/compaction.c
@@ -218,6 +218,20 @@ static void reset_cached_positions(struc
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
@@ -241,6 +255,8 @@ static void __reset_isolation_suitable(s
 			continue;
 		if (zone != page_zone(page))
 			continue;
+		if (pageblock_skip_persistent(page, compound_order(page)))
+			continue;
 
 		clear_pageblock_skip(page);
 	}
@@ -448,13 +464,15 @@ static unsigned long isolate_freepages_b
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
 
@@ -771,11 +789,13 @@ isolate_migratepages_block(struct compac
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
 
@@ -837,7 +857,13 @@ isolate_migratepages_block(struct compac
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

mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch

