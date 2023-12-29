Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F413FE6
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJyXBQQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70C4C433CB;
	Fri, 29 Dec 2023 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880053;
	bh=xNiiV5O/18hzQekDVRXyrG1a+hRhXfwWQmkZoEgwXVk=;
	h=Date:To:From:Subject:From;
	b=CJyXBQQcJ5WPlGKqUUSb9FyoOADcWIkqC9ZymwgojJl5IUtbZ2fWp5AxUYcTyupqX
	 xqwTiGEyiBYV7xFm9KbWhB+hNDLr299d1jFc7+u2yH4vVXMqqrSxZwUb2RLPaHRTnr
	 7hINEQ9iZ8i1B1wAgMDdWjQ5S1d8UVppXrpMhdtg=
Date: Fri, 29 Dec 2023 12:00:53 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-rename-and-document-kasan_unpoison_object_data.patch removed from -mm tree
Message-Id: <20231229200053.B70C4C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: rename and document kasan_(un)poison_object_data
has been removed from the -mm tree.  Its filename was
     kasan-rename-and-document-kasan_unpoison_object_data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename and document kasan_(un)poison_object_data
Date: Tue, 19 Dec 2023 23:29:03 +0100

Rename kasan_unpoison_object_data to kasan_unpoison_new_object and add a
documentation comment.  Do the same for kasan_poison_object_data.

The new names and the comments should suggest the users that these hooks
are intended for internal use by the slab allocator.

The following patch will remove non-slab-internal uses of these hooks.

No functional changes.

[andreyknvl@google.com: update references to renamed functions in comments]
  Link: https://lkml.kernel.org/r/20231221180637.105098-1-andrey.konovalov@linux.dev
Link: https://lkml.kernel.org/r/eab156ebbd635f9635ef67d1a4271f716994e628.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   35 +++++++++++++++++++++++++++--------
 mm/kasan/common.c     |    4 ++--
 mm/kasan/shadow.c     |    4 ++--
 mm/slab.c             |   10 ++++------
 mm/slub.c             |    4 ++--
 net/core/skbuff.c     |    8 ++++----
 6 files changed, 41 insertions(+), 24 deletions(-)

--- a/include/linux/kasan.h~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/include/linux/kasan.h
@@ -129,20 +129,39 @@ static __always_inline void kasan_poison
 		__kasan_poison_slab(slab);
 }
 
-void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
-static __always_inline void kasan_unpoison_object_data(struct kmem_cache *cache,
+void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object);
+/**
+ * kasan_unpoison_new_object - Temporarily unpoison a new slab object.
+ * @cache: Cache the object belong to.
+ * @object: Pointer to the object.
+ *
+ * This function is intended for the slab allocator's internal use. It
+ * temporarily unpoisons an object from a newly allocated slab without doing
+ * anything else. The object must later be repoisoned by
+ * kasan_poison_new_object().
+ */
+static __always_inline void kasan_unpoison_new_object(struct kmem_cache *cache,
 							void *object)
 {
 	if (kasan_enabled())
-		__kasan_unpoison_object_data(cache, object);
+		__kasan_unpoison_new_object(cache, object);
 }
 
-void __kasan_poison_object_data(struct kmem_cache *cache, void *object);
-static __always_inline void kasan_poison_object_data(struct kmem_cache *cache,
+void __kasan_poison_new_object(struct kmem_cache *cache, void *object);
+/**
+ * kasan_unpoison_new_object - Repoison a new slab object.
+ * @cache: Cache the object belong to.
+ * @object: Pointer to the object.
+ *
+ * This function is intended for the slab allocator's internal use. It
+ * repoisons an object that was previously unpoisoned by
+ * kasan_unpoison_new_object() without doing anything else.
+ */
+static __always_inline void kasan_poison_new_object(struct kmem_cache *cache,
 							void *object)
 {
 	if (kasan_enabled())
-		__kasan_poison_object_data(cache, object);
+		__kasan_poison_new_object(cache, object);
 }
 
 void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
@@ -342,9 +361,9 @@ static inline bool kasan_unpoison_pages(
 	return false;
 }
 static inline void kasan_poison_slab(struct slab *slab) {}
-static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
+static inline void kasan_unpoison_new_object(struct kmem_cache *cache,
 					void *object) {}
-static inline void kasan_poison_object_data(struct kmem_cache *cache,
+static inline void kasan_poison_new_object(struct kmem_cache *cache,
 					void *object) {}
 static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
 				const void *object)
--- a/mm/kasan/common.c~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/mm/kasan/common.c
@@ -143,12 +143,12 @@ void __kasan_poison_slab(struct slab *sl
 		     KASAN_SLAB_REDZONE, false);
 }
 
