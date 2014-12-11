From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-activate_kmem_mutex.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 10:56:57 -0800
Message-ID: <5489e8f9.eEaJbnGuIa1v//TG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaLKS46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove activate_kmem_mutex
has been removed from the -mm tree.  Its filename was
     memcg-remove-activate_kmem_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove activate_kmem_mutex

The activate_kmem_mutex is used to serialize memcg.kmem.limit updates, but
we already serialize them with memcg_limit_mutex so let's remove the
former.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-activate_kmem_mutex mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-activate_kmem_mutex
+++ a/mm/memcontrol.c
@@ -2627,8 +2627,6 @@ static void commit_charge(struct page *p
  */
 static DEFINE_MUTEX(memcg_slab_mutex);
 
-static DEFINE_MUTEX(activate_kmem_mutex);
-
 /*
  * This is a bit cumbersome, but it is rarely used and avoids a backpointer
  * in the memcg_cache_params struct.
@@ -3747,9 +3745,8 @@ static u64 mem_cgroup_read_u64(struct cg
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-/* should be called with activate_kmem_mutex held */
-static int __memcg_activate_kmem(struct mem_cgroup *memcg,
-				 unsigned long nr_pages)
+static int memcg_activate_kmem(struct mem_cgroup *memcg,
+			       unsigned long nr_pages)
 {
 	int err = 0;
 	int memcg_id;
@@ -3811,17 +3808,6 @@ out:
 	return err;
 }
 
-static int memcg_activate_kmem(struct mem_cgroup *memcg,
-			       unsigned long nr_pages)
-{
-	int ret;
-
-	mutex_lock(&activate_kmem_mutex);
-	ret = __memcg_activate_kmem(memcg, nr_pages);
-	mutex_unlock(&activate_kmem_mutex);
-	return ret;
-}
-
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
@@ -3844,14 +3830,14 @@ static int memcg_propagate_kmem(struct m
 	if (!parent)
 		return 0;
 
-	mutex_lock(&activate_kmem_mutex);
+	mutex_lock(&memcg_limit_mutex);
 	/*
 	 * If the parent cgroup is not kmem-active now, it cannot be activated
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = __memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
-	mutex_unlock(&activate_kmem_mutex);
+		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
 #else
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

