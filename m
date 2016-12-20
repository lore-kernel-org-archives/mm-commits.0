From: akpm@linux-foundation.org
Subject: + kasan-drain-quarantine-of-memcg-slab-objects.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:06:21 -0800
Message-ID: <5859ab5d.aryIIMQNTEPD+8F0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbcLTWFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:05:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: drain quarantine of memcg slab objects
has been added to the -mm tree.  Its filename is
     kasan-drain-quarantine-of-memcg-slab-objects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-drain-quarantine-of-memcg-slab-objects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-drain-quarantine-of-memcg-slab-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: kasan: drain quarantine of memcg slab objects

Per memcg slab accounting and kasan have a problem with kmem_cache
destruction.
- kmem_cache_create() allocates a kmem_cache, which is used for
  allocations from processes running in root (top) memcg.
- Processes running in non root memcg and allocating with either
  __GFP_ACCOUNT or from a SLAB_ACCOUNT cache use a per memcg kmem_cache.
- Kasan catches use-after-free by having kfree() and kmem_cache_free()
  defer freeing of objects.  Objects are placed in a quarantine.
- kmem_cache_destroy() destroys root and non root kmem_caches.  It takes
  care to drain the quarantine of objects from the root memcg's
  kmem_cache, but ignores objects associated with non root memcg.  This
  causes leaks because quarantined per memcg objects refer to per memcg
  kmem cache being destroyed.

To see the problem:
1) create a slab cache with kmem_cache_create(,,,SLAB_ACCOUNT,)
2) from non root memcg, allocate and free a few objects from cache
3) dispose of the cache with kmem_cache_destroy()
kmem_cache_destroy() will trigger a "Slab cache still has objects"
warning indicating that the per memcg kmem_cache structure was leaked.

Fix the leak by draining kasan quarantined objects allocated from non
root memcg.

Racing memcg deletion is tricky, but handled.  kmem_cache_destroy() =>
shutdown_memcg_caches() => __shutdown_memcg_cache() => shutdown_cache()
flushes per memcg quarantined objects, even if that memcg has been
rmdir'd and gone through memcg_deactivate_kmem_caches().

This leak only affects destroyed SLAB_ACCOUNT kmem caches when kasan is
enabled.  So I don't think it's worth patching stable kernels.

Link: http://lkml.kernel.org/r/1482257462-36948-1-git-send-email-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    4 ++--
 mm/kasan/kasan.c      |    2 +-
 mm/kasan/quarantine.c |    1 +
 mm/slab_common.c      |    4 +++-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/kasan.h~kasan-drain-quarantine-of-memcg-slab-objects include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-drain-quarantine-of-memcg-slab-objects
+++ a/include/linux/kasan.h
@@ -52,7 +52,7 @@ void kasan_free_pages(struct page *page,
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
 			unsigned long *flags);
 void kasan_cache_shrink(struct kmem_cache *cache);
-void kasan_cache_destroy(struct kmem_cache *cache);
+void kasan_cache_shutdown(struct kmem_cache *cache);
 
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
@@ -98,7 +98,7 @@ static inline void kasan_cache_create(st
 				      size_t *size,
 				      unsigned long *flags) {}
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
-static inline void kasan_cache_destroy(struct kmem_cache *cache) {}
+static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 
 static inline void kasan_poison_slab(struct page *page) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
diff -puN mm/kasan/kasan.c~kasan-drain-quarantine-of-memcg-slab-objects mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-drain-quarantine-of-memcg-slab-objects
+++ a/mm/kasan/kasan.c
@@ -435,7 +435,7 @@ void kasan_cache_shrink(struct kmem_cach
 	quarantine_remove_cache(cache);
 }
 
-void kasan_cache_destroy(struct kmem_cache *cache)
+void kasan_cache_shutdown(struct kmem_cache *cache)
 {
 	quarantine_remove_cache(cache);
 }
diff -puN mm/kasan/quarantine.c~kasan-drain-quarantine-of-memcg-slab-objects mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-drain-quarantine-of-memcg-slab-objects
+++ a/mm/kasan/quarantine.c
@@ -274,6 +274,7 @@ static void per_cpu_remove_cache(void *a
 	qlist_free_all(&to_free, cache);
 }
 
+/* Free all quarantined objects belonging to cache. */
 void quarantine_remove_cache(struct kmem_cache *cache)
 {
 	unsigned long flags, i;
diff -puN mm/slab_common.c~kasan-drain-quarantine-of-memcg-slab-objects mm/slab_common.c
--- a/mm/slab_common.c~kasan-drain-quarantine-of-memcg-slab-objects
+++ a/mm/slab_common.c
@@ -461,6 +461,9 @@ EXPORT_SYMBOL(kmem_cache_create);
 static int shutdown_cache(struct kmem_cache *s,
 		struct list_head *release, bool *need_rcu_barrier)
 {
+	/* free asan quarantined objects */
+	kasan_cache_shutdown(s);
+
 	if (__kmem_cache_shutdown(s) != 0)
 		return -EBUSY;
 
@@ -744,7 +747,6 @@ void kmem_cache_destroy(struct kmem_cach
 	get_online_cpus();
 	get_online_mems();
 
-	kasan_cache_destroy(s);
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
_

Patches currently in -mm which might be from gthelen@google.com are

kasan-drain-quarantine-of-memcg-slab-objects.patch
kasan-add-memcg-kmem_cache-test.patch

