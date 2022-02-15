Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334AFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 21:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbiBOV3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 16:29:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbiBOV3k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 16:29:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F52BC24AD
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 13:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35666B81C23
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 21:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64F4C340EB;
        Tue, 15 Feb 2022 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644960565;
        bh=JsjJT2bzebuj/biVjGLjWCvr7cJkpca9wtf56U86N04=;
        h=Date:To:From:Subject:From;
        b=ULyC16g2FBErBgA7leUyhy57CHSv4xo6LD5pwE0uTKygIRvMV3DziB5fPEHU9w6YT
         ficZqHh+dPI+HmPqkivoe6vDumhk8bw8VvJFjChpRprT/09s3+Mdre22a+82FvNMsg
         JTlhceIBcn1TYAl9FgoOnIN+1/936SbP7qMwjrMk=
Date:   Tue, 15 Feb 2022 13:29:25 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch added to -mm tree
Message-Id: <20220215212925.C64F4C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: support async (again) and asymm modes for HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch

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
Subject: kasan: test: support async (again) and asymm modes for HW_TAGS

Async mode support has already been implemented in commit e80a76aa1a91
("kasan, arm64: tests supports for HW_TAGS async mode") but then got
accidentally broken in commit 99734b535d9b ("kasan: detect false-positives
in tests").

Restore the changes removed by the latter patch and adapt them for asymm
mode: add a sync_fault flag to kunit_kasan_expectation that only get set
if the MTE fault was synchronous, and reenable MTE on such faults in
tests.

Also rename kunit_kasan_expectation to kunit_kasan_status and move its
definition to mm/kasan/kasan.h from include/linux/kasan.h, as this
structure is only internally used by KASAN.

Link: https://lkml.kernel.org/r/51ae4a56205a41953971113ab2c264c7e2e5d969.1644938763.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    5 -----
 lib/test_kasan.c      |   39 ++++++++++++++++++++++-----------------
 mm/kasan/hw_tags.c    |   18 +++++++++---------
 mm/kasan/kasan.h      |   14 ++++++++++++--
 mm/kasan/report.c     |   17 +++++++++--------
 5 files changed, 52 insertions(+), 41 deletions(-)

--- a/include/linux/kasan.h~kasan-test-support-async-again-and-asymm-modes-for-hw_tags
+++ a/include/linux/kasan.h
@@ -18,11 +18,6 @@ struct task_struct;
 #include <linux/linkage.h>
 #include <asm/kasan.h>
 
-/* kasan_data struct is used in KUnit tests for KASAN expected failures */
-struct kunit_kasan_expectation {
-	bool report_found;
-};
-
 #endif
 
 typedef unsigned int __bitwise kasan_vmalloc_flags_t;
--- a/lib/test_kasan.c~kasan-test-support-async-again-and-asymm-modes-for-hw_tags
+++ a/lib/test_kasan.c
@@ -37,7 +37,7 @@ void *kasan_ptr_result;
 int kasan_int_result;
 
 static struct kunit_resource resource;
-static struct kunit_kasan_expectation fail_data;
+static struct kunit_kasan_status test_status;
 static bool multishot;
 
 /*
@@ -54,58 +54,63 @@ static int kasan_test_init(struct kunit
 	}
 
 	multishot = kasan_save_enable_multi_shot();
-	fail_data.report_found = false;
+	test_status.report_found = false;
+	test_status.sync_fault = false;
 	kunit_add_named_resource(test, NULL, NULL, &resource,
-					"kasan_data", &fail_data);
+					"kasan_status", &test_status);
 	return 0;
 }
 
 static void kasan_test_exit(struct kunit *test)
 {
 	kasan_restore_multi_shot(multishot);
-	KUNIT_EXPECT_FALSE(test, fail_data.report_found);
+	KUNIT_EXPECT_FALSE(test, test_status.report_found);
 }
 
 /**
  * KUNIT_EXPECT_KASAN_FAIL() - check that the executed expression produces a
  * KASAN report; causes a test failure otherwise. This relies on a KUnit
- * resource named "kasan_data". Do not use this name for KUnit resources
+ * resource named "kasan_status". Do not use this name for KUnit resources
  * outside of KASAN tests.
  *
- * For hardware tag-based KASAN in sync mode, when a tag fault happens, tag
+ * For hardware tag-based KASAN, when a synchronous tag fault happens, tag
  * checking is auto-disabled. When this happens, this test handler reenables
  * tag checking. As tag checking can be only disabled or enabled per CPU,
  * this handler disables migration (preemption).
  *
- * Since the compiler doesn't see that the expression can change the fail_data
+ * Since the compiler doesn't see that the expression can change the test_status
  * fields, it can reorder or optimize away the accesses to those fields.
  * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
  * expression to prevent that.
  *
- * In between KUNIT_EXPECT_KASAN_FAIL checks, fail_data.report_found is kept as
- * false. This allows detecting KASAN reports that happen outside of the checks
- * by asserting !fail_data.report_found at the start of KUNIT_EXPECT_KASAN_FAIL
- * and in kasan_test_exit.
+ * In between KUNIT_EXPECT_KASAN_FAIL checks, test_status.report_found is kept
+ * as false. This allows detecting KASAN reports that happen outside of the
+ * checks by asserting !test_status.report_found at the start of
+ * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
  */
 #define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {			\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
 	    kasan_sync_fault_possible())				\
 		migrate_disable();					\
