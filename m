From: akpm@linux-foundation.org
Subject: [merged]
 memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:51 -0800
Message-ID: <5489e8f3.U8lmSuF744/q6aex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbaLKS4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify unreclaimable groups handling in soft limit reclaim
has been removed from the -mm tree.  Its filename was
     memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: simplify unreclaimable groups handling in soft limit reclaim

If we fail to reclaim anything from a cgroup during a soft reclaim pass
we want to get the next largest cgroup exceeding its soft limit. To
achieve this, we should obviously remove the current group from the tree
and then pick the largest group. Currently we have a weird loop instead.
Let's simplify it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim
+++ a/mm/memcontrol.c
@@ -3518,34 +3518,16 @@ unsigned long mem_cgroup_soft_limit_recl
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
+		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
 		 * it is time to move on to the next cgroup
 		 */
 		next_mz = NULL;
-		if (!reclaimed) {
-			do {
-				/*
-				 * Loop until we find yet another one.
-				 *
-				 * By the time we get the soft_limit lock
-				 * again, someone might have aded the
-				 * group back on the RB tree. Iterate to
-				 * make sure we get a different mem.
-				 * mem_cgroup_largest_soft_limit_node returns
-				 * NULL if no other cgroup is present on
-				 * the tree
-				 */
-				next_mz =
-				__mem_cgroup_largest_soft_limit_node(mctz);
-				if (next_mz == mz)
-					css_put(&next_mz->memcg->css);
-				else /* next_mz == NULL or other memcg */
-					break;
-			} while (1);
-		}
-		__mem_cgroup_remove_exceeded(mz, mctz);
+		if (!reclaimed)
+			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
+
 		excess = soft_limit_excess(mz->memcg);
 		/*
 		 * One school of thought says that we should not add
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

