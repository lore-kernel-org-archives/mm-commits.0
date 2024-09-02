Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18F26AF3
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247722; cv=none; b=Yk3edHGLSpSQ2hHLn2fa7hVoJABs73u4lFzdfkq4cMwUjJlqa+u1nI3pEI786b3FQXDqb64ftM5HFdOMDch4AB+n+1rSiiu+GO6c8J6Jz5Kh1OPVQeDK1iLrFjim4znhIV+yQLLnfY8eDqxc6laVSk8hW/+vcAo9M0yxMawmjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247722; c=relaxed/simple;
	bh=Rsm3zaq2dxl5T8nyuIc+uIxXQLlthtW/Qjnmz9QByh8=;
	h=Date:To:From:Subject:Message-Id; b=mK0a3tWGqXdMOj2xH5RdaKXHRingvAP5UFntApFXIDakXCLXD4nWn4ZqsYGuuzYuLd3qSk+PWB6ErESZBaQWuRvFn1cNcu92IfIfvSMLXRgiQ9IzvOI4EmAo2JUbKkvSoXSw8khF3wkbtgujzqhDbpWQwuehUxWX431b6iphJeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egg5qw1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egg5qw1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0622C4CEC2;
	Mon,  2 Sep 2024 03:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247721;
	bh=Rsm3zaq2dxl5T8nyuIc+uIxXQLlthtW/Qjnmz9QByh8=;
	h=Date:To:From:Subject:From;
	b=egg5qw1Gwn/eZ5jCOMZA8RNj9F637GMVFGerrQePIGL2PnBNxfl+HaH9fYQKUhxN1
	 Xe3eIFIhI8C3x2L0RNcgpH+x6vU7QYYZyZiFReAXxg6qqSEcM04XpE2XiXJg4hiZ/L
	 oEtdsazuC9kYT8K9EfhBPAd7qy9cFbd3wz6VEg0g=
Date: Sun, 01 Sep 2024 20:28:41 -0700
To: mm-commits@vger.kernel.org,shivankg@amd.com,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-improve-code-consistency-with-zonelist_-helper-functions.patch removed from -mm tree
Message-Id: <20240902032841.B0622C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: improve code consistency with zonelist_* helper functions
has been removed from the -mm tree.  Its filename was
     mm-improve-code-consistency-with-zonelist_-helper-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: improve code consistency with zonelist_* helper functions
Date: Mon, 29 Jul 2024 14:47:17 +0530

Replace direct access to zoneref->zone, zoneref->zone_idx, or
zone_to_nid(zoneref->zone) with the corresponding zonelist_* helper
functions for consistency.

No functional change.

Link: https://lkml.kernel.org/r/20240729091717.464-1-shivankg@amd.com
Co-developed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h     |    4 ++--
 include/trace/events/oom.h |    4 ++--
 mm/mempolicy.c             |    4 ++--
 mm/mmzone.c                |    2 +-
 mm/page_alloc.c            |   22 +++++++++++-----------
 5 files changed, 18 insertions(+), 18 deletions(-)

--- a/include/linux/mmzone.h~mm-improve-code-consistency-with-zonelist_-helper-functions
+++ a/include/linux/mmzone.h
@@ -1688,7 +1688,7 @@ static inline struct zoneref *first_zone
 			zone = zonelist_zone(z))
 
 #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
-	for (zone = z->zone;	\
+	for (zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
@@ -1724,7 +1724,7 @@ static inline bool movable_only_nodes(no
 	nid = first_node(*nodes);
 	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
 	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
-	return (!z->zone) ? true : false;
+	return (!zonelist_zone(z)) ? true : false;
 }
 
 
--- a/include/trace/events/oom.h~mm-improve-code-consistency-with-zonelist_-helper-functions
+++ a/include/trace/events/oom.h
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zone_to_nid(zoneref->zone);
-		__entry->zone_idx = zoneref->zone_idx;
+		__entry->node = zonelist_node_idx(zoneref);
+		__entry->zone_idx = zonelist_zone_idx(zoneref);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
--- a/mm/mempolicy.c~mm-improve-code-consistency-with-zonelist_-helper-functions
+++ a/mm/mempolicy.c
@@ -1951,7 +1951,7 @@ unsigned int mempolicy_slab_node(void)
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->nodes);
-		return z->zone ? zone_to_nid(z->zone) : node;
+		return zonelist_zone(z) ? zonelist_node_idx(z) : node;
 	}
 	case MPOL_LOCAL:
 		return node;
