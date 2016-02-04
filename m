From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch added to
 -mm tree
Date: Thu, 04 Feb 2016 15:07:43 -0800
Message-ID: <56b3d9bf.qlLtBD1Ov7nQ/ZNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbcBDXHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not bypass slab charge if memcg is offline
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: do not bypass slab charge if memcg is offline

Slab pages are charged in two steps.  First, an appropriate per memcg
cache is selected (see memcg_kmem_get_cache) basing on the current
context, then the new slab page is charged to the memory cgroup which the
selected cache was created for (see memcg_charge_slab ->
__memcg_kmem_charge_memcg).  It is OK to bypass kmemcg charge at step 1,
but if step 1 succeeded and we successfully allocated a new slab page,
step 2 must be performed, otherwise we would get a per memcg kmem cache
which contains a slab that does not hold a reference to the memory cgroup
owning the cache.  Since per memcg kmem caches are destroyed on memcg css
free, this could result in freeing a cache while there are still active
objects in it.

However, currently we will bypass slab page charge if the memory cgroup
owning the cache is offline (see __memcg_kmem_charge_memcg).  This is very
unlikely to occur in practice, because for this to happen a process must
be migrated to a different cgroup and the old cgroup must be removed while
the process is in kmalloc somewhere between steps 1 and 2 (e.g.  trying to
allocate a new page).  Nevertheless, it's still better to eliminate such a
possibility.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline
+++ a/mm/memcontrol.c
@@ -2325,9 +2325,6 @@ int __memcg_kmem_charge_memcg(struct pag
 	struct page_counter *counter;
 	int ret;
 
-	if (!memcg_kmem_online(memcg))
-		return 0;
-
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		return ret;
@@ -2346,10 +2343,11 @@ int __memcg_kmem_charge_memcg(struct pag
 int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
 	struct mem_cgroup *memcg;
-	int ret;
+	int ret = 0;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
-	ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+	if (memcg_kmem_online(memcg))
+		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
 	css_put(&memcg->css);
 	return ret;
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

