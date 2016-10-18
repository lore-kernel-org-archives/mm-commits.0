From: akpm@linux-foundation.org
Subject: + mm-make-unreserve-highatomic-functions-reliable.patch added to
 -mm tree
Date: Tue, 18 Oct 2016 15:16:36 -0700
Message-ID: <58069f44.+v3hrP+IlBK7zpsQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57917 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935681AbcJRWQh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 18:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, sangseok.lee@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make unreserve highatomic functions reliable
has been added to the -mm tree.  Its filename is
     mm-make-unreserve-highatomic-functions-reliable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-unreserve-highatomic-functions-reliable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-unreserve-highatomic-functions-reliable.patch

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
Subject: mm: make unreserve highatomic functions reliable

Currently, unreserve_highatomic_pageblock bails out if it found highatomic
pageblock regardless of really moving free pages from the one so that it
could mitigate unreserve logic's goal which saves OOM of a process.

This patch makes unreserve functions bail out only if it moves some pages
out of !highatomic free list to avoid such false positive.

Another potential problem is that by race between page freeing and reserve
highatomic function, pages could be in highatomic free list even though
the pageblock is !high atomic migratetype.  In that case,
unreserve_highatomic_pageblock can be void if count of highatomic reserve
is less than pageblock_nr_pages.  We could solve it simply via draining
all of reserved pages before the OOM.  It would have a safeguard role to
exhuast reserved pages before converging to OOM.

Link: http://lkml.kernel.org/r/1476259429-18279-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-make-unreserve-highatomic-functions-reliable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-unreserve-highatomic-functions-reliable
+++ a/mm/page_alloc.c
@@ -2058,8 +2058,12 @@ out_unlock:
  * potentially hurts the reliability of high-order allocations when under
  * intense memory pressure but failed atomic allocations should be easier
  * to recover from than an OOM.
+ *
+ * If @force is true, try to unreserve a pageblock even though highatomic
+ * pageblock is exhausted.
  */
-static bool unreserve_highatomic_pageblock(const struct alloc_context *ac)
+static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
+						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
 	unsigned long flags;
@@ -2071,8 +2075,12 @@ static bool unreserve_highatomic_pageblo
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->high_zoneidx,
 								ac->nodemask) {
-		/* Preserve at least one pageblock */
-		if (zone->nr_reserved_highatomic <= pageblock_nr_pages)
+		/*
+		 * Preserve at least one pageblock unless memory pressure
+		 * is really high.
+		 */
+		if (!force && zone->nr_reserved_highatomic <=
+					pageblock_nr_pages)
 			continue;
 
 		spin_lock_irqsave(&zone->lock, flags);
@@ -2117,8 +2125,10 @@ static bool unreserve_highatomic_pageblo
 			 */
 			set_pageblock_migratetype(page, ac->migratetype);
 			ret = move_freepages_block(zone, page, ac->migratetype);
-			spin_unlock_irqrestore(&zone->lock, flags);
-			return ret;
+			if (ret) {
+				spin_unlock_irqrestore(&zone->lock, flags);
+				return ret;
+			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -3322,7 +3332,7 @@ retry:
 	 * Shrink them them and try again
 	 */
 	if (!page && !drained) {
-		unreserve_highatomic_pageblock(ac);
+		unreserve_highatomic_pageblock(ac, false);
 		drain_all_pages(NULL);
 		drained = true;
 		goto retry;
@@ -3441,7 +3451,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	 */
 	if (*no_progress_loops > MAX_RECLAIM_RETRIES) {
 		/* Before OOM, exhaust highatomic_reserve */
-		return unreserve_highatomic_pageblock(ac);
+		return unreserve_highatomic_pageblock(ac, true);
 	}
 
 	/*
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-steal-highatomic-pageblock.patch
mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
mm-try-to-exhaust-highatomic-reserve-before-the-oom.patch
mm-make-unreserve-highatomic-functions-reliable.patch

