From: akpm@linux-foundation.org
Subject: +
 memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch added to -mm tree
Date: Mon, 06 Jan 2014 14:56:23 -0800
Message-ID: <52cb3497.NVttSFIXoezqLqZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbaAFW4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:23 -0800


The patch titled
     Subject: memcg: fix possible NULL deref while traversing memcg_slab_caches list
has been added to the -mm tree.  Its filename is
     memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch

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
Subject: memcg: fix possible NULL deref while traversing memcg_slab_caches list

All caches of the same memory cgroup are linked in the memcg_slab_caches
list via kmem_cache::memcg_params::list.  This list is traversed, for
example, when we read memory.kmem.slabinfo.  Since the list actually
consists of memcg_cache_params objects, we have to convert an element of
the list to a kmem_cache object using memcg_params_to_cache(), which
obtains the pointer to the cache from the memcg_params::memcg_caches array
of the corresponding root cache.  That said the pointer to a kmem_cache in
its parent's memcg_params must be initialized before adding the cache to
the list, and cleared only after it has been unlinked.  Currently it is
vice-versa, which can result in a NULL ptr dereference while traversing
the memcg_slab_caches list.  This patch restores the correct order.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list
+++ a/mm/memcontrol.c
@@ -3230,9 +3230,6 @@ void memcg_register_cache(struct kmem_ca
 
 	css_get(&memcg->css);
 
-	mutex_lock(&memcg->slab_caches_mutex);
-	list_add(&s->memcg_params->list, &memcg->memcg_slab_caches);
-	mutex_unlock(&memcg->slab_caches_mutex);
 
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
@@ -3241,7 +3238,16 @@ void memcg_register_cache(struct kmem_ca
 	 */
 	smp_wmb();
 
+	/*
+	 * Initialize the pointer to this cache in its parent's memcg_params
+	 * before adding it to the memcg_slab_caches list, otherwise we can
+	 * fail to convert memcg_params_to_cache() while traversing the list.
+	 */
 	root->memcg_params->memcg_caches[id] = s;
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_add(&s->memcg_params->list, &memcg->memcg_slab_caches);
+	mutex_unlock(&memcg->slab_caches_mutex);
 }
 
 void memcg_unregister_cache(struct kmem_cache *s)
@@ -3253,16 +3259,21 @@ void memcg_unregister_cache(struct kmem_
 	if (is_root_cache(s))
 		return;
 
-	memcg = s->memcg_params->memcg;
-	id  = memcg_cache_id(memcg);
-
 	root = s->memcg_params->root_cache;
-	root->memcg_params->memcg_caches[id] = NULL;
+	memcg = s->memcg_params->memcg;
+	id = memcg_cache_id(memcg);
 
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
+	/*
+	 * Clear the pointer to this cache in its parent's memcg_params only
+	 * after removing it from the memcg_slab_caches list, otherwise we can
+	 * fail to convert memcg_params_to_cache() while traversing the list.
+	 */
+	root->memcg_params->memcg_caches[id] = NULL;
+
 	css_put(&memcg->css);
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
linux-next.patch

