Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89F36FDC
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141600; cv=none; b=m+jgNhBdVWJxVma0TIqcXyeQi4FWrHZv+BPOfhw0jghZdWKpaTbaUYuTWN8p1lS6fxSP5pLYC1S3APt0rlYRE1+m1etHP4TqJN4A9rMfV4W/4vZnHtRUfBOuEE1NYWXrDVFoIiUu9YDEsIVA54DAfoX47WiQuxzARMjSIwyDdUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141600; c=relaxed/simple;
	bh=QqnHuUFbsNTNt03VZQBlW0rmzj3jJAD/8Uy/zcFb28E=;
	h=Date:To:From:Subject:Message-Id; b=iJ589z3iCybw5IckEMzATRA7TOytGgH49cWVSOUt4tHh8DLJjieyPiSyqNNADBLYQWOpGduYLMsEyudHe4qQcbi6FPBH4NZshhDYon24FtVrZUU3GZdmZXUCH9/dMDVU4n5NSQguBrZotniMMaiTIb97kRSRZB5NvKevbz3WFgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSqCHXnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSqCHXnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD67C3277B;
	Fri,  5 Jul 2024 01:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141600;
	bh=QqnHuUFbsNTNt03VZQBlW0rmzj3jJAD/8Uy/zcFb28E=;
	h=Date:To:From:Subject:From;
	b=sSqCHXnBfjzHv323Y1FV5Fh710k9Hg/3mehIbVEcrMdbLlgFSCN1rMHuHm33Ka6ZY
	 i0b8nNe/oPM4OwA8fq+31gZ9R3SlUNLVIYPbI+G8fplSnwzOEBEVqAqnbKyeiR+xfl
	 Va8MKQ2RNWGifEc/u631Q7RoJtjU9jS+kMp5/x0Q=
Date: Thu, 04 Jul 2024 18:06:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-rename-soft-limit-reclaim-related-functions.patch removed from -mm tree
Message-Id: <20240705010640.9BD67C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: rename soft limit reclaim-related functions
has been removed from the -mm tree.  Its filename was
     mm-memcg-rename-soft-limit-reclaim-related-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: rename soft limit reclaim-related functions
Date: Mon, 24 Jun 2024 17:58:55 -0700

Rename exported function related to the softlimit reclaim to have memcg1_
prefix.

Link: https://lkml.kernel.org/r/20240625005906.106920-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++++++------
 mm/memcontrol-v1.c         |    6 +++---
 mm/memcontrol-v1.h         |    4 ++--
 mm/memcontrol.c            |    4 ++--
 mm/vmscan.c                |   10 +++++-----
 5 files changed, 18 insertions(+), 18 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-rename-soft-limit-reclaim-related-functions
+++ a/include/linux/memcontrol.h
@@ -1121,9 +1121,9 @@ static inline void memcg_memory_event_mm
 
 void split_page_memcg(struct page *head, int old_order, int new_order);
 
-unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
-						gfp_t gfp_mask,
-						unsigned long *total_scanned);
+unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
+					gfp_t gfp_mask,
+					unsigned long *total_scanned);
 
 #else /* CONFIG_MEMCG */
 
@@ -1572,9 +1572,9 @@ static inline void split_page_memcg(stru
 }
 
 static inline
-unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
+unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
+					gfp_t gfp_mask,
+					unsigned long *total_scanned)
 {
 	return 0;
 }
--- a/mm/memcontrol.c~mm-memcg-rename-soft-limit-reclaim-related-functions
+++ a/mm/memcontrol.c
@@ -1011,7 +1011,7 @@ static void memcg_check_events(struct me
 						MEM_CGROUP_TARGET_SOFTLIMIT);
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
-			mem_cgroup_update_tree(memcg, nid);
+			memcg1_update_tree(memcg, nid);
 	}
 }
 
@@ -5608,7 +5608,7 @@ static void mem_cgroup_css_free(struct c
 
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
-	mem_cgroup_remove_from_trees(memcg);
+	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);
 	mem_cgroup_free(memcg);
 }
--- a/mm/memcontrol-v1.c~mm-memcg-rename-soft-limit-reclaim-related-functions
+++ a/mm/memcontrol-v1.c
@@ -100,7 +100,7 @@ static unsigned long soft_limit_excess(s
 	return excess;
 }
 
-void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
+void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
 {
 	unsigned long excess;
 	struct mem_cgroup_per_node *mz;
@@ -143,7 +143,7 @@ void mem_cgroup_update_tree(struct mem_c
 	}
 }
 
-void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
+void memcg1_remove_from_trees(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_tree_per_node *mctz;
 	struct mem_cgroup_per_node *mz;
@@ -243,7 +243,7 @@ static int mem_cgroup_soft_reclaim(struc
 	return total;
 }
 
-unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
+unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
 					    unsigned long *total_scanned)
 {
--- a/mm/memcontrol-v1.h~mm-memcg-rename-soft-limit-reclaim-related-functions
+++ a/mm/memcontrol-v1.h
@@ -3,8 +3,8 @@
 #ifndef __MM_MEMCONTROL_V1_H
 #define __MM_MEMCONTROL_V1_H
 
-void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid);
-void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg);
+void memcg1_update_tree(struct mem_cgroup *memcg, int nid);
+void memcg1_remove_from_trees(struct mem_cgroup *memcg);
 
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
 {
--- a/mm/vmscan.c~mm-memcg-rename-soft-limit-reclaim-related-functions
+++ a/mm/vmscan.c
@@ -6169,9 +6169,9 @@ static void shrink_zones(struct zonelist
 			 * and balancing, not for a memcg's limit.
 			 */
 			nr_soft_scanned = 0;
-			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone->zone_pgdat,
-						sc->order, sc->gfp_mask,
-						&nr_soft_scanned);
+			nr_soft_reclaimed = memcg1_soft_limit_reclaim(zone->zone_pgdat,
+								      sc->order, sc->gfp_mask,
+								      &nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
 			/* need some check for avoid more shrink_zone() */
@@ -6933,8 +6933,8 @@ restart:
 		/* Call soft limit reclaim before calling shrink_node. */
 		sc.nr_scanned = 0;
 		nr_soft_scanned = 0;
-		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(pgdat, sc.order,
-						sc.gfp_mask, &nr_soft_scanned);
+		nr_soft_reclaimed = memcg1_soft_limit_reclaim(pgdat, sc.order,
+							      sc.gfp_mask, &nr_soft_scanned);
 		sc.nr_reclaimed += nr_soft_reclaimed;
 
 		/*
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

