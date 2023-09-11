Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093EFCA0EDA
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbjIKWWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243964AbjIKSdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:33:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1A71A2
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:33:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7ECC433C7;
        Mon, 11 Sep 2023 18:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694457216;
        bh=rYh0f2OjPGtDw2sQY19vFdGgcnk+gGi26KxkDIGWxN8=;
        h=Date:To:From:Subject:From;
        b=rpa/Jq0WzVZKM2aoCj6DIOHpE0+Azsua0nMVkFMw1FiX2nVIihW+6y9NsjNtVxXYG
         eBcFYaBLhvQSUt94WwBdJ42rB2Ox8W7KWxKyDcDNdKUQ651dvRkfcIhGY9LgpA+u4D
         19FYasKVbEKLPpy5H7xs0Gke02Mie+1Ew/OkAKIM=
Date:   Mon, 11 Sep 2023 11:33:35 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-introduce-test_memcpy_initialized_gap.patch added to mm-unstable branch
Message-Id: <20230911183336.AB7ECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: introduce test_memcpy_initialized_gap()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-introduce-test_memcpy_initialized_gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-introduce-test_memcpy_initialized_gap.patch

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
Subject: kmsan: introduce test_memcpy_initialized_gap()
Date: Mon, 11 Sep 2023 16:57:02 +0200

Add a regression test for the special case where memcpy() previously
failed to correctly set the origins: if upon memcpy() four aligned
initialized bytes with a zero origin value ended up split between two
aligned four-byte chunks, one of those chunks could've received the zero
origin value even despite it contained uninitialized bytes from other
writes.

Link: https://lkml.kernel.org/r/20230911145702.2663753-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   53 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-introduce-test_memcpy_initialized_gap
+++ a/mm/kmsan/kmsan_test.c
@@ -486,6 +486,58 @@ static void test_memcpy_aligned_to_unali
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/*
+ * Test case: ensure that origin slots do not accidentally get overwritten with
+ * zeroes during memcpy().
+ *
+ * Previously, when copying memory from an aligned buffer to an unaligned one,
+ * if there were zero origins corresponding to zero shadow values in the source
+ * buffer, they could have ended up being copied to nonzero shadow values in the
+ * destination buffer:
+ *
+ *  memcpy(0xffff888080a00000, 0xffff888080900002, 8)
+ *
+ *  src (0xffff888080900002): ..xx .... xx..
+ *  src origins:              o111 0000 o222
+ *  dst (0xffff888080a00000): xx.. ..xx
+ *  dst origins:              o111 0000
+ *                        (or 0000 o222)
+ *
+ * (here . stands for an initialized byte, and x for an uninitialized one.
+ *
+ * Ensure that this does not happen anymore, and for both destination bytes
+ * the origin is nonzero (i.e. KMSAN reports an error).
+ */
+static void test_memcpy_initialized_gap(struct kunit *test)
+{
+	EXPECTATION_UNINIT_VALUE_FN(expect, "test_memcpy_initialized_gap");
+	volatile char uninit_src[12];
+	volatile char dst[8] = { 0 };
+
+	kunit_info(
+		test,
+		"unaligned 4-byte initialized value gets a nonzero origin after memcpy() - (2 UMR reports)\n");
+
+	uninit_src[0] = 42;
+	uninit_src[1] = 42;
+	uninit_src[4] = 42;
+	uninit_src[5] = 42;
+	uninit_src[6] = 42;
+	uninit_src[7] = 42;
+	uninit_src[10] = 42;
+	uninit_src[11] = 42;
+	memcpy_noinline((void *)&dst[0], (void *)&uninit_src[2], 8);
+
+	kmsan_check_memory((void *)&dst[0], 4);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+	report_reset();
+	kmsan_check_memory((void *)&dst[2], 4);
+	KUNIT_EXPECT_FALSE(test, report_matches(&expect));
+	report_reset();
+	kmsan_check_memory((void *)&dst[4], 4);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 /* Generate test cases for memset16(), memset32(), memset64(). */
 #define DEFINE_TEST_MEMSETXX(size)                                          \
 	static void test_memset##size(struct kunit *test)                   \
@@ -579,6 +631,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_init_memcpy),
 	KUNIT_CASE(test_memcpy_aligned_to_aligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned),
+	KUNIT_CASE(test_memcpy_initialized_gap),
 	KUNIT_CASE(test_memset16),
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
_

Patches currently in -mm which might be from glider@google.com are

kmsan-simplify-kmsan_internal_memmove_metadata.patch
kmsan-prevent-optimizations-in-memcpy-tests.patch
kmsan-merge-test_memcpy_aligned_to_unaligned2-together.patch
kmsan-introduce-test_memcpy_initialized_gap.patch

