Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57D913AD3F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976918; cv=none; b=GjOdMQ/gRagYcQSqAt/Zyd5wq8NUq8shSFSC9phzPH8ga3mWeJMqOlE6mVGKUbkP9OPrgb8DJ4UPuohQCxm3jOGzcJ6GRIiT3L2VuHQwuvsF/0wPCSmjlglCA/MabLgwGTP/W/PXHhkhnvh+EuCv8h6Mh6T/QWJxlGPDqOqM3ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976918; c=relaxed/simple;
	bh=fqXydXLIMRbq1x3il6vEktJLEQjIzpmFvYkLZVOW8zM=;
	h=Date:To:From:Subject:Message-Id; b=A6/gTJ5eZK1BWitVJtkH209/YrsnRJzrvlblxE1iTKpwYT73VdnG1RyNy7wAztKKtuSZ/bKRkNWtwGQ5uWIhsYhol5IYASwP9CK9vwryjNbXnA8IQHH0AiQW548qItnFf1X0sIJM1TqIuI+mLYTx0EKoz9kOqPZ4aPa/I0T/ooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w0jdjqyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w0jdjqyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A510C4CEE3;
	Sun, 20 Jul 2025 02:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976918;
	bh=fqXydXLIMRbq1x3il6vEktJLEQjIzpmFvYkLZVOW8zM=;
	h=Date:To:From:Subject:From;
	b=w0jdjqyvtCZgm1mqH0OgD0qrt4008UUyxUiy7WwJak5x96IxWWvbiXb3Ixp7Ov0GC
	 h/PzhD/qb6Ux78Lfxc2fe7wfdkMn9//iwt6z+y7Q03IMP9wzz9cMI33PFMIpszh7Ih
	 s+azF8FYazKIlHCklWffXYY7hgexV7UpzW6TgX1Y=
Date: Sat, 19 Jul 2025 19:01:58 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-make-__node_reclaim-more-generic.patch removed from -mm tree
Message-Id: <20250720020158.9A510C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: make __node_reclaim() more generic
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-__node_reclaim-more-generic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmscan: make __node_reclaim() more generic
Date: Mon, 23 Jun 2025 11:58:50 -0700

As this will be called from non page allocator paths for proactive
reclaim, allow users to pass the sc and nr of pages, and adjust the return
value as well.  No change in semantics.

Link: https://lkml.kernel.org/r/20250623185851.830632-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-__node_reclaim-more-generic
+++ a/mm/vmscan.c
@@ -7618,36 +7618,26 @@ static unsigned long node_pagecache_recl
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+				    unsigned long nr_pages,
+				    struct scan_control *sc)
 {
-	/* Minimum pages needed in order to stay on node */
-	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	unsigned int noreclaim_flag;
-	struct scan_control sc = {
-		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = current_gfp_context(gfp_mask),
-		.order = order,
-		.priority = NODE_RECLAIM_PRIORITY,
-		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
-		.may_swap = 1,
-		.reclaim_idx = gfp_zone(gfp_mask),
-	};
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, order,
-					   sc.gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
+					   sc->gfp_mask);
 
 	cond_resched();
 	psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
-	fs_reclaim_acquire(sc.gfp_mask);
+	fs_reclaim_acquire(sc->gfp_mask);
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	set_task_reclaim_state(p, &sc.reclaim_state);
+	set_task_reclaim_state(p, &sc->reclaim_state);
 
 	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
@@ -7656,24 +7646,36 @@ static int __node_reclaim(struct pglist_
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_node(pgdat, &sc);
-		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
+			shrink_node(pgdat, sc);
+		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
 	}
 
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
-	fs_reclaim_release(sc.gfp_mask);
+	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed);
 
-	return sc.nr_reclaimed >= nr_pages;
+	return sc->nr_reclaimed;
 }
 
 int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
 	int ret;
+	/* Minimum pages needed in order to stay on node */
+	const unsigned long nr_pages = 1 << order;
+	struct scan_control sc = {
+		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
+		.gfp_mask = current_gfp_context(gfp_mask),
+		.order = order,
+		.priority = NODE_RECLAIM_PRIORITY,
+		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
+		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
+		.may_swap = 1,
+		.reclaim_idx = gfp_zone(gfp_mask),
+	};
 
 	/*
 	 * Node reclaim reclaims unmapped file backed pages and
@@ -7708,7 +7710,7 @@ int node_reclaim(struct pglist_data *pgd
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
-	ret = __node_reclaim(pgdat, gfp_mask, order);
+	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret)
_

Patches currently in -mm which might be from dave@stgolabs.net are


