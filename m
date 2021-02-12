Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3F2C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 21:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3153764E01
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 21:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhBLVHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231584AbhBLVHi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 16:07:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F296664DEC;
        Fri, 12 Feb 2021 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613164017;
        bh=OMjkx9gvbsrMoZiADmEY96jlevMr3f84aXiE1CDf1TM=;
        h=Date:From:To:Subject:From;
        b=usgs6m6EkpMcyaQXIFdg1Dd2fb8yxm97Fjb4f9Y0bU0KCwteDLjzuxMzwINmlqK4/
         29AjL9iJZ3txeOCbXT94Ux9pfrrzgJAWDJ0x4gVtkeqyC/i5MECqpgiOkfunZuqbxP
         pQu5+2q70g56MsV8DY8rVf9XLqqmDhkfYfsNkUow=
Date:   Fri, 12 Feb 2021 13:06:56 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        vincenzo.frascino@arm.com, pcc@google.com, kevin.brodsky@arm.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, catalin.marinas@arm.com,
        Branislav.Rankov@arm.com, aryabinin@virtuozzo.com,
        andreyknvl@google.com
Subject:  +
 kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch added to -mm
 tree
Message-ID: <20210212210656.Jh25R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: export HW_TAGS symbols for KUnit tests
has been added to the -mm tree.  Its filename is
     kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch

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
Subject: kasan: export HW_TAGS symbols for KUnit tests

Currently, building KASAN-KUnit tests as a module fails with:

ERROR: modpost: "mte_enable_kernel" [lib/test_kasan.ko] undefined!
ERROR: modpost: "mte_set_report_once" [lib/test_kasan.ko] undefined!

This change adds KASAN wrappers for mte_enable_kernel() and
mte_set_report_once() and only defines and exports them when KASAN-KUnit
tests are enabled.

The wrappers aren't defined when tests aren't enabled to avoid misuse.
The mte_() functions aren't exported directly to avoid having low-level
KASAN ifdefs in the arch code.

Link: https://lkml.kernel.org/r/e7eeb252da408b08f0c81b950a55fb852f92000b.1613155970.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c   |    6 +++---
 mm/kasan/hw_tags.c |   16 ++++++++++++++++
 mm/kasan/kasan.h   |   12 ++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

--- a/lib/test_kasan.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix
+++ a/lib/test_kasan.c
@@ -48,13 +48,13 @@ static bool multishot;
 static int kasan_test_init(struct kunit *test)
 {
 	multishot = kasan_save_enable_multi_shot();
-	hw_set_tagging_report_once(false);
+	kasan_set_tagging_report_once(false);
 	return 0;
 }
 
 static void kasan_test_exit(struct kunit *test)
 {
-	hw_set_tagging_report_once(true);
+	kasan_set_tagging_report_once(true);
 	kasan_restore_multi_shot(multishot);
 }
 
@@ -85,7 +85,7 @@ static void kasan_test_exit(struct kunit
 			fail_data.report_found);		\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {			\
 		if (fail_data.report_found)			\
-			hw_enable_tagging();			\
+			kasan_enable_tagging();			\
 		migrate_enable();				\
 	}							\
 } while (0)
--- a/mm/kasan/hw_tags.c~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix
+++ a/mm/kasan/hw_tags.c
@@ -185,3 +185,19 @@ struct kasan_track *kasan_get_free_track
 
 	return &alloc_meta->free_track[0];
 }
+
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+void kasan_set_tagging_report_once(bool state)
+{
+	hw_set_tagging_report_once(state);
+}
+EXPORT_SYMBOL_GPL(kasan_set_tagging_report_once);
+
+void kasan_enable_tagging(void)
+{
+	hw_enable_tagging();
+}
+EXPORT_SYMBOL_GPL(kasan_enable_tagging);
+
+#endif
--- a/mm/kasan/kasan.h~kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix
+++ a/mm/kasan/kasan.h
@@ -307,6 +307,18 @@ static inline const void *arch_kasan_set
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+void kasan_set_tagging_report_once(bool state);
+void kasan_enable_tagging(void);
+
+#else /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+
+static inline void kasan_set_tagging_report_once(bool state) { }
+static inline void kasan_enable_tagging(void) { }
+
+#endif /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+
 #ifdef CONFIG_KASAN_SW_TAGS
 u8 kasan_random_tag(void);
 #elif defined(CONFIG_KASAN_HW_TAGS)
_

Patches currently in -mm which might be from andreyknvl@google.com are

maintainers-update-kasan-file-list.patch
maintainers-update-andrey-konovalovs-email-address.patch
maintainers-add-andrey-konovalov-to-kasan-reviewers.patch
kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode-fix.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

