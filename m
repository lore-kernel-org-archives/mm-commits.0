From: akpm@linux-foundation.org
Subject: + memcg-get-rid-of-kmem_cache_dup.patch added to -mm tree
Date: Mon, 06 Jan 2014 14:56:26 -0800
Message-ID: <52cb349a.4SMC4jr71OuEWfJL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517AbaAFW41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 17:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: + memcg-get-rid-of-kmem_cache_dup.patch added to -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 14:56:26 -0800


The patch titled
     Subject: memcg: get rid of kmem_cache_dup()
has been added to the -mm tree.  Its filename is
     memcg-get-rid-of-kmem_cache_dup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-get-rid-of-kmem_cache_dup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-get-rid-of-kmem_cache_dup.patch

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
Subject: memcg: get rid of kmem_cache_dup()

kmem_cache_dup() is only called from memcg_create_kmem_cache().  The
latter, in fact, does nothing besides this, so let's fold kmem_cache_dup()
into memcg_create_kmem_cache().

This patch also makes the memcg_cache_mutex private to
memcg_create_kmem_cache(), because it is not used anywhere else.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff -puN mm/memcontrol.c~memcg-get-rid-of-kmem_cache_dup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-rid-of-kmem_cache_dup
+++ a/mm/memcontrol.c
@@ -3387,27 +3387,16 @@ void mem_cgroup_destroy_cache(struct kme
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-/*
- * This lock protects updaters, not readers. We want readers to be as fast as
- * they can, and they will either see NULL or a valid cache value. Our model
- * allow them to see NULL, in which case the root memcg will be selected.
- *
- * We need this lock because multiple allocations to the same cache from a non
- * will span more than one worker. Only one of them can create the cache.
- */
-static DEFINE_MUTEX(memcg_cache_mutex);
-
-/*
- * Called with memcg_cache_mutex held
- */
-static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
-					 struct kmem_cache *s)
+static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
+						  struct kmem_cache *s)
 {
 	struct kmem_cache *new;
 	static char *tmp_name = NULL;
+	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
-	lockdep_assert_held(&memcg_cache_mutex);
+	BUG_ON(!memcg_can_account_kmem(memcg));
 
+	mutex_lock(&mutex);
 	/*
 	 * kmem_cache_create_memcg duplicates the given name and
 	 * cgroup_name for this name requires RCU context.
@@ -3430,25 +3419,13 @@ static struct kmem_cache *kmem_cache_dup
 
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
+	else
+		new = s;
 
+	mutex_unlock(&mutex);
 	return new;
 }
 
-static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-						  struct kmem_cache *cachep)
-{
-	struct kmem_cache *new_cachep;
-
-	BUG_ON(!memcg_can_account_kmem(memcg));
-
-	mutex_lock(&memcg_cache_mutex);
-	new_cachep = kmem_cache_dup(memcg, cachep);
-	if (new_cachep == NULL)
-		new_cachep = cachep;
-	mutex_unlock(&memcg_cache_mutex);
-	return new_cachep;
-}
