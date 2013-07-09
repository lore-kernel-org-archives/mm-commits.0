From: akpm@linux-foundation.org
Subject: [merged]
 memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:39 -0700
Message-ID: <51dc9ac7.MIhKic/VQNndGgzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3GIXUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: [merged] memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch removed from -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:39 -0700


The patch titled
     Subject: memcg: don't use mem_cgroup_get() when creating a kmemcg cache
has been removed from the -mm tree.  Its filename was
     memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: don't use mem_cgroup_get() when creating a kmemcg cache

Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().

There are two things being done in the current code:

First, we acquired a css_ref to make sure that the underlying cgroup
would not go away. That is a short lived reference, and it is put as
soon as the cache is created.

At this point, we acquire a long-lived per-cache memcg reference count
to guarantee that the memcg will still be alive.

so it is:

enqueue: css_get
create : memcg_get, css_put
destroy: memcg_put

So we only need to get rid of the memcg_get, change the memcg_put to
css_put, and get rid of the now extra css_put.

(This changelog is mostly written by Glauber)

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache
+++ a/mm/memcontrol.c
@@ -3242,7 +3242,7 @@ void memcg_release_cache(struct kmem_cac
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
-	mem_cgroup_put(memcg);
+	css_put(&memcg->css);
 out:
 	kfree(s->memcg_params);
 }
@@ -3402,16 +3402,18 @@ static struct kmem_cache *memcg_create_k
 
 	mutex_lock(&memcg_cache_mutex);
 	new_cachep = cachep->memcg_params->memcg_caches[idx];
-	if (new_cachep)
+	if (new_cachep) {
+		css_put(&memcg->css);
 		goto out;
+	}
 
 	new_cachep = kmem_cache_dup(memcg, cachep);
 	if (new_cachep == NULL) {
 		new_cachep = cachep;
+		css_put(&memcg->css);
 		goto out;
 	}
 
-	mem_cgroup_get(memcg);
 	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
@@ -3499,8 +3501,6 @@ static void memcg_create_cache_work_func
 
 	cw = container_of(w, struct create_work, work);
 	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	/* Drop the reference gotten when we enqueued. */
-	css_put(&cw->memcg->css);
 	kfree(cw);
 }
 
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch

