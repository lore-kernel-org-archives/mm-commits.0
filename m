Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AD0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE58761504
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhKRWPE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229978AbhKRWPD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:15:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB286142A;
        Thu, 18 Nov 2021 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637273523;
        bh=MIRbp0hpxyB4g6Z0+a32K6hZAEdqNy8TzP9mWYy/Goc=;
        h=Date:From:To:Subject:From;
        b=tI7a3rBH8O68hMQWy0aeaGuHzbror7I+1kpAiLWFy9DFyVPA3v2Meq9MKA3maYUSW
         wPyNXrfe1YOHUgw3tE+X5lhT6iyLVmHd7v6m3Pyjp57OYlQjQ7fnfDBI8lknNhChy0
         AbS/Ig3J7HrN+Y0TrwTqiIbFVRHHwIF8OIKJnjFw=
Date:   Thu, 18 Nov 2021 14:12:02 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, kaiwan.billimoria@gmail.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  + kasan-test-add-globals-left-out-of-bounds-test.patch
 added to -mm tree
Message-ID: <20211118221202.aN9MIe6QL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: add globals left-out-of-bounds test
has been added to the -mm tree.  Its filename is
     kasan-test-add-globals-left-out-of-bounds-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-add-globals-left-out-of-bounds-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-add-globals-left-out-of-bounds-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: test: add globals left-out-of-bounds test

Add a test checking that KASAN generic can also detect out-of-bounds
accesses to the left of globals.

Unfortunately it seems that GCC doesn't catch this (tested GCC 10, 11). 
The main difference between GCC's globals redzoning and Clang's is that
GCC relies on using increased alignment to producing padding, where
Clang's redzoning implementation actually adds real data after the global
and doesn't rely on alignment to produce padding.  I believe this is the
main reason why GCC can't reliably catch globals out-of-bounds in this
case.

Given this is now a known issue, to avoid failing the whole test suite,
skip this test case with GCC.

Link: https://lkml.kernel.org/r/20211117130714.135656-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/lib/test_kasan.c~kasan-test-add-globals-left-out-of-bounds-test
+++ a/lib/test_kasan.c
@@ -700,7 +700,7 @@ static void kmem_cache_bulk(struct kunit
 
 static char global_array[10];
 
-static void kasan_global_oob(struct kunit *test)
+static void kasan_global_oob_right(struct kunit *test)
 {
 	/*
 	 * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
@@ -723,6 +723,20 @@ static void kasan_global_oob(struct kuni
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
+static void kasan_global_oob_left(struct kunit *test)
+{
+	char *volatile array = global_array;
+	char *p = array - 3;
+
+	/*
+	 * GCC is known to fail this test, skip it.
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=215051.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_CC_IS_CLANG);
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
+}
+
 /* Check that ksize() makes the whole object accessible. */
 static void ksize_unpoisons_memory(struct kunit *test)
 {
@@ -1160,7 +1174,8 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmem_cache_oob),
 	KUNIT_CASE(kmem_cache_accounted),
 	KUNIT_CASE(kmem_cache_bulk),
-	KUNIT_CASE(kasan_global_oob),
+	KUNIT_CASE(kasan_global_oob_right),
+	KUNIT_CASE(kasan_global_oob_left),
 	KUNIT_CASE(kasan_stack_oob),
 	KUNIT_CASE(kasan_alloca_oob_left),
 	KUNIT_CASE(kasan_alloca_oob_right),
_

Patches currently in -mm which might be from elver@google.com are

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
kasan-test-add-globals-left-out-of-bounds-test.patch
panic-use-error_report_end-tracepoint-on-warnings.patch