-void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object)
+void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object)
 {
 	kasan_unpoison(object, cache->object_size, false);
 }
 
-void __kasan_poison_object_data(struct kmem_cache *cache, void *object)
+void __kasan_poison_new_object(struct kmem_cache *cache, void *object)
 {
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_REDZONE, false);
--- a/mm/kasan/shadow.c~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/mm/kasan/shadow.c
@@ -130,7 +130,7 @@ void kasan_poison(const void *addr, size
 
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
-	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
+	 * some of the callers (e.g. kasan_poison_new_object) pass tagged
 	 * addresses to this function.
 	 */
 	addr = kasan_reset_tag(addr);
@@ -170,7 +170,7 @@ void kasan_unpoison(const void *addr, si
 
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
-	 * some of the callers (e.g. kasan_unpoison_object_data) pass tagged
+	 * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
 	 * addresses to this function.
 	 */
 	addr = kasan_reset_tag(addr);
--- a/mm/slab.c~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/mm/slab.c
@@ -2327,11 +2327,9 @@ static void cache_init_objs_debug(struct
 		 * They must also be threaded.
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON)) {
-			kasan_unpoison_object_data(cachep,
-						   objp + obj_offset(cachep));
+			kasan_unpoison_new_object(cachep, objp + obj_offset(cachep));
 			cachep->ctor(objp + obj_offset(cachep));
-			kasan_poison_object_data(
-				cachep, objp + obj_offset(cachep));
+			kasan_poison_new_object(cachep, objp + obj_offset(cachep));
 		}
 
 		if (cachep->flags & SLAB_RED_ZONE) {
@@ -2472,9 +2470,9 @@ static void cache_init_objs(struct kmem_
 
 		/* constructor could break poison info */
 		if (DEBUG == 0 && cachep->ctor) {
-			kasan_unpoison_object_data(cachep, objp);
+			kasan_unpoison_new_object(cachep, objp);
 			cachep->ctor(objp);
-			kasan_poison_object_data(cachep, objp);
+			kasan_poison_new_object(cachep, objp);
 		}
 
 		if (!shuffled)
--- a/mm/slub.c~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/mm/slub.c
@@ -1860,9 +1860,9 @@ static void *setup_object(struct kmem_ca
 	setup_object_debug(s, object);
 	object = kasan_init_slab_obj(s, object);
 	if (unlikely(s->ctor)) {
-		kasan_unpoison_object_data(s, object);
+		kasan_unpoison_new_object(s, object);
 		s->ctor(object);
-		kasan_poison_object_data(s, object);
+		kasan_poison_new_object(s, object);
 	}
 	return object;
 }
--- a/net/core/skbuff.c~kasan-rename-and-document-kasan_unpoison_object_data
+++ a/net/core/skbuff.c
@@ -337,7 +337,7 @@ static struct sk_buff *napi_skb_cache_ge
 	}
 
 	skb = nc->skb_cache[--nc->skb_count];
-	kasan_unpoison_object_data(skbuff_cache, skb);
+	kasan_unpoison_new_object(skbuff_cache, skb);
 
 	return skb;
 }
@@ -1309,13 +1309,13 @@ static void napi_skb_cache_put(struct sk
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	u32 i;
 
-	kasan_poison_object_data(skbuff_cache, skb);
+	kasan_poison_new_object(skbuff_cache, skb);
 	nc->skb_cache[nc->skb_count++] = skb;
 
 	if (unlikely(nc->skb_count == NAPI_SKB_CACHE_SIZE)) {
 		for (i = NAPI_SKB_CACHE_HALF; i < NAPI_SKB_CACHE_SIZE; i++)
-			kasan_unpoison_object_data(skbuff_cache,
-						   nc->skb_cache[i]);
+			kasan_unpoison_new_object(skbuff_cache,
+						  nc->skb_cache[i]);
 
 		kmem_cache_free_bulk(skbuff_cache, NAPI_SKB_CACHE_HALF,
 				     nc->skb_cache + NAPI_SKB_CACHE_HALF);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

