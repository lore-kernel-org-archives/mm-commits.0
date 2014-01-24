From: akpm@linux-foundation.org
Subject: [merged]
 slab-clean-up-kmem_cache_create_memcg-error-handling.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:58:35 -0800
Message-ID: <52e2b7db.Pwwn4+M2gQE2feS/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, vdavydov@parallels.com

Subject: [merged] slab-clean-up-kmem_cache_create_memcg-error-handling.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:35 -0800


The patch titled
     Subject: slab: clean up kmem_cache_create_memcg() error handling
has been removed from the -mm tree.  Its filename was
     slab-clean-up-kmem_cache_create_memcg-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: clean up kmem_cache_create_memcg() error handling

Currently kmem_cache_create_memcg() backoffs on failure inside
conditionals, without using gotos.  This results in the rollback code
duplication, which makes the function look cumbersome even though on error
we should only free the allocated cache.  Since in the next patch I am
going to add yet another rollback function call on error path there, let's
employ labels instead of conditionals for undoing any changes on failure
to keep things clean.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   69 +++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff -puN mm/slab_common.c~slab-clean-up-kmem_cache_create_memcg-error-handling mm/slab_common.c
--- a/mm/slab_common.c~slab-clean-up-kmem_cache_create_memcg-error-handling
+++ a/mm/slab_common.c
@@ -171,13 +171,14 @@ kmem_cache_create_memcg(struct mem_cgrou
 			struct kmem_cache *parent_cache)
 {
 	struct kmem_cache *s = NULL;
-	int err = 0;
+	int err;
 
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
-		goto out_locked;
+	err = kmem_cache_sanity_check(memcg, name, size);
+	if (err)
+		goto out_unlock;
 
 	/*
 	 * Some allocators will constraint the set of valid flags to a subset
@@ -189,45 +190,38 @@ kmem_cache_create_memcg(struct mem_cgrou
 
 	s = __kmem_cache_alias(memcg, name, size, align, flags, ctor);
 	if (s)
-		goto out_locked;
+		goto out_unlock;
 
+	err = -ENOMEM;
 	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
-	if (s) {
-		s->object_size = s->size = size;
-		s->align = calculate_alignment(flags, align, size);
-		s->ctor = ctor;
-
-		if (memcg_register_cache(memcg, s, parent_cache)) {
-			kmem_cache_free(kmem_cache, s);
-			err = -ENOMEM;
-			goto out_locked;
-		}
-
-		s->name = kstrdup(name, GFP_KERNEL);
-		if (!s->name) {
-			kmem_cache_free(kmem_cache, s);
-			err = -ENOMEM;
-			goto out_locked;
-		}
+	if (!s)
+		goto out_unlock;
 
-		err = __kmem_cache_create(s, flags);
-		if (!err) {
-			s->refcount = 1;
-			list_add(&s->list, &slab_caches);
-			memcg_cache_list_add(memcg, s);
-		} else {
-			kfree(s->name);
-			kmem_cache_free(kmem_cache, s);
-		}
-	} else
-		err = -ENOMEM;
+	s->object_size = s->size = size;
+	s->align = calculate_alignment(flags, align, size);
+	s->ctor = ctor;
+
+	s->name = kstrdup(name, GFP_KERNEL);
+	if (!s->name)
+		goto out_free_cache;
+
+	err = memcg_register_cache(memcg, s, parent_cache);
+	if (err)
+		goto out_free_cache;
+
+	err = __kmem_cache_create(s, flags);
+	if (err)
+		goto out_free_cache;
+
+	s->refcount = 1;
+	list_add(&s->list, &slab_caches);
+	memcg_cache_list_add(memcg, s);
 
-out_locked:
+out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
 	if (err) {
-
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
@@ -236,11 +230,14 @@ out_locked:
 				name, err);
 			dump_stack();
 		}
-
 		return NULL;
 	}