@@ -2809,7 +2809,7 @@ int mpol_misplaced(struct folio *folio,
 				node_zonelist(thisnid, GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
 				&pol->nodes);
-		polnid = zone_to_nid(z->zone);
+		polnid = zonelist_node_idx(z);
 		break;
 
 	default:
--- a/mm/mmzone.c~mm-improve-code-consistency-with-zonelist_-helper-functions
+++ a/mm/mmzone.c
@@ -66,7 +66,7 @@ struct zoneref *__next_zones_zonelist(st
 			z++;
 	else
 		while (zonelist_zone_idx(z) > highest_zoneidx ||
-				(z->zone && !zref_in_nodemask(z, nodes)))
+				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
 			z++;
 
 	return z;
--- a/mm/page_alloc.c~mm-improve-code-consistency-with-zonelist_-helper-functions
+++ a/mm/page_alloc.c
@@ -3350,7 +3350,7 @@ retry:
 		}
 
 		if (no_fallback && nr_online_nodes > 1 &&
-		    zone != ac->preferred_zoneref->zone) {
+		    zone != zonelist_zone(ac->preferred_zoneref)) {
 			int local_nid;
 
 			/*
@@ -3358,7 +3358,7 @@ retry:
 			 * fragmenting fallbacks. Locality is more important
 			 * than fragmentation avoidance.
 			 */
-			local_nid = zone_to_nid(ac->preferred_zoneref->zone);
+			local_nid = zonelist_node_idx(ac->preferred_zoneref);
 			if (zone_to_nid(zone) != local_nid) {
 				alloc_flags &= ~ALLOC_NOFRAGMENT;
 				goto retry;
@@ -3411,7 +3411,7 @@ check_alloc_wmark:
 				goto try_this_zone;
 
 			if (!node_reclaim_enabled() ||
-			    !zone_allows_reclaim(ac->preferred_zoneref->zone, zone))
+			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
 			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
@@ -3433,7 +3433,7 @@ check_alloc_wmark:
 		}
 
 try_this_zone:
-		page = rmqueue(ac->preferred_zoneref->zone, zone, order,
+		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
@@ -4202,7 +4202,7 @@ restart:
 	 */
 	ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
-	if (!ac->preferred_zoneref->zone)
+	if (!zonelist_zone(ac->preferred_zoneref))
 		goto nopage;
 
 	/*
@@ -4214,7 +4214,7 @@ restart:
 		struct zoneref *z = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx,
 					&cpuset_current_mems_allowed);
-		if (!z->zone)
+		if (!zonelist_zone(z))
 			goto nopage;
 	}
 
@@ -4571,8 +4571,8 @@ unsigned long alloc_pages_bulk_noprof(gf
 			continue;
 		}
 
-		if (nr_online_nodes > 1 && zone != ac.preferred_zoneref->zone &&
-		    zone_to_nid(zone) != zone_to_nid(ac.preferred_zoneref->zone)) {
+		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
+		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
 			goto failed;
 		}
 
@@ -4631,7 +4631,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 	pcp_trylock_finish(UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
+	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
 
 out:
 	return nr_populated;
@@ -4689,7 +4689,7 @@ struct page *__alloc_pages_noprof(gfp_t
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp);
+	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
@@ -5294,7 +5294,7 @@ int local_memory_node(int node)
 	z = first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
 				   gfp_zone(GFP_KERNEL),
 				   NULL);
-	return zone_to_nid(z->zone);
+	return zonelist_node_idx(z);
 }
 #endif
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-ma_data_end-in-mas_data_end.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

