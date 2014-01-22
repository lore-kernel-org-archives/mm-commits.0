From: akpm@linux-foundation.org
Subject: [merged]
 memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:13:14 -0800
Message-ID: <52e0265a.D/+Zd8z9nq84+q9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@parallels.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@parallels.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:14 -0800


The patch titled
     Subject: memcg: fix kmem_account_flags check in memcg_can_account_kmem()
has been removed from the -mm tree.  Its filename was
     memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: fix kmem_account_flags check in memcg_can_account_kmem()

We should start kmem accounting for a memory cgroup only after both its
kmem limit is set (KMEM_ACCOUNTED_ACTIVE) and related call sites are
patched (KMEM_ACCOUNTED_ACTIVATED).  Currently memcg_can_account_kmem()
allows kmem accounting even if only one of the conditions is true.  Fix
it.

This means that a page might get charged by memcg_kmem_newpage_charge
which would see its static key patched already but
memcg_kmem_commit_charge would still see it unpatched and so the charge
won't be committed.  The result would be charge inconsistency (page_cgroup
not marked as PageCgroupUsed) and the charge would leak because
__memcg_kmem_uncharge_pages would ignore it.

[mhocko@suse.cz: augment changelog]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem
+++ a/mm/memcontrol.c
@@ -2959,7 +2959,8 @@ static DEFINE_MUTEX(set_limit_mutex);
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
-		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
+		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK) ==
+							KMEM_ACCOUNTED_MASK;
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch
linux-next.patch

