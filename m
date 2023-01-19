Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0014CC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjASBUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjASBTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C662B607
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5710B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EAC433D2;
        Thu, 19 Jan 2023 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090975;
        bh=ZpoZj7U938/MwvDBia8hoEbAgZdzBd80nU6m5eOrBiU=;
        h=Date:To:From:Subject:From;
        b=VoL2Gg06ns/Wb3qdED0Il5gZXa0H7DkokcOCLySEEXmRASepisCaIsCuLEeeWs2YA
         PEnHlHiSsVglN5dzys0QFeIZOu9U+qpbYraTdE8yMU+prlsHpFmcOn4O9yuzmCB9Xr
         5PjQAH+hzWqH9hNTvLWd1e7SbdqqHBBL7Rl3LsPs=
Date:   Wed, 18 Jan 2023 17:16:14 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vbabka@suse.cz, ryabinin.a.a@gmail.com, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        glider@google.com, dvyukov@google.com, cl@linux.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, feng.tang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-simplify-and-refine-kasan_cache-code.patch removed from -mm tree
Message-Id: <20230119011615.547EAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kasan: simplify and refine kasan_cache code
has been removed from the -mm tree.  Its filename was
     mm-kasan-simplify-and-refine-kasan_cache-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/kasan: simplify and refine kasan_cache code
Date: Wed, 4 Jan 2023 14:06:05 +0800

struct 'kasan_cache' has a member 'is_kmalloc' indicating whether its host
kmem_cache is a kmalloc cache.  With newly introduced is_kmalloc_cache()
helper, 'is_kmalloc' and its related function can be replaced and removed.

Also 'kasan_cache' is only needed by KASAN generic mode, and not by SW/HW
tag modes, so refine its protection macro accordingly, suggested by Andrey
Konoval.

Link: https://lkml.kernel.org/r/20230104060605.930910-2-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h    |   22 +++++-----------------
 include/linux/slab_def.h |    2 +-
 include/linux/slub_def.h |    2 +-
 mm/kasan/common.c        |    9 ++-------
 mm/slab_common.c         |    1 -
 5 files changed, 9 insertions(+), 27 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-simplify-and-refine-kasan_cache-code
+++ a/include/linux/kasan.h
@@ -96,15 +96,6 @@ static inline bool kasan_has_integrated_
 }
 
 #ifdef CONFIG_KASAN
-
-struct kasan_cache {
-#ifdef CONFIG_KASAN_GENERIC
-	int alloc_meta_offset;
-	int free_meta_offset;
-#endif
-	bool is_kmalloc;
-};
-
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -129,13 +120,6 @@ static __always_inline bool kasan_unpois
 	return false;
 }
 
-void __kasan_cache_create_kmalloc(struct kmem_cache *cache);
-static __always_inline void kasan_cache_create_kmalloc(struct kmem_cache *cache)
-{
-	if (kasan_enabled())
-		__kasan_cache_create_kmalloc(cache);
-}
-
 void __kasan_poison_slab(struct slab *slab);
 static __always_inline void kasan_poison_slab(struct slab *slab)
 {
@@ -255,7 +239,6 @@ static inline bool kasan_unpoison_pages(
 {
 	return false;
 }
-static inline void kasan_cache_create_kmalloc(struct kmem_cache *cache) {}
 static inline void kasan_poison_slab(struct slab *slab) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
 					void *object) {}
@@ -306,6 +289,11 @@ static inline void kasan_unpoison_task_s
 
 #ifdef CONFIG_KASAN_GENERIC
 
+struct kasan_cache {
+	int alloc_meta_offset;
+	int free_meta_offset;
+};
+
 size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object);
 slab_flags_t kasan_never_merge(void);
 void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
--- a/include/linux/slab_def.h~mm-kasan-simplify-and-refine-kasan_cache-code
+++ a/include/linux/slab_def.h
@@ -72,7 +72,7 @@ struct kmem_cache {
 	int obj_offset;
 #endif /* CONFIG_DEBUG_SLAB */
 
-#ifdef CONFIG_KASAN
+#ifdef CONFIG_KASAN_GENERIC
 	struct kasan_cache kasan_info;
 #endif
 
--- a/include/linux/slub_def.h~mm-kasan-simplify-and-refine-kasan_cache-code
+++ a/include/linux/slub_def.h
@@ -136,7 +136,7 @@ struct kmem_cache {
 	unsigned int *random_seq;
 #endif
 
-#ifdef CONFIG_KASAN
+#ifdef CONFIG_KASAN_GENERIC
 	struct kasan_cache kasan_info;
 #endif
 
--- a/mm/kasan/common.c~mm-kasan-simplify-and-refine-kasan_cache-code
+++ a/mm/kasan/common.c
@@ -122,11 +122,6 @@ void __kasan_poison_pages(struct page *p
 			     KASAN_PAGE_FREE, init);
 }
 
-void __kasan_cache_create_kmalloc(struct kmem_cache *cache)
-{
-	cache->kasan_info.is_kmalloc = true;
-}
-
 void __kasan_poison_slab(struct slab *slab)
 {
 	struct page *page = slab_page(slab);
@@ -326,7 +321,7 @@ void * __must_check __kasan_slab_alloc(s
 	kasan_unpoison(tagged_object, cache->object_size, init);
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
-	if (kasan_stack_collection_enabled() && !cache->kasan_info.is_kmalloc)
+	if (kasan_stack_collection_enabled() && !is_kmalloc_cache(cache))
 		kasan_save_alloc_info(cache, tagged_object, flags);
 
 	return tagged_object;
@@ -372,7 +367,7 @@ static inline void *____kasan_kmalloc(st
 	 * Save alloc info (if possible) for kmalloc() allocations.
 	 * This also rewrites the alloc info when called from kasan_krealloc().
 	 */
-	if (kasan_stack_collection_enabled() && cache->kasan_info.is_kmalloc)
+	if (kasan_stack_collection_enabled() && is_kmalloc_cache(cache))
 		kasan_save_alloc_info(cache, (void *)object, flags);
 
 	/* Keep the tag that was set by kasan_slab_alloc(). */
--- a/mm/slab_common.c~mm-kasan-simplify-and-refine-kasan_cache-code
+++ a/mm/slab_common.c
@@ -670,7 +670,6 @@ struct kmem_cache *__init create_kmalloc
 
 	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, useroffset,
 								usersize);
-	kasan_cache_create_kmalloc(s);
 	list_add(&s->list, &slab_caches);
 	s->refcount = 1;
 	return s;
_

Patches currently in -mm which might be from feng.tang@intel.com are


