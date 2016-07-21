From: akpm@linux-foundation.org
Subject: + mm-page_alloc-make-thp-specific-decisions-more-generic.patch
 added to -mm tree
Date: Thu, 21 Jul 2016 12:44:07 -0700
Message-ID: <57912607.L+QfQ1fYPteqQp+r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbcGUToI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 15:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: make THP-specific decisions more generic
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-thp-specific-decisions-more-generic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-thp-specific-decisions-more-generic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-thp-specific-decisions-more-generic.patch

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
Subject: mm, page_alloc: make THP-specific decisions more generic

Since THP allocations during page faults can be costly, extra decisions
are employed for them to avoid excessive reclaim and compaction, if the
initial compaction doesn't look promising.  The detection has never been
perfect as there is no gfp flag specific to THP allocations.  At this
moment it checks the whole combination of flags that makes up
GFP_TRANSHUGE, and hopes that no other users of such combination exist, or
would mind being treated the same way.  Extra care is also taken to
separate allocations from khugepaged, where latency doesn't matter that
much.

It is however possible to distinguish these allocations in a simpler and
more reliable way.  The key observation is that after the initial
compaction followed by the first iteration of "standard"
reclaim/compaction, both __GFP_NORETRY allocations and costly allocations
without __GFP_REPEAT are declared as failures:

        /* Do not loop if specifically requested */
        if (gfp_mask & __GFP_NORETRY)
                goto nopage;

        /*
         * Do not retry costly high order allocations unless they are
         * __GFP_REPEAT
         */
        if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
                goto nopage;

This means we can further distinguish allocations that are costly order
*and* additionally include the __GFP_NORETRY flag.  As it happens,
GFP_TRANSHUGE allocations do already fall into this category.  This will
also allow other costly allocations with similar high-order benefit vs
latency considerations to use this semantic.  Furthermore, we can
distinguish THP allocations that should try a bit harder (such as from
khugepageed) by removing __GFP_NORETRY, as will be done in the next patch.

Link: http://lkml.kernel.org/r/20160721073614.24395-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-thp-specific-decisions-more-generic mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-thp-specific-decisions-more-generic
+++ a/mm/page_alloc.c
@@ -3085,7 +3085,6 @@ out:
 	return page;
 }
 
-
 /*
  * Maximum number of compaction retries wit a progress before OOM
  * killer is consider as the only way to move forward.
@@ -3373,11 +3372,6 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 	return false;
 }
 
-static inline bool is_thp_gfp_mask(gfp_t gfp_mask)
-{
-	return (gfp_mask & (GFP_TRANSHUGE | __GFP_KSWAPD_RECLAIM)) == GFP_TRANSHUGE;
-}
-
 /*
  * Maximum number of reclaim retries without any progress before OOM killer
  * is consider as the only way to move forward.
@@ -3567,8 +3561,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		if (page)
 			goto got_pg;
 
-		/* Checks for THP-specific high-order allocations */
-		if (is_thp_gfp_mask(gfp_mask)) {
+		/*
+		 * Checks for costly allocations with __GFP_NORETRY, which
+		 * includes THP page fault allocations
+		 */
+		if (gfp_mask & __GFP_NORETRY) {
 			/*
 			 * If compaction is deferred for high-order allocations,
 			 * it is because sync compaction recently failed. If
@@ -3588,11 +3585,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 				goto nopage;
 
 			/*
-			 * It can become very expensive to allocate transparent
-			 * hugepages at fault, so use asynchronous memory
-			 * compaction for THP unless it is khugepaged trying to
-			 * collapse. All other requests should tolerate at
-			 * least light sync migration.
+			 * Looks like reclaim/compaction is worth trying, but
+			 * sync compaction could be very expensive, so keep
+			 * using async compaction, unless it's khugepaged
+			 * trying to collapse.
 			 */
 			if (!(current->flags & PF_KTHREAD))
 				migration_mode = MIGRATE_ASYNC;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-frontswap-convert-frontswap_enabled-to-static-key.patch
mm-page_alloc-set-alloc_flags-only-once-in-slowpath.patch
mm-page_alloc-dont-retry-initial-attempt-in-slowpath.patch
mm-page_alloc-restructure-direct-compaction-handling-in-slowpath.patch
mm-page_alloc-make-thp-specific-decisions-more-generic.patch
mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations.patch
mm-compaction-introduce-direct-compaction-priority.patch
mm-compaction-simplify-contended-compaction-handling.patch

