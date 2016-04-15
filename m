From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-field-from-alloc_context.patch added to
 -mm tree
Date: Fri, 15 Apr 2016 16:12:27 -0700
Message-ID: <5711755b.8z/Xcy4q31eVfQus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDOXM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: remove field from alloc_context
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-field-from-alloc_context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-field-from-alloc_context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-field-from-alloc_context.patch

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
Subject: mm, page_alloc: remove field from alloc_context

The classzone_idx can be inferred from preferred_zoneref so remove the
unnecessary field and save stack space.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 mm/internal.h   |    3 ++-
 mm/page_alloc.c |    7 +++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-page_alloc-remove-field-from-alloc_context mm/compaction.c
--- a/mm/compaction.c~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/compaction.c
@@ -1663,7 +1663,7 @@ unsigned long try_to_compact_pages(gfp_t
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
 				&zone_contended, alloc_flags,
-				ac->classzone_idx);
+				ac_classzone_idx(ac));
 		rc = max(status, rc);
 		/*
 		 * It takes at least one zone that wasn't lock contended
@@ -1673,7 +1673,7 @@ unsigned long try_to_compact_pages(gfp_t
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
-					ac->classzone_idx, alloc_flags)) {
+					ac_classzone_idx(ac), alloc_flags)) {
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
diff -puN mm/internal.h~mm-page_alloc-remove-field-from-alloc_context mm/internal.h
--- a/mm/internal.h~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/internal.h
@@ -103,12 +103,13 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
-	int classzone_idx;
 	int migratetype;
 	enum zone_type high_zoneidx;
 	bool spread_dirty_pages;
 };
 
+#define ac_classzone_idx(ac) zonelist_zone_idx(ac->preferred_zoneref)
+
 /*
  * Locate the struct page for both the matching buddy in our
  * pair (buddy1) and the combined O(n+1) page they form (page).
diff -puN mm/page_alloc.c~mm-page_alloc-remove-field-from-alloc_context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-field-from-alloc_context
+++ a/mm/page_alloc.c
@@ -2797,7 +2797,7 @@ zonelist_scan:
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->classzone_idx, alloc_flags)) {
+				       ac_classzone_idx(ac), alloc_flags)) {
 			int ret;
 
 			/* Checked here to keep the fast path fast */
@@ -2820,7 +2820,7 @@ zonelist_scan:
 			default:
 				/* did we reclaim enough */
 				if (zone_watermark_ok(zone, order, mark,
-						ac->classzone_idx, alloc_flags))
+						ac_classzone_idx(ac), alloc_flags))
 					goto try_this_zone;
 
 				continue;
@@ -3140,7 +3140,7 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 						ac->high_zoneidx, ac->nodemask)
-		wakeup_kswapd(zone, order, zonelist_zone_idx(ac->preferred_zoneref));
+		wakeup_kswapd(zone, order, ac_classzone_idx(ac));
 }
 
 static inline unsigned int
@@ -3435,7 +3435,6 @@ retry_cpuset:
 	/* The preferred zone is used for statistics later */
 	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
 				ac.nodemask);
-	ac.classzone_idx = zonelist_zone_idx(ac.preferred_zoneref);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
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

