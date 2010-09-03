From: akpm@linux-foundation.org
Subject: + vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch added to -mm tree
Date: Fri, 03 Sep 2010 14:07:08 -0700
Message-ID: <201009032107.o83L78C1012387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab0ICVIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 17:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     vmscan: prevent background aging of anon page in no swap system
has been added to the -mm tree.  Its filename is
     vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>

Ying Han reported that backing aging of anon pages in no swap system
causes unnecessary TLB flush.

When I sent a patch(69c8548175), I wanted this patch but Rik pointed out
and allowed aging of anon pages to give a chance to promote from inactive
to active LRU.

It has a two problem.

1) non-swap system

Never make sense to age anon pages.

2) swap configured but still doesn't swapon

It doesn't make sense to age anon pages until swap-on time.  But it's
arguable.  If we have aged anon pages by swapon, VM have moved anon pages
from active to inactive.  And in the time swapon by admin, the VM can't
reclaim hot pages so we can protect hot pages swapout.

But let's think about it.  When does swap-on happen?  It depends on admin.
 we can't expect it.  Nonetheless, we have done aging of anon pages to
protect hot pages swapout.  It means we lost run time overhead when below
high watermark but gain hot page swap-[in/out] overhead when VM decide
swapout.  Is it true?  Let's think more detail.  We don't promote anon
pages in case of non-swap system.  So even though VM does aging of anon
pages, the pages would be in inactive LRU for a long time.  It means many
of pages in there would mark access bit again.  So access bit hot/code
separation would be pointless.

This patch prevents unnecessary anon pages demotion in not-swapon and
non-configured swap system.  Of course, it could make side effect that hot
anon pages could swap out when admin does swap on.  But I think sooner or
later it would be steady state.  So it's not a big problem.  We could lose
someting but gain more thing(TLB flush and unnecessary function call to
demote anon pages).

I used total_swap_pages because we want to age anon pages even though swap
full happens.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-prevent-background-aging-of-anon-page-in-no-swap-system mm/vmscan.c
--- a/mm/vmscan.c~vmscan-prevent-background-aging-of-anon-page-in-no-swap-system
+++ a/mm/vmscan.c
@@ -2137,7 +2137,7 @@ loop_again:
 			 * Do some background aging of the anon list, to give
 			 * pages a chance to be referenced before reclaiming.
 			 */
-			if (inactive_anon_is_low(zone, &sc))
+			if (total_swap_pages > 0 && inactive_anon_is_low(zone, &sc))
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-vmap-area-cache.patch

