Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5C3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347614AbiATVYZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiATVYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A88C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16E5EB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C776C340E3;
        Thu, 20 Jan 2022 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713861;
        bh=hCkPLOwwmUWDL6UB7rsHmOm1952zwxmiZ5nUa5ENYjM=;
        h=Date:From:To:Subject:From;
        b=lvnZqfojsjr+rTFFWU2yBHEvLx/wP95d0K/loOyPV8IVqkxcmjDN1Lr9s0j3Ty0b+
         ZAbl87/ngaSTNoYpZtg6AGoqt7f+qR3qSVO5dx3OEmoNk/2w3rcNNtU53oUhmu+D1j
         jpsX2d31ld0hymiuH7iqQ0ihwuuyHxxfQkVIjlCk=
Date:   Thu, 20 Jan 2022 13:24:21 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, kaiwan.billimoria@gmail.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-test-add-globals-left-out-of-bounds-test.patch removed from -mm tree
Message-ID: <20220120212421.gFfSAibFV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: add globals left-out-of-bounds test
has been removed from the -mm tree.  Its filename was
     kasan-test-add-globals-left-out-of-bounds-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1162,7 +1176,8 @@ static struct kunit_case kasan_kunit_tes
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

lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

