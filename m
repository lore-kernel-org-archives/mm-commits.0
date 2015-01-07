From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch added to -mm tree
Date: Wed, 07 Jan 2015 14:01:30 -0800
Message-ID: <54adacba.+60W9eiYGsI39sI0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbAGWBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 17:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: wake up all pfmemalloc-throttled processes at once
has been added to the -mm tree.  Its filename is
     mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch

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
Subject: mm, vmscan: wake up all pfmemalloc-throttled processes at once

Kswapd in balance_pgdate() currently uses wake_up() on processes waiting
in throttle_direct_reclaim(), which only wakes up a single process.  This
might leave processes waiting for longer than necessary, until the check
is reached in the next loop iteration.  Processes might also be left
waiting if zone was fully balanced in single iteration.  Note that the
comment in balance_pgdat() also says "Wake them", so waking up a single
process does not seem intentional.

Thus, replace wake_up() with wake_up_all().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once
+++ a/mm/vmscan.c
@@ -3175,7 +3175,7 @@ static unsigned long balance_pgdat(pg_da
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
 				pfmemalloc_watermark_ok(pgdat))
-			wake_up(&pgdat->pfmemalloc_wait);
+			wake_up_all(&pgdat->pfmemalloc_wait);
 
 		/*
 		 * Fragmentation may mean that the system cannot be rebalanced
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch

