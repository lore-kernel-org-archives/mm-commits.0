From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches.patch
 added to -mm tree
Date: Thu, 20 Oct 2016 20:47:26 -0700
Message-ID: <58098fce.xbDOQxx0QFeMnbMh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbcJUDr2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 23:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov.dev@gmail.com, cl@linux.com, dsmythies@telus.net, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use special workqueue for creating per-memcg caches
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2145,6 +2145,8 @@ struct memcg_kmem_cache_create_work {
 	struct work_struct work;
 };
 
+static struct workqueue_struct *memcg_kmem_cache_create_wq;
+
 static void memcg_kmem_cache_create_func(struct work_struct *w)
 {
 	struct memcg_kmem_cache_create_work *cw =
@@ -2176,7 +2178,7 @@ static void __memcg_schedule_kmem_cache_
 	cw->cachep = cachep;
 	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
 
-	schedule_work(&cw->work);
+	queue_work(memcg_kmem_cache_create_wq, &cw->work);
 }
 
 static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
@@ -5774,6 +5776,17 @@ static int __init mem_cgroup_init(void)
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

Patches currently in -mm which might be from vdavydov.dev@gmail.com are

mm-memcontrol-use-special-workqueue-for-creating-per-memcg-caches.patch
slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch

