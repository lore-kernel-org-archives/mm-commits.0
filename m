Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9C6C77B6E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjC1XWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjC1XVk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D371985
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B383D619A3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A444C433D2;
        Tue, 28 Mar 2023 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045692;
        bh=cNOWiSoTtxQRbpDxc5WztpNrHtFKskPUnyFtfljvG5c=;
        h=Date:To:From:Subject:From;
        b=Cg0b6g8bAJYeJ44+lOfkuV2XsnEJ4xMs5CovK/IOsgKPKDhxsbcSYHIHZ09hUFfVp
         jpVcYerCNsA8RThwqBGQXVp2TxXk59TrgWfoRrlQEj7w3YNlSjFZxNPAyv2rDtnxeo
         3qs4xtyTs8x0r6JJ0HDbDhJK528dWgK+0sO6WKKs=
Date:   Tue, 28 Mar 2023 16:21:31 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-another-take-at-fixing-memcpy-tests.patch removed from -mm tree
Message-Id: <20230328232132.1A444C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: another take at fixing memcpy tests
has been removed from the -mm tree.  Its filename was
     kmsan-another-take-at-fixing-memcpy-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: another take at fixing memcpy tests
Date: Fri, 3 Mar 2023 15:14:31 +0100

commit 5478afc55a21 ("kmsan: fix memcpy tests") uses OPTIMIZER_HIDE_VAR()
to hide the uninitialized var from the compiler optimizations.

However OPTIMIZER_HIDE_VAR(uninit) enforces an immediate check of @uninit,
so memcpy tests did not actually check the behavior of memcpy(), because
they always contained a KMSAN report.

Replace OPTIMIZER_HIDE_VAR() with a file-local macro that just clobbers
the memory with a barrier(), and add a test case for memcpy() that does
not expect an error report.

Also reflow kmsan_test.c with clang-format.

Link: https://lkml.kernel.org/r/20230303141433.3422671-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   44 ++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

--- a/mm/kmsan/kmsan_test.c~kmsan-another-take-at-fixing-memcpy-tests
+++ a/mm/kmsan/kmsan_test.c
@@ -408,6 +408,37 @@ static void test_printk(struct kunit *te
 }
 
 /*
+ * Prevent the compiler from optimizing @var away. Without this, Clang may
+ * notice that @var is uninitialized and drop memcpy() calls that use it.
+ *
+ * There is OPTIMIZER_HIDE_VAR() in linux/compier.h that we cannot use here,
+ * because it is implemented as inline assembly receiving @var as a parameter
+ * and will enforce a KMSAN check. Same is true for e.g. barrier_data(var).
+ */
+#define DO_NOT_OPTIMIZE(var) barrier()
+
+/*
+ * Test case: ensure that memcpy() correctly copies initialized values.
+ * Also serves as a regression test to ensure DO_NOT_OPTIMIZE() does not cause
+ * extra checks.
+ */
+static void test_init_memcpy(struct kunit *test)
+{
+	EXPECTATION_NO_REPORT(expect);
+	volatile int src;
+	volatile int dst = 0;
+
+	DO_NOT_OPTIMIZE(src);
+	src = 1;
+	kunit_info(
+		test,
+		"memcpy()ing aligned initialized src to aligned dst (no reports)\n");
+	memcpy((void *)&dst, (void *)&src, sizeof(src));
+	kmsan_check_memory((void *)&dst, sizeof(dst));
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
+/*
  * Test case: ensure that memcpy() correctly copies uninitialized values between
  * aligned `src` and `dst`.
  */
@@ -420,7 +451,7 @@ static void test_memcpy_aligned_to_align
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to aligned dst (UMR report)\n");
-	OPTIMIZER_HIDE_VAR(uninit_src);
+	DO_NOT_OPTIMIZE(uninit_src);
 	memcpy((void *)&dst, (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst, sizeof(dst));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
@@ -443,7 +474,7 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst (UMR report)\n");
-	OPTIMIZER_HIDE_VAR(uninit_src);
+	DO_NOT_OPTIMIZE(uninit_src);
 	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)dst, 4);
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
@@ -467,13 +498,14 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst - part 2 (UMR report)\n");
-	OPTIMIZER_HIDE_VAR(uninit_src);
+	DO_NOT_OPTIMIZE(uninit_src);
 	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst[4], sizeof(uninit_src));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
-static noinline void fibonacci(int *array, int size, int start) {
+static noinline void fibonacci(int *array, int size, int start)
+{
 	if (start < 2 || (start == size))
 		return;
 	array[start] = array[start - 1] + array[start - 2];
@@ -482,8 +514,7 @@ static noinline void fibonacci(int *arra
 
 static void test_long_origin_chain(struct kunit *test)
 {
-	EXPECTATION_UNINIT_VALUE_FN(expect,
-				    "test_long_origin_chain");
+	EXPECTATION_UNINIT_VALUE_FN(expect, "test_long_origin_chain");
 	/* (KMSAN_MAX_ORIGIN_DEPTH * 2) recursive calls to fibonacci(). */
 	volatile int accum[KMSAN_MAX_ORIGIN_DEPTH * 2 + 2];
 	int last = ARRAY_SIZE(accum) - 1;
@@ -515,6 +546,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_uaf),
 	KUNIT_CASE(test_percpu_propagate),
 	KUNIT_CASE(test_printk),
+	KUNIT_CASE(test_init_memcpy),
 	KUNIT_CASE(test_memcpy_aligned_to_aligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned2),
_

Patches currently in -mm which might be from glider@google.com are


