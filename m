From: akpm@linux-foundation.org
Subject: +
 mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch added
 to -mm tree
Date: Wed, 07 May 2014 14:22:42 -0700
Message-ID: <536aa422.Tztkj8/xeZ6tLV/F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:22:42 -0700


The patch titled
     Subject: mm/compaction: avoid rescanning pageblocks in isolate_freepages
has been added to the -mm tree.  Its filename is
     mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch

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
Subject: mm/compaction: avoid rescanning pageblocks in isolate_freepages

The compaction free scanner in isolate_freepages() currently remembers PFN
of the highest pageblock where it successfully isolates, to be used as the
starting pageblock for the next invocation.  The rationale behind this is
that page migration might return free pages to the allocator when
migration fails and we don't want to skip them if the compaction
continues.

Since migration now returns free pages back to compaction code where they
can be reused, this is no longer a concern.  This patch changes
isolate_freepages() so that the PFN for restarting is updated with each
pageblock where isolation is attempted.  Using stress-highalloc from
mmtests, this resulted in 10% reduction of the pages scanned by the free
scanner.

Note that the somewhat similar functionality that records highest
successful pageblock in zone->compact_cached_free_pfn, remains unchanged. 
This cache is used when the whole compaction is restarted, not for
multiple invocations of the free scanner during single compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages
+++ a/mm/compaction.c
@@ -706,12 +706,6 @@ static void isolate_freepages(struct zon
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * If no pages are isolated, the block_start_pfn < low_pfn check
-	 * will kick in.
-	 */
-	next_free_pfn = 0;
-
-	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
@@ -751,19 +745,19 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
+		next_free_pfn = block_start_pfn;
 		isolated = isolate_freepages_block(cc, block_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
-		 * Record the highest PFN we isolated pages from. When next
-		 * looking for free pages, the search will restart here as
-		 * page migration may have returned some pages to the allocator
+		 * Set a flag that we successfully isolated in this pageblock.
+		 * In the next loop iteration, zone->compact_cached_free_pfn
+		 * will not be updated and thus it will effectively contain the
+		 * highest pageblock we isolated pages from.
 		 */
-		if (isolated && next_free_pfn == 0) {
+		if (isolated)
 			cc->finished_update_free = true;
-			next_free_pfn = block_start_pfn;
-		}
 	}
 
 	/* split_free_page does not map the pages */
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch

