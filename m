Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA00C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245366AbiCBVhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245347AbiCBVg5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:36:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E438C7C3C
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BC8A619D2
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E49FC004E1;
        Wed,  2 Mar 2022 21:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256971;
        bh=F/MEt/YXbvAjjhNy2q8DbW7a7jizb/7kPpPwd8dFsjg=;
        h=Date:To:From:Subject:From;
        b=x2gVo9FZx9GZFnrRvjOwaBq4qdSFcVEcK6oP1HDtLqklb47QKEviYzviwR3d86Cxa
         y5QY6s+Z515Wjw2D3R5JHIDO+oaYjylj5cswoPyNqhDfwDvGzg8tKZFKfJ9QgDAtdY
         LQd52ZcYHo01tLf+0RCAB0OpBKtC2aCeAZQVg5dA=
Date:   Wed, 02 Mar 2022 13:36:10 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch added to -mm tree
Message-Id: <20220302213611.7E49FC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT
has been added to the -mm tree.  Its filename is
     kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch

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
Subject: kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT

Check the more specific CONFIG_KASAN_KUNIT_TEST config option when
defining things related to KUnit-compatible KASAN tests instead of
CONFIG_KUNIT.

Also put the kunit_kasan_status definition next to the definitons of other
KASAN-related structs.

Link: https://lkml.kernel.org/r/223592d38d2a601a160a3b2b3d5a9f9090350e62.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |   18 ++++++++----------
 mm/kasan/report.c |    2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/mm/kasan/kasan.h~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/kasan.h
@@ -7,16 +7,6 @@
 #include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
-#if IS_ENABLED(CONFIG_KUNIT)
-
-/* Used in KUnit-compatible KASAN tests. */
-struct kunit_kasan_status {
-	bool report_found;
-	bool sync_fault;
-};
-
-#endif
-
 #ifdef CONFIG_KASAN_HW_TAGS
 
 #include <linux/static_key.h>
@@ -224,6 +214,14 @@ struct kasan_free_meta {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+/* Used in KUnit-compatible KASAN tests. */
+struct kunit_kasan_status {
+	bool report_found;
+	bool sync_fault;
+};
+#endif
+
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 #ifdef CONFIG_KASAN_GENERIC
--- a/mm/kasan/report.c~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/report.c
@@ -356,7 +356,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KUNIT)
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 static void update_kunit_status(bool sync)
 {
 	struct kunit *test;
_

Patches currently in -mm which might be from andreyknvl@google.com are

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
kasan-print-virtual-mapping-info-in-reports.patch
kasan-drop-addr-check-from-describe_object_addr.patch
kasan-more-line-breaks-in-reports.patch
kasan-rearrange-stack-frame-info-in-reports.patch
kasan-improve-stack-frame-info-in-reports.patch
kasan-print-basic-stack-frame-info-for-sw_tags.patch
kasan-simplify-async-check-in-end_report.patch
kasan-simplify-kasan_update_kunit_status-and-call-sites.patch
kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch
kasan-move-update_kunit_status-to-start_report.patch
kasan-move-disable_trace_on_warning-to-start_report.patch
kasan-split-out-print_report-from-__kasan_report.patch
kasan-simplify-kasan_find_first_bad_addr-call-sites.patch
kasan-restructure-kasan_report.patch
kasan-merge-__kasan_report-into-kasan_report.patch
kasan-call-print_report-from-kasan_report_invalid_free.patch
kasan-move-and-simplify-kasan_report_async.patch
kasan-rename-kasan_access_info-to-kasan_report_info.patch
kasan-add-comment-about-uaccess-regions-to-kasan_report.patch
kasan-respect-kasan_bit_reported-in-all-reporting-routines.patch
kasan-reorder-reporting-functions.patch
kasan-move-and-hide-kasan_save_enable-restore_multi_shot.patch
kasan-disable-lockdep-when-printing-reports.patch

