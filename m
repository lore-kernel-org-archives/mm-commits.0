Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E73FC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJCVIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJCVGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7D4DF2B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C847611F1
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B26C433D7;
        Mon,  3 Oct 2022 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831155;
        bh=g/xwlqqfa2WsYglrKpVpI00q/+m9pAGyk7dtoyhwB0U=;
        h=Date:To:From:Subject:From;
        b=w7zRcf0K6+NlbQpFoCoYKrhv/r8fHDUtpD8AsldE74r1BuxWv//UhgHGb5TeB/8/7
         aKodlAd/gqleWeqZQpID7Ccz+AbjlmEy/cz/47van8Gs4aEFPVTRGXyn3JeU4t68R2
         fJamZvQ37kn89yyZPNkjU7p/0FX1+3XRU1aSnW14=
Date:   Mon, 03 Oct 2022 14:05:55 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-introduce-kasan_init_object_meta.patch removed from -mm tree
Message-Id: <20221003210555.B0B26C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: introduce kasan_init_object_meta
has been removed from the -mm tree.  Its filename was
     kasan-introduce-kasan_init_object_meta.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce kasan_init_object_meta
Date: Mon, 5 Sep 2022 23:05:23 +0200

Add a kasan_init_object_meta() helper that initializes metadata for a slab
object and use it in the common code.

For now, the implementations of this helper are the same for the Generic
and tag-based modes, but they will diverge later in the series.

This change hides references to alloc_meta from the common code.  This is
desired as only the Generic mode will be using per-object metadata after
this series.

Link: https://lkml.kernel.org/r/47c12938fc7f8105e7aaa592527c0e9d3c81fc37.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |   10 +++-------
 mm/kasan/generic.c |    9 +++++++++
 mm/kasan/kasan.h   |    2 ++
 mm/kasan/tags.c    |    9 +++++++++
 4 files changed, 23 insertions(+), 7 deletions(-)

--- a/mm/kasan/common.c~kasan-introduce-kasan_init_object_meta
+++ a/mm/kasan/common.c
@@ -313,13 +313,9 @@ static inline u8 assign_tag(struct kmem_
 void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
 						const void *object)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	if (kasan_stack_collection_enabled()) {
-		alloc_meta = kasan_get_alloc_meta(cache, object);
-		if (alloc_meta)
-			__memset(alloc_meta, 0, sizeof(*alloc_meta));
-	}
+	/* Initialize per-object metadata if it is present. */
+	if (kasan_stack_collection_enabled())
+		kasan_init_object_meta(cache, object);
 
 	/* Tag is ignored in set_tag() without CONFIG_KASAN_SW/HW_TAGS */
 	object = set_tag(object, assign_tag(cache, object, true));
--- a/mm/kasan/generic.c~kasan-introduce-kasan_init_object_meta
+++ a/mm/kasan/generic.c
@@ -328,6 +328,15 @@ DEFINE_ASAN_SET_SHADOW(f3);
 DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
 
+void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+}
+
 static void __kasan_record_aux_stack(void *addr, bool can_alloc)
 {
 	struct slab *slab = kasan_addr_to_slab(addr);
--- a/mm/kasan/kasan.h~kasan-introduce-kasan_init_object_meta
+++ a/mm/kasan/kasan.h
@@ -279,6 +279,8 @@ void kasan_report_invalid_free(void *obj
 struct page *kasan_addr_to_page(const void *addr);
 struct slab *kasan_addr_to_slab(const void *addr);
 
+void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
+
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
--- a/mm/kasan/tags.c~kasan-introduce-kasan_init_object_meta
+++ a/mm/kasan/tags.c
@@ -17,6 +17,15 @@
 
 #include "kasan.h"
 
+void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+}
+
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	struct kasan_alloc_meta *alloc_meta;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

