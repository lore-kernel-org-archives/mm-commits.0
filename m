Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027645BE3
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348617; cv=none; b=u3ka2e5vuJjuO5/SuqNF+I2UVk8g8e9W2XZK8xHBLyG56rqvwEgTznljwxpDOOpLfz2SM8YfSxR9aQHM9zlAVCYtw4DyV8OE00YDYcXQnrvaX5aD6kZ7DFRMoosqf+7wt4o6BB+3l/RFhQFHUfR9l+Ny+PCERJJDYOKQGQo/ILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348617; c=relaxed/simple;
	bh=ufD0eAwzZp7t/YtVTWWk1iuq/VScXj06dMdE1Jjl1Us=;
	h=Date:To:From:Subject:Message-Id; b=L5vvtz+P7QVEf4AqVMd4cqYI7WZWFSoaliLu3D03lckgKmYigOYSCNm72UwMmAlAKhQaA8T6hOu1LQVpomfSFgUbe4yHsMj/0TuUrIZySCq5erh4DKB+hJqHVTwEnt+Pb0L84QkgLl3v9JfFNOkTlfzA7vVigqnVzlU2BfNLZXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f2piD+aL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f2piD+aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82784C32781;
	Tue, 25 Jun 2024 20:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348616;
	bh=ufD0eAwzZp7t/YtVTWWk1iuq/VScXj06dMdE1Jjl1Us=;
	h=Date:To:From:Subject:From;
	b=f2piD+aLuwAocv8FpbVWGxsPBRG2z80oJ8wtTha1kxamPatnj6UIFMDREalpxQl90
	 UPoB+QR6Xl6tYDoLfngZu2S7SWfAnmW4spRXlw5h7KwMS7KsMP3vgYtczcYmSrH53+
	 zRv93hZCyCUHo2ZNfA8VZNHdGrP2Bu9QFIoKfYDU=
Date: Tue, 25 Jun 2024 13:50:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-rename-soft-limit-reclaim-related-functions.patch added to mm-unstable branch
Message-Id: <20240625205016.82784C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: rename soft limit reclaim-related functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-rename-soft-limit-reclaim-related-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-rename-soft-limit-reclaim-related-functions.patch

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

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

