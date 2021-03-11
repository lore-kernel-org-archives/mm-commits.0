Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B255C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAABF64F88
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCKWpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhCKWpN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:45:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4D264F88;
        Thu, 11 Mar 2021 22:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615502713;
        bh=D4LSMP2cmNaonMbINluMN/Ubkk0L5tCRPAK0cKK9gSQ=;
        h=Date:From:To:Subject:From;
        b=GV2c7xfNtrxRrcv6Pqh0T8+86zOq7mY9iSn3e7WXsv2wod7UYnn1EhJaMpESWIYeD
         7S87VLKpaTPSWZuVsx20dj5hmD8ekGvm44SnK4ROU9X3n/9mM9/k5FRn0vdwzMaC8K
         eQbjGLpifr6yrDBP2udVZ1XLQvbMB4F8sjEIK+oI=
Date:   Thu, 11 Mar 2021 14:45:10 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, iamjoonsoo.kim@lge.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch added to -mm tree
Message-ID: <20210311224510._0SSPcAVu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: integrate slab init_on_alloc with HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: integrate slab init_on_alloc with HW_TAGS

This change uses the previously added memory initialization feature of
HW_TAGS KASAN routines for slab memory when init_on_alloc is enabled.

With this change, memory initialization memset() is no longer called when
both HW_TAGS KASAN and init_on_alloc are enabled.  Instead, memory is
initialized in KASAN runtime.

The memory initialization memset() is moved into slab_post_alloc_hook()
that currently directly follows the initialization loop.  A new argument
is added to slab_post_alloc_hook() that indicates whether to initialize
the memory or not.

To avoid discrepancies with which memory gets initialized that can be
caused by future changes, both KASAN hook and initialization memset() are
put together and a warning comment is added.

Combining setting allocation tags with memory initialization improves
HW_TAGS KASAN performance when init_on_alloc is enabled.

Link: https://lkml.kernel.org/r/c1292aeb5d519da221ec74a0684a949b027d7720.1615296150.git.andreyknvl@google.com
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

 include/linux/kasan.h |    8 ++++----
 mm/kasan/common.c     |    4 ++--
 mm/slab.c             |   28 +++++++++++++---------------
 mm/slab.h             |   17 +++++++++++++----
 mm/slub.c             |   27 +++++++++++----------------
 5 files changed, 43 insertions(+), 41 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-integrate-slab-init_on_alloc-with-hw_tags
+++ a/include/linux/kasan.h
@@ -226,12 +226,12 @@ static __always_inline void kasan_slab_f
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
-				       void *object, gfp_t flags);
+				       void *object, gfp_t flags, bool init);
 static __always_inline void * __must_check kasan_slab_alloc(
-				struct kmem_cache *s, void *object, gfp_t flags)
+		struct kmem_cache *s, void *object, gfp_t flags, bool init)
 {
 	if (kasan_enabled())
-		return __kasan_slab_alloc(s, object, flags);
+		return __kasan_slab_alloc(s, object, flags, init);
 	return object;
 }
 
@@ -320,7 +320,7 @@ static inline bool kasan_slab_free(struc
 static inline void kasan_kfree_large(void *ptr) {}
 static inline void kasan_slab_free_mempool(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
-				   gfp_t flags)
+				   gfp_t flags, bool init)
 {
 	return object;
 }
--- a/mm/kasan/common.c~kasan-mm-integrate-slab-init_on_alloc-with-hw_tags
+++ a/mm/kasan/common.c
@@ -428,7 +428,7 @@ static void set_alloc_info(struct kmem_c
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
-					void *object, gfp_t flags)
+					void *object, gfp_t flags, bool init)
 {
 	u8 tag;
 	void *tagged_object;
@@ -453,7 +453,7 @@ void * __must_check __kasan_slab_alloc(s
 	 * Unpoison the whole object.
 	 * For kmalloc() allocations, kasan_kmalloc() will do precise poisoning.
 	 */
-	kasan_unpoison(tagged_object, cache->object_size, false);
+	kasan_unpoison(tagged_object, cache->object_size, init);
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
 	if (kasan_stack_collection_enabled())
--- a/mm/slab.c~kasan-mm-integrate-slab-init_on_alloc-with-hw_tags
+++ a/mm/slab.c
@@ -3216,6 +3216,7 @@ slab_alloc_node(struct kmem_cache *cache
 	void *ptr;
 	int slab_node = numa_mem_id();
 	struct obj_cgroup *objcg = NULL;
+	bool init = false;
 
 	flags &= gfp_allowed_mask;
 	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
@@ -3254,12 +3255,10 @@ slab_alloc_node(struct kmem_cache *cache
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
-
-	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && ptr)
-		memset(ptr, 0, cachep->object_size);
+	init = slab_want_init_on_alloc(flags, cachep);
 
 out_hooks:
-	slab_post_alloc_hook(cachep, objcg, flags, 1, &ptr);
+	slab_post_alloc_hook(cachep, objcg, flags, 1, &ptr, init);
 	return ptr;
 }
 
@@ -3301,6 +3300,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 	unsigned long save_flags;
 	void *objp;
 	struct obj_cgroup *objcg = NULL;
+	bool init = false;
 
 	flags &= gfp_allowed_mask;
 	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
@@ -3317,12 +3317,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
-
-	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && objp)
-		memset(objp, 0, cachep->object_size);
+	init = slab_want_init_on_alloc(flags, cachep);
 
 out:
-	slab_post_alloc_hook(cachep, objcg, flags, 1, &objp);
+	slab_post_alloc_hook(cachep, objcg, flags, 1, &objp, init);
 	return objp;
 }
 
