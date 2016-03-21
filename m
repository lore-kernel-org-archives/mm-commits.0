From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-zap-memcg_kmem_online-helper.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:53 -0700
Message-ID: <56f03fbd.GFA07N+pcufixSBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbcCUT4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: zap memcg_kmem_online helper
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-zap-memcg_kmem_online-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: zap memcg_kmem_online helper

As kmem accounting is now either enabled for all cgroups or disabled
system-wide, there's no point in having memcg_kmem_online() helper -
instead one can use memcg_kmem_enabled() and mem_cgroup_online(), as
shrink_slab() now does.

There are only two places left where this helper is used -
__memcg_kmem_charge() and memcg_create_kmem_cache().  The former can only
be called if memcg_kmem_enabled() returned true.  Since the cgroup it
operates on is online, mem_cgroup_is_root() check will be enough.

memcg_create_kmem_cache() can't use mem_cgroup_online() helper instead of
memcg_kmem_online(), because it relies on the fact that in
memcg_offline_kmem() memcg->kmem_state is changed before
memcg_deactivate_kmem_caches() is called, but there we can just open-code
the check.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ----------
 mm/memcontrol.c            |    2 +-
 mm/slab_common.c           |    2 +-
 3 files changed, 2 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-zap-memcg_kmem_online-helper include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-zap-memcg_kmem_online-helper
+++ a/include/linux/memcontrol.h
@@ -795,11 +795,6 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
-static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
-{
-	return memcg->kmem_state == KMEM_ONLINE;
-}
-
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -908,11 +903,6 @@ static inline bool memcg_kmem_enabled(vo
 {
 	return false;
 }
-
-static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
-{
-	return false;
-}
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
diff -puN mm/memcontrol.c~mm-memcontrol-zap-memcg_kmem_online-helper mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-zap-memcg_kmem_online-helper
+++ a/mm/memcontrol.c
@@ -2346,7 +2346,7 @@ int __memcg_kmem_charge(struct page *pag
 	int ret = 0;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-	if (memcg_kmem_online(memcg))
+	if (!mem_cgroup_is_root(memcg))
 		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
 	css_put(&memcg->css);
 	return ret;
diff -puN mm/slab_common.c~mm-memcontrol-zap-memcg_kmem_online-helper mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-zap-memcg_kmem_online-helper
+++ a/mm/slab_common.c
@@ -510,7 +510,7 @@ void memcg_create_kmem_cache(struct mem_
 	 * The memory cgroup could have been offlined while the cache
 	 * creation work was pending.
 	 */
-	if (!memcg_kmem_online(memcg))
+	if (memcg->kmem_state != KMEM_ONLINE)
 		goto out_unlock;
 
 	idx = memcg_cache_id(memcg);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

