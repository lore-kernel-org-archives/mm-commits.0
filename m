From: akpm@linux-foundation.org
Subject: [merged] slab-annotate-on-slab-caches-nodelist-locks.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:10 -0800
Message-ID: <20121219204111.36386100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:37573 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2LSUlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:13 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so309693qad.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: annotate on-slab caches nodelist locks
has been removed from the -mm tree.  Its filename was
     slab-annotate-on-slab-caches-nodelist-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -641,6 +641,26 @@ static void init_node_lock_keys(int q)
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
@@ -657,6 +677,14 @@ static inline void init_lock_keys(void)
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
@@ -1385,6 +1413,9 @@ static int __cpuinit cpuup_prepare(long 
 		free_alien_cache(alien);
 		if (cachep->flags & SLAB_DEBUG_OBJECTS)
 			slab_set_debugobj_lock_classes_node(cachep, node);
+		else if (!OFF_SLAB(cachep) &&
+			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
+			on_slab_lock_classes_node(cachep, node);
 	}
 	init_node_lock_keys(node);
 
@@ -2489,7 +2520,8 @@ __kmem_cache_create (struct kmem_cache *
 		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
 
 		slab_set_debugobj_lock_classes(cachep);
-	}
+	} else if (!OFF_SLAB(cachep) && !(flags & SLAB_DESTROY_BY_RCU))
+		on_slab_lock_classes(cachep);
 
 	return 0;
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

