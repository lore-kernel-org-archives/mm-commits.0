From: akpm@linux-foundation.org
Subject: + mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 13:16:16 -0700
Message-ID: <579fae10.lu3UtoMMi2EVPUBJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbcHAU3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, xiaolong.ye@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: get rid of ->state in struct kasan_alloc_meta
has been added to the -mm tree.  Its filename is
     mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: get rid of ->state in struct kasan_alloc_meta

The state of object currently tracked in two places - shadow memory,
and the ->state field in struct kasan_alloc_meta.
We can get rid of the latter. The will save us a little bit of memory.
Also, this allow us to move free stack into struct kasan_alloc_meta,
without increasing memory consumption. So now we should always know
when the last time the object was freed. This may be useful for
long delayed use-after-free bugs.

As a side effect this fixes following UBSAN warning:
	UBSAN: Undefined behaviour in mm/kasan/quarantine.c:102:13
	member access within misaligned address ffff88000d1efebc for type 'struct qlist_node'
	which requires 8 byte alignment

Link: http://lkml.kernel.org/r/1470062715-14077-5-git-send-email-aryabinin@virtuozzo.com
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    3 +
 mm/kasan/kasan.c      |   63 ++++++++++++++++++----------------------
 mm/kasan/kasan.h      |   12 +------
 mm/kasan/quarantine.c |    2 -
 mm/kasan/report.c     |   23 +++-----------
 mm/slab.c             |    4 +-
 mm/slub.c             |    1 
 7 files changed, 43 insertions(+), 65 deletions(-)

diff -puN include/linux/kasan.h~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta include/linux/kasan.h
--- a/include/linux/kasan.h~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/include/linux/kasan.h
@@ -56,6 +56,7 @@ void kasan_cache_destroy(struct kmem_cac
 void kasan_poison_slab(struct page *page);
 void kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
 void kasan_poison_object_data(struct kmem_cache *cache, void *object);
+void kasan_init_slab_obj(struct kmem_cache *cache, const void *object);
 
 void kasan_kmalloc_large(const void *ptr, size_t size, gfp_t flags);
 void kasan_kfree_large(const void *ptr);
@@ -102,6 +103,8 @@ static inline void kasan_unpoison_object
 					void *object) {}
 static inline void kasan_poison_object_data(struct kmem_cache *cache,
 					void *object) {}
+static inline void kasan_init_slab_obj(struct kmem_cache *cache,
+				const void *object) {}
 
 static inline void kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags) {}
 static inline void kasan_kfree_large(const void *ptr) {}
diff -puN mm/kasan/kasan.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/kasan/kasan.c
@@ -442,11 +442,6 @@ void kasan_poison_object_data(struct kme
 	kasan_poison_shadow(object,
 			round_up(cache->object_size, KASAN_SHADOW_SCALE_SIZE),
 			KASAN_KMALLOC_REDZONE);
-	if (cache->flags & SLAB_KASAN) {
-		struct kasan_alloc_meta *alloc_info =
-			get_alloc_info(cache, object);
-		alloc_info->state = KASAN_STATE_INIT;
-	}
 }
 
 static inline int in_irqentry_text(unsigned long ptr)
@@ -510,6 +505,17 @@ struct kasan_free_meta *get_free_info(st
 	return (void *)object + cache->kasan_info.free_meta_offset;
 }
 
