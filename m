From: akpm@linux-foundation.org
Subject: + mm-compaction-cleanup-isolate_freepages-fix-2.patch added to
 -mm tree
Date: Tue, 22 Apr 2014 12:59:16 -0700
Message-ID: <5356ca14.znZIOLyibEm9Rbjw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaDVT7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-compaction-cleanup-isolate_freepages-fix-2.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:59:16 -0700


The patch titled
     Subject: mm-compaction-cleanup-isolate_freepages-fix 2
has been added to the -mm tree.  Its filename is
     mm-compaction-cleanup-isolate_freepages-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-cleanup-isolate_freepages-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-cleanup-isolate_freepages-fix-2.patch

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
Subject: mm-compaction-cleanup-isolate_freepages-fix 2

Cleanup detection of compaction scanners crossing in isolate_freepages(). 
To make sure compact_finished() observes scanners crossing, we can just
set free_pfn to migrate_pfn instead of confusing max() construct.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix-2
+++ a/mm/compaction.c
@@ -758,7 +758,7 @@ static void isolate_freepages(struct zon
 	 * so that compact_finished() may detect this
 	 */
 	if (pfn < low_pfn)
-		next_free_pfn = max(pfn, zone->zone_start_pfn);
+		next_free_pfn = cc->migrate_pfn;
 
 	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch

