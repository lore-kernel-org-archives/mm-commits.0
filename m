From: akpm@linux-foundation.org
Subject: + mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
 added to -mm tree
Date: Tue, 18 Oct 2016 15:16:32 -0700
Message-ID: <58069f40.OBO7oTgy6X0Ym50p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57905 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933385AbcJRWQe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 18:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, sangseok.lee@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent double decrease of nr_reserved_highatomic
has been added to the -mm tree.  Its filename is
     mm-prevent-double-decrease-of-nr_reserved_highatomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-double-decrease-of-nr_reserved_highatomic.patch

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
Subject: mm: prevent double decrease of nr_reserved_highatomic

There is race between page freeing and unreserved highatomic.

 CPU 0				    CPU 1

    free_hot_cold_page
      mt = get_pfnblock_migratetype
      set_pcppage_migratetype(page, mt)
    				    unreserve_highatomic_pageblock
    				    spin_lock_irqsave(&zone->lock)
    				    move_freepages_block
    				    set_pageblock_migratetype(page)
    				    spin_unlock_irqrestore(&zone->lock)
      free_pcppages_bulk
        __free_one_page(mt) <- mt is stale

By above race, a page on CPU 0 could go non-highorderatomic free list
since the pageblock's type is changed.  By that, unreserve logic of
highorderatomic can decrease reserved count on a same pageblock severak
times and then it will make mismatch between nr_reserved_highatomic and
the number of reserved pageblock.

So, this patch verifies whether the pageblock is highatomic or not
and decrease the count only if the pageblock is highatomic.

Link: http://lkml.kernel.org/r/1476259429-18279-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-prevent-double-decrease-of-nr_reserved_highatomic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-prevent-double-decrease-of-nr_reserved_highatomic
+++ a/mm/page_alloc.c
@@ -2085,13 +2085,25 @@ static void unreserve_highatomic_pageblo
 				continue;
 
 			/*
-			 * It should never happen but changes to locking could
-			 * inadvertently allow a per-cpu drain to add pages
-			 * to MIGRATE_HIGHATOMIC while unreserving so be safe
-			 * and watch for underflows.
+			 * In page freeing path, migratetype change is racy so
+			 * we can counter several free pages in a pageblock
+			 * in this loop althoug we changed the pageblock type
+			 * from highatomic to ac->migratetype. So we should
+			 * adjust the count once.
 			 */
-			zone->nr_reserved_highatomic -= min(pageblock_nr_pages,
-				zone->nr_reserved_highatomic);
+			if (get_pageblock_migratetype(page) ==
+							MIGRATE_HIGHATOMIC) {
+				/*
+				 * It should never happen but changes to
+				 * locking could inadvertently allow a per-cpu
+				 * drain to add pages to MIGRATE_HIGHATOMIC
+				 * while unreserving so be safe and watch for
+				 * underflows.
+				 */
+				zone->nr_reserved_highatomic -= min(
+						pageblock_nr_pages,
+						zone->nr_reserved_highatomic);
+			}
 
 			/*
 			 * Convert to ac->migratetype and avoid the normal
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-steal-highatomic-pageblock.patch
mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
mm-try-to-exhaust-highatomic-reserve-before-the-oom.patch
mm-make-unreserve-highatomic-functions-reliable.patch

