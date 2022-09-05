Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DB0C54EE9
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiIEWrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiIEWrl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:47:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F7244548
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4209760ECA
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9ABC433D7;
        Mon,  5 Sep 2022 22:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418058;
        bh=hinfyQP/f/sBwcf1ZpOCz0bcxpuIvuG45WlmO6BFh2g=;
        h=Date:To:From:Subject:From;
        b=SnfVdnueh1qMj+IcC47t0lTXnCCqkOoR2tFCcTnqgEvC2aBNxgxyJzL+RS6vOfHXQ
         y4cNNaooLFndFZypF/vytt1AYNYUttssxEJ5eUf9VB+QBVilMvjmjh+nN6A07mxZGp
         jqs0OHTP50Ghrh0/bF0AK8tqY6agDRPgfFSR4bG0=
Date:   Mon, 05 Sep 2022 15:47:37 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rename-kasan_set__info-to-kasan_save__info.patch added to mm-unstable branch
Message-Id: <20220905224738.9B9ABC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename kasan_set_*_info to kasan_save_*_info
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-rename-kasan_set__info-to-kasan_save__info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-rename-kasan_set__info-to-kasan_save__info.patch

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

