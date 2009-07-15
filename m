From: akpm@linux-foundation.org
Subject: + page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:28:20 -0700
Message-ID: <200907152028.n6FKSKqC010291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268AbZGOU3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, acme@redhat.com, davem@davemloft.net, rientjes@google.com


The patch titled
     page-allocator: allow too high-order warning messages to be suppressed with __GFP_NOWARN
has been added to the -mm tree.  Its filename is
     page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch

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
Subject: page-allocator: allow too high-order warning messages to be suppressed with __GFP_NOWARN
From: Mel Gorman <mel@csn.ul.ie>

The page allocator warns once when an order >= MAX_ORDER is specified. 
This is to catch callers of the allocator that are always falling back to
their worst-case when it was not expected.  However, there are cases where
the caller is behaving correctly but cannot suppress the warning.  This
patch allows the warning to be suppressed by the callers by specifying
__GFP_NOWARN.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn
+++ a/mm/page_alloc.c
@@ -1755,8 +1755,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * be using allocators in order of preference for an area that is
 	 * too large.
 	 */
-	if (WARN_ON_ONCE(order >= MAX_ORDER))
+	if (order >= MAX_ORDER) {
+		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
 		return NULL;
+	}
 
 	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-clean-up-page_remove_rmap.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch
net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
add-debugging-aid-for-memory-initialisation-problems.patch

