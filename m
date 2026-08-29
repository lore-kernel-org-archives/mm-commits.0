Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C219331ED7
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971441; cv=none; b=BONOodhUm95cWvw8Yta7BOyEJS2MvHwROKx7Z00e8nBrJ4gM/v18jYHxNQV9aDL1R/4jrYdpSYyjAIUrVyIVZtn1mYT2kLxGzCeneEGF5zBo+pFM3y8j1hyIg5CORTHTkf2rf9SrxqPgHNKZUQ5mzCKktPEqcHSdwok7IS/R9oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971441; c=relaxed/simple;
	bh=dP2VtyIvhZqzNeX27sN1Yr2gqlVqLwG5nV75e6Ve5zA=;
	h=Date:To:From:Subject:Message-Id; b=TEoLXk3l1SNcA08+lRySnGn+zL9izKSAuRSFYF+OqBdsvwapdbV2bogi9cd0V0Tn43ooaX5ybvqNJM+zUN+u1JzlSKP1OUp8oowuyCN5VfChYF+4eOdS2WVTiuvk1H9Co/f5vwGlvQobYZmt8/Ewla97xWadHElCoscjV57dTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLdywRio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLdywRio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479481F000E9;
	Sat, 29 Aug 2026 02:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971440;
	bh=O9EfcW7b829zTx71PUgVW0jthnRabAPf0zOvzqVBBSM=;
	h=Date:To:From:Subject;
	b=wLdywRioWW4YedQ9ebVjeOdgXvN232XW+7OMF6fKkZw+gs9gjcboLvCtrfRUT7sFV
	 V9/sVvjk+bO6wA4qUbnQroXl3csFKIIOaYY4fhuS76L0/cfjfhtqtZUPxdtSq11SqS
	 XljBggMhsFQTMtd1hAP2z1DH2WjZNBVONERnlFY8=
Date: Fri, 28 Aug 2026 19:43:59 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-per-node-soft-limit-tree-fields.patch added to mm-new branch
Message-Id: <20260829024400.479481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the per-node soft limit tree fields
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-the-per-node-soft-limit-tree-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-per-node-soft-limit-tree-fields.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove the per-node soft limit tree fields
Date: Tue, 11 Aug 2026 13:32:01 -0700

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree.  They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them with
the explicit padding that CONFIG_MEMCG_V1=n already used.

Link: https://lore.kernel.org/20260811203203.3456029-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-the-per-node-soft-limit-tree-fields
+++ a/include/linux/memcontrol.h
@@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

