From: akpm@linux-foundation.org
Subject: + mm-compaction-cleanup-isolate_freepages.patch added to -mm tree
Date: Mon, 21 Apr 2014 12:41:55 -0700
Message-ID: <53557483.gGjoPudee3mPx8+t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaDUTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-compaction-cleanup-isolate_freepages.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 12:41:55 -0700


The patch titled
     Subject: mm/compaction: cleanup isolate_freepages()
has been added to the -mm tree.  Its filename is
     mm-compaction-cleanup-isolate_freepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-cleanup-isolate_freepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-cleanup-isolate_freepages.patch

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
Subject: mm/compaction: cleanup isolate_freepages()

isolate_freepages() is currently somewhat hard to follow thanks to many
looks like it is related to the 'low_pfn' variable, but in fact it is not.

This patch renames the 'high_pfn' variable to a hopefully less confusing name,
and slightly changes its handling without a functional change. A comment made
obsolete by recent changes is also updated.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages
+++ a/mm/compaction.c
@@ -662,7 +662,7 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
+	unsigned long pfn, low_pfn, next_free_pfn, z_end_pfn;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -679,11 +679,10 @@ static void isolate_freepages(struct zon
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * Take care that if the migration scanner is at the end of the zone
-	 * that the free scanner does not accidentally move to the next zone
-	 * in the next isolation cycle.
+	 * Seed the value for max(next_free_pfn, pfn) updates. If there are
+	 * none, the pfn < low_pfn check will kick in.
 	 */
-	high_pfn = min(low_pfn, pfn);
+	next_free_pfn = 0;
 
 	z_end_pfn = zone_end_pfn(zone);
 
@@ -744,7 +743,7 @@ static void isolate_freepages(struct zon
 		 */
 		if (isolated) {
 			cc->finished_update_free = true;
-			high_pfn = max(high_pfn, pfn);
+			next_free_pfn = max(next_free_pfn, pfn);
 		}
 	}
 
@@ -756,9 +755,9 @@ static void isolate_freepages(struct zon
 	 * so that compact_finished() may detect this
 	 */
 	if (pfn < low_pfn)
-		cc->free_pfn = max(pfn, zone->zone_start_pfn);
-	else
-		cc->free_pfn = high_pfn;
+		next_free_pfn = max(pfn, zone->zone_start_pfn);
+
+	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch

