From: akpm@linux-foundation.org
Subject: + mm-oom-rework-oom-detection-clean-up-classzone_idx.patch added
 to -mm tree
Date: Tue, 05 Apr 2016 13:41:19 -0700
Message-ID: <570422ef.KpdPinRz2ysYEc3t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbcDEUlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c:shrink_zones(): clean up classzone_idx
has been added to the -mm tree.  Its filename is
     mm-oom-rework-oom-detection-clean-up-classzone_idx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-rework-oom-detection-clean-up-classzone_idx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-rework-oom-detection-clean-up-classzone_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmscan.c:shrink_zones(): clean up classzone_idx

"mm, oom: rework oom detection" removed classzone_idx so we don't need
code related to it.  This patch cleans it up.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~mm-oom-rework-oom-detection-clean-up-classzone_idx mm/vmscan.c
--- a/mm/vmscan.c~mm-oom-rework-oom-detection-clean-up-classzone_idx
+++ a/mm/vmscan.c
@@ -2531,16 +2531,8 @@ static void shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
-		enum zone_type classzone_idx;
-
 		if (!populated_zone(zone))
 			continue;
-
-		classzone_idx = requested_highidx;
-		while (!populated_zone(zone->zone_pgdat->node_zones +
-							classzone_idx))
-			classzone_idx--;
-
 		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-compaction-support-non-lru-movable-page-migration.patch
mm-add-non-lru-movable-page-support-document.patch
mm-balloon-use-general-movable-page-feature-into-balloon.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch
mm-oom-rework-oom-detection-clean-up-classzone_idx.patch

