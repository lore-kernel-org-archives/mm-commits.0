From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch added to -mm tree
Date: Tue, 16 Dec 2014 15:56:56 -0800
Message-ID: <5490c6c8.lmz7vYU/2yF/A7/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaLPX45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Dec 2014 18:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update
has been added to the -mm tree.  Its filename is
     mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch

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
Subject: mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update

Here is an updated version of this patch with a more detailed changelog.

The OOM killing invocation does a lot of duplicative checks against
the task's allocation context.  Rework it to take advantage of the
existing checks in the allocator slowpath.

The OOM killer is invoked when the allocator is unable to reclaim any
pages but the allocation has to keep looping.  Instead of having a
check for __GFP_NORETRY hidden in oom_gfp_allowed(), just move the OOM
invocation to the true branch of should_alloc_retry().  The __GFP_FS
check from oom_gfp_allowed() can then be moved into the OOM avoidance
branch in __alloc_pages_may_oom(), along with the PF_DUMPCORE test.

__alloc_pages_may_oom() can then signal to the caller whether the OOM
killer was invoked, instead of requiring it to duplicate the order and
high_zoneidx checks to guess this when deciding whether to continue.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update
+++ a/mm/page_alloc.c
@@ -2818,10 +2818,8 @@ rebalance:
 						migratetype,&did_some_progress);
 			if (page)
 				goto got_pg;
-			if (!did_some_progress) {
-				BUG_ON(gfp_mask & __GFP_NOFAIL);
+			if (!did_some_progress)
 				goto nopage;
-			}
 		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch

