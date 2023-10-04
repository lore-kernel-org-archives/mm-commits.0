Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C3E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbjJDUTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244031AbjJDUTF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:19:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A793
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:19:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C69C433CA;
        Wed,  4 Oct 2023 20:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450741;
        bh=4RvW4CvqgDkSB2r6fOfCdy//s+TGMQnngzXFU+0TA7Y=;
        h=Date:To:From:Subject:From;
        b=bZxfLOmjlqSTyDz+oWORrjkGCimzMP+KX/Rs4q5fs/lToS4DzzOpbxI79ERo4LWb2
         9f4SVtgzbSmyqTTy3vzUD2Havfr8/TOI6qzqDA1c+0pL0RT3lDKH7ecuNSABePWLak
         GfhmhhDsPNIrEK40H4JIXCaELdiH9Fsk8KYKToJY=
Date:   Wed, 04 Oct 2023 13:19:00 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-introduce-test_memcpy_initialized_gap.patch removed from -mm tree
Message-Id: <20231004201901.83C69C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: introduce test_memcpy_initialized_gap()
has been removed from the -mm tree.  Its filename was
     kmsan-introduce-test_memcpy_initialized_gap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