-	KUNIT_EXPECT_FALSE(test, READ_ONCE(fail_data.report_found));	\
+	KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));	\
 	barrier();							\
 	expression;							\
 	barrier();							\
-	if (!READ_ONCE(fail_data.report_found)) {			\
+	if (kasan_async_fault_possible())				\
+		kasan_force_async_fault();				\
+	if (!READ_ONCE(test_status.report_found)) {			\
 		KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "	\
 				"expected in \"" #expression		\
 				 "\", but none occurred");		\
 	}								\
-	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {				\
-		if (READ_ONCE(fail_data.report_found))			\
-			kasan_enable_tagging_sync();			\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
+	    kasan_sync_fault_possible()) {				\
+		if (READ_ONCE(test_status.report_found) &&		\
+		    READ_ONCE(test_status.sync_fault))			\
+			kasan_enable_tagging();				\
 		migrate_enable();					\
 	}								\
-	WRITE_ONCE(fail_data.report_found, false);			\
+	WRITE_ONCE(test_status.report_found, false);			\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
--- a/mm/kasan/hw_tags.c~kasan-test-support-async-again-and-asymm-modes-for-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -172,12 +172,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * Enable async or asymm modes only when explicitly requested
 	 * through the command line.
 	 */
-	if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
-		hw_enable_tagging_async();
-	else if (kasan_arg_mode == KASAN_ARG_MODE_ASYMM)
-		hw_enable_tagging_asymm();
-	else
-		hw_enable_tagging_sync();
+	kasan_enable_tagging();
 }
 
 /* kasan_init_hw_tags() is called once on boot CPU. */
@@ -343,11 +338,16 @@ void __kasan_poison_vmalloc(const void *
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-void kasan_enable_tagging_sync(void)
+void kasan_enable_tagging(void)
 {
-	hw_enable_tagging_sync();
+	if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
+		hw_enable_tagging_async();
+	else if (kasan_arg_mode == KASAN_ARG_MODE_ASYMM)
+		hw_enable_tagging_asymm();
+	else
+		hw_enable_tagging_sync();
 }
-EXPORT_SYMBOL_GPL(kasan_enable_tagging_sync);
+EXPORT_SYMBOL_GPL(kasan_enable_tagging);
 
 void kasan_force_async_fault(void)
 {
--- a/mm/kasan/kasan.h~kasan-test-support-async-again-and-asymm-modes-for-hw_tags
+++ a/mm/kasan/kasan.h
@@ -7,6 +7,16 @@
 #include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
+#ifdef CONFIG_KASAN_KUNIT_TEST
+
+/* Used in KUnit-compatible KASAN tests. */
+struct kunit_kasan_status {
+	bool report_found;
+	bool sync_fault;
+};
+
+#endif
+
 #ifdef CONFIG_KASAN_HW_TAGS
 
 #include <linux/static_key.h>
@@ -350,12 +360,12 @@ static inline const void *arch_kasan_set
 
 #if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-void kasan_enable_tagging_sync(void);
+void kasan_enable_tagging(void);
 void kasan_force_async_fault(void);
 
 #else /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
 
-static inline void kasan_enable_tagging_sync(void) { }
+static inline void kasan_enable_tagging(void) { }
 static inline void kasan_force_async_fault(void) { }
 
 #endif /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
--- a/mm/kasan/report.c~kasan-test-support-async-again-and-asymm-modes-for-hw_tags
+++ a/mm/kasan/report.c
@@ -344,20 +344,21 @@ static bool report_enabled(void)
 }
 
 #if IS_ENABLED(CONFIG_KUNIT)
-static void kasan_update_kunit_status(struct kunit *cur_test)
+static void kasan_update_kunit_status(struct kunit *cur_test, bool sync)
 {
 	struct kunit_resource *resource;
-	struct kunit_kasan_expectation *kasan_data;
+	struct kunit_kasan_status *status;
 
-	resource = kunit_find_named_resource(cur_test, "kasan_data");
+	resource = kunit_find_named_resource(cur_test, "kasan_status");
 
 	if (!resource) {
 		kunit_set_failure(cur_test);
 		return;
 	}
 
-	kasan_data = (struct kunit_kasan_expectation *)resource->data;
-	WRITE_ONCE(kasan_data->report_found, true);
+	status = (struct kunit_kasan_status *)resource->data;
+	WRITE_ONCE(status->report_found, true);
+	WRITE_ONCE(status->sync_fault, sync);
 	kunit_put_resource(resource);
 }
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
@@ -371,7 +372,7 @@ void kasan_report_invalid_free(void *obj
 
 #if IS_ENABLED(CONFIG_KUNIT)
 	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test);
+		kasan_update_kunit_status(current->kunit_test, true);
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
 
 	start_report(&flags);
@@ -391,7 +392,7 @@ void kasan_report_async(void)
 
 #if IS_ENABLED(CONFIG_KUNIT)
 	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test);
+		kasan_update_kunit_status(current->kunit_test, false);
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
 
 	start_report(&flags);
@@ -413,7 +414,7 @@ static void __kasan_report(unsigned long
 
 #if IS_ENABLED(CONFIG_KUNIT)
 	if (current->kunit_test)
-		kasan_update_kunit_status(current->kunit_test);
+		kasan_update_kunit_status(current->kunit_test, true);
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
 
 	disable_trace_on_warning();
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
kasan-improve-vmalloc-tests-fix-2.patch
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch

