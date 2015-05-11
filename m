From: akpm@linux-foundation.org
Subject: + rename-reclaim_swap-to-reclaim_unmap.patch added to -mm tree
Date: Mon, 11 May 2015 15:52:18 -0700
Message-ID: <555132a2.ko3mPXqa960yG7At%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbEKWwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 May 2015 18:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zzhsuny@gmail.com, hannes@cmpxchg.org, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename RECLAIM_SWAP to RECLAIM_UNMAP
has been added to the -mm tree.  Its filename is
     rename-reclaim_swap-to-reclaim_unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rename-reclaim_swap-to-reclaim_unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rename-reclaim_swap-to-reclaim_unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhihui Zhang <zzhsuny@gmail.com>
Subject: mm: rename RECLAIM_SWAP to RECLAIM_UNMAP

The name SWAP implies that we are dealing with anonymous pages only.  In
fact, the original patch that introduced the min_unmapped_ratio logic was
to fix an issue related to file pages.  Rename it to RECLAIM_UNMAP to
match what does.

Historically, commit a6dc60f8975a ("vmscan: rename sc.may_swap to
may_unmap") renamed .may_swap to .may_unmap, leaving RECLAIM_SWAP behind. 
commit 2e2e42598908 ("vmscan,memcg: reintroduce sc->may_swap")
reintroduced .may_swap for memory controller.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~rename-reclaim_swap-to-reclaim_unmap mm/vmscan.c
--- a/mm/vmscan.c~rename-reclaim_swap-to-reclaim_unmap
+++ a/mm/vmscan.c
@@ -3597,7 +3597,7 @@ int zone_reclaim_mode __read_mostly;
 #define RECLAIM_OFF 0
 #define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
 #define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
+#define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
 
 /*
  * Priority for ZONE_RECLAIM. This determines the fraction of pages
@@ -3639,12 +3639,12 @@ static long zone_pagecache_reclaimable(s
 	long delta = 0;
 
 	/*
-	 * If RECLAIM_SWAP is set, then all file pages are considered
+	 * If RECLAIM_UNMAP is set, then all file pages are considered
 	 * potentially reclaimable. Otherwise, we have to worry about
 	 * pages like swapcache and zone_unmapped_file_pages() provides
 	 * a better estimate
 	 */
-	if (zone_reclaim_mode & RECLAIM_SWAP)
+	if (zone_reclaim_mode & RECLAIM_UNMAP)
 		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
 	else
 		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
@@ -3675,15 +3675,15 @@ static int __zone_reclaim(struct zone *z
 		.order = order,
 		.priority = ZONE_RECLAIM_PRIORITY,
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+		.may_unmap = !!(zone_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
 	};
 
 	cond_resched();
 	/*
-	 * We need to be able to allocate from the reserves for RECLAIM_SWAP
+	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
 	 * and we also need to be able to write out pages for RECLAIM_WRITE
-	 * and RECLAIM_SWAP.
+	 * and RECLAIM_UNMAP.
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
 	lockdep_set_current_reclaim_state(gfp_mask);
_

Patches currently in -mm which might be from zzhsuny@gmail.com are

rename-reclaim_swap-to-reclaim_unmap.patch

