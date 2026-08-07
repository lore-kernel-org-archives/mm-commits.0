Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383F63C4554
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068077; cv=none; b=DmngAzBY4dqBxKX0yk3E8DW2PAHStRdpZOEdEFvp/Y4Qwv+SaA/ySW1oU4wqZphap9jBGnwULwoisZKucUNVoI4OsCoaTyU3uDi/SiMU2mCWAXbiw8zlzlXk00YnUXK1Dud03trJ7iu9ltna69iLxCQVwjOQzOzmHJLB6MuZ+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068077; c=relaxed/simple;
	bh=9DN/TOV3tWvdLH9FG3Mg62YZFd9PGO/bE8NFbFVvlVU=;
	h=Date:To:From:Subject:Message-Id; b=fLFv0e+0xPizGSpgbnp1sLLhjfA5Z94W0n5jedhnBdu7ygrAomVR5ls0tormdQlSAR8+w5zvm/rQSKFf/66NLem2eJ1bZJ0Wu4EkJrJxlxbpquXsKLMsqp+OuJ/swvzvp/nycfXu8IxjsH63j3DtQtJO0eol4729JOZT7ny2oBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQkQBEi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQkQBEi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEED1F00A3A;
	Fri,  7 Aug 2026 02:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068073;
	bh=GPZoAyCrfpL6duyEaRFTDIBLMBsyksd/I/2/NvZXZ2Y=;
	h=Date:To:From:Subject;
	b=UQkQBEi0CbXLAL2yRZ7n1+tpmEPXAvCJZAOpL1ypbwygfB6SD+vu70WLF5Ed33Ujg
	 zUlq8CCkUXkJkuERBO46L+xQxthjhrWqFnBnbIHatUEZhsLN1n0d4jt0mujXLmSWhq
	 7M3h6rs9scP9OSfWLn2Zg+HxTffoUovyp9CmXTtE=
Date: Thu, 06 Aug 2026 19:01:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch removed from -mm tree
Message-Id: <20260807020113.5EEED1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: let node_reclaim() return the number of pages reclaimed
has been removed from the -mm tree.  Its filename was
     mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: mm: let node_reclaim() return the number of pages reclaimed
Date: Tue, 14 Jul 2026 15:23:00 +0200

There is only one caller, get_page_from_freelist(), and it does not make
any use of the reason for skipping the reclaim, nor does it make any
distinction between a full and partially successful reclaim.

Therefore, node_reclaim() can simply return the number of pages that have
been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
can be removed.

There is one small change of behavior when __node_reclaim() was attempted
but returned zero.  The allocation now skips the zone immediately; before
this patch, the zone watermarks were checked first.  I believe it was an
oversight rather than intention, because the chances that zone watermark
is OK after __node_reclaim() did not reclaim any pages are very close to
zero.

Originally, I was looking for occurences of NODE_RECLAIM_SOME and
NODE_RECLAIM_SUCCESS, but I couldn't find any.  That's because they are
typecast from the result of a relational operator.  This seemed a bit
fragile, so I dug a bit deeper and came up with this proposed cleanup.

Link: https://lore.kernel.org/20260714132300.2136018-1-ptesarik@suse.com
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   14 +++++---------
 mm/page_alloc.c |   19 ++++---------------
 mm/vmscan.c     |   16 ++++++++--------
 3 files changed, 17 insertions(+), 32 deletions(-)

--- a/mm/internal.h~mm-let-node_reclaim-return-the-number-of-pages-reclaimed
+++ a/mm/internal.h
@@ -1098,23 +1098,19 @@ static inline void mlock_drain_local(voi
 static inline void mlock_drain_remote(int cpu) { }
 #endif /* !CONFIG_MMU */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
-
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+extern unsigned long node_reclaim(struct pglist_data *pgdat,
+				  gfp_t gfp_mask, unsigned int order);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
-static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
+static inline unsigned long node_reclaim(struct pglist_data *pgdat,
+					 gfp_t mask, unsigned int order)
 {
-	return NODE_RECLAIM_NOSCAN;
+	return 0;
 }
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
--- a/mm/page_alloc.c~mm-let-node_reclaim-return-the-number-of-pages-reclaimed
+++ a/mm/page_alloc.c
@@ -3908,8 +3908,6 @@ check_alloc_wmark:
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
-			int ret;
-
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -3930,22 +3928,13 @@ check_alloc_wmark:
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
-			switch (ret) {
-			case NODE_RECLAIM_NOSCAN:
-				/* did not scan */
-				continue;
-			case NODE_RECLAIM_FULL:
-				/* scanned but unreclaimable */
+			if (!node_reclaim(zone->zone_pgdat, gfp_mask, order))
 				continue;
-			default:
-				/* did we reclaim enough */
-				if (zone_watermark_ok(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags))
-					goto try_this_zone;
 
+			/* did we reclaim enough */
+			if (!zone_watermark_ok(zone, order, mark,
+					       ac->highest_zoneidx, alloc_flags))
 				continue;
-			}
 		}
 
 try_this_zone:
--- a/mm/vmscan.c~mm-let-node_reclaim-return-the-number-of-pages-reclaimed
+++ a/mm/vmscan.c
@@ -7773,9 +7773,9 @@ static unsigned long __node_reclaim(stru
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int ret;
+	unsigned long ret;
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7802,13 +7802,13 @@ int node_reclaim(struct pglist_data *pgd
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
 	    pgdat->min_slab_pages)
-		return NODE_RECLAIM_FULL;
+		return 0;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	/*
 	 * Only run node reclaim on the local node or on nodes that do not
@@ -7817,15 +7817,15 @@ int node_reclaim(struct pglist_data *pgd
 	 * as wide as possible.
 	 */
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
-		return NODE_RECLAIM_NOSCAN;
+		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
+	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-	if (ret)
+	if (ret >= nr_pages)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
 	else
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
_

Patches currently in -mm which might be from ptesarik@suse.com are


