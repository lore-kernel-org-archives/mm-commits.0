From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:22:59 -0800
Message-ID: <20171120212259.jms5mN65K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbdKTVXA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm, compaction: remove unneeded pageblock_skip_persistent() checks
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: remove unneeded pageblock_skip_persistent() checks

f3c931633a59 ("mm, compaction: persistently skip hugetlbfs pageblocks")
has introduced pageblock_skip_persistent() checks into migration and free
scanners, to make sure pageblocks that should be persistently skipped are
marked as such, regardless of the ignore_skip_hint flag.

Since the previous patch introduced a new no_set_skip_hint flag, the
ignore flag no longer prevents marking pageblocks as skipped.  Therefore
we can remove the special cases.  The relevant pageblocks will be marked
as skipped by the common logic which marks each pageblock where no page
could be isolated.  This makes the code simpler.

Link: http://lkml.kernel.org/r/20171102121706.21504-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-remove-unneeded-pageblock_skip_persistent-checks mm/compaction.c
--- a/mm/compaction.c~mm-compaction-remove-unneeded-pageblock_skip_persistent-checks
+++ a/mm/compaction.c
@@ -476,10 +476,7 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (pageblock_skip_persistent(page, order)) {
-				set_pageblock_skip(page);
-				blockpfn = end_pfn;
-			} else if (likely(order < MAX_ORDER)) {
+			if (likely(order < MAX_ORDER)) {
 				blockpfn += (1UL << order) - 1;
 				cursor += (1UL << order) - 1;
 			}
@@ -801,10 +798,7 @@ isolate_migratepages_block(struct compac
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (pageblock_skip_persistent(page, order)) {
-				set_pageblock_skip(page);
-				low_pfn = end_pfn;
-			} else if (likely(order < MAX_ORDER))
+			if (likely(order < MAX_ORDER))
 				low_pfn += (1UL << order) - 1;
 			goto isolate_fail;
 		}
@@ -867,13 +861,7 @@ isolate_migratepages_block(struct compac
 			 * is safe to read and it's 0 for tail pages.
 			 */
 			if (unlikely(PageCompound(page))) {
-				const unsigned int order = compound_order(page);
