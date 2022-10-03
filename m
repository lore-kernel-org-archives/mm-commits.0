Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449B4C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJCVIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJCVG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CAF4D811
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36B10611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8603BC433D6;
        Mon,  3 Oct 2022 21:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831148;
        bh=B5M80wXJHX76qEgSB6rqFhXe9kKfVbY6ckINtlCJOxY=;
        h=Date:To:From:Subject:From;
        b=n/yq5kIxWhRRPM3ZlWtpwYLN127riv/TyqOBpJm4DNMvr4A1QZkVdxeSPH9+DoHKf
         qyfpYgxNU3sML61bIU4Q1ET6o9ea/PoaTDR8wcSD3S2MKf7W7d5l3qSkfoOtZzRZbQ
         h5QkeVrEs1cZZLI7BzyILUqoQlKQcrOIZI0c18Qw=
Date:   Mon, 03 Oct 2022 14:05:47 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-rename-kasan_set__info-to-kasan_save__info.patch removed from -mm tree
Message-Id: <20221003210548.8603BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: rename kasan_set_*_info to kasan_save_*_info
has been removed from the -mm tree.  Its filename was
     kasan-rename-kasan_set__info-to-kasan_save__info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename kasan_set_*_info to kasan_save_*_info
Date: Mon, 5 Sep 2022 23:05:17 +0200

Rename set_alloc_info() and kasan_set_free_info() to save_alloc_info() and
kasan_save_free_info().  The new names make more sense.

Link: https://lkml.kernel.org/r/9f04777a15cb9d96bf00331da98e021d732fe1c9.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |    8 ++++----
 mm/kasan/generic.c |    2 +-
 mm/kasan/kasan.h   |    2 +-
 mm/kasan/tags.c    |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/kasan/common.c~kasan-rename-kasan_set__info-to-kasan_save__info
+++ a/mm/kasan/common.c
@@ -365,7 +365,7 @@ static inline bool ____kasan_slab_free(s
 		return false;
 
 	if (kasan_stack_collection_enabled())
-		kasan_set_free_info(cache, object, tag);
+		kasan_save_free_info(cache, object, tag);
 
 	return kasan_quarantine_put(cache, object);
 }
@@ -424,7 +424,7 @@ void __kasan_slab_free_mempool(void *ptr
 	}
 }
 
-static void set_alloc_info(struct kmem_cache *cache, void *object,
+static void save_alloc_info(struct kmem_cache *cache, void *object,
 				gfp_t flags, bool is_kmalloc)
 {
 	struct kasan_alloc_meta *alloc_meta;
@@ -468,7 +468,7 @@ void * __must_check __kasan_slab_alloc(s
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
 	if (kasan_stack_collection_enabled())
-		set_alloc_info(cache, (void *)object, flags, false);
+		save_alloc_info(cache, (void *)object, flags, false);
 
 	return tagged_object;
 }
@@ -514,7 +514,7 @@ static inline void *____kasan_kmalloc(st
 	 * This also rewrites the alloc info when called from kasan_krealloc().
 	 */
 	if (kasan_stack_collection_enabled())
-		set_alloc_info(cache, (void *)object, flags, true);
+		save_alloc_info(cache, (void *)object, flags, true);
 
 	/* Keep the tag that was set by kasan_slab_alloc(). */
 	return (void *)object;
--- a/mm/kasan/generic.c~kasan-rename-kasan_set__info-to-kasan_save__info
+++ a/mm/kasan/generic.c
@@ -358,7 +358,7 @@ void kasan_record_aux_stack_noalloc(void
 	return __kasan_record_aux_stack(addr, false);
 }
 
-void kasan_set_free_info(struct kmem_cache *cache,
+void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
 	struct kasan_free_meta *free_meta;
--- a/mm/kasan/kasan.h~kasan-rename-kasan_set__info-to-kasan_save__info
+++ a/mm/kasan/kasan.h
@@ -285,7 +285,7 @@ struct slab *kasan_addr_to_slab(const vo
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
-void kasan_set_free_info(struct kmem_cache *cache, void *object, u8 tag);
+void kasan_save_free_info(struct kmem_cache *cache, void *object, u8 tag);
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 				void *object, u8 tag);
 
--- a/mm/kasan/tags.c~kasan-rename-kasan_set__info-to-kasan_save__info
+++ a/mm/kasan/tags.c
@@ -17,7 +17,7 @@
 
 #include "kasan.h"
 
-void kasan_set_free_info(struct kmem_cache *cache,
+void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
 	struct kasan_alloc_meta *alloc_meta;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

