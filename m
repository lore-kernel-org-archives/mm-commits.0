Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E42DB780
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334218; cv=none; b=dVbLUQwU9PeV9cFhdcMtxnNIta85KsobsiqZexwvhrCGSX455nIvh/U2+BGHCMEcdeOgtE8uYKiseJp3FH7EbMtYyg06o5W2uh6Ll3rM2mvDqu/8ypnzhteux1qzPqHKY+JYZIEf4raGYg7QBK7JgtapqbayjhRGrztMfL1hts4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334218; c=relaxed/simple;
	bh=HbMhCbvwUaGt97HBJCnO6btNvnHiC9PCOvQdlt266I0=;
	h=Date:To:From:Subject:Message-Id; b=CeR+cX1j8JlJGz3rAVN3OaA6XEDzHHR6GSGlA5Bg50a5B+EWn5Ge5njLn/km9MWtn75WwCS50OfMtYQUs97PNf/0kok67DYmPTSoeuTBb+j1L2cZ4XAgRwAecViiJkC+wbKuLRuEp7bhDGrDr2cFVZf4E1tI8UiqT5bQYFt9S1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aRwz5AHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aRwz5AHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A3C1F0089B;
	Wed,  7 Oct 2026 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334217;
	bh=Li9yrEkZLno8zvcqOvy9p6iK8RNYyhaB8F2qTWS7FeQ=;
	h=Date:To:From:Subject;
	b=aRwz5AHUvm6cpL0H5DAPfBUQLbku9DCJcyZhsC8KHXblm9HMl3AmSgZyrheQ3/YsF
	 MA3xIn9GWFEs4kGD6RG6GF+8gSTU6S52RqovZ6MQfJv4JIkUH2soP3dVPPFbR0mvgP
	 aS58mCPiHK9UXuM3MAl4MTsq92LS06bS5oknH5Us=
Date: Tue, 06 Oct 2026 17:50:17 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-mem_cgroup_shrink_node.patch removed from -mm tree
Message-Id: <20261007005017.93A3C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove mem_cgroup_shrink_node()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_shrink_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove mem_cgroup_shrink_node()
Date: Wed, 2 Sep 2026 10:43:05 -0700

Its only caller was soft limit reclaim, which is gone.

Link: https://lore.kernel.org/20260902174311.1772372-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -6805,47 +6805,6 @@ unsigned long try_to_free_pages(struct z
 
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

memcg-move-per-node-objcg-to-the-read-mostly-fields.patch
memcg-split-mem_cgroup_private_id-into-two-fields.patch
memcg-group-the-write-hot-fields-of-struct-mem_cgroup.patch
memcg-group-the-cold-fields-of-struct-mem_cgroup.patch
memcg-group-the-read-mostly-fields-of-struct-mem_cgroup.patch
memcg-group-the-fields-of-struct-mem_cgroup_per_node.patch

