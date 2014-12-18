From: akpm@linux-foundation.org
Subject: + memcg-zap-__memcg_chargeuncharge_slab.patch added to -mm tree
Date: Thu, 18 Dec 2014 14:12:29 -0800
Message-ID: <5493514d.Z2PC71ME6djctukE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaLRWMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap __memcg_{charge,uncharge}_slab
has been added to the -mm tree.  Its filename is
     memcg-zap-__memcg_chargeuncharge_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-zap-__memcg_chargeuncharge_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-zap-__memcg_chargeuncharge_slab.patch

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
Subject: memcg: zap __memcg_{charge,uncharge}_slab

They are simple wrappers around memcg_{charge,uncharge}_kmem, so let's
zap them and call these functions directly.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |   21 +++------------------
 mm/slab.h                  |    4 ++--
 3 files changed, 8 insertions(+), 22 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-zap-__memcg_chargeuncharge_slab include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-zap-__memcg_chargeuncharge_slab
+++ a/include/linux/memcontrol.h
@@ -403,8 +403,9 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
+		      unsigned long nr_pages);
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages);
 
 int __memcg_cleanup_cache_params(struct kmem_cache *s);
 
diff -puN mm/memcontrol.c~memcg-zap-__memcg_chargeuncharge_slab mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-__memcg_chargeuncharge_slab
+++ a/mm/memcontrol.c
@@ -2495,8 +2495,8 @@ static struct kmem_cache *memcg_params_t
 	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
 }
 
-static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
-			     unsigned long nr_pages)
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
+		      unsigned long nr_pages)
 {
 	struct page_counter *counter;
 	int ret = 0;
@@ -2533,8 +2533,7 @@ static int memcg_charge_kmem(struct mem_
 	return ret;
 }
 
-static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
-				unsigned long nr_pages)
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_swap_account)
@@ -2767,20 +2766,6 @@ static void memcg_schedule_register_cach
 	current->memcg_kmem_skip_account = 0;
 }
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	return memcg_charge_kmem(cachep->memcg_params->memcg, gfp, nr_pages);
-}
-
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	memcg_uncharge_kmem(cachep->memcg_params->memcg, nr_pages);
-}
-
 /*
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
diff -puN mm/slab.h~memcg-zap-__memcg_chargeuncharge_slab mm/slab.h
--- a/mm/slab.h~memcg-zap-__memcg_chargeuncharge_slab
+++ a/mm/slab.h
@@ -235,7 +235,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return __memcg_charge_slab(s, gfp, order);
+	return memcg_charge_kmem(s->memcg_params->memcg, gfp, 1 << order);
 }
 
 static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
@@ -244,7 +244,7 @@ static __always_inline void memcg_unchar
 		return;
 	if (is_root_cache(s))
 		return;
-	__memcg_uncharge_slab(s, order);
+	memcg_uncharge_kmem(s->memcg_params->memcg, 1 << order);
 }
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch

