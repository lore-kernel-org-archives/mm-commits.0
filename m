From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch added to -mm tree
Date: Tue, 05 Apr 2016 13:37:58 -0700
Message-ID: <57042226.sAQ1+/uPKkB0x/55%akpm__30725.6829263226$1459888694$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcDEUh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: reclaim highmem zone if buffer_heads is over limit
has been added to the -mm tree.  Its filename is
     mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch

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
Subject: mm: vmscan: reclaim highmem zone if buffer_heads is over limit

We have been reclaimed highmem zone if buffer_heads is over limit but
6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
changed the behavior so it doesn't reclaim highmem zone although
buffer_heads is over the limit.  This patch restores the logic.

Fixes: 6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit
+++ a/mm/vmscan.c
@@ -2553,7 +2553,7 @@ static bool shrink_zones(struct zonelist
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					requested_highidx, sc->nodemask) {
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		enum zone_type classzone_idx;
 
 		if (!populated_zone(zone))
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

