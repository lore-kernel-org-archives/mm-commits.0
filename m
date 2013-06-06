From: akpm@linux-foundation.org
Subject: [to-be-updated]
 memcg-reap-dead-memcgs-upon-global-memory-pressure.patch removed from -mm
 tree
Date: Thu, 06 Jun 2013 12:35:29 -0700
Message-ID: <51b0e481.fT3LSIH8da2dQV8b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3FFTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] memcg-reap-dead-memcgs-upon-global-memory-pressure.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:29 -0700


The patch titled
     Subject: memcg: reap dead memcgs upon global memory pressure
has been removed from the -mm tree.  Its filename was
     memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: memcg: reap dead memcgs upon global memory pressure

When we delete kmem-enabled memcgs, they can still be zombieing around for
a while.  The reason is that the objects may still be alive, and we won't
be able to delete them at destruction time.

The only entry point for that, though, are the shrinkers.  The shrinker
interface, however, is not exactly tailored to our needs.  It could be a
little bit better by using the API Dave Chinner proposed, but it is still
not ideal since we aren't really a count-and-scan event, but more a
one-off flush-all-you-can event that would have to abuse that somehow.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   52 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-reap-dead-memcgs-upon-global-memory-pressure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reap-dead-memcgs-upon-global-memory-pressure
+++ a/mm/memcontrol.c
@@ -400,7 +400,6 @@ static size_t memcg_size(void)
 		nr_node_ids * sizeof(struct mem_cgroup_per_node);
 }
 
-#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 static LIST_HEAD(dangling_memcgs);
 static DEFINE_MUTEX(dangling_memcgs_mutex);
 
@@ -409,11 +408,14 @@ static inline void memcg_dangling_free(s
 	mutex_lock(&dangling_memcgs_mutex);
 	list_del(&memcg->dead);
 	mutex_unlock(&dangling_memcgs_mutex);
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 	free_pages((unsigned long)memcg->memcg_name, 0);
+#endif
 }
 
 static inline void memcg_dangling_add(struct mem_cgroup *memcg)
 {
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 	/*
 	 * cgroup.c will do page-sized allocations most of the time,
 	 * so we'll just follow the pattern. Also, __get_free_pages
@@ -439,15 +441,12 @@ static inline void memcg_dangling_add(st
 	}
 
 add_list:
+#endif
 	INIT_LIST_HEAD(&memcg->dead);
 	mutex_lock(&dangling_memcgs_mutex);
 	list_add(&memcg->dead, &dangling_memcgs);
 	mutex_unlock(&dangling_memcgs_mutex);
 }
-#else
-static inline void memcg_dangling_free(struct mem_cgroup *memcg) {}
-static inline void memcg_dangling_add(struct mem_cgroup *memcg) {}
-#endif
 
 static DEFINE_MUTEX(set_limit_mutex);
 
@@ -6339,6 +6338,41 @@ static int mem_cgroup_oom_control_write(
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+static void memcg_vmpressure_shrink_dead(void)
+{
+	struct memcg_cache_params *params, *tmp;
+	struct kmem_cache *cachep;
+	struct mem_cgroup *memcg;
+
+	mutex_lock(&dangling_memcgs_mutex);
+	list_for_each_entry(memcg, &dangling_memcgs, dead) {
+		mutex_lock(&memcg->slab_caches_mutex);
+		/* The element may go away as an indirect result of shrink */
+		list_for_each_entry_safe(params, tmp,
+					 &memcg->memcg_slab_caches, list) {
+			cachep = memcg_params_to_cache(params);
+			/*
+			 * the cpu_hotplug lock is taken in kmem_cache_create
+			 * outside the slab_caches_mutex manipulation. It will
+			 * be taken by kmem_cache_shrink to flush the cache.
+			 * So we need to drop the lock. It is all right because
+			 * the lock only protects elements moving in and out the
+			 * list.
+			 */
+			mutex_unlock(&memcg->slab_caches_mutex);
+			kmem_cache_shrink(cachep);
+			mutex_lock(&memcg->slab_caches_mutex);
+		}
+		mutex_unlock(&memcg->slab_caches_mutex);
+	}
+	mutex_unlock(&dangling_memcgs_mutex);
+}
+
+static void memcg_register_kmem_events(struct cgroup *cont)
+{
+	vmpressure_register_kernel_event(cont, memcg_vmpressure_shrink_dead);
+}
+
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	int ret;
@@ -6374,6 +6408,10 @@ static void kmem_cgroup_destroy(struct m
 	}
 }
 #else
+static inline void memcg_register_kmem_events(struct cgroup *cont)
+{
+}
+
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	return 0;
@@ -6759,8 +6797,10 @@ mem_cgroup_css_online(struct cgroup *con
 	struct mem_cgroup *memcg, *parent;
 	int error = 0;
 
-	if (!cont->parent)
+	if (!cont->parent) {
+		memcg_register_kmem_events(cont);
 		return 0;
+	}
 
 	mutex_lock(&memcg_create_mutex);
 	memcg = mem_cgroup_from_cont(cont);
_

Patches currently in -mm which might be from glommer@openvz.org are


