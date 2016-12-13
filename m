From: akpm@linux-foundation.org
Subject: [patch 018/123] mm: memcontrol: use special workqueue for
 creating per-memcg caches
Date: Mon, 12 Dec 2016 16:41:29 -0800
Message-ID: <584f43b9.M/dH4V1kQnoCm7ns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAla (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov.dev@gmail.com, cl@linux.com, dsmythies@telus.net, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com

From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: mm: memcontrol: use special workqueue for creating per-memcg caches

Creating a lot of cgroups at the same time might stall all worker threads
with kmem cache creation works, because kmem cache creation is done with
the slab_mutex held.  The problem was amplified by commits 801faf0db894
("mm/slab: lockless decision to grow cache") in case of SLAB and
81ae6d03952c ("mm/slub.c: replace kick_all_cpus_sync() with
synchronize_sched() in kmem_cache_shrink()") in case of SLUB, which
increased the maximal time the slab_mutex can be held.

To prevent that from happening, let's use a special ordered single
threaded workqueue for kmem cache creation.  This shouldn't introduce any
functional changes regarding how kmem caches are created, as the work
function holds the global slab_mutex during its whole runtime anyway,
making it impossible to run more than one work at a time.  By using a
single threaded workqueue, we just avoid creating a thread per each work. 
Ordering is required to avoid a situation when a cgroup's work is put off
indefinitely because there are other cgroups to serve, in other words to
guarantee fairness.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=172981
Link: http://lkml.kernel.org/r/20161004131417.GC1862@esperanza
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Reported-by: Doug Smythies <dsmythies@telus.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches
+++ a/mm/memcontrol.c
@@ -2154,6 +2154,8 @@ struct memcg_kmem_cache_create_work {
 	struct work_struct work;
 };
 
+static struct workqueue_struct *memcg_kmem_cache_create_wq;
+
 static void memcg_kmem_cache_create_func(struct work_struct *w)
 {
 	struct memcg_kmem_cache_create_work *cw =
@@ -2185,7 +2187,7 @@ static void __memcg_schedule_kmem_cache_
 	cw->cachep = cachep;
 	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
 
-	schedule_work(&cw->work);
+	queue_work(memcg_kmem_cache_create_wq, &cw->work);
 }
 
 static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
@@ -5783,6 +5785,17 @@ static int __init mem_cgroup_init(void)
 {
 	int cpu, node;
 
+#ifndef CONFIG_SLOB
+	/*
+	 * Kmem cache creation is mostly done with the slab_mutex held,
+	 * so use a special workqueue to avoid stalling all worker
+	 * threads in case lots of cgroups are created simultaneously.
+	 */
+	memcg_kmem_cache_create_wq =
+		alloc_ordered_workqueue("memcg_kmem_cache_create", 0);
+	BUG_ON(!memcg_kmem_cache_create_wq);
+#endif
+
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 
 	for_each_possible_cpu(cpu)
_
