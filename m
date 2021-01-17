Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D68C433E9
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F613224DE
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbhAQT7t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 14:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbhAQT7g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 14:59:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0AB0224D3;
        Sun, 17 Jan 2021 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610913535;
        bh=TirzKWjHDBOJJGhjvP8vfxenWOYbiR/E96oxdIs+THY=;
        h=Date:From:To:Subject:From;
        b=1NqZm2siF+6AEmxxYrtBTwOlJGM7bFTFc4e4H/wFT/u/NkNAyDvN0hFOnYANxvXp6
         QLSqL12xzYlV+V1GggdqNPyAWUdhitnpQ+2/PRZBlpKTIEeLX+WIfP7j8VhYB6nt6l
         IIWstT+v6GYL6shMyLJ4oErGB54iHhaQQn7s1kks=
Date:   Sun, 17 Jan 2021 11:58:54 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [to-be-updated] kasan-clean-up-comments-in-tests.patch
 removed from -mm tree
Message-ID: <20210117195854.PsE2wf1An%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clean up comments in tests
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-comments-in-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up comments in tests

Clarify and update comments and info messages in KASAN tests.

Link: https://lkml.kernel.org/r/cb4e610c6584251aa2397b56c46e278da0050a25.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I6c816c51fa1e0eb7aa3dead6bda1f339d2af46c8Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c        |   94 +++++++++++++++++++++-----------------
 lib/test_kasan_module.c |    5 +-
 2 files changed, 55 insertions(+), 44 deletions(-)

--- a/lib/test_kasan.c~kasan-clean-up-comments-in-tests
+++ a/lib/test_kasan.c
@@ -28,10 +28,9 @@
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
 /*
- * We assign some test results to these globals to make sure the tests
- * are not eliminated as dead code.
+ * Some tests use these global variables to store return values from function
+ * calls that could otherwise be eliminated by the compiler as dead code.
  */
-
 void *kasan_ptr_result;
 int kasan_int_result;
 
@@ -39,14 +38,13 @@ static struct kunit_resource resource;
 static struct kunit_kasan_expectation fail_data;
 static bool multishot;
 
+/*
+ * Temporarily enable multi-shot mode. Otherwise, KASAN would only report the
+ * first detected bug and panic the kernel if panic_on_warn is enabled.
+ */
 static int kasan_test_init(struct kunit *test)
 {
-	/*
-	 * Temporarily enable multi-shot mode and set panic_on_warn=0.
-	 * Otherwise, we'd only get a report for the first case.
-	 */
 	multishot = kasan_save_enable_multi_shot();
-
 	return 0;
 }
 
@@ -56,12 +54,12 @@ static void kasan_test_exit(struct kunit
 }
 
 /**
- * KUNIT_EXPECT_KASAN_FAIL() - Causes a test failure when the expression does
- * not cause a KASAN error. This uses a KUnit resource named "kasan_data." Do
- * Do not use this name for a KUnit resource outside here.
- *
+ * KUNIT_EXPECT_KASAN_FAIL() - check that the executed expression produces a
+ * KASAN report; causes a test failure otherwise. This relies on a KUnit
+ * resource named "kasan_data". Do not use this name for KUnit resources
+ * outside of KASAN tests.
  */
