Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97282C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 03:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiBWD4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiBWD4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 22:56:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB29966ADD
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 19:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77411616B0
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 03:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB5FC340E7;
        Wed, 23 Feb 2022 03:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645588575;
        bh=3tfhgVB+cl5AAxz5WhAzlu1DORXqU2lHAZTKxEqleZM=;
        h=Date:To:From:Subject:From;
        b=Df40CAZNbKDVStzOjeF6qS3Y+QNXPFqhfIWX3LNx7lh68K19GkyyZHHa/ptMEPBfy
         3XgbP1t/O/1WPIgk4S5Geqk1TfkrYseRjuLpdQASaRsCcDcww1v/wel10FS1xj37rL
         xnELsmJsMtC4t8aFf10U3GWI0L5JgovNzOG4amrk=
Date:   Tue, 22 Feb 2022 19:56:15 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-improve-vmalloc-tests-fix-3.patch added to -mm tree
Message-Id: <20220223035615.CBB5FC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: another fix for "kasan: improve vmalloc tests"
has been added to the -mm tree.  Its filename is
     kasan-improve-vmalloc-tests-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-vmalloc-tests-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-vmalloc-tests-fix-3.patch

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
Subject: another fix for "kasan: improve vmalloc tests"

set_memory_rw/ro() are not exported to be used in modules and thus
cannot be used in KUnit-compatible KASAN tests.

Do the checks that rely on these functions only when the tests are
built-in.

Link: https://lkml.kernel.org/r/019ac41602e0c4a7dfe96dc8158a95097c2b2ebd.1645554036.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix-3
+++ a/lib/test_kasan.c
@@ -1079,11 +1079,13 @@ static void vmalloc_helpers_tags(struct
 	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
 
+#if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
 	/* Make sure vmalloc'ed memory permissions can be changed. */
 	rv = set_memory_ro((unsigned long)ptr, 1);
 	KUNIT_ASSERT_GE(test, rv, 0);
 	rv = set_memory_rw((unsigned long)ptr, 1);
 	KUNIT_ASSERT_GE(test, rv, 0);
+#endif
 
 	vfree(ptr);
 }
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
kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch
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
kasan-improve-vmalloc-tests-fix-2.patch
kasan-improve-vmalloc-tests-fix-3.patch
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch

