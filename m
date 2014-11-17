From: akpm@linux-foundation.org
Subject: + mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache.patch added to -mm tree
Date: Mon, 17 Nov 2014 13:55:36 -0800
Message-ID: <546a6ed8.uLcylC9eSbVEIBVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKQVzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 16:55:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove the unused arg in __memcg_kmem_get_cache()
has been added to the -mm tree.  Its filename is
     mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/memcontrol.c: remove the unused arg in __memcg_kmem_get_cache()

The gfp was passed in but never used in this function.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache
+++ a/include/linux/memcontrol.h
@@ -401,7 +401,7 @@ int memcg_cache_id(struct mem_cgroup *me
 void memcg_update_array_size(int num_groups);
 
 struct kmem_cache *
-__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
+__memcg_kmem_get_cache(struct kmem_cache *cachep);
 
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
@@ -492,7 +492,7 @@ memcg_kmem_get_cache(struct kmem_cache *
 	if (unlikely(fatal_signal_pending(current)))
 		return cachep;
 
-	return __memcg_kmem_get_cache(cachep, gfp);
+	return __memcg_kmem_get_cache(cachep);
 }
 #else
 #define for_each_memcg_cache_index(_idx)	\
diff -puN mm/memcontrol.c~mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -2804,8 +2804,7 @@ void __memcg_uncharge_slab(struct kmem_c
  * Can't be called in interrupt context or from kernel threads.
  * This function needs to be called with rcu_read_lock() held.
  */
-struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
-					  gfp_t gfp)
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep)
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

memory-hotplug-remove-redundant-call-of-page_to_pfn.patch
mm-remove-the-useless-gfp-in-__memcg_kmem_get_cache.patch

