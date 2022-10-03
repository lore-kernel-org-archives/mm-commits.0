Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D587AC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJCVIg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJCVG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32F74DB7E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B3900CE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57F0C433D7;
        Mon,  3 Oct 2022 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831151;
        bh=rrIF2X1YI6pQFjCU6KB0ssjsZYLtA7J44wkFoIU/64M=;
        h=Date:To:From:Subject:From;
        b=DfusVL0Zbm987WP3on8l1cSZaerCLvJe4zDS4CyRvnDixuVTlHn9FvbAnlmeVSPlr
         UilY9SoLGiIO1fnNUZOy3pBJ2ia701BHj5+mSpn/1jYuRtpPbArQFrgia6qiPaH1dw
         mQDCx2YthbLd6CgVMr2j1aax3FsdQVv2m+Z+1k3o=
Date:   Mon, 03 Oct 2022 14:05:50 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-split-save_alloc_info-implementations.patch removed from -mm tree
Message-Id: <20221003210550.E57F0C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: split save_alloc_info implementations
has been removed from the -mm tree.  Its filename was
     kasan-split-save_alloc_info-implementations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: split save_alloc_info implementations
Date: Mon, 5 Sep 2022 23:05:19 +0200

Provide standalone implementations of save_alloc_info() for the Generic
and tag-based modes.

For now, the implementations are the same, but they will diverge later in
the series.

Link: https://lkml.kernel.org/r/77f1a078489c1e859aedb5403f772e5e1f7410a0.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |   13 ++-----------
 mm/kasan/generic.c |    9 +++++++++
 mm/kasan/kasan.h   |    1 +
 mm/kasan/tags.c    |    9 +++++++++
 4 files changed, 21 insertions(+), 11 deletions(-)

--- a/mm/kasan/common.c~kasan-split-save_alloc_info-implementations
+++ a/mm/kasan/common.c
@@ -424,15 +424,6 @@ void __kasan_slab_free_mempool(void *ptr
 	}
 }
 
-static void save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
-{
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		kasan_set_track(&alloc_meta->alloc_track, flags);
-}
-
 void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
 					void *object, gfp_t flags, bool init)
 {
@@ -463,7 +454,7 @@ void * __must_check __kasan_slab_alloc(s
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
 	if (kasan_stack_collection_enabled() && !cache->kasan_info.is_kmalloc)
-		save_alloc_info(cache, (void *)object, flags);
+		kasan_save_alloc_info(cache, (void *)object, flags);
 
 	return tagged_object;
 }
@@ -509,7 +500,7 @@ static inline void *____kasan_kmalloc(st
 	 * This also rewrites the alloc info when called from kasan_krealloc().
 	 */
 	if (kasan_stack_collection_enabled() && cache->kasan_info.is_kmalloc)
-		save_alloc_info(cache, (void *)object, flags);
+		kasan_save_alloc_info(cache, (void *)object, flags);
 
 	/* Keep the tag that was set by kasan_slab_alloc(). */
 	return (void *)object;
--- a/mm/kasan/generic.c~kasan-split-save_alloc_info-implementations
+++ a/mm/kasan/generic.c
@@ -358,6 +358,15 @@ void kasan_record_aux_stack_noalloc(void
 	return __kasan_record_aux_stack(addr, false);
 }
 
+void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		kasan_set_track(&alloc_meta->alloc_track, flags);
+}
+
 void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
--- a/mm/kasan/kasan.h~kasan-split-save_alloc_info-implementations
+++ a/mm/kasan/kasan.h
@@ -285,6 +285,7 @@ struct slab *kasan_addr_to_slab(const vo
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
+void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 void kasan_save_free_info(struct kmem_cache *cache, void *object, u8 tag);
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 				void *object, u8 tag);
--- a/mm/kasan/tags.c~kasan-split-save_alloc_info-implementations
+++ a/mm/kasan/tags.c
@@ -17,6 +17,15 @@
 
 #include "kasan.h"
 
+void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		kasan_set_track(&alloc_meta->alloc_track, flags);
+}
+
 void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

