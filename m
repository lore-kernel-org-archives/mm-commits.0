From: akpm@linux-foundation.org
Subject: [patch 044/102] mm: page_alloc: __GFP_NOWARN shouldn't
 suppress stall warnings
Date: Wed, 03 May 2017 14:53:48 -0700
Message-ID: <20170503215348.HK-PEDTWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdECVyK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, torvalds@linux-foundation.org

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
@@ -3751,7 +3751,7 @@ retry:
 
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
-		warn_alloc(gfp_mask, ac->nodemask,
+		warn_alloc(gfp_mask & ~__GFP_NOWARN, ac->nodemask,
 			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
_
