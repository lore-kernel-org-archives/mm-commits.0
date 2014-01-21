From: akpm@linux-foundation.org
Subject: +
 memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch added to
 -mm tree
Date: Tue, 21 Jan 2014 12:02:48 -0800
Message-ID: <52ded268.WzTZAs1C4NGHPmoy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaAUUCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 15:02:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: + memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch added to -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 12:02:48 -0800


The patch titled
     Subject: memcg: remove unused code from kmem_cache_destroy_work_func
has been added to the -mm tree.  Its filename is
     memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove unused code from kmem_cache_destroy_work_func

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-code-from-kmem_cache_destroy_work_func mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-code-from-kmem_cache_destroy_work_func
+++ a/mm/memcontrol.c
@@ -3320,11 +3320,9 @@ static void kmem_cache_destroy_work_func
 	 * So if we aren't down to zero, we'll just schedule a worker and try
 	 * again
 	 */
-	if (atomic_read(&cachep->memcg_params->nr_pages) != 0) {
+	if (atomic_read(&cachep->memcg_params->nr_pages) != 0)
 		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			return;
-	} else
+	else
 		kmem_cache_destroy(cachep);
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

fs-superc-fix-warn-on-alloc_super-fail-path.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
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