+void kasan_init_slab_obj(struct kmem_cache *cache, const void *object)
+{
+	struct kasan_alloc_meta *alloc_info;
+
+	if (!(cache->flags & SLAB_KASAN))
+		return;
+
+	alloc_info = get_alloc_info(cache, object);
+	__memset(alloc_info, 0, sizeof(*alloc_info));
+}
+
 void kasan_slab_alloc(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	kasan_kmalloc(cache, object, cache->object_size, flags);
@@ -529,34 +535,27 @@ static void kasan_poison_slab_free(struc
 
 bool kasan_slab_free(struct kmem_cache *cache, void *object)
 {
+	s8 shadow_byte;
+
 	/* RCU slabs could be legally used after free within the RCU period */
 	if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
 		return false;
 
-	if (likely(cache->flags & SLAB_KASAN)) {
-		struct kasan_alloc_meta *alloc_info;
-		struct kasan_free_meta *free_info;
-
-		alloc_info = get_alloc_info(cache, object);
-		free_info = get_free_info(cache, object);
-
-		switch (alloc_info->state) {
-		case KASAN_STATE_ALLOC:
-			alloc_info->state = KASAN_STATE_QUARANTINE;
-			set_track(&free_info->track, GFP_NOWAIT);
-			kasan_poison_slab_free(cache, object);
-			quarantine_put(free_info, cache);
-			return true;
-		case KASAN_STATE_QUARANTINE:
-		case KASAN_STATE_FREE:
-			pr_err("Double free");
-			dump_stack();
-			break;
-		default:
-			break;
-		}
+	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(object));
+	if (shadow_byte < 0 || shadow_byte >= KASAN_SHADOW_SCALE_SIZE) {
+		pr_err("Double free");
+		dump_stack();
+		return true;
 	}
-	return false;
+
+	kasan_poison_slab_free(cache, object);
+
+	if (unlikely(!(cache->flags & SLAB_KASAN)))
+		return false;
+
+	set_track(&get_alloc_info(cache, object)->free_track, GFP_NOWAIT);
+	quarantine_put(get_free_info(cache, object), cache);
+	return true;
 }
 
 void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size,
@@ -579,13 +578,9 @@ void kasan_kmalloc(struct kmem_cache *ca
 	kasan_unpoison_shadow(object, size);
 	kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
 		KASAN_KMALLOC_REDZONE);
-	if (cache->flags & SLAB_KASAN) {
-		struct kasan_alloc_meta *alloc_info =
-			get_alloc_info(cache, object);
 
-		alloc_info->state = KASAN_STATE_ALLOC;
-		set_track(&alloc_info->track, flags);
-	}
+	if (cache->flags & SLAB_KASAN)
+		set_track(&get_alloc_info(cache, object)->alloc_track, flags);
 }
 EXPORT_SYMBOL(kasan_kmalloc);
 
diff -puN mm/kasan/kasan.h~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/kasan/kasan.h
@@ -59,13 +59,6 @@ struct kasan_global {
  * Structures to keep alloc and free tracks *
  */
 
-enum kasan_state {
-	KASAN_STATE_INIT,
-	KASAN_STATE_ALLOC,
-	KASAN_STATE_QUARANTINE,
-	KASAN_STATE_FREE
-};
-
 #define KASAN_STACK_DEPTH 64
 
 struct kasan_track {
@@ -74,8 +67,8 @@ struct kasan_track {
 };
 
 struct kasan_alloc_meta {
-	struct kasan_track track;
-	u32 state;
+	struct kasan_track alloc_track;
+	struct kasan_track free_track;
 };
 
 struct qlist_node {
@@ -86,7 +79,6 @@ struct kasan_free_meta {
 	 * Otherwise it might be used for the allocator freelist.
 	 */
 	struct qlist_node quarantine_link;
-	struct kasan_track track;
 };
 
 struct kasan_alloc_meta *get_alloc_info(struct kmem_cache *cache,
diff -puN mm/kasan/quarantine.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/kasan/quarantine.c
@@ -144,13 +144,11 @@ static void *qlink_to_object(struct qlis
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
-	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
 	unsigned long flags;
 
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
-	alloc_info->state = KASAN_STATE_FREE;
 	___cache_free(cache, object, _THIS_IP_);
 
 	if (IS_ENABLED(CONFIG_SLAB))
diff -puN mm/kasan/report.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/kasan/report.c
@@ -133,7 +133,6 @@ static void kasan_object_err(struct kmem
 				void *object, char *unused_reason)
 {
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
-	struct kasan_free_meta *free_info;
 
 	dump_stack();
 	pr_err("Object at %p, in cache %s size: %d\n", object, cache->name,
@@ -141,23 +140,11 @@ static void kasan_object_err(struct kmem
 
 	if (!(cache->flags & SLAB_KASAN))
 		return;
-	switch (alloc_info->state) {
-	case KASAN_STATE_INIT:
-		pr_err("Object not allocated yet\n");
-		break;
-	case KASAN_STATE_ALLOC:
-		pr_err("Allocation:\n");
-		print_track(&alloc_info->track);
-		break;
-	case KASAN_STATE_FREE:
-	case KASAN_STATE_QUARANTINE:
-		free_info = get_free_info(cache, object);
-		pr_err("Allocation:\n");
-		print_track(&alloc_info->track);
-		pr_err("Deallocation:\n");
-		print_track(&free_info->track);
-		break;
-	}
+
+	pr_err("Allocated:\n");
+	print_track(&alloc_info->alloc_track);
+	pr_err("Freed:\n");
+	print_track(&alloc_info->free_track);
 }
 
 static void print_address_description(struct kasan_access_info *info)
diff -puN mm/slab.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/slab.c
--- a/mm/slab.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/slab.c
@@ -2604,9 +2604,11 @@ static void cache_init_objs(struct kmem_
 	}
 
 	for (i = 0; i < cachep->num; i++) {
+		objp = index_to_obj(cachep, page, i);
+		kasan_init_slab_obj(cachep, objp);
+
 		/* constructor could break poison info */
 		if (DEBUG == 0 && cachep->ctor) {
-			objp = index_to_obj(cachep, page, i);
 			kasan_unpoison_object_data(cachep, objp);
 			cachep->ctor(objp);
 			kasan_poison_object_data(cachep, objp);
diff -puN mm/slub.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta mm/slub.c
--- a/mm/slub.c~mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta
+++ a/mm/slub.c
@@ -1384,6 +1384,7 @@ static void setup_object(struct kmem_cac
 				void *object)
 {
 	setup_object_debug(s, page, object);
+	kasan_init_slab_obj(s, object);
 	if (unlikely(s->ctor)) {
 		kasan_unpoison_object_data(s, object);
 		s->ctor(object);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch

