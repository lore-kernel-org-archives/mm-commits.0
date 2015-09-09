From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:47:19 -0700
Message-ID: <55f08cc7.ryi9o6v1bbS7K5LY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbbIITrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip compound pages by order in free scanner
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: skip compound pages by order in free scanner

The compaction free scanner is looking for PageBuddy() pages and skipping
all others.  For large compound pages such as THP or hugetlbfs, we can
save a lot of iterations if we skip them at once using their
compound_order().  This is generally unsafe and we can read a bogus value
of order due to a race, but if we are careful, the only danger is skipping
too much.

When tested with stress-highalloc from mmtests on 4GB system with 1GB
hugetlbfs pages, the vmstat compact_free_scanned count decreased by at
least 15%.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN mm/compaction.c~mm-compaction-skip-compound-pages-by-order-in-free-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-compound-pages-by-order-in-free-scanner
+++ a/mm/compaction.c
@@ -437,6 +437,24 @@ static unsigned long isolate_freepages_b
 
 		if (!valid_page)
 			valid_page = page;
+
+		/*
+		 * For compound pages such as THP and hugetlbfs, we can save
+		 * potentially a lot of iterations if we skip them at once.
+		 * The check is racy, but we can consider only valid values
+		 * and the only danger is skipping too much.
+		 */
+		if (PageCompound(page)) {
+			unsigned int comp_order = compound_order(page);
+
+			if (likely(comp_order < MAX_ORDER)) {
+				blockpfn += (1UL << comp_order) - 1;
+				cursor += (1UL << comp_order) - 1;
+			}
+
+			goto isolate_fail;
+		}
+
 		if (!PageBuddy(page))
 			goto isolate_fail;
 
@@ -496,6 +514,13 @@ isolate_fail:
 
 	}
 
+	/*
+	 * There is a tiny chance that we have read bogus compound_order(),
+	 * so be careful to not go outside of the pageblock.
+	 */
+	if (unlikely(blockpfn > end_pfn))
+		blockpfn = end_pfn;
+
 	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
 					nr_scanned, total_isolated);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


