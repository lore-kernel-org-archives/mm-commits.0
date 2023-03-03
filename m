Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E92C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjCCW6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCCW6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:58:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B097725977
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2056618B3
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17262C433EF;
        Fri,  3 Mar 2023 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677884254;
        bh=S1/I1k9GfPVUjU1HammHt3ty+KyfzPB8ZoAuLPkUFJk=;
        h=Date:To:From:Subject:From;
        b=OEqLM4ZHJbuGuIgyKczr8ZKkTVy1qFhGvNUI+Md9K0o+cI/+YnnBh31RFzcas52eS
         T72ws6NQuNZ3O3EP1bi4uouBcnPjqY8MGERJu+kRM/ogtbpTsigwI7BPjplm7c4y5v
         9GHmtx/bz+csPE0BtPa5WnBoHiT/CHdnwQOMcOVw=
Date:   Fri, 03 Mar 2023 14:57:33 -0800
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-add-memsetxx-tests.patch added to mm-unstable branch
Message-Id: <20230303225734.17262C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: add memsetXX tests
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-add-memsetxx-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-add-memsetxx-tests.patch

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

x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch
kmsan-another-take-at-fixing-memcpy-tests.patch
x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch
kmsan-add-memsetxx-tests.patch

