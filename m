From: akpm@linux-foundation.org
Subject: [merged] mm-enable-madv_free-for-swapless-system.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:09:50 -0700
Message-ID: <20170504190950.SAsomQhlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51006 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756213AbdEDTJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com


The patch titled
     Subject: mm: enable MADV_FREE for swapless system
has been removed from the -mm tree.  Its filename was
     mm-enable-madv_free-for-swapless-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: enable MADV_FREE for swapless system

Now MADV_FREE pages can be easily reclaimed even for swapless system.  We
can safely enable MADV_FREE for all systems.

Link: http://lkml.kernel.org/r/155648585589300bfae1d45078e7aebb3d988b87.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/madvise.c~mm-enable-madv_free-for-swapless-system mm/madvise.c
--- a/mm/madvise.c~mm-enable-madv_free-for-swapless-system
+++ a/mm/madvise.c
@@ -650,13 +650,7 @@ madvise_vma(struct vm_area_struct *vma,
 	case MADV_WILLNEED:
 		return madvise_willneed(vma, prev, start, end);
 	case MADV_FREE:
-		/*
-		 * XXX: In this implementation, MADV_FREE works like
-		 * MADV_DONTNEED on swapless system or full swap.
-		 */
-		if (get_nr_swap_pages() > 0)
-			return madvise_free(vma, prev, start, end);
-		/* passthrough */
+		return madvise_free(vma, prev, start, end);
 	case MADV_DONTNEED:
 		return madvise_dontneed(vma, prev, start, end);
 	default:
_

Patches currently in -mm which might be from shli@fb.com are


