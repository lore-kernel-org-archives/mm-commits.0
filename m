Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93793C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjC1XWI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjC1XVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E010530E1
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76910B81F55
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5AEC433EF;
        Tue, 28 Mar 2023 23:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045694;
        bh=96RJEz1p+Zg40t6AJCr9KAumTGjZqRvecSFDYT6y8uw=;
        h=Date:To:From:Subject:From;
        b=HTlhv0uw2uwbK2NNMeYdYtgLaJtIB5Arqv8dgMtYiLcV/ozmCXtbMUNqdaoeEaVNk
         mO3rahdhmLJwzaLzsCm7gLa9LrVdGj72aI/rTIUM435im2EoTixpaLSbCbSWOprOcc
         wto0jcvGq06gPX2NZEZjqi2REAoEMIM2K12vV7Y8=
Date:   Tue, 28 Mar 2023 16:21:33 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-add-memsetxx-tests.patch removed from -mm tree
Message-Id: <20230328232134.2E5AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: add memsetXX tests
has been removed from the -mm tree.  Its filename was
     kmsan-add-memsetxx-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: add memsetXX tests
Date: Fri, 3 Mar 2023 15:14:33 +0100

Add tests ensuring that memset16()/memset32()/memset64() are instrumented
by KMSAN and correctly initialize the memory.

Link: https://lkml.kernel.org/r/20230303141433.3422671-4-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-add-memsetxx-tests
+++ a/mm/kmsan/kmsan_test.c
@@ -504,6 +504,25 @@ static void test_memcpy_aligned_to_unali
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/* Generate test cases for memset16(), memset32(), memset64(). */
+#define DEFINE_TEST_MEMSETXX(size)                                          \
+	static void test_memset##size(struct kunit *test)                   \
+	{                                                                   \
+		EXPECTATION_NO_REPORT(expect);                              \
+		volatile uint##size##_t uninit;                             \
+                                                                            \
+		kunit_info(test,                                            \
+			   "memset" #size "() should initialize memory\n"); \
+		DO_NOT_OPTIMIZE(uninit);                                    \
+		memset##size((uint##size##_t *)&uninit, 0, 1);              \
+		kmsan_check_memory((void *)&uninit, sizeof(uninit));        \
+		KUNIT_EXPECT_TRUE(test, report_matches(&expect));           \
+	}
+
+DEFINE_TEST_MEMSETXX(16)
+DEFINE_TEST_MEMSETXX(32)
+DEFINE_TEST_MEMSETXX(64)
+
 static noinline void fibonacci(int *array, int size, int start)
 {
 	if (start < 2 || (start == size))
@@ -550,6 +569,9 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_memcpy_aligned_to_aligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned),
 	KUNIT_CASE(test_memcpy_aligned_to_unaligned2),
+	KUNIT_CASE(test_memset16),
+	KUNIT_CASE(test_memset32),
+	KUNIT_CASE(test_memset64),
 	KUNIT_CASE(test_long_origin_chain),
 	{},
 };
_

Patches currently in -mm which might be from glider@google.com are


