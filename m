From: akpm@linux-foundation.org
Subject: [merged] net-dccp-suppress-warning-about-large-allocations-from-dccp.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:20 -0700
Message-ID: <200907302037.n6UKbKrZ011323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbZG3Uhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, acme@redhat.com, davem@davemloft.net, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     net-dccp: suppress warning about large allocations from DCCP
has been removed from the -mm tree.  Its filename was
     net-dccp-suppress-warning-about-large-allocations-from-dccp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net-dccp: suppress warning about large allocations from DCCP
From: Mel Gorman <mel@csn.ul.ie>

The DCCP protocol tries to allocate some large hash tables during
initialisation using the largest size possible.  This can be larger than
what the page allocator can provide so it prints a warning.  However, the
caller is able to handle the situation so this patch suppresses the
warning.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/proto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/dccp/proto.c~net-dccp-suppress-warning-about-large-allocations-from-dccp net/dccp/proto.c
--- a/net/dccp/proto.c~net-dccp-suppress-warning-about-large-allocations-from-dccp
+++ a/net/dccp/proto.c
@@ -1066,7 +1066,7 @@ static int __init dccp_init(void)
 		       (dccp_hashinfo.ehash_size - 1))
 			dccp_hashinfo.ehash_size--;
 		dccp_hashinfo.ehash = (struct inet_ehash_bucket *)
-			__get_free_pages(GFP_ATOMIC, ehash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, ehash_order);
 	} while (!dccp_hashinfo.ehash && --ehash_order > 0);
 
 	if (!dccp_hashinfo.ehash) {
@@ -1091,7 +1091,7 @@ static int __init dccp_init(void)
 		    bhash_order > 0)
 			continue;
 		dccp_hashinfo.bhash = (struct inet_bind_hashbucket *)
-			__get_free_pages(GFP_ATOMIC, bhash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, bhash_order);
 	} while (!dccp_hashinfo.bhash && --bhash_order >= 0);
 
 	if (!dccp_hashinfo.bhash) {
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

