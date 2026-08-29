Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5B1C5D72
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 02:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971430; cv=none; b=EeZMd0wuCDEXGUu8Ro9hVyPZX00ytWS/ZsSplf+DCs8qpZbTw3biCFkOsvId3LH2HRZnfE+G6qIWM7zQYTGv7fv9Opp76gso69SMWnekU2a5Vxcx5MzqoJ807HW1Prif5mqyiDOF+80nucM4fD9S0rRnd4NW1A2YbixF/2G4iF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971430; c=relaxed/simple;
	bh=5ZJ1zudrXUgl02gCIePkH3H6N0HFZr2uE3l9ivD8K1Q=;
	h=Date:To:From:Subject:Message-Id; b=CGqg10AWRpkIMNqJb2LA787pf67NSNIdMNkd4iYA63Wn/cUsJCmYXWr4sBPpPqJSwWdJTRG59uGGL8G1okhINPSWSSiVmpyYJjmZFeDv4VL0DPHDhZvA4B8d7hEf20jMVYaSfzp0lJvCxM2PMEUnXpls8tPMdylO9jM4sakAGig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZrQJs87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZrQJs87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CEF1F000E9;
	Sat, 29 Aug 2026 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971428;
	bh=v6Er26ZAgi24vc5YeHcS7phTr+tVH/QIJOQ6AJqFDGs=;
	h=Date:To:From:Subject;
	b=ZZrQJs8757AhCiTqOU5zwps5snsdYn+BcF3pNd3IA7xRY/Oko2S543Z2J4ZmrXKIW
	 SzH276nkgR77aiuI4xKNyCvzR7OEytr11x/aBS4HO+JLbR4b22q7xu5Hm+XbHbvlQA
	 KAKFyMGMZX6dxndyGLjUBJLajIw0y6nAGU2RptaU=
Date: Fri, 28 Aug 2026 19:43:48 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-mem_cgroup_shrink_node.patch added to mm-new branch
Message-Id: <20260829024348.93CEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove mem_cgroup_shrink_node()
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-mem_cgroup_shrink_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-mem_cgroup_shrink_node.patch

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
Subject: memcg: remove mem_cgroup_shrink_node()
Date: Tue, 11 Aug 2026 13:31:57 -0700

Its only caller was soft limit reclaim, which is gone.

Link: https://lore.kernel.org/20260811203203.3456029-4-shakeel.butt@linux.dev
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

 mm/internal.h |    4 ----
 mm/vmscan.c   |   41 -----------------------------------------
 2 files changed, 45 deletions(-)

--- a/mm/internal.h~memcg-remove-mem_cgroup_shrink_node
+++ a/mm/internal.h
@@ -78,10 +78,6 @@ unsigned long try_to_free_mem_cgroup_pag
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
 					   int *swappiness);
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-				     gfp_t gfp_mask, bool noswap,
-				     pg_data_t *pgdat,
-				     unsigned long *nr_scanned);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
--- a/mm/vmscan.c~memcg-remove-mem_cgroup_shrink_node
+++ a/mm/vmscan.c
@@ -6810,47 +6810,6 @@ unsigned long try_to_free_pages(struct z
 
 #ifdef CONFIG_MEMCG
 
-/* Only used by soft limit reclaim. Do not reuse for anything else. */
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct scan_control sc = {
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.target_mem_cgroup = memcg,
-		.may_writepage = 1,
-		.may_unmap = 1,
-		.reclaim_idx = MAX_NR_ZONES - 1,
-		.may_swap = !noswap,
-	};
-
-	WARN_ON_ONCE(!current->reclaim_state);
-
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
-						      sc.order,
-						      memcg);
-
-	/*
-	 * NOTE: Although we can get the priority field, using it
-	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_node from balance_pgdat
-	 * will pick up pages from other mem cgroup's as well. We hack
-	 * the priority and make it zero.
-	 */
-	shrink_lruvec(lruvec, &sc);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
-
-	*nr_scanned = sc.nr_scanned;
-
-	return sc.nr_reclaimed;
-}
-
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
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

