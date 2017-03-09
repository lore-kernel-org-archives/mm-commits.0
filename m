From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch added to
 -mm tree
Date: Thu, 09 Mar 2017 14:24:11 -0800
Message-ID: <58c1d60b.7z69kqxgse97augN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbdCIWYN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 17:24:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: __GFP_NOWARN shouldn't suppress stall warnings
has been added to the -mm tree.  Its filename is
     mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: __GFP_NOWARN shouldn't suppress stall warnings

__GFP_NOWARN, which is usually added to avoid warnings from callsites that
expect to fail and have fallbacks, currently also suppresses allocation
stall warnings.  These trigger when an allocation is stuck inside the
allocator for 10 seconds or longer.

But there is no class of allocations that can get legitimately stuck in
the allocator for this long.  This always indicates a problem.

Always emit stall warnings. Restrict __GFP_NOWARN to alloc failures.

Link: http://lkml.kernel.org/r/20170125181150.GA16398@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings
+++ a/mm/page_alloc.c
@@ -3814,7 +3814,7 @@ retry:
 
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
-		warn_alloc(gfp_mask, ac->nodemask,
+		warn_alloc(gfp_mask & ~__GFP_NOWARN, ac->nodemask,
 			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch
mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch

