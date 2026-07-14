Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCEA44C67A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057310; cv=none; b=H3HI/oE64YyvceSk2UTWxIuhzN9+0gYF/avxcSaPjthsl6cKckMXe83zc97ijdETPYmkw1UOys5gYku5vGuYfFMplhirjKGE/oJ+vwCqEK1pge/pjbSjs/bMAZHO2LmsRdcQd2cxMo4L1mDUnTyMeKuGx3wiG8ySbmEMJTNjzxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057310; c=relaxed/simple;
	bh=kcgpQsKHqiRaL1Z4AJkcVcZL/bu50xjpG8OQAQjsvcI=;
	h=Date:To:From:Subject:Message-Id; b=Eh3t+cEBOae8m/EBP+f6SzIG8DiHXsxGqP4UFco5mqCt6DFYIc8wWTcOON5FZ35oss+gCbDwzmMJXRQz0fqsRiuutXDOEmnRHAV42k4YHewXF3CY7RMsCh+ON5J3ocECMQfD8bqP1WY9gTx33PB+lYin5IxBNfVKEd+lQ55g904=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ee/R5bo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ee/R5bo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA511F000E9;
	Tue, 14 Jul 2026 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057309;
	bh=moehg0ZQanvK7PNdKdZactm3W6pz8rN8r3m6mmcd6po=;
	h=Date:To:From:Subject;
	b=Ee/R5bo+0JE6S6Aq+CX57BH8Q0knLmPoPRg70WTF7M2drqQLBOT7v8A7yo3mTkf5r
	 xUZaPNoCpoF/aietFupW+nF4/2VQw7MxKnZB/0XNCFg1SOVGchFRkJds6FTtAcErw8
	 nUNIf6MOYbEMoqWtObyCRmJYm7btyft97I38gT7k=
Date: Tue, 14 Jul 2026 12:28:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch added to mm-new branch
Message-Id: <20260714192828.ECA511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: let node_reclaim() return the number of pages reclaimed
has been added to the -mm mm-new branch.  Its filename is
     mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -7768,9 +7768,9 @@ static unsigned long __node_reclaim(stru
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
@@ -7797,13 +7797,13 @@ int node_reclaim(struct pglist_data *pgd
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
@@ -7812,15 +7812,15 @@ int node_reclaim(struct pglist_data *pgd
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

mm-let-node_reclaim-return-the-number-of-pages-reclaimed.patch

