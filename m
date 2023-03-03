Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A79C7EE2F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCCFzo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCCFzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A52339B9B
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:55:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAA34B81608
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735D7C433EF;
        Fri,  3 Mar 2023 05:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822898;
        bh=1im1ZVL6+NsvCGqUumIIM6e/l0D2f0bM5uRUENd6h64=;
        h=Date:To:From:Subject:From;
        b=APpByZY/7CgHrQeWPB14mfIt+/PmAsNSwBW7S1aJKQj+1BNNvlC3f8aZZPsDmLBfQ
         ohjDIoS7gTDLmUmMuD2ysvduZk5EKSwcyoN/baKhgKvOi8/KUOXJiUxPmep0geAWsl
         +LErYa2EJXZVER1Gdqh6h7jG/yKkWJCYdC3NmH3E=
Date:   Thu, 02 Mar 2023 21:54:57 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andreyknvl@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-test-fix-test-for-new-meminstrinsic-instrumentation.patch removed from -mm tree
Message-Id: <20230303055458.735D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: test: fix test for new meminstrinsic instrumentation
has been removed from the -mm tree.  Its filename was
     kasan-test-fix-test-for-new-meminstrinsic-instrumentation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: test: fix test for new meminstrinsic instrumentation
Date: Fri, 24 Feb 2023 09:59:41 +0100

The tests for memset/memmove have been failing since they haven't been
instrumented in 69d4c0d32186.

Fix the test to recognize when memintrinsics aren't instrumented, and skip
test cases accordingly.  We also need to conditionally pass -fno-builtin
to the test, otherwise the instrumentation pass won't recognize
memintrinsics and end up not instrumenting them either.

Link: https://lkml.kernel.org/r/20230224085942.1791837-3-elver@google.com
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/kasan_test.c~kasan-test-fix-test-for-new-meminstrinsic-instrumentation
+++ a/mm/kasan/kasan_test.c
@@ -165,6 +165,15 @@ static void kasan_test_exit(struct kunit
 		kunit_skip((test), "Test requires " #config "=n");	\
 } while (0)
 
+#define KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test) do {		\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))				\
+		break;  /* No compiler instrumentation. */		\
+	if (IS_ENABLED(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX))	\
+		break;  /* Should always be instrumented! */		\
+	if (IS_ENABLED(CONFIG_GENERIC_ENTRY))				\
+		kunit_skip((test), "Test requires checked mem*()");	\
+} while (0)
+
 static void kmalloc_oob_right(struct kunit *test)
 {
 	char *ptr;
@@ -454,6 +463,8 @@ static void kmalloc_oob_16(struct kunit
 		u64 words[2];
 	} *ptr1, *ptr2;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	/* This test is specifically crafted for the generic mode. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
 
@@ -476,6 +487,8 @@ static void kmalloc_uaf_16(struct kunit
 		u64 words[2];
 	} *ptr1, *ptr2;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr1 = kmalloc(sizeof(*ptr1), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
@@ -498,6 +511,8 @@ static void kmalloc_oob_memset_2(struct
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -511,6 +526,8 @@ static void kmalloc_oob_memset_4(struct
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -524,6 +541,8 @@ static void kmalloc_oob_memset_8(struct
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -537,6 +556,8 @@ static void kmalloc_oob_memset_16(struct
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -550,6 +571,8 @@ static void kmalloc_oob_in_memset(struct
 	char *ptr;
 	size_t size = 128 - KASAN_GRANULE_SIZE;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -566,6 +589,8 @@ static void kmalloc_memmove_negative_siz
 	size_t size = 64;
 	size_t invalid_size = -2;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	/*
 	 * Hardware tag-based mode doesn't check memmove for negative size.
 	 * As a result, this test introduces a side-effect memory corruption,
@@ -590,6 +615,8 @@ static void kmalloc_memmove_invalid_size
 	size_t size = 64;
 	size_t invalid_size = size;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -618,6 +645,8 @@ static void kmalloc_uaf_memset(struct ku
 	char *ptr;
 	size_t size = 33;
 
+	KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test);
+
 	/*
 	 * Only generic KASAN uses quarantine, which is required to avoid a
 	 * kernel memory corruption this test causes.
--- a/mm/kasan/Makefile~kasan-test-fix-test-for-new-meminstrinsic-instrumentation
+++ a/mm/kasan/Makefile
@@ -35,7 +35,14 @@ CFLAGS_shadow.o := $(CC_FLAGS_KASAN_RUNT
 CFLAGS_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 
-CFLAGS_KASAN_TEST := $(CFLAGS_KASAN) -fno-builtin $(call cc-disable-warning, vla)
+CFLAGS_KASAN_TEST := $(CFLAGS_KASAN) $(call cc-disable-warning, vla)
+ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+# If compiler instruments memintrinsics by prefixing them with __asan/__hwasan,
+# we need to treat them normally (as builtins), otherwise the compiler won't
+# recognize them as instrumentable. If it doesn't instrument them, we need to
+# pass -fno-builtin, so the compiler doesn't inline them.
+CFLAGS_KASAN_TEST += -fno-builtin
+endif
 
 CFLAGS_kasan_test.o := $(CFLAGS_KASAN_TEST)
 CFLAGS_kasan_test_module.o := $(CFLAGS_KASAN_TEST)
_

Patches currently in -mm which might be from elver@google.com are


