From: akpm@linux-foundation.org
Subject: [patch 037/142] slab: use memcg_kmem_cache_wq for slab
 destruction operations
Date: Wed, 22 Feb 2017 15:41:36 -0800
Message-ID: <58ae21b0.vl8EosASVB5m6/VT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934506AbdBVXmE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, jsvana@fb.com, penberg@kernel.org, rientjes@google.com, vdavydov@tarantool.org

From: Tejun Heo <tj@kernel.org>
Subject: slab: use memcg_kmem_cache_wq for slab destruction operations

If there's contention on slab_mutex, queueing the per-cache destruction
work item on the system_wq can unnecessarily create and tie up a lot of
kworkers.

Rename memcg_kmem_cache_create_wq to memcg_kmem_cache_wq and make it
global and use that workqueue for the destruction work items too.  While
at it, convert the workqueue from an unbound workqueue to a per-cpu one
with concurrency limited to 1.  It's generally preferable to use per-cpu
workqueues and concurrency limit of 1 is safe enough.

This is suggested by Joonsoo Kim.

Link: http://lkml.kernel.org/r/20170117235411.9408-11-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Acked-by: Vladimir Davydov <vdavydov@tarantool.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   16 ++++++++--------
 mm/slab_common.c           |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations
+++ a/include/linux/memcontrol.h
@@ -830,6 +830,7 @@ void memcg_kmem_uncharge(struct page *pa
 
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 extern struct static_key_false memcg_kmem_enabled_key;
+extern struct workqueue_struct *memcg_kmem_cache_wq;
 
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
diff -puN mm/memcontrol.c~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations mm/memcontrol.c
--- a/mm/memcontrol.c~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations
+++ a/mm/memcontrol.c
@@ -317,6 +317,8 @@ void memcg_put_cache_ids(void)
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
+struct workqueue_struct *memcg_kmem_cache_wq;
+
 #endif /* !CONFIG_SLOB */
 
 /**
@@ -2143,8 +2145,6 @@ struct memcg_kmem_cache_create_work {
 	struct work_struct work;
 };
 
-static struct workqueue_struct *memcg_kmem_cache_create_wq;
-
 static void memcg_kmem_cache_create_func(struct work_struct *w)
 {
 	struct memcg_kmem_cache_create_work *cw =
@@ -2176,7 +2176,7 @@ static void __memcg_schedule_kmem_cache_
 	cw->cachep = cachep;
 	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
 
-	queue_work(memcg_kmem_cache_create_wq, &cw->work);
+	queue_work(memcg_kmem_cache_wq, &cw->work);
 }
 
 static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
@@ -5778,12 +5778,12 @@ static int __init mem_cgroup_init(void)
 #ifndef CONFIG_SLOB
 	/*
 	 * Kmem cache creation is mostly done with the slab_mutex held,
-	 * so use a special workqueue to avoid stalling all worker
-	 * threads in case lots of cgroups are created simultaneously.
+	 * so use a workqueue with limited concurrency to avoid stalling
+	 * all worker threads in case lots of cgroups are created and
+	 * destroyed simultaneously.
 	 */
-	memcg_kmem_cache_create_wq =
-		alloc_ordered_workqueue("memcg_kmem_cache_create", 0);
-	BUG_ON(!memcg_kmem_cache_create_wq);
+	memcg_kmem_cache_wq = alloc_workqueue("memcg_kmem_cache", 0, 1);
+	BUG_ON(!memcg_kmem_cache_wq);
 #endif
 
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
diff -puN mm/slab_common.c~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations mm/slab_common.c
--- a/mm/slab_common.c~slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations
+++ a/mm/slab_common.c
@@ -659,7 +659,7 @@ static void kmemcg_deactivate_rcufn(stru
 	 * initialized eariler.
 	 */
 	INIT_WORK(&s->memcg_params.deact_work, kmemcg_deactivate_workfn);
-	schedule_work(&s->memcg_params.deact_work);
+	queue_work(memcg_kmem_cache_wq, &s->memcg_params.deact_work);
 }
 
 /**
_
