Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0B3C07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiI2ECi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiI2ECe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9168D127C99
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3982AB82339
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B616DC433D7;
        Thu, 29 Sep 2022 04:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424147;
        bh=DX1gj/tmfwgWMJUQ3HY9yZiYyngr7VzUccu8o1QfoVc=;
        h=Date:To:From:Subject:From;
        b=w11ULTDbpxWciSMif/OvEbuER+B70qGDP8OlNd2XHs96hewC2VN6OflsdeW11SXJW
         4tAGkv/aBshLrf+RKDGxeWEfmIcYARWGD8wdeLNoxfYhJF5vdGtW5pLyNEFFct+QAK
         lzpMwr4xfzGI+ySJFJ4VYPwICvhLtbOU2cBjqgLI=
Date:   Wed, 28 Sep 2022 21:02:26 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-implement-stack-ring-for-tag-based-modes-fix.patch removed from -mm tree
Message-Id: <20220929040227.B616DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: initialize read-write lock in stack ring
has been removed from the -mm tree.  Its filename was
     kasan-implement-stack-ring-for-tag-based-modes-fix.patch

This patch was dropped because it was folded into kasan-implement-stack-ring-for-tag-based-modes.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: initialize read-write lock in stack ring
Date: Tue, 20 Sep 2022 20:58:07 +0200

Use __RW_LOCK_UNLOCKED to initialize stack_ring.lock.

Link: https://lkml.kernel.org/r/576182d194e27531e8090bad809e4136953895f4.1663700262.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kasan/tags.c~kasan-implement-stack-ring-for-tag-based-modes-fix
+++ a/mm/kasan/tags.c
@@ -22,7 +22,9 @@
 /* Non-zero, as initial pointer values are 0. */
 #define STACK_RING_BUSY_PTR ((void *)1)
 
-struct kasan_stack_ring stack_ring;
+struct kasan_stack_ring stack_ring = {
+	.lock = __RW_LOCK_UNLOCKED(stack_ring.lock)
+};
 
 static void save_stack_info(struct kmem_cache *cache, void *object,
 			gfp_t gfp_flags, bool is_free)
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
kasan-better-invalid-double-free-report-header.patch
kasan-fix-array-bounds-warnings-in-tests.patch

