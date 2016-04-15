From: akpm@linux-foundation.org
Subject: + mm-page_alloc-reduce-branches-in-zone_statistics.patch added to -mm tree
Date: Fri, 15 Apr 2016 16:11:51 -0700
Message-ID: <57117537.B5rfV4sTxbJRjCX4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbcDOXLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reduce branches in zone_statistics
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reduce-branches-in-zone_statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reduce-branches-in-zone_statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reduce-branches-in-zone_statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: reduce branches in zone_statistics

zone_statistics has more branches than it really needs to take an unlikely
GFP flag into account.  Reduce the number and annotate the unlikely flag.

The performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                    nocompound-v1r10           statbranch-v1r10
Min      alloc-odr0-1               417.00 (  0.00%)           419.00 ( -0.48%)
Min      alloc-odr0-2               308.00 (  0.00%)           305.00 (  0.97%)
Min      alloc-odr0-4               253.00 (  0.00%)           250.00 (  1.19%)
Min      alloc-odr0-8               221.00 (  0.00%)           219.00 (  0.90%)
Min      alloc-odr0-16              205.00 (  0.00%)           203.00 (  0.98%)
Min      alloc-odr0-32              199.00 (  0.00%)           195.00 (  2.01%)
Min      alloc-odr0-64              193.00 (  0.00%)           191.00 (  1.04%)
Min      alloc-odr0-128             191.00 (  0.00%)           189.00 (  1.05%)
Min      alloc-odr0-256             200.00 (  0.00%)           198.00 (  1.00%)
Min      alloc-odr0-512             212.00 (  0.00%)           210.00 (  0.94%)
Min      alloc-odr0-1024            219.00 (  0.00%)           216.00 (  1.37%)
Min      alloc-odr0-2048            225.00 (  0.00%)           221.00 (  1.78%)
Min      alloc-odr0-4096            231.00 (  0.00%)           227.00 (  1.73%)
Min      alloc-odr0-8192            234.00 (  0.00%)           232.00 (  0.85%)
Min      alloc-odr0-16384           234.00 (  0.00%)           232.00 (  0.85%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/vmstat.c~mm-page_alloc-reduce-branches-in-zone_statistics mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-reduce-branches-in-zone_statistics
+++ a/mm/vmstat.c
@@ -581,17 +581,21 @@ void drain_zonestat(struct zone *zone, s
  */
 void zone_statistics(struct zone *preferred_zone, struct zone *z, gfp_t flags)
 {
-	if (z->zone_pgdat == preferred_zone->zone_pgdat) {
+	int local_nid = numa_node_id();
+	enum zone_stat_item local_stat = NUMA_LOCAL;
+
+	if (unlikely(flags & __GFP_OTHER_NODE)) {
+		local_stat = NUMA_OTHER;
+		local_nid = preferred_zone->node;
+	}
+
+	if (z->node == local_nid) {
 		__inc_zone_state(z, NUMA_HIT);
+		__inc_zone_state(z, local_stat);
 	} else {
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
-	if (z->node == ((flags & __GFP_OTHER_NODE) ?
-			preferred_zone->node : numa_node_id()))
-		__inc_zone_state(z, NUMA_LOCAL);
-	else
-		__inc_zone_state(z, NUMA_OTHER);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

