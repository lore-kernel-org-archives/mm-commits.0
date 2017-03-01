From: akpm@linux-foundation.org
Subject: + mm-enable-madv_free-for-swapless-system.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:32:41 -0800
Message-ID: <58b616a9.z5JrJ7AVrmbUg2YK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdCAA46 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable MADV_FREE for swapless system
has been added to the -mm tree.  Its filename is
     mm-enable-madv_free-for-swapless-system.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-enable-madv_free-for-swapless-system.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-enable-madv_free-for-swapless-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -612,13 +612,7 @@ madvise_vma(struct vm_area_struct *vma,
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

mm-delete-unnecessary-ttu_-flags.patch
mm-dont-assume-anonymous-pages-have-swapbacked-flag.patch
mm-move-madv_free-pages-into-lru_inactive_file-list.patch
mm-reclaim-madv_free-pages.patch
mm-enable-madv_free-for-swapless-system.patch
proc-show-madv_free-pages-info-in-smaps.patch

