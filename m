From: akpm@linux-foundation.org
Subject: + mm-remove-__gfp_nofail-is-deprecated-comment.patch added to -mm tree
Date: Fri, 26 Feb 2016 16:58:42 -0800
Message-ID: <56d0f4c2.1RkqBZZpfmFURJ5d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbcB0A6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 19:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, kernel@kyup.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __GFP_NOFAIL is deprecated comment
has been added to the -mm tree.  Its filename is
     mm-remove-__gfp_nofail-is-deprecated-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-__gfp_nofail-is-deprecated-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-__gfp_nofail-is-deprecated-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: remove __GFP_NOFAIL is deprecated comment

647757197cd3 ("mm: clarify __GFP_NOFAIL deprecation status") was
incomplete and didn't remove the comment about __GFP_NOFAIL being
deprecated in buffered_rmqueue.  Let's get rid of this leftover but keep
the WARN_ON_ONCE for order > 1 because we should really discourage from
using __GFP_NOFAIL with higher order allocations because those are just
too subtle.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-__gfp_nofail-is-deprecated-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-__gfp_nofail-is-deprecated-comment
+++ a/mm/page_alloc.c
@@ -2347,19 +2347,11 @@ struct page *buffered_rmqueue(struct zon
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
-		if (unlikely(gfp_flags & __GFP_NOFAIL)) {
-			/*
-			 * __GFP_NOFAIL is not to be used in new code.
-			 *
-			 * All __GFP_NOFAIL callers should be fixed so that they
-			 * properly detect and handle allocation failures.
-			 *
-			 * We most definitely don't want callers attempting to
-			 * allocate greater than order-1 page units with
-			 * __GFP_NOFAIL.
-			 */
-			WARN_ON_ONCE(order > 1);
-		}
+		/*
+		 * We most definitely don't want callers attempting to
+		 * allocate greater than order-1 page units with __GFP_NOFAIL.
+		 */
+		WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 		spin_lock_irqsave(&zone->lock, flags);
 
 		page = NULL;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-remove-__gfp_nofail-is-deprecated-comment.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

