Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C94A9D6C
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378066; cv=none; b=bSKgsHk6cboH9jMU9gI+Mls5l0p+qiHOhsz+nJRDeC7ptMaIS0GudnVklwO5MIfVw8Py9EoBwAd1wxn5QwMtASSZhpj6Jmzt5x9Me2KG6hUKO8tL8FuLxz3rv+kirBjjeUAwYVqdU/wb9nFcZHk4PNGwaoQa4XjNjgjvqogPh5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378066; c=relaxed/simple;
	bh=jyGXd4xhwyPuEq13VFlzN5jCWhr4DHw0kF26NmFASfw=;
	h=Date:To:From:Subject:Message-Id; b=MO14X1jtgUMYFAONswMb3RYs7g6gWQSxEsjRlEbTRoXCKqJsSGo+0BNF10vgHFmrRSs9T0ltllYuXYC+eNz5OFWExyexVeELFRJPnauPC5JcaCR0J4aWQ2gkT8yV0xenBWabzhTzO8q6XRF8reLC7SUExwZvjR/QVY5eXoeRPj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HzyxPLns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HzyxPLns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F371F00A3E;
	Wed,  2 Sep 2026 19:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378040;
	bh=n9liraixDjsDs/D3338v1FSXrxw/MZr703VHLtPxKfA=;
	h=Date:To:From:Subject;
	b=HzyxPLnshuzGKxU7t0+KaCzkMQL7SkGhTdX70cKL0F9gqWjsC4YM5KaS/2KETsPEn
	 1g5EHgdGZdT5SKHngbPhbdoQ0a8olnkpvozvojZpq58x7fUnhGNBxzAvItOGxnymUW
	 LGi4y/B33t/Z98pssyXmqglRu57zM/WROlgiZS1A=
Date: Wed, 02 Sep 2026 12:40:40 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-the-per-node-soft-limit-tree-fields.patch added to mm-unstable branch
Message-Id: <20260902194040.A1F371F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove the per-node soft limit tree fields
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-the-per-node-soft-limit-tree-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-the-per-node-soft-limit-tree-fields.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Wed, 2 Sep 2026 10:43:09 -0700

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree. They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them
with the explicit padding that CONFIG_MEMCG_V1=n already used.

Link: https://lore.kernel.org/20260902174311.1772372-7-shakeel.butt@linux.dev
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

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
mm-mlock-use-the-irq-safe-accessor-for-nr_mlock-in-__munlock_folio.patch
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

