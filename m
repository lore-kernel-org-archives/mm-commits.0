Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC82C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B8B2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781277;
	bh=Fhu6cQTbKmBdAAVvI4mhNXkwC0uRFIVD/XvH3G4l5u0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2mf8/iVs0c3KJ4kx9QeGHsg0J/irsWvY3/CIBs0rxwpzhTw0VrOsf50/JMg5PtaoT
	 pFNByweGJvenV95PAaIQQJefcy/xMzq+6aN5gG3IaHXphK2/Oh+uSqjKYVqJ33JJoO
	 7wRumaNtvLZZ4vrpFyy30DmRl24GYh/ELLM7TA9g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CDC22CAF;
        Fri,  7 Aug 2020 06:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781275;
        bh=Fhu6cQTbKmBdAAVvI4mhNXkwC0uRFIVD/XvH3G4l5u0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jAShDOzajjZpL54sYHhpgdEJXHsHLoq5LlBpkHpcfXNBLYffXfvs8zGH6EKbjnPYL
         UGxh3C8dU0i5gMG12k6FTdMmfwDGincoqTGp9+MmneYeJDZI45MuP79+dmulPjdPk6
         jYaoz3uZ0OAU9h1WGmo3e5d1fmWnKQTn4Age7+pg=
Date:   Thu, 06 Aug 2020 23:21:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 074/163] mm: memcg/slab: simplify memcg cache
 creation
Message-ID: <20200807062114.A811_SKgY%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: simplify memcg cache creation

Because the number of non-root kmem_caches doesn't depend on the number of
memory cgroups anymore and is generally not very big, there is no more
need for a dedicated workqueue.

Also, as there is no more need to pass any arguments to the
memcg_create_kmem_cache() except the root kmem_cache, it's possible to
just embed the work structure into the kmem_cache and avoid the dynamic
allocation of the work structure.

This will also simplify the synchronization: for each root kmem_cache
there is only one work.  So there will be no more concurrent attempts to
create a non-root kmem_cache for a root kmem_cache: the second and all
following attempts to queue the work will fail.

On the kmem_cache destruction path there is no more need to call the
expensive flush_workqueue() and wait for all pending works to be finished.
Instead, cancel_work_sync() can be used to cancel/wait for only one work.

Link: http://lkml.kernel.org/r/20200623174037.3951353-14-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol.c            |   48 -----------------------------------
 mm/slab.h                  |    2 +
 mm/slab_common.c           |   22 ++++++++--------
 4 files changed, 15 insertions(+), 58 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/include/linux/memcontrol.h
@@ -1418,7 +1418,6 @@ int obj_cgroup_charge(struct obj_cgroup
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
 extern struct static_key_false memcg_kmem_enabled_key;
-extern struct workqueue_struct *memcg_kmem_cache_wq;
 
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
--- a/mm/memcontrol.c~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/memcontrol.c
@@ -399,8 +399,6 @@ void memcg_put_cache_ids(void)
  */
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
-
-struct workqueue_struct *memcg_kmem_cache_wq;
 #endif
 
 static int memcg_shrinker_map_size;
@@ -2902,39 +2900,6 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
-struct memcg_kmem_cache_create_work {
-	struct kmem_cache *cachep;
-	struct work_struct work;
-};
-
-static void memcg_kmem_cache_create_func(struct work_struct *w)
-{
-	struct memcg_kmem_cache_create_work *cw =
-		container_of(w, struct memcg_kmem_cache_create_work, work);
-	struct kmem_cache *cachep = cw->cachep;
-
-	memcg_create_kmem_cache(cachep);
-
-	kfree(cw);
-}
-
-/*
- * Enqueue the creation of a per-memcg kmem_cache.
- */
-static void memcg_schedule_kmem_cache_create(struct kmem_cache *cachep)
-{
-	struct memcg_kmem_cache_create_work *cw;
-
-	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
-	if (!cw)
-		return;
-
-	cw->cachep = cachep;
-	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
-
-	queue_work(memcg_kmem_cache_wq, &cw->work);
-}
-
 /**
  * memcg_kmem_get_cache: select memcg or root cache for allocation
  * @cachep: the original global kmem cache
@@ -2951,7 +2916,7 @@ struct kmem_cache *memcg_kmem_get_cache(
 
 	memcg_cachep = READ_ONCE(cachep->memcg_params.memcg_cache);
 	if (unlikely(!memcg_cachep)) {
-		memcg_schedule_kmem_cache_create(cachep);
+		queue_work(system_wq, &cachep->memcg_params.work);
 		return cachep;
 	}
 
@@ -7022,17 +6987,6 @@ static int __init mem_cgroup_init(void)
 {
 	int cpu, node;
 
-#ifdef CONFIG_MEMCG_KMEM
-	/*
-	 * Kmem cache creation is mostly done with the slab_mutex held,
-	 * so use a workqueue with limited concurrency to avoid stalling
-	 * all worker threads in case lots of cgroups are created and
-	 * destroyed simultaneously.
-	 */
-	memcg_kmem_cache_wq = alloc_workqueue("memcg_kmem_cache", 0, 1);
-	BUG_ON(!memcg_kmem_cache_wq);
-#endif
-
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
--- a/mm/slab_common.c~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/slab_common.c
@@ -134,10 +134,18 @@ int __kmem_cache_alloc_bulk(struct kmem_
 
 LIST_HEAD(slab_root_caches);
 
+static void memcg_kmem_cache_create_func(struct work_struct *work)
+{
+	struct kmem_cache *cachep = container_of(work, struct kmem_cache,
+						 memcg_params.work);
+	memcg_create_kmem_cache(cachep);
+}
+
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.root_cache = NULL;
 	s->memcg_params.memcg_cache = NULL;
+	INIT_WORK(&s->memcg_params.work, memcg_kmem_cache_create_func);
 }
 
 static void init_memcg_params(struct kmem_cache *s,
@@ -586,15 +594,9 @@ static int shutdown_memcg_caches(struct
 	return 0;
 }
 
-static void flush_memcg_workqueue(struct kmem_cache *s)
+static void cancel_memcg_cache_creation(struct kmem_cache *s)
 {
-	/*
-	 * SLAB and SLUB create memcg kmem_caches through workqueue and SLUB
-	 * deactivates the memcg kmem_caches through workqueue. Make sure all
-	 * previous workitems on workqueue are processed.
-	 */
-	if (likely(memcg_kmem_cache_wq))
-		flush_workqueue(memcg_kmem_cache_wq);
+	cancel_work_sync(&s->memcg_params.work);
 }
 #else
 static inline int shutdown_memcg_caches(struct kmem_cache *s)
@@ -602,7 +604,7 @@ static inline int shutdown_memcg_caches(
 	return 0;
 }
 
-static inline void flush_memcg_workqueue(struct kmem_cache *s)
+static inline void cancel_memcg_cache_creation(struct kmem_cache *s)
 {
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -621,7 +623,7 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
-	flush_memcg_workqueue(s);
+	cancel_memcg_cache_creation(s);
 
 	get_online_cpus();
 	get_online_mems();
--- a/mm/slab.h~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/slab.h
@@ -45,12 +45,14 @@ struct kmem_cache {
  * @memcg_cache: pointer to memcg kmem cache, used by all non-root memory
  *		cgroups.
  * @root_caches_node: list node for slab_root_caches list.
+ * @work: work struct used to create the non-root cache.
  */
 struct memcg_cache_params {
 	struct kmem_cache *root_cache;
 
 	struct kmem_cache *memcg_cache;
 	struct list_head __root_caches_node;
+	struct work_struct work;
 };
 #endif /* CONFIG_SLOB */
 
_
