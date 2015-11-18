From: akpm@linux-foundation.org
Subject: + mm-get-rid-of-__alloc_pages_high_priority.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 16:33:21 -0800
Message-ID: <564bc751.TmTe3o1QKxouO22R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbbKRAdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: get rid of __alloc_pages_high_priority()
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-__alloc_pages_high_priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-__alloc_pages_high_priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-__alloc_pages_high_priority.patch

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
Subject: mm/page_alloc.c: get rid of __alloc_pages_high_priority()

__alloc_pages_high_priority doesn't do anything special other than it
calls get_page_from_freelist and loops around GFP_NOFAIL allocation until
it succeeds.  It would be better if the first part was done in
__alloc_pages_slowpath where we modify the zonelist because this would be
easier to read and understand.  Opencoding the function into its only
caller allows to simplify it a bit as well.

This patch doesn't introduce any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority
+++ a/mm/page_alloc.c
@@ -2876,28 +2876,6 @@ retry:
 	return page;
 }
 
-/*
- * This is called in the allocator slow-path if the allocation request is of
- * sufficient urgency to ignore watermarks and take other desperate measures
- */
-static inline struct page *
-__alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
-				const struct alloc_context *ac)
-{
-	struct page *page;
-
-	do {
-		page = get_page_from_freelist(gfp_mask, order,
-						ALLOC_NO_WATERMARKS, ac);
-
-		if (!page && gfp_mask & __GFP_NOFAIL)
-			wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC,
-									HZ/50);
-	} while (!page && (gfp_mask & __GFP_NOFAIL));
-
-	return page;
-}
-
 static void wake_all_kswapds(unsigned int order, const struct alloc_context *ac)
 {
 	struct zoneref *z;
@@ -3042,12 +3020,16 @@ retry:
 		 * allocations are system rather than user orientated
 		 */
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
-
-		page = __alloc_pages_high_priority(gfp_mask, order, ac);
