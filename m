From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-endless-loop-caused-by-mem_cgroup_iter.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:39 -0800
Message-ID: <52e2b81b.G/d8Pw/dqvRsl00s%akpm__38061.8291245357$1390589992$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: [merged] memcg-fix-endless-loop-caused-by-mem_cgroup_iter.patch removed from -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:39 -0800


The patch titled
     Subject: memcg: fix endless loop caused by mem_cgroup_iter
has been removed from the -mm tree.  Its filename was
     memcg-fix-endless-loop-caused-by-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: fix endless loop caused by mem_cgroup_iter

Hugh has reported an endless loop when the hardlimit reclaim sees the same
group all the time.  This might happen when the reclaim races with the
memcg removal.

shrink_zone
                                                [rmdir root]
  mem_cgroup_iter(root, NULL, reclaim)
    // prev = NULL
    rcu_read_lock()
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root || NULL
      css_tryget(last_visited)            // failed
      last_visited = NULL                 [1]
    memcg = root = __mem_cgroup_iter_next(root, NULL)
    mem_cgroup_iter_update
      iter->last_visited = root;
    reclaim->generation = iter->generation

 mem_cgroup_iter(root, root, reclaim)
   // prev = root
   rcu_read_lock
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root
      css_tryget(last_visited)            // failed
    [1]

The issue seemed to be introduced by 5f5781619718 ("memcg: relax memcg
iter caching") which has replaced unconditional css_get/css_put by
css_tryget/css_put for the cached iterator.

This patch fixes the issue by skipping css_tryget on the root of the tree
walk in mem_cgroup_iter_load and symmetrically doesn't release it in
mem_cgroup_iter_update.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-endless-loop-caused-by-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-endless-loop-caused-by-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1158,7 +1158,15 @@ mem_cgroup_iter_load(struct mem_cgroup_r
 	if (iter->last_dead_count == *sequence) {
 		smp_rmb();
 		position = iter->last_visited;
-		if (position && !css_tryget(&position->css))
+
+		/*
+		 * We cannot take a reference to root because we might race
+		 * with root removal and returning NULL would end up in
+		 * an endless loop on the iterator user level when root
+		 * would be returned all the time.
+		 */
+		if (position && position != root &&
+				!css_tryget(&position->css))
 			position = NULL;
 	}
 	return position;
@@ -1167,9 +1175,11 @@ mem_cgroup_iter_load(struct mem_cgroup_r
 static void mem_cgroup_iter_update(struct mem_cgroup_reclaim_iter *iter,
 				   struct mem_cgroup *last_visited,
 				   struct mem_cgroup *new_position,
+				   struct mem_cgroup *root,
 				   int sequence)
 {
-	if (last_visited)
+	/* root reference counting symmetric to mem_cgroup_iter_load */
+	if (last_visited && last_visited != root)
 		css_put(&last_visited->css);
 	/*
 	 * We store the sequence count from the time @last_visited was
@@ -1244,7 +1254,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
+			mem_cgroup_iter_update(iter, last_visited, memcg, root,
+					seq);
 
 			if (!memcg)
 				iter->generation++;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

