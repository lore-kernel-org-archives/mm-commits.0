Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E21FE47B
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883056; cv=none; b=HqPGIW59C8Tjgwg18vUOUn5FHSSRShBaLfZbihL8ouqMQo5Dt9DRLkgR/FnReoZCpIglwm0tdYhKmDk/ouuDxxFhejmVbTArnB3rHg7ZkBXV38+qAI/QtT6OX2TbLNSi0PdeSRCFLNBoVg3IJZwuWto2ijGyF45DYg/i2w84n3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883056; c=relaxed/simple;
	bh=aofALiWL1vDAP0Lyllyw5gh1gpGpGuoKWOArKxI2fTI=;
	h=Date:To:From:Subject:Message-Id; b=T2XK1zBdQsZ9qldzBPHxEILt47+KA3pT1SnFf+j/0Llcn+8OK/gAZZuaeNsAusY95NJjoHMSrph5dWbMNsfZVUGbW4BM/kZuKz5voECYXd1GFZVg8V/e082x+DmNx0k/zlAYCtFHjnw6lJ3ASG7rGupXJvh61Rwpka9U2mKRtc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GBBy/JxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GBBy/JxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436F9C4CEEA;
	Wed, 25 Jun 2025 20:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750883056;
	bh=aofALiWL1vDAP0Lyllyw5gh1gpGpGuoKWOArKxI2fTI=;
	h=Date:To:From:Subject:From;
	b=GBBy/JxSt3otpOIxpCXtjRYVUiyXGjSyMUGwD6z8JAY0tzFo2e4ssVS/1odYAwL6c
	 7LvnZhmA4AOdBBjbaFQ2DiuomvNTqf8SiTLXEuUdMsbbT0lqtQnBC/zrnBpnjPEU3Y
	 dTudUCMOCgaXu13hEUyItAvSxRibx6iL1bKM/coA=
Date: Wed, 25 Jun 2025 13:24:16 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-__node_reclaim-more-generic.patch added to mm-unstable branch
Message-Id: <20250625202416.436F9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: make __node_reclaim() more generic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-make-__node_reclaim-more-generic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-make-__node_reclaim-more-generic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmscan: make __node_reclaim() more generic
Date: Mon, 23 Jun 2025 11:58:50 -0700

As this will be called from non page allocator paths for proactive
reclaim, allow users to pass the sc and nr of pages, and adjust the return
value as well.  No change in semantics.

Link: https://lkml.kernel.org/r/20250623185851.830632-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-make-__node_reclaim-more-generic
+++ a/mm/vmscan.c
@@ -7616,36 +7616,26 @@ static unsigned long node_pagecache_recl
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
@@ -7654,24 +7644,36 @@ static int __node_reclaim(struct pglist_
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
@@ -7706,7 +7708,7 @@ int node_reclaim(struct pglist_data *pgd
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
-	ret = __node_reclaim(pgdat, gfp_mask, order);
+	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret)
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch
mm-memcg-make-memoryreclaim-interface-generic.patch
mm-vmscan-make-__node_reclaim-more-generic.patch
mm-introduce-per-node-proactive-reclaim-interface.patch

