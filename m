Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363F5CA0ED0
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbjIKWYB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243963AbjIKSdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:33:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5283F1A2
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:33:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8073C433C7;
        Mon, 11 Sep 2023 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694457214;
        bh=J8WG2ec7ZewjNSc2IJRixIDxzSG27Vc99KZjsZFHaZA=;
        h=Date:To:From:Subject:From;
        b=m2v3hvdgWBpPxbMFAW3QApuIwJh9DUJLki4rNCwMXnNeRB28Jm3m7clYibSxXOrZu
         AGld1eBPi9ToNmm7XSPJHnN7riiP/+//JHrXLrwpCnPqfGRdX4g/xbo+ljmrg28JqD
         FQ92P/K/c4i64Umn1RwtyRjjoWOkbAtyvk+jncAk=
Date:   Mon, 11 Sep 2023 11:33:33 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch added to mm-unstable branch
Message-Id: <20230911183333.D8073C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: merge test_memcpy_aligned_to_unaligned{,2}() together
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch

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
Subject: kmsan: merge test_memcpy_aligned_to_unaligned{,2}() together
Date: Mon, 11 Sep 2023 16:57:01 +0200

Introduce report_reset() that allows checking for more than one KMSAN
report per testcase.

Fold test_memcpy_aligned_to_unaligned2() into
test_memcpy_aligned_to_unaligned(), so that they share the setup phase and
check the behavior of a single memcpy() call.

Link: https://lkml.kernel.org/r/20230911145702.2663753-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

--- a/mm/kmsan/kmsan_test.c~kmsan-merge-test_memcpy_aligned_to_unaligned2-together
+++ a/mm/kmsan/kmsan_test.c
@@ -67,6 +67,17 @@ static bool report_available(void)
 	return READ_ONCE(observed.available);
 }
 
+/* Reset observed.available, so that the test can trigger another report. */
+static void report_reset(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&observed.lock, flags);
+	WRITE_ONCE(observed.available, false);
+	observed.ignore = false;
+	spin_unlock_irqrestore(&observed.lock, flags);
+}
+
 /* Information we expect in a report. */
 struct expect_report {
 	const char *error_type; /* Error type. */
@@ -454,7 +465,7 @@ static void test_memcpy_aligned_to_align
  *
  * Copying aligned 4-byte value to an unaligned one leads to touching two
  * aligned 4-byte values. This test case checks that KMSAN correctly reports an
- * error on the first of the two values.
+ * error on the mentioned two values.
  */
 static void test_memcpy_aligned_to_unaligned(struct kunit *test)
 {
@@ -470,28 +481,7 @@ static void test_memcpy_aligned_to_unali
 			sizeof(uninit_src));
 	kmsan_check_memory((void *)dst, 4);
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
-}
-
-/*
- * Test case: ensure that memcpy() correctly copies uninitialized values between
- * aligned `src` and unaligned `dst`.
- *
- * Copying aligned 4-byte value to an unaligned one leads to touching two
- * aligned 4-byte values. This test case checks that KMSAN correctly reports an
- * error on the second of the two values.
- */
-static void test_memcpy_aligned_to_unaligned2(struct kunit *test)
-{
-	EXPECTATION_UNINIT_VALUE_FN(expect,
-				    "test_memcpy_aligned_to_unaligned2");
-	volatile int uninit_src;
-	volatile char dst[8] = { 0 };
-
-	kunit_info(
-		test,
-		"memcpy()ing aligned uninit src to unaligned dst - part 2 (UMR report)\n");
-	memcpy_noinline((void *)&dst[1], (void *)&uninit_src,
-			sizeof(uninit_src));
+	report_reset();
 	kmsan_check_memory((void *)&dst[4], sizeof(uninit_src));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
@@ -589,7 +579,6 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_init_memcpy),
 	KUNIT_CASE(test_memcpy_aligned_to_aligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned),
-	KUNIT_CASE(test_memcpy_aligned_to_unaligned2),
 	KUNIT_CASE(test_memset16),
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
_

Patches currently in -mm which might be from glider@google.com are

kmsan-simplify-kmsan_internal_memmove_metadata.patch
kmsan-prevent-optimizations-in-memcpy-tests.patch
kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch
kmsan-introduce-test_memcpy_initialized_gap.patch

