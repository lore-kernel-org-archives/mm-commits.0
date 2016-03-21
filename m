From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:37:54 -0700
Message-ID: <56f03f82.Ofv+WhGGb9kAEzd8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbcCUT4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not bypass slab charge if memcg is offline
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
