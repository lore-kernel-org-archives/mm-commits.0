Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E2DC6FA8B
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiIEWsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiIEWsC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC39153002
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 680E5B815D5
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE52CC433D6;
        Mon,  5 Sep 2022 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418078;
        bh=kibvsxboroL2Xw0BygMZ+j0Vh7K5teK/SPBvYU2K5mU=;
        h=Date:To:From:Subject:From;
        b=clyHPKALhL+lb3HgUu3D/kJA3EVxMFUB/IiDrgwRufEM/f5rohrixsnKRn0E9O8Hq
         2vDNGxpMU6VUEZqM9YM1vcRWSzz02ZCOJ8tuUcjYY1OrvAxh/2ZTWeJ6N5O3rScIat
         gvDeNPpR20tAs7Bt5vCVkSOotUvz20gZBBrOHghE=
Date:   Mon, 05 Sep 2022 15:47:57 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-clear-metadata-functions-for-tag-based-modes.patch added to mm-unstable branch
Message-Id: <20220905224757.EE52CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clear metadata functions for tag-based modes
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-clear-metadata-functions-for-tag-based-modes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-clear-metadata-functions-for-tag-based-modes.patch

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
Subject: kasan: clear metadata functions for tag-based modes
Date: Mon, 5 Sep 2022 23:05:24 +0200

Remove implementations of the metadata-related functions for the tag-based
modes.

The following patches in the series will provide alternative
implementations.

As of this patch, the tag-based modes no longer collect alloc and free
stack traces.  This functionality will be restored later in the series.

Link: https://lkml.kernel.org/r/470fbe5d15e8015092e76e395de354be18ccceab.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

--- a/mm/kasan/tags.c~kasan-clear-metadata-functions-for-tag-based-modes
+++ a/mm/kasan/tags.c
@@ -19,54 +19,25 @@
 
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		__memset(alloc_meta, 0, sizeof(*alloc_meta));
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		kasan_set_track(&alloc_meta->alloc_track, flags);
 }
 
 void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return;
-
-	kasan_set_track(&alloc_meta->free_track, GFP_NOWAIT);
 }
 
 struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
 						void *object)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
-
-	return &alloc_meta->alloc_track;
+	return NULL;
 }
 
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 						void *object, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
-
-	return &alloc_meta->free_track;
+	return NULL;
 }
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

