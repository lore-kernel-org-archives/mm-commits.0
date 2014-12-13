From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:41:15 -0800
Message-ID: <548b8b2b.OTUqBaPKH85JE9LD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, david@fromorbit.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: shrink_zones: assure class zone is populated
has been removed from the -mm tree.  Its filename was
     mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch

This patch was dropped because it was folded into mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: shrink_zones: assure class zone is populated

Since commit 5df87d36a45e ("mm: vmscan: invoke slab shrinkers from
shrink_zone()") slab shrinkers are invoked from shrink_zone.  Since slab
shrinkers lack the notion of memory zones, we only call slab shrinkers
after scanning the highest zone suitable for allocation (class zone). 
However, class zone can be empty.  E.g.  if an x86_64 host has less than
4G of RAM, it will have only ZONE_DMA and ZONE_DMA32 populated while the
class zone for most allocations, ZONE_NORMAL, will be empty.  As a result,
slab caches will not be scanned at all from the direct reclaim path, which
may result in premature OOM killer invocations.

Let's take the highest *populated* zone suitable for allocation for the
class zone to fix this issue.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix
+++ a/mm/vmscan.c
@@ -2454,8 +2454,16 @@ static bool shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					requested_highidx, sc->nodemask) {
+		enum zone_type classzone_idx;
+
 		if (!populated_zone(zone))
 			continue;
+
+		classzone_idx = requested_highidx;
+		while (!populated_zone(zone->zone_pgdat->node_zones +
+							classzone_idx))
+			classzone_idx--;
+
 		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
@@ -2502,7 +2510,7 @@ static bool shrink_zones(struct zonelist
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		if (shrink_zone(zone, sc, zone_idx(zone) == requested_highidx))
+		if (shrink_zone(zone, sc, zone_idx(zone) == classzone_idx))
 			reclaimable = true;
 
 		if (global_reclaim(sc) &&
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

