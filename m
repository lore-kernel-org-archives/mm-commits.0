Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E30C47084
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387707AbiBHW0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386397AbiBHUX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:23:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A38AC0613CB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A10CB615B1
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D9EC004E1;
        Tue,  8 Feb 2022 20:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644351805;
        bh=mVLcJRxUSQhdDKUMlpCrExRijpdZd6sGW7D1E8292JA=;
        h=Date:To:From:Subject:From;
        b=HmG7bd2Ps+socOP2TatNQ6RWzQBuWCXogXi+JijCUnM0WT9FtDBjTONev6EcoOyvX
         96mP1WnuIj6NXvWEE1aBgwfILEFrNcaqc/lUroTnXvbyQpQ9c2KItiM6RlvJgqeDtu
         PB8bVCi0ndpteIsUWukhCQCfqI+W9hXhKNZaKiCY=
Date:   Tue, 08 Feb 2022 12:23:24 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch added to -mm tree
Message-Id: <20220208202324.E8D9EC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: prevent cache merging in kmem_cache_double_destroy
has been added to the -mm tree.  Its filename is
     kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch

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
Subject: kasan: test: prevent cache merging in kmem_cache_double_destroy

With HW_TAGS KASAN and kasan.stacktrace=off, the cache created in the
kmem_cache_double_destroy() test might get merged with an existing one. 
Thus, the first kmem_cache_destroy() call won't actually destroy it but
will only decrease the refcount.  This causes the test to fail.

Provide an empty constructor for the created cache to prevent the cache
from getting merged.

Link: https://lkml.kernel.org/r/b597bd434c49591d8af00ee3993a42c609dc9a59.1644346040.git.andreyknvl@google.com
Fixes: f98f966cd750 ("kasan: test: add test case for double-kmem_cache_destroy()")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy
+++ a/lib/test_kasan.c
@@ -869,11 +869,14 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+static void empty_cache_ctor(void *object) { }
+
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
 
-	cache = kmem_cache_create("test_cache", 200, 0, 0, NULL);
+	/* Provide a constructor to prevent cache merging. */
+	cache = kmem_cache_create("test_cache", 200, 0, 0, empty_cache_ctor);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 	kmem_cache_destroy(cache);
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch
kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch
kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch
kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch
kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch
kasan-page_alloc-init-memory-of-skipped-pages-on-free.patch
kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch
mm-clarify-__gfp_zerotags-comment.patch
kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch
kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch
kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook.patch
kasan-page_alloc-combine-tag_clear_highpage-calls-in-post_alloc_hook.patch
kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch
kasan-page_alloc-move-kernel_init_free_pages-in-post_alloc_hook.patch
kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch
kasan-clean-up-metadata-byte-definitions.patch
kasan-define-kasan_vmalloc_invalid-for-sw_tags.patch
kasan-x86-arm64-s390-rename-functions-for-modules-shadow.patch
kasan-vmalloc-drop-outdated-vm_kasan-comment.patch
kasan-reorder-vmalloc-hooks.patch
kasan-add-wrappers-for-vmalloc-hooks.patch
kasan-vmalloc-reset-tags-in-vmalloc-functions.patch
kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch
kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch
kasan-vmalloc-add-vmalloc-tagging-for-sw_tags.patch
kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch
kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch
kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags.patch
kasan-page_alloc-allow-skipping-unpoisoning-for-hw_tags.patch
kasan-page_alloc-allow-skipping-memory-init-for-hw_tags.patch
kasan-vmalloc-add-vmalloc-tagging-for-hw_tags.patch
kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch
kasan-arm64-dont-tag-executable-vmalloc-allocations.patch
kasan-mark-kasan_arg_stacktrace-as-__initdata.patch
kasan-clean-up-feature-flags-for-hw_tags-mode.patch
kasan-add-kasanvmalloc-command-line-flag.patch
kasan-allow-enabling-kasan_vmalloc-and-sw-hw_tags.patch
arm64-select-kasan_vmalloc-for-sw-hw_tags-modes.patch
kasan-documentation-updates.patch
kasan-improve-vmalloc-tests.patch

