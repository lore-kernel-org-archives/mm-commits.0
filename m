From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 16:12:21 -0700
Message-ID: <57117555.ANVtA7J7eq7JFRsm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDOXMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reduce cost of fair zone allocation policy retry
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch

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
Subject: mm, page_alloc: reduce cost of fair zone allocation policy retry

The fair zone allocation policy is not without cost but it can be reduced
slightly.  This patch removes an unnecessary local variable, checks the
likely conditions of the fair zone policy first, uses a bool instead of a
flags check and falls through when a remote node is encountered instead of
doing a full restart.  The benefit is marginal but it's there

                                           4.6.0-rc2                  4.6.0-rc2
                                       decstat-v1r20              optfair-v1r20
Min      alloc-odr0-1               377.00 (  0.00%)           380.00 ( -0.80%)
Min      alloc-odr0-2               273.00 (  0.00%)           273.00 (  0.00%)
Min      alloc-odr0-4               226.00 (  0.00%)           227.00 ( -0.44%)
Min      alloc-odr0-8               196.00 (  0.00%)           196.00 (  0.00%)
Min      alloc-odr0-16              183.00 (  0.00%)           183.00 (  0.00%)
Min      alloc-odr0-32              175.00 (  0.00%)           173.00 (  1.14%)
Min      alloc-odr0-64              172.00 (  0.00%)           169.00 (  1.74%)
Min      alloc-odr0-128             170.00 (  0.00%)           169.00 (  0.59%)
Min      alloc-odr0-256             183.00 (  0.00%)           180.00 (  1.64%)
Min      alloc-odr0-512             191.00 (  0.00%)           190.00 (  0.52%)
Min      alloc-odr0-1024            199.00 (  0.00%)           198.00 (  0.50%)
Min      alloc-odr0-2048            204.00 (  0.00%)           204.00 (  0.00%)
Min      alloc-odr0-4096            210.00 (  0.00%)           209.00 (  0.48%)
Min      alloc-odr0-8192            213.00 (  0.00%)           213.00 (  0.00%)
Min      alloc-odr0-16384           214.00 (  0.00%)           214.00 (  0.00%)

The benefit is marginal at best but one of the most important benefits,
avoiding a second search when falling back to another node is not
triggered by this particular test so the benefit for some corner cases is
understated.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry
+++ a/mm/page_alloc.c
@@ -2706,12 +2706,10 @@ get_page_from_freelist(gfp_t gfp_mask, u
 {
 	struct zoneref *z;
 	struct zone *zone;
-	bool fair_skipped;
-	bool zonelist_rescan;
+	bool fair_skipped = false;
+	bool apply_fair = (alloc_flags & ALLOC_FAIR);
 
 zonelist_scan:
-	zonelist_rescan = false;
-
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
@@ -2731,13 +2729,16 @@ zonelist_scan:
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
 		 */
-		if (alloc_flags & ALLOC_FAIR) {
-			if (!zone_local(ac->preferred_zone, zone))
-				break;
+		if (apply_fair) {
 			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
 				fair_skipped = true;
 				continue;
 			}
+			if (!zone_local(ac->preferred_zone, zone)) {
+				if (fair_skipped)
+					goto reset_fair;
+				apply_fair = false;
+			}
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2826,18 +2827,13 @@ try_this_zone:
 	 * include remote zones now, before entering the slowpath and waking
 	 * kswapd: prefer spilling to a remote zone over swapping locally.
 	 */
-	if (alloc_flags & ALLOC_FAIR) {
-		alloc_flags &= ~ALLOC_FAIR;
-		if (fair_skipped) {
-			zonelist_rescan = true;
-			reset_alloc_batches(ac->preferred_zone);
-		}
-		if (nr_online_nodes > 1)
-			zonelist_rescan = true;
-	}
-
-	if (zonelist_rescan)
+	if (fair_skipped) {
+reset_fair:
+		apply_fair = false;
+		fair_skipped = false;
+		reset_alloc_batches(ac->preferred_zone);
 		goto zonelist_scan;
+	}
 
 	return NULL;
 }
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

