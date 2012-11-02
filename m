From: akpm@linux-foundation.org
Subject: + slab-annotate-on-slab-caches-nodelist-locks.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:11 -0700
Message-ID: <20121102000412.C6D2520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:41085 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992605Ab2KBAES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:18 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so196262lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: slab: annotate on-slab caches nodelist locks
has been added to the -mm tree.  Its filename is
     slab-annotate-on-slab-caches-nodelist-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slab: annotate on-slab caches nodelist locks

We currently provide lockdep annotation for kmalloc caches, and also
caches that have SLAB_DEBUG_OBJECTS enabled.  The reason for this is that
we can quite frequently nest in the l3->list_lock lock, which is not
something trivial to avoid.

My proposal with this patch, is to extend this to caches whose slab
management object lives within the slab as well ("on_slab").  The need for
this arose in the context of testing kmemcg-slab patches.  With such
patchset, we can have per-memcg kmalloc caches.  So the same path that led
to nesting between kmalloc caches will could then lead to in-memcg
nesting.  Because they are not annotated, lockdep will trigger.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-annotate-on-slab-caches-nodelist-locks mm/slab.c
--- a/mm/slab.c~slab-annotate-on-slab-caches-nodelist-locks
+++ a/mm/slab.c
@@ -645,6 +645,26 @@ static void init_node_lock_keys(int q)
 	}
 }
 
+static void on_slab_lock_classes_node(struct kmem_cache *cachep, int q)
+{
+	struct kmem_list3 *l3;
+	l3 = cachep->nodelists[q];
+	if (!l3)
+		return;
+
+	slab_set_lock_classes(cachep, &on_slab_l3_key,
+			&on_slab_alc_key, q);
+}
+
+static inline void on_slab_lock_classes(struct kmem_cache *cachep)
+{
+	int node;
+
+	VM_BUG_ON(OFF_SLAB(cachep));
+	for_each_node(node)
+		on_slab_lock_classes_node(cachep, node);
+}
+
 static inline void init_lock_keys(void)
 {
 	int node;
@@ -661,6 +681,14 @@ static inline void init_lock_keys(void)
 {
 }
 
+static inline void on_slab_lock_classes(struct kmem_cache *cachep)
+{
+}
+
+static inline void on_slab_lock_classes_node(struct kmem_cache *cachep, int node)
+{
+}
+
 static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
 {
 }
@@ -1389,6 +1417,9 @@ static int __cpuinit cpuup_prepare(long 
 		free_alien_cache(alien);
 		if (cachep->flags & SLAB_DEBUG_OBJECTS)
 			slab_set_debugobj_lock_classes_node(cachep, node);
+		else if (!OFF_SLAB(cachep) &&
+			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
+			on_slab_lock_classes_node(cachep, node);
 	}
 	init_node_lock_keys(node);
 
@@ -2544,7 +2575,8 @@ __kmem_cache_create (struct kmem_cache *
 		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
 
 		slab_set_debugobj_lock_classes(cachep);
-	}
+	} else if (!OFF_SLAB(cachep) && !(flags & SLAB_DESTROY_BY_RCU))
+		on_slab_lock_classes(cachep);
 
 	return 0;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