@@ -3542,18 +3540,18 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 
 	cache_alloc_debugcheck_after_bulk(s, flags, size, p, _RET_IP_);
 
-	/* Clear memory outside IRQ disabled section */
-	if (unlikely(slab_want_init_on_alloc(flags, s)))
-		for (i = 0; i < size; i++)
-			memset(p[i], 0, s->object_size);
-
-	slab_post_alloc_hook(s, objcg, flags, size, p);
+	/*
+	 * memcg and kmem_cache debug support and memory initialization.
+	 * Done outside of the IRQ disabled section.
+	 */
+	slab_post_alloc_hook(s, objcg, flags, size, p,
+				slab_want_init_on_alloc(flags, s));
 	/* FIXME: Trace call missing. Christoph would like a bulk variant */
 	return size;
 error:
 	local_irq_enable();
 	cache_alloc_debugcheck_after_bulk(s, flags, i, p, _RET_IP_);
-	slab_post_alloc_hook(s, objcg, flags, i, p);
+	slab_post_alloc_hook(s, objcg, flags, i, p, false);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
 }
--- a/mm/slab.h~kasan-mm-integrate-slab-init_on_alloc-with-hw_tags
+++ a/mm/slab.h
@@ -506,15 +506,24 @@ static inline struct kmem_cache *slab_pr
 }
 
 static inline void slab_post_alloc_hook(struct kmem_cache *s,
-					struct obj_cgroup *objcg,
-					gfp_t flags, size_t size, void **p)
+					struct obj_cgroup *objcg, gfp_t flags,
+					size_t size, void **p, bool init)
 {
 	size_t i;
 
 	flags &= gfp_allowed_mask;
+
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * kasan_slab_alloc and initialization memset must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
+	 */
 	for (i = 0; i < size; i++) {
-		p[i] = kasan_slab_alloc(s, p[i], flags);
-		/* As p[i] might get tagged, call kmemleak hook after KASAN. */
+		p[i] = kasan_slab_alloc(s, p[i], flags, init);
+		if (p[i] && init && !kasan_has_integrated_init())
+			memset(p[i], 0, s->object_size);
 		kmemleak_alloc_recursive(p[i], s->object_size, 1,
 					 s->flags, flags);
 	}
--- a/mm/slub.c~kasan-mm-integrate-slab-init_on_alloc-with-hw_tags
+++ a/mm/slub.c
@@ -2856,6 +2856,7 @@ static __always_inline void *slab_alloc_
 	struct page *page;
 	unsigned long tid;
 	struct obj_cgroup *objcg = NULL;
+	bool init = false;
 
 	s = slab_pre_alloc_hook(s, &objcg, 1, gfpflags);
 	if (!s)
@@ -2933,12 +2934,10 @@ redo:
 	}
 
 	maybe_wipe_obj_freeptr(s, object);
-
-	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
-		memset(kasan_reset_tag(object), 0, s->object_size);
+	init = slab_want_init_on_alloc(gfpflags, s);
 
 out:
-	slab_post_alloc_hook(s, objcg, gfpflags, 1, &object);
+	slab_post_alloc_hook(s, objcg, gfpflags, 1, &object, init);
 
 	return object;
 }
@@ -3399,20 +3398,16 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	c->tid = next_tid(c->tid);
 	local_irq_enable();
 
-	/* Clear memory outside IRQ disabled fastpath loop */
-	if (unlikely(slab_want_init_on_alloc(flags, s))) {
-		int j;
-
-		for (j = 0; j < i; j++)
-			memset(kasan_reset_tag(p[j]), 0, s->object_size);
-	}
-
-	/* memcg and kmem_cache debug support */
-	slab_post_alloc_hook(s, objcg, flags, size, p);
+	/*
+	 * memcg and kmem_cache debug support and memory initialization.
+	 * Done outside of the IRQ disabled fastpath loop.
+	 */
+	slab_post_alloc_hook(s, objcg, flags, size, p,
+				slab_want_init_on_alloc(flags, s));
 	return i;
 error:
 	local_irq_enable();
-	slab_post_alloc_hook(s, objcg, flags, i, p);
+	slab_post_alloc_hook(s, objcg, flags, i, p, false);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
 }
@@ -3630,7 +3625,7 @@ static void early_kmem_cache_node_alloc(
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
-	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL);
+	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
 	page->freelist = get_freepointer(kmem_cache_node, n);
 	page->inuse = 1;
 	page->frozen = 0;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch

