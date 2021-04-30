Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D068C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235F561483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhD3GBC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3GA7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 097A46147E;
        Fri, 30 Apr 2021 06:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762410;
        bh=icD84AthwAm92NJXxAZ91M9jWsK9Srh+WD/FbmwNI4g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l8QBe7Efat0SfeEy9BvMoF6inOS3cFvx1/El7bo7wCUwnLcbOs0onTxqxVqjTAji7
         v+5J1Jy2qQjnkP7BiEtimA4eqS2GkQz1dEYifKyaMbPK3cK5uVfdHr8BfpNVwZrs52
         dHINMWPqINfIQWJZHr1vaP9+Ko3LbttbWTut9xOQ=
Date:   Thu, 29 Apr 2021 23:00:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 135/178] kasan, mm: integrate slab init_on_free
 with HW_TAGS
Message-ID: <20210430060009.AMjKM6c49%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: integrate slab init_on_free with HW_TAGS

This change uses the previously added memory initialization feature of
HW_TAGS KASAN routines for slab memory when init_on_free is enabled.

With this change, memory initialization memset() is no longer called when
both HW_TAGS KASAN and init_on_free are enabled.  Instead, memory is
initialized in KASAN runtime.

For SLUB, the memory initialization memset() is moved into
slab_free_hook() that currently directly follows the initialization loop. 
A new argument is added to slab_free_hook() that indicates whether to
initialize the memory or not.

To avoid discrepancies with which memory gets initialized that can be
caused by future changes, both KASAN hook and initialization memset() are
put together and a warning comment is added.

Combining setting allocation tags with memory initialization improves
HW_TAGS KASAN performance when init_on_free is enabled.

Link: https://lkml.kernel.org/r/190fd15c1886654afdec0d19ebebd5ade665b601.1615296150.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   10 +++++----
 mm/kasan/common.c     |   13 ++++++------
 mm/slab.c             |   15 ++++++++++---
 mm/slub.c             |   43 ++++++++++++++++++++++------------------
 4 files changed, 48 insertions(+), 33 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-integrate-slab-init_on_free-with-hw_tags
+++ a/include/linux/kasan.h
@@ -203,11 +203,13 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
-bool __kasan_slab_free(struct kmem_cache *s, void *object, unsigned long ip);
-static __always_inline bool kasan_slab_free(struct kmem_cache *s, void *object)
+bool __kasan_slab_free(struct kmem_cache *s, void *object,
+			unsigned long ip, bool init);
+static __always_inline bool kasan_slab_free(struct kmem_cache *s,
+						void *object, bool init)
 {
 	if (kasan_enabled())
-		return __kasan_slab_free(s, object, _RET_IP_);
+		return __kasan_slab_free(s, object, _RET_IP_, init);
 	return false;
 }
 
@@ -313,7 +315,7 @@ static inline void *kasan_init_slab_obj(
 {
 	return (void *)object;
 }
-static inline bool kasan_slab_free(struct kmem_cache *s, void *object)
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object, bool init)
 {
 	return false;
 }
--- a/mm/kasan/common.c~kasan-mm-integrate-slab-init_on_free-with-hw_tags
+++ a/mm/kasan/common.c
@@ -322,8 +322,8 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static inline bool ____kasan_slab_free(struct kmem_cache *cache,
-				void *object, unsigned long ip, bool quarantine)
+static inline bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
+				unsigned long ip, bool quarantine, bool init)
 {
 	u8 tag;
 	void *tagged_object;
@@ -351,7 +351,7 @@ static inline bool ____kasan_slab_free(s
 	}
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
-			KASAN_KMALLOC_FREE, false);
+			KASAN_KMALLOC_FREE, init);
 
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
@@ -362,9 +362,10 @@ static inline bool ____kasan_slab_free(s
 	return kasan_quarantine_put(cache, object);
 }
 
-bool __kasan_slab_free(struct kmem_cache *cache, void *object, unsigned long ip)
+bool __kasan_slab_free(struct kmem_cache *cache, void *object,
+				unsigned long ip, bool init)
 {
-	return ____kasan_slab_free(cache, object, ip, true);
+	return ____kasan_slab_free(cache, object, ip, true, init);
 }
 
 static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
