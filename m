Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AE2CA0ECF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbjIKWX0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbjIKSdf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:33:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF4A1A2
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:33:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57ACC433C8;
        Mon, 11 Sep 2023 18:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694457210;
        bh=x8wQH77wZaXZq6+XcKYMfPepWpThD2+J0B2OiH0gj04=;
        h=Date:To:From:Subject:From;
        b=zDJxPUPwbeKBHXm+Z4TGspBB+qlPLlrDGprgtXyUk83brpsKY6v+j1UFmdPPK70ua
         Gn+Q2tmRoQ6z2trROHW5Nn4WYT/VtzFnDtPtunMumJbLbwzleQn+efM2XZw2t22p+d
         N/d1pHUqaJmIkUAoFm0CxxE5mFjGv0nIM9HDtoE0=
Date:   Mon, 11 Sep 2023 11:33:30 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-prevent-optimizations-in-memcpy-tests.patch added to mm-unstable branch
Message-Id: <20230911183330.A57ACC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: prevent optimizations in memcpy tests
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-prevent-optimizations-in-memcpy-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-prevent-optimizations-in-memcpy-tests.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: prevent optimizations in memcpy tests
Date: Mon, 11 Sep 2023 16:57:00 +0200

Clang 18 learned to optimize away memcpy() calls of small uninitialized
scalar values.  To ensure that memcpy tests in kmsan_test.c still perform
calls to memcpy() (which KMSAN replaces with __msan_memcpy()), declare a
separate memcpy_noinline() function with volatile parameters, which won't
be optimized.

Also retire DO_NOT_OPTIMIZE(), as memcpy_noinline() is apparently enough.

Link: https://lkml.kernel.org/r/20230911145702.2663753-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   41 +++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

--- a/mm/kmsan/kmsan_test.c~kmsan-prevent-optimizations-in-memcpy-tests
+++ a/mm/kmsan/kmsan_test.c
@@ -407,33 +407,25 @@ static void test_printk(struct kunit *te
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
-/*
- * Prevent the compiler from optimizing @var away. Without this, Clang may
- * notice that @var is uninitialized and drop memcpy() calls that use it.
- *
- * There is OPTIMIZER_HIDE_VAR() in linux/compier.h that we cannot use here,
- * because it is implemented as inline assembly receiving @var as a parameter
- * and will enforce a KMSAN check. Same is true for e.g. barrier_data(var).
- */
-#define DO_NOT_OPTIMIZE(var) barrier()
+/* Prevent the compiler from inlining a memcpy() call. */
+static noinline void *memcpy_noinline(volatile void *dst,
+				      const volatile void *src, size_t size)
+{
+	return memcpy((void *)dst, (const void *)src, size);
+}
 
-/*
- * Test case: ensure that memcpy() correctly copies initialized values.
- * Also serves as a regression test to ensure DO_NOT_OPTIMIZE() does not cause
- * extra checks.
- */
+/* Test case: ensure that memcpy() correctly copies initialized values. */
 static void test_init_memcpy(struct kunit *test)
 {
 	EXPECTATION_NO_REPORT(expect);
-	volatile int src;
-	volatile int dst = 0;
+	volatile long long src;
+	volatile long long dst = 0;
 
-	DO_NOT_OPTIMIZE(src);
 	src = 1;
 	kunit_info(
 		test,
 		"memcpy()ing aligned initialized src to aligned dst (no reports)\n");
-	memcpy((void *)&dst, (void *)&src, sizeof(src));
+	memcpy_noinline((void *)&dst, (void *)&src, sizeof(src));
 	kmsan_check_memory((void *)&dst, sizeof(dst));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
@@ -451,8 +443,7 @@ static void test_memcpy_aligned_to_align
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to aligned dst (UMR report)\n");
-	DO_NOT_OPTIMIZE(uninit_src);
-	memcpy((void *)&dst, (void *)&uninit_src, sizeof(uninit_src));
+	memcpy_noinline((void *)&dst, (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst, sizeof(dst));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
@@ -474,8 +465,9 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst (UMR report)\n");
-	DO_NOT_OPTIMIZE(uninit_src);
-	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
+	kmsan_check_memory((void *)&uninit_src, sizeof(uninit_src));
+	memcpy_noinline((void *)&dst[1], (void *)&uninit_src,
+			sizeof(uninit_src));
 	kmsan_check_memory((void *)dst, 4);
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
@@ -498,8 +490,8 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst - part 2 (UMR report)\n");
-	DO_NOT_OPTIMIZE(uninit_src);
-	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
+	memcpy_noinline((void *)&dst[1], (void *)&uninit_src,
+			sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst[4], sizeof(uninit_src));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
@@ -513,7 +505,6 @@ static void test_memcpy_aligned_to_unali
                                                                             \
 		kunit_info(test,                                            \
 			   "memset" #size "() should initialize memory\n"); \
-		DO_NOT_OPTIMIZE(uninit);                                    \
 		memset##size((uint##size##_t *)&uninit, 0, 1);              \
 		kmsan_check_memory((void *)&uninit, sizeof(uninit));        \
 		KUNIT_EXPECT_TRUE(test, report_matches(&expect));           \
_

Patches currently in -mm which might be from glider@google.com are

kmsan-simplify-kmsan_internal_memmove_metadata.patch
kmsan-prevent-optimizations-in-memcpy-tests.patch
kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch
kmsan-introduce-test_memcpy_initialized_gap.patch

