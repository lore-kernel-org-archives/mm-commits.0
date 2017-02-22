From: akpm@linux-foundation.org
Subject: [patch 035/142] slab: remove synchronous synchronize_sched() from memcg cache deactivation path
Date: Wed, 22 Feb 2017 15:41:30 -0800
Message-ID: <58ae21aa.Qyv/3RzLtTu0R/Tn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933833AbdBVXmI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, jsvana@fb.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com

From: Tejun Heo <tj@kernel.org>
Subject: slab: remove synchronous synchronize_sched() from memcg cache deactivation path

With kmem cgroup support enabled, kmem_caches can be created and destroyed
frequently and a great number of near empty kmem_caches can accumulate if
there are a lot of transient cgroups and the system is not under memory
pressure.  When memory reclaim starts under such conditions, it can lead
to consecutive deactivation and destruction of many kmem_caches, easily
hundreds of thousands on moderately large systems, exposing scalability
issues in the current slab management code.  This is one of the patches to
address the issue.

slub uses synchronize_sched() to deactivate a memcg cache. 
synchronize_sched() is an expensive and slow operation and doesn't scale
when a huge number of caches are destroyed back-to-back.  While there used
to be a simple batching mechanism, the batching was too restricted to be
helpful.

This patch implements slab_deactivate_memcg_cache_rcu_sched() which slub
can use to schedule sched RCU callback instead of performing
synchronize_sched() synchronously while holding cgroup_mutex.  While this
adds online cpus, mems and slab_mutex operations, operating on these locks
back-to-back from the same kworker, which is what's gonna happen when
there are many to deactivate, isn't expensive at all and this gets rid of
the scalability problem completely.

Link: http://lkml.kernel.org/r/20170117235411.9408-9-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    6 ++++
 mm/slab.h            |    2 +
 mm/slab_common.c     |   60 +++++++++++++++++++++++++++++++++++++++++
 mm/slub.c            |   12 +++++---
 4 files changed, 76 insertions(+), 4 deletions(-)

diff -puN include/linux/slab.h~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path
+++ a/include/linux/slab.h
@@ -582,6 +582,12 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head children_node;
 			struct list_head kmem_caches_node;
+
+			void (*deact_fn)(struct kmem_cache *);
+			union {
+				struct rcu_head deact_rcu_head;
+				struct work_struct deact_work;
+			};
 		};
 	};
 };
diff -puN mm/slab.h~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path mm/slab.h
--- a/mm/slab.h~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path
+++ a/mm/slab.h
@@ -307,6 +307,8 @@ static __always_inline void memcg_unchar
 
 extern void slab_init_memcg_params(struct kmem_cache *);
 extern void memcg_link_cache(struct kmem_cache *s);
+extern void slab_deactivate_memcg_cache_rcu_sched(struct kmem_cache *s,
+				void (*deact_fn)(struct kmem_cache *));
 
 #else /* CONFIG_MEMCG && !CONFIG_SLOB */
 
diff -puN mm/slab_common.c~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path mm/slab_common.c
--- a/mm/slab_common.c~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path
+++ a/mm/slab_common.c
@@ -627,6 +627,66 @@ out_unlock:
 	put_online_cpus();
 }
 
+static void kmemcg_deactivate_workfn(struct work_struct *work)
+{
+	struct kmem_cache *s = container_of(work, struct kmem_cache,
+					    memcg_params.deact_work);
+
+	get_online_cpus();
+	get_online_mems();
+
+	mutex_lock(&slab_mutex);
+
+	s->memcg_params.deact_fn(s);
+
+	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
+	put_online_cpus();
+
+	/* done, put the ref from slab_deactivate_memcg_cache_rcu_sched() */
+	css_put(&s->memcg_params.memcg->css);
+}
+
+static void kmemcg_deactivate_rcufn(struct rcu_head *head)
+{
+	struct kmem_cache *s = container_of(head, struct kmem_cache,
+					    memcg_params.deact_rcu_head);
+
+	/*
+	 * We need to grab blocking locks.  Bounce to ->deact_work.  The
+	 * work item shares the space with the RCU head and can't be
+	 * initialized eariler.
+	 */
+	INIT_WORK(&s->memcg_params.deact_work, kmemcg_deactivate_workfn);
+	schedule_work(&s->memcg_params.deact_work);
+}
+
+/**
+ * slab_deactivate_memcg_cache_rcu_sched - schedule deactivation after a
+ *					   sched RCU grace period
+ * @s: target kmem_cache
+ * @deact_fn: deactivation function to call
+ *
+ * Schedule @deact_fn to be invoked with online cpus, mems and slab_mutex
+ * held after a sched RCU grace period.  The slab is guaranteed to stay
+ * alive until @deact_fn is finished.  This is to be used from
+ * __kmemcg_cache_deactivate().
+ */
+void slab_deactivate_memcg_cache_rcu_sched(struct kmem_cache *s,
+					   void (*deact_fn)(struct kmem_cache *))
+{
+	if (WARN_ON_ONCE(is_root_cache(s)) ||
+	    WARN_ON_ONCE(s->memcg_params.deact_fn))
+		return;
+
+	/* pin memcg so that @s doesn't get destroyed in the middle */
+	css_get(&s->memcg_params.memcg->css);
+
+	s->memcg_params.deact_fn = deact_fn;
+	call_rcu_sched(&s->memcg_params.deact_rcu_head, kmemcg_deactivate_rcufn);
+}
+
 void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
 {
 	int idx;
diff -puN mm/slub.c~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path mm/slub.c
--- a/mm/slub.c~slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path
+++ a/mm/slub.c
@@ -3957,6 +3957,12 @@ int __kmem_cache_shrink(struct kmem_cach
 }
 
 #ifdef CONFIG_MEMCG
+static void kmemcg_cache_deact_after_rcu(struct kmem_cache *s)
+{
+	/* called with all the locks held after a sched RCU grace period */
+	__kmem_cache_shrink(s);
+}
+
 void __kmemcg_cache_deactivate(struct kmem_cache *s)
 {
 	/*
@@ -3968,11 +3974,9 @@ void __kmemcg_cache_deactivate(struct km
 
 	/*
 	 * s->cpu_partial is checked locklessly (see put_cpu_partial), so
-	 * we have to make sure the change is visible.
+	 * we have to make sure the change is visible before shrinking.
 	 */
-	synchronize_sched();
