From: akpm@linux-foundation.org
Subject: [merged] page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:15 -0700
Message-ID: <200907302037.n6UKbFYi011071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbZG3Uhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, acme@redhat.com, davem@davemloft.net, rientjes@google.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     page-allocator: allow too high-order warning messages to be suppressed with __GFP_NOWARN
has been removed from the -mm tree.  Its filename was
     page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn
+++ a/mm/page_alloc.c
@@ -1745,8 +1745,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
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

origin.patch
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
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
add-debugging-aid-for-memory-initialisation-problems.patch

