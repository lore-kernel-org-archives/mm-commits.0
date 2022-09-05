Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC30ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiIEWrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiIEWro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D05E3C8D4
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3609E60DC5
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F625C433C1;
        Mon,  5 Sep 2022 22:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418061;
        bh=9ZQiLTkpUwJpQTkX42JCtDAm4pUIKHdVZZHHmV2k1Co=;
        h=Date:To:From:Subject:From;
        b=dMBR6nLt7Wpm3M5cokGnIm+QI2amnhLuT6TJ7tufgpUb66RDni4dzMFQ9WbgpQGln
         T/ley7JXB2D62J/57/+vNWq2nmKPFOW49qe7+rdTAahta3rcS1mVtWctXZ41TqnqeL
         j9BVjnucOZvV5QtVkYyvqzck0m9u/v9DpVHTGzy0=
Date:   Mon, 05 Sep 2022 15:47:40 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch added to mm-unstable branch
Message-Id: <20220905224741.8F625C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move is_kmalloc check out of save_alloc_info
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move is_kmalloc check out of save_alloc_info
Date: Mon, 5 Sep 2022 23:05:18 +0200

Move kasan_info.is_kmalloc check out of save_alloc_info().

This is a preparatory change that simplifies the following patches in this
series.

Link: https://lkml.kernel.org/r/df89f1915b788f9a10319905af6d0202a3b30c30.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/kasan/common.c~kasan-move-is_kmalloc-check-out-of-save_alloc_info
+++ a/mm/kasan/common.c
@@ -424,15 +424,10 @@ void __kasan_slab_free_mempool(void *ptr
 	}
 }
 
-static void save_alloc_info(struct kmem_cache *cache, void *object,
-				gfp_t flags, bool is_kmalloc)
+static void save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	struct kasan_alloc_meta *alloc_meta;
 
-	/* Don't save alloc info for kmalloc caches in kasan_slab_alloc(). */
-	if (cache->kasan_info.is_kmalloc && !is_kmalloc)
-		return;
-
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (alloc_meta)
 		kasan_set_track(&alloc_meta->alloc_track, flags);
@@ -467,8 +462,8 @@ void * __must_check __kasan_slab_alloc(s
 	kasan_unpoison(tagged_object, cache->object_size, init);
 
 	/* Save alloc info (if possible) for non-kmalloc() allocations. */
-	if (kasan_stack_collection_enabled())
-		save_alloc_info(cache, (void *)object, flags, false);
+	if (kasan_stack_collection_enabled() && !cache->kasan_info.is_kmalloc)
+		save_alloc_info(cache, (void *)object, flags);
 
 	return tagged_object;
 }
@@ -513,8 +508,8 @@ static inline void *____kasan_kmalloc(st
 	 * Save alloc info (if possible) for kmalloc() allocations.
 	 * This also rewrites the alloc info when called from kasan_krealloc().
 	 */
-	if (kasan_stack_collection_enabled())
-		save_alloc_info(cache, (void *)object, flags, true);
+	if (kasan_stack_collection_enabled() && cache->kasan_info.is_kmalloc)
+		save_alloc_info(cache, (void *)object, flags);
 
 	/* Keep the tag that was set by kasan_slab_alloc(). */
 	return (void *)object;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

