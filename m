From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch added to -mm tree
Date: Mon, 23 Feb 2015 11:41:32 -0800
Message-ID: <54eb826c.7kvsGOwvM/EczB7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbBWTld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 14:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, david@fromorbit.com, mgorman@suse.de, mhocko@suse.cz, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, stable@vger.kernel.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change
has been added to the -mm tree.  Its filename is
     mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch

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
Subject: mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change

Historically, !__GFP_FS allocations were not allowed to invoke the OOM
killer once reclaim had failed, but nevertheless kept looping in the
allocator.  9879de7373fc ("mm: page_alloc: embed OOM killing naturally
into allocation slowpath"), which should have been a simple cleanup patch,
accidentally changed the behavior to aborting the allocation at that
point.  This creates problems with filesystem callers (?) that currently
rely on the allocator waiting for other tasks to intervene.

Revert the behavior as it shouldn't have been changed as part of a cleanup
patch.

Fixes: 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into allocation slowpath")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[3.19.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change
+++ a/mm/page_alloc.c
@@ -2353,8 +2353,15 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (ac->high_zoneidx < ZONE_NORMAL)
 			goto out;
 		/* The OOM killer does not compensate for light reclaim */
-		if (!(gfp_mask & __GFP_FS))
+		if (!(gfp_mask & __GFP_FS)) {
+			/*
+			 * XXX: Page reclaim didn't yield anything,
+			 * and the OOM killer can't be invoked, but
+			 * keep looping as per should_alloc_retry().
+			 */
+			*did_some_progress = 1;
 			goto out;
+		}
 		/*
 		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
 		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-fix-low-limit-calculation.patch
mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
mm-memcontrol-update-copyright-notice.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

