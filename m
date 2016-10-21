From: akpm@linux-foundation.org
Subject: + slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
 added to -mm tree
Date: Thu, 20 Oct 2016 20:47:28 -0700
Message-ID: <58098fd0.4iWI8G0AH18JxXWt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbcJUDra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 23:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov.dev@gmail.com, cl@linux.com, dsmythies@telus.net, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: move synchronize_sched out of slab_mutex on shrink
has been added to the -mm tree.  Its filename is
     slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch

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
Subject: slub: move synchronize_sched out of slab_mutex on shrink

synchronize_sched() is a heavy operation and calling it per each cache
owned by a memory cgroup being destroyed may take quite some time. What
is worse, it's currently called under the slab_mutex, stalling all works
doing cache creation/destruction.

Actually, there isn't much point in calling synchronize_sched() for each
cache - it's enough to call it just once - after setting cpu_partial for
all caches and before shrinking them. This way, we can also move it out
of the slab_mutex, which we have to hold for iterating over the slab
cache list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=172991
Link: http://lkml.kernel.org/r/0a10d71ecae3db00fb4421bcd3f82bcc911f4be4.1475329751.git.vdavydov.dev@gmail.com
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Reported-by: Doug Smythies <dsmythies@telus.net>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    4 ++--
 mm/slab.h        |    2 +-
 mm/slab_common.c |   27 +++++++++++++++++++++++++--
 mm/slob.c        |    2 +-
 mm/slub.c        |   19 ++-----------------
 5 files changed, 31 insertions(+), 23 deletions(-)

diff -puN mm/slab.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab.c
--- a/mm/slab.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab.c
@@ -2332,7 +2332,7 @@ out:
 	return nr_freed;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *cachep, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *cachep)
 {
 	int ret = 0;
 	int node;
@@ -2352,7 +2352,7 @@ int __kmem_cache_shrink(struct kmem_cach
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	return __kmem_cache_shrink(cachep, false);
+	return __kmem_cache_shrink(cachep);
 }
 
 void __kmem_cache_release(struct kmem_cache *cachep)
diff -puN mm/slab.h~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab.h
--- a/mm/slab.h~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab.h
@@ -146,7 +146,7 @@ static inline unsigned long kmem_cache_f
 
 int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
-int __kmem_cache_shrink(struct kmem_cache *, bool);
+int __kmem_cache_shrink(struct kmem_cache *);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff -puN mm/slab_common.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slab_common.c
--- a/mm/slab_common.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slab_common.c
@@ -573,6 +573,29 @@ void memcg_deactivate_kmem_caches(struct
 	get_online_cpus();
 	get_online_mems();
 
+#ifdef CONFIG_SLUB
+	/*
+	 * In case of SLUB, we need to disable empty slab caching to
+	 * avoid pinning the offline memory cgroup by freeable kmem
+	 * pages charged to it. SLAB doesn't need this, as it
+	 * periodically purges unused slabs.
+	 */
+	mutex_lock(&slab_mutex);
+	list_for_each_entry(s, &slab_caches, list) {
+		c = is_root_cache(s) ? cache_from_memcg_idx(s, idx) : NULL;
+		if (c) {
+			c->cpu_partial = 0;
+			c->min_partial = 0;
+		}
+	}
+	mutex_unlock(&slab_mutex);
+	/*
+	 * kmem_cache->cpu_partial is checked locklessly (see
+	 * put_cpu_partial()). Make sure the change is visible.
+	 */
+	synchronize_sched();
+#endif
+
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		if (!is_root_cache(s))
@@ -584,7 +607,7 @@ void memcg_deactivate_kmem_caches(struct
 		if (!c)
 			continue;
 
-		__kmem_cache_shrink(c, true);
+		__kmem_cache_shrink(c);
 		arr->entries[idx] = NULL;
 	}
 	mutex_unlock(&slab_mutex);
@@ -755,7 +778,7 @@ int kmem_cache_shrink(struct kmem_cache
 	get_online_cpus();
 	get_online_mems();
 	kasan_cache_shrink(cachep);
-	ret = __kmem_cache_shrink(cachep, false);
+	ret = __kmem_cache_shrink(cachep);
 	put_online_mems();
 	put_online_cpus();
 	return ret;
diff -puN mm/slob.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slob.c
--- a/mm/slob.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slob.c
@@ -634,7 +634,7 @@ void __kmem_cache_release(struct kmem_ca
 {
 }
 
-int __kmem_cache_shrink(struct kmem_cache *d, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
 }
diff -puN mm/slub.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink mm/slub.c
--- a/mm/slub.c~slub-move-synchronize_sched-out-of-slab_mutex-on-shrink
+++ a/mm/slub.c
@@ -3883,7 +3883,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s, bool deactivate)
+int __kmem_cache_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -3895,21 +3895,6 @@ int __kmem_cache_shrink(struct kmem_cach
 	unsigned long flags;
 	int ret = 0;
 
-	if (deactivate) {
-		/*
-		 * Disable empty slabs caching. Used to avoid pinning offline
-		 * memory cgroups by kmem pages that can be freed.
-		 */
-		s->cpu_partial = 0;
-		s->min_partial = 0;
-
-		/*
-		 * s->cpu_partial is checked locklessly (see put_cpu_partial),
-		 * so we have to make sure the change is visible.
-		 */
-		synchronize_sched();
-	}