@@ -409,7 +410,7 @@ void __kasan_slab_free_mempool(void *ptr
 			return;
 		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE, false);
 	} else {
-		____kasan_slab_free(page->slab_cache, ptr, ip, false);
+		____kasan_slab_free(page->slab_cache, ptr, ip, false, false);
 	}
 }
 
--- a/mm/slab.c~kasan-mm-integrate-slab-init_on_free-with-hw_tags
+++ a/mm/slab.c
@@ -3425,17 +3425,24 @@ free_done:
 static __always_inline void __cache_free(struct kmem_cache *cachep, void *objp,
 					 unsigned long caller)
 {
+	bool init;
+
 	if (is_kfence_address(objp)) {
 		kmemleak_free_recursive(objp, cachep->flags);
 		__kfence_free(objp);
 		return;
 	}
 
-	if (unlikely(slab_want_init_on_free(cachep)))
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * kasan_slab_free and initialization memset must be
+	 * kept together to avoid discrepancies in behavior.
+	 */
+	init = slab_want_init_on_free(cachep);
+	if (init && !kasan_has_integrated_init())
 		memset(objp, 0, cachep->object_size);
-
-	/* Put the object into the quarantine, don't touch it for now. */
-	if (kasan_slab_free(cachep, objp))
+	/* KASAN might put objp into memory quarantine, delaying its reuse. */
+	if (kasan_slab_free(cachep, objp, init))
 		return;
 
 	/* Use KCSAN to help debug racy use-after-free. */
--- a/mm/slub.c~kasan-mm-integrate-slab-init_on_free-with-hw_tags
+++ a/mm/slub.c
@@ -1545,7 +1545,8 @@ static __always_inline void kfree_hook(v
 	kasan_kfree_large(x);
 }
 
-static __always_inline bool slab_free_hook(struct kmem_cache *s, void *x)
+static __always_inline bool slab_free_hook(struct kmem_cache *s,
+						void *x, bool init)
 {
 	kmemleak_free_recursive(x, s->flags);
 
@@ -1571,8 +1572,25 @@ static __always_inline bool slab_free_ho
 		__kcsan_check_access(x, s->object_size,
 				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 
-	/* KASAN might put x into memory quarantine, delaying its reuse */
-	return kasan_slab_free(s, x);
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * kasan_slab_free and initialization memset's must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * The initialization memset's clear the object and the metadata,
+	 * but don't touch the SLAB redzone.
+	 */
+	if (init) {
+		int rsize;
+
+		if (!kasan_has_integrated_init())
+			memset(kasan_reset_tag(x), 0, s->object_size);
+		rsize = (s->flags & SLAB_RED_ZONE) ? s->red_left_pad : 0;
+		memset((char *)kasan_reset_tag(x) + s->inuse, 0,
+		       s->size - s->inuse - rsize);
+	}
+	/* KASAN might put x into memory quarantine, delaying its reuse. */
+	return kasan_slab_free(s, x, init);
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
@@ -1582,10 +1600,9 @@ static inline bool slab_free_freelist_ho
 	void *object;
 	void *next = *head;
 	void *old_tail = *tail ? *tail : *head;
-	int rsize;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next);
+		slab_free_hook(s, next, false);
 		return true;
 	}
 
@@ -1597,20 +1614,8 @@ static inline bool slab_free_freelist_ho
 		object = next;
 		next = get_freepointer(s, object);
 
-		if (slab_want_init_on_free(s)) {
-			/*
-			 * Clear the object and the metadata, but don't touch
-			 * the redzone.
-			 */
-			memset(kasan_reset_tag(object), 0, s->object_size);
-			rsize = (s->flags & SLAB_RED_ZONE) ? s->red_left_pad
-							   : 0;
-			memset((char *)kasan_reset_tag(object) + s->inuse, 0,
-			       s->size - s->inuse - rsize);
-
-		}
 		/* If object's reuse doesn't have to be delayed */
-		if (!slab_free_hook(s, object)) {
+		if (!slab_free_hook(s, object, slab_want_init_on_free(s))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -3248,7 +3253,7 @@ int build_detached_freelist(struct kmem_
 	}
 
 	if (is_kfence_address(object)) {
-		slab_free_hook(df->s, object);
+		slab_free_hook(df->s, object, false);
 		__kfence_free(object);
 		p[size] = NULL; /* mark object processed */
 		return size;
_
