Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADD9C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665FD64F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhBYTaA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234435AbhBYT1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC25D64F8A;
        Thu, 25 Feb 2021 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280549;
        bh=J4ItupXAM6bQkmIKP1fcJItHz5cA+H/aos9erqMmGAY=;
        h=Date:From:To:Subject:From;
        b=kXAVtoadSfGxwY7B0CoyOjxgy+8OT0LpRqXyUHXrEezeE1FccGz0Mlepqj6rJ6CKq
         ++nadpIT6vu0zwd8PslBrWf983GXIj9oYJItRG3LHQ08tPwFmoGnD9BPTs1HeU+Kk4
         +iHG3+dyYwjpOKzTfQDxLDzGV++KSyBVmNuSUULM=
Date:   Thu, 25 Feb 2021 11:15:48 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-move-_ret_ip_-to-inline-wrappers.patch
 removed from -mm tree
Message-ID: <20210225191548.aBa20Kt2F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move _RET_IP_ to inline wrappers
has been removed from the -mm tree.  Its filename was
     kasan-move-_ret_ip_-to-inline-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move _RET_IP_ to inline wrappers

Generic mm functions that call KASAN annotations that might report a bug
pass _RET_IP_ to them as an argument. This allows KASAN to include the
name of the function that called the mm function in its report's header.

Now that KASAN has inline wrappers for all of its annotations, move
_RET_IP_ to those wrappers to simplify annotation call sites.

Link: https://linux-review.googlesource.com/id/I8fb3c06d49671305ee184175a39591bc26647a67
Link: https://lkml.kernel.org/r/5c1490eddf20b436b8c4eeea83fce47687d5e4a4.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   20 +++++++++-----------
 mm/mempool.c          |    2 +-
 mm/slab.c             |    2 +-
 mm/slub.c             |    4 ++--
 4 files changed, 13 insertions(+), 15 deletions(-)

--- a/include/linux/kasan.h~kasan-move-_ret_ip_-to-inline-wrappers
+++ a/include/linux/kasan.h
@@ -185,19 +185,18 @@ static __always_inline void * __must_che
 }
 
 bool __kasan_slab_free(struct kmem_cache *s, void *object, unsigned long ip);
-static __always_inline bool kasan_slab_free(struct kmem_cache *s, void *object,
-						unsigned long ip)
+static __always_inline bool kasan_slab_free(struct kmem_cache *s, void *object)
 {
 	if (kasan_enabled())
-		return __kasan_slab_free(s, object, ip);
+		return __kasan_slab_free(s, object, _RET_IP_);
 	return false;
 }
 
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip);
-static __always_inline void kasan_slab_free_mempool(void *ptr, unsigned long ip)
+static __always_inline void kasan_slab_free_mempool(void *ptr)
 {
 	if (kasan_enabled())
-		__kasan_slab_free_mempool(ptr, ip);
+		__kasan_slab_free_mempool(ptr, _RET_IP_);
 }
 
 void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
@@ -241,10 +240,10 @@ static __always_inline void * __must_che
 }
 
 void __kasan_kfree_large(void *ptr, unsigned long ip);
-static __always_inline void kasan_kfree_large(void *ptr, unsigned long ip)
+static __always_inline void kasan_kfree_large(void *ptr)
 {
 	if (kasan_enabled())
-		__kasan_kfree_large(ptr, ip);
+		__kasan_kfree_large(ptr, _RET_IP_);
 }
 
 bool kasan_save_enable_multi_shot(void);
@@ -277,12 +276,11 @@ static inline void *kasan_init_slab_obj(
 {
 	return (void *)object;
 }
-static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
-				   unsigned long ip)
+static inline bool kasan_slab_free(struct kmem_cache *s, void *object)
 {
 	return false;
 }
-static inline void kasan_slab_free_mempool(void *ptr, unsigned long ip) {}
+static inline void kasan_slab_free_mempool(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags)
 {
@@ -302,7 +300,7 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
-static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
+static inline void kasan_kfree_large(void *ptr) {}
 
 #endif /* CONFIG_KASAN */
 
--- a/mm/mempool.c~kasan-move-_ret_ip_-to-inline-wrappers
+++ a/mm/mempool.c
@@ -104,7 +104,7 @@ static inline void poison_element(mempoo
 static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_slab_free_mempool(element, _RET_IP_);
+		kasan_slab_free_mempool(element);
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
--- a/mm/slab.c~kasan-move-_ret_ip_-to-inline-wrappers
+++ a/mm/slab.c
@@ -3420,7 +3420,7 @@ static __always_inline void __cache_free
 		memset(objp, 0, cachep->object_size);
 
 	/* Put the object into the quarantine, don't touch it for now. */
-	if (kasan_slab_free(cachep, objp, _RET_IP_))
+	if (kasan_slab_free(cachep, objp))
 		return;
 
 	/* Use KCSAN to help debug racy use-after-free. */
--- a/mm/slub.c~kasan-move-_ret_ip_-to-inline-wrappers
+++ a/mm/slub.c
@@ -1528,7 +1528,7 @@ static inline void *kmalloc_large_node_h
 static __always_inline void kfree_hook(void *x)
 {
 	kmemleak_free(x);
-	kasan_kfree_large(x, _RET_IP_);
+	kasan_kfree_large(x);
 }
 
 static __always_inline bool slab_free_hook(struct kmem_cache *s, void *x)
@@ -1558,7 +1558,7 @@ static __always_inline bool slab_free_ho
 				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 
 	/* KASAN might put x into memory quarantine, delaying its reuse */
-	return kasan_slab_free(s, x, _RET_IP_);
+	return kasan_slab_free(s, x);
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

