From: akpm@linux-foundation.org
Subject: + memcg-remove-activate_kmem_mutex.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:54:00 -0700
Message-ID: <54458478.SY24RgVa4220EN/a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaJTVyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove activate_kmem_mutex
has been added to the -mm tree.  Its filename is
     memcg-remove-activate_kmem_mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-remove-activate_kmem_mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-remove-activate_kmem_mutex.patch

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
@@ -2618,8 +2618,6 @@ static void commit_charge(struct page *p
  */
 static DEFINE_MUTEX(memcg_slab_mutex);
 
-static DEFINE_MUTEX(activate_kmem_mutex);
-
 /*
  * This is a bit cumbersome, but it is rarely used and avoids a backpointer
  * in the memcg_cache_params struct.
@@ -3738,9 +3736,8 @@ static u64 mem_cgroup_read_u64(struct cg
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
@@ -3802,17 +3799,6 @@ out:
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
@@ -3835,14 +3821,14 @@ static int memcg_propagate_kmem(struct m
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

mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch

