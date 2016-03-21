From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:48 -0700
Message-ID: <56f03fb8.2qVFUKo7wXTfYD27%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbcCUT4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: enable kmem accounting for all cgroups in the legacy hierarchy
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: enable kmem accounting for all cgroups in the legacy hierarchy

Workingset code was recently made memcg aware, but shadow node shrinker is
still global.  As a result, one small cgroup can consume all memory
available for shadow nodes, possibly hurting other cgroups by reclaiming
their shadow nodes, even though reclaim distances stored in its shadow
nodes have no effect.  To avoid this, we need to make shadow node shrinker
memcg aware.

The actual work is done in patch 6 of the series.  Patches 1 and 2 prepare
memcg/shrinker infrastructure for the change.  Patch 3 is just a
collateral cleanup.  Patch 4 makes radix_tree_node accounted, which is
necessary for making shadow node shrinker memcg aware.  Patch 5 reduces
shadow nodes overhead in case workload mostly uses anonymous pages.



This patch:

Currently, in the legacy hierarchy kmem accounting is off for all cgroups
by default and must be enabled explicitly by writing something to
memory.kmem.limit_in_bytes.  Since we don't support reclaim on hitting
kmem limit, nor do we have any plans to implement it, this is likely to be
-1, just to enable kmem accounting and limit kernel memory consumption by
the memory.limit_in_bytes along with user memory.

This user API was introduced when the implementation of kmem accounting
lacked slab shrinker support and hence was useless in practice.  Things
have changed since then - slab shrinkers were made memcg aware, the
accounting overhead seems to be negligible, and a failure to charge a kmem
allocation should not have critical consequences, because we only account
those kernel objects that should be safe to fail.  That's why kmem
accounting is enabled by default for all cgroups in the default hierarchy,
which will eventually replace the legacy one.

The ability to enable kmem accounting for some cgroups while keeping it
disabled for others is getting difficult to maintain.  E.g.  to make
shadow node shrinker memcg aware (see mm/workingset.c), we need to know
the relationship between the number of shadow nodes allocated for a cgroup
and the size of its lru list.  If kmem accounting is enabled for all
cgroups there is no problem, but what should we do if kmem accounting is
enabled only for half of cgroups?  We've no other choice but use global
lru stats while scanning root cgroup's shadow nodes, but that would be
wrong if kmem accounting was enabled for all cgroups (which is the case if
the unified hierarchy is used), in which case we should use lru stats of
the root cgroup's lruvec.

That being said, let's enable kmem accounting for all memory cgroups by
default.  If one finds it unstable or too costly, it can always be
disabled system-wide by passing cgroup.memory=nokmem to the kernel at boot
time.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy
+++ a/mm/memcontrol.c
@@ -2824,6 +2824,9 @@ static int memcg_online_kmem(struct mem_
 {
 	int memcg_id;
 
+	if (cgroup_memory_nokmem)
+		return 0;
+
 	BUG_ON(memcg->kmemcg_id >= 0);
 	BUG_ON(memcg->kmem_state);
 
@@ -2844,24 +2847,6 @@ static int memcg_online_kmem(struct mem_
 	return 0;
 }
 
-static int memcg_propagate_kmem(struct mem_cgroup *parent,
-				struct mem_cgroup *memcg)
-{
-	int ret = 0;
-
-	mutex_lock(&memcg_limit_mutex);
-	/*
-	 * If the parent cgroup is not kmem-online now, it cannot be
-	 * onlined after this point, because it has at least one child
-	 * already.
-	 */
-	if (memcg_kmem_online(parent) ||
-	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nokmem))
-		ret = memcg_online_kmem(memcg);
-	mutex_unlock(&memcg_limit_mutex);
-	return ret;
-}
-
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct cgroup_subsys_state *css;
@@ -2920,10 +2905,6 @@ static void memcg_free_kmem(struct mem_c
 	}
 }
 #else
-static int memcg_propagate_kmem(struct mem_cgroup *parent, struct mem_cgroup *memcg)
-{
-	return 0;
-}
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	return 0;
@@ -2939,22 +2920,10 @@ static void memcg_free_kmem(struct mem_c
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&memcg_limit_mutex);
-	/* Top-level cgroup doesn't propagate from root */
-	if (!memcg_kmem_online(memcg)) {
-		if (cgroup_is_populated(memcg->css.cgroup) ||
-		    (memcg->use_hierarchy && memcg_has_children(memcg)))
-			ret = -EBUSY;
-		if (ret)
-			goto out;
-		ret = memcg_online_kmem(memcg);
-		if (ret)
-			goto out;
-	}
 	ret = page_counter_limit(&memcg->kmem, limit);
-out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
@@ -4205,7 +4174,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		return &memcg->css;
 	}
 
-	error = memcg_propagate_kmem(parent, memcg);
+	error = memcg_online_kmem(memcg);
 	if (error)
 		goto fail;
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