-#define KUNIT_EXPECT_KASAN_FAIL(test, condition) do { \
+#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do { \
 	fail_data.report_expected = true; \
 	fail_data.report_found = false; \
 	kunit_add_named_resource(test, \
@@ -69,7 +67,7 @@ static void kasan_test_exit(struct kunit
 				NULL, \
 				&resource, \
 				"kasan_data", &fail_data); \
-	condition; \
+	expression; \
 	KUNIT_EXPECT_EQ(test, \
 			fail_data.report_expected, \
 			fail_data.report_found); \
@@ -117,11 +115,12 @@ static void kmalloc_pagealloc_oob_right(
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
 	if (!IS_ENABLED(CONFIG_SLUB)) {
-		kunit_info(test, "CONFIG_SLUB is not enabled.");
+		kunit_info(test, "skipping, CONFIG_SLUB required");
 		return;
 	}
 
-	/* Allocate a chunk that does not fit into a SLUB cache to trigger
+	/*
+	 * Allocate a chunk that does not fit into a SLUB cache to trigger
 	 * the page allocator fallback.
 	 */
 	ptr = kmalloc(size, GFP_KERNEL);
@@ -137,7 +136,7 @@ static void kmalloc_pagealloc_uaf(struct
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
 	if (!IS_ENABLED(CONFIG_SLUB)) {
-		kunit_info(test, "CONFIG_SLUB is not enabled.");
+		kunit_info(test, "skipping, CONFIG_SLUB required");
 		return;
 	}
 
@@ -154,7 +153,7 @@ static void kmalloc_pagealloc_invalid_fr
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
 	if (!IS_ENABLED(CONFIG_SLUB)) {
-		kunit_info(test, "CONFIG_SLUB is not enabled.");
+		kunit_info(test, "skipping, CONFIG_SLUB required");
 		return;
 	}
 
@@ -168,7 +167,9 @@ static void kmalloc_large_oob_right(stru
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE - 256;
-	/* Allocate a chunk that is large enough, but still fits into a slab
+
+	/*
+	 * Allocate a chunk that is large enough, but still fits into a slab
 	 * and does not trigger the page allocator fallback in SLUB.
 	 */
 	ptr = kmalloc(size, GFP_KERNEL);
@@ -218,7 +219,7 @@ static void kmalloc_oob_16(struct kunit
 
 	/* This test is specifically crafted for the generic mode. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_GENERIC required\n");
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC required");
 		return;
 	}
 
@@ -454,7 +455,7 @@ static void kasan_global_oob(struct kuni
 
 	/* Only generic mode instruments globals. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC required");
 		return;
 	}
 
@@ -469,10 +470,13 @@ static void ksize_unpoisons_memory(struc
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	real_size = ksize(ptr);
-	/* This access doesn't trigger an error. */
+
+	/* This access shouldn't trigger a KASAN report. */
 	ptr[size] = 'x';
-	/* This one does. */
+
+	/* This one must. */
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[real_size] = 'y');
+
 	kfree(ptr);
 }
 
@@ -483,7 +487,7 @@ static void kasan_stack_oob(struct kunit
 	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
 
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
-		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
+		kunit_info(test, "skipping, CONFIG_KASAN_STACK required");
 		return;
 	}
 
@@ -498,12 +502,12 @@ static void kasan_alloca_oob_left(struct
 
 	/* Only generic mode instruments dynamic allocas. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC required");
 		return;
 	}
 
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
-		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
+		kunit_info(test, "skipping, CONFIG_KASAN_STACK required");
 		return;
 	}
 
@@ -518,12 +522,12 @@ static void kasan_alloca_oob_right(struc
 
 	/* Only generic mode instruments dynamic allocas. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC required");
 		return;
 	}
 
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
-		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
+		kunit_info(test, "skipping, CONFIG_KASAN_STACK required");
 		return;
 	}
 
@@ -568,7 +572,7 @@ static void kmem_cache_invalid_free(stru
 		return;
 	}
 
-	/* Trigger invalid free, the object doesn't get freed */
+	/* Trigger invalid free, the object doesn't get freed. */
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p + 1));
 
 	/*
@@ -585,10 +589,12 @@ static void kasan_memchr(struct kunit *t
 	char *ptr;
 	size_t size = 24;
 
-	/* See https://bugzilla.kernel.org/show_bug.cgi?id=206337 */
+	/*
+	 * str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT.
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=206337 for details.
+	 */
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
-		kunit_info(test,
-			"str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT");
+		kunit_info(test, "skipping, CONFIG_AMD_MEM_ENCRYPT enabled");
 		return;
 	}
 
@@ -610,10 +616,12 @@ static void kasan_memcmp(struct kunit *t
 	size_t size = 24;
 	int arr[9];
 
-	/* See https://bugzilla.kernel.org/show_bug.cgi?id=206337 */
+	/*
+	 * str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT.
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=206337 for details.
+	 */
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
-		kunit_info(test,
-			"str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT");
+		kunit_info(test, "skipping, CONFIG_AMD_MEM_ENCRYPT enabled");
 		return;
 	}
 
@@ -634,10 +642,12 @@ static void kasan_strings(struct kunit *
 	char *ptr;
 	size_t size = 24;
 
-	/* See https://bugzilla.kernel.org/show_bug.cgi?id=206337 */
+	/*
+	 * str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT.
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=206337 for details.
+	 */
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
-		kunit_info(test,
-			"str* functions are not instrumented with CONFIG_AMD_MEM_ENCRYPT");
+		kunit_info(test, "skipping, CONFIG_AMD_MEM_ENCRYPT enabled");
 		return;
 	}
 
@@ -701,12 +711,12 @@ static void kasan_bitops_generic(struct
 
 	/* This test is specifically crafted for the generic mode. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_GENERIC required\n");
+		kunit_info(test, "skipping, CONFIG_KASAN_GENERIC required");
 		return;
 	}
 
 	/*
-	 * Allocate 1 more byte, which causes kzalloc to round up to 16-bytes;
+	 * Allocate 1 more byte, which causes kzalloc to round up to 16 bytes;
 	 * this way we do not actually corrupt other memory.
 	 */
 	bits = kzalloc(sizeof(*bits) + 1, GFP_KERNEL);
@@ -733,7 +743,7 @@ static void kasan_bitops_tags(struct kun
 
 	/* This test is specifically crafted for the tag-based mode. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "CONFIG_KASAN_SW_TAGS required\n");
+		kunit_info(test, "skipping, CONFIG_KASAN_SW_TAGS required");
 		return;
 	}
 
@@ -765,7 +775,7 @@ static void vmalloc_oob(struct kunit *te
 	void *area;
 
 	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
-		kunit_info(test, "CONFIG_KASAN_VMALLOC is not enabled.");
+		kunit_info(test, "skipping, CONFIG_KASAN_VMALLOC required");
 		return;
 	}
 
--- a/lib/test_kasan_module.c~kasan-clean-up-comments-in-tests
+++ a/lib/test_kasan_module.c
@@ -123,8 +123,9 @@ static noinline void __init kasan_workqu
 static int __init test_kasan_module_init(void)
 {
 	/*
-	 * Temporarily enable multi-shot mode. Otherwise, we'd only get a
-	 * report for the first case.
+	 * Temporarily enable multi-shot mode. Otherwise, KASAN would only
+	 * report the first detected bug and panic the kernel if panic_on_warn
+	 * is enabled.
 	 */
 	bool multishot = kasan_save_enable_multi_shot();
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-hw_tags-boot-parameters.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adopt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

