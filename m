Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE32FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiANWEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:04:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWEy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D89CB825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF9EC36AE5;
        Fri, 14 Jan 2022 22:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197891;
        bh=K7d9/zwteFw3tKgifwWd6u4KHcJSfaDZ0dTFWzZcAzs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sYsVEv2joorPpttaqduymzcKWFl4I3EzBMZvKoehCv7p7gxhVd0//5FB+3G+8NF51
         NlpkAl68IR1y6Uh+XxWuQ6FTeRXFuANcJP7KoC6E2MEa3XGgMD0ht6cUalQ/LsrJyJ
         m9Eb2C8j/XlS2oS5Ud6TTXdfzopbjwCvOukLViMQ=
Date:   Fri, 14 Jan 2022 14:04:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        kaiwan.billimoria@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 036/146] kasan: test: add globals
 left-out-of-bounds test
Message-ID: <20220114220451.BSo5QR8et%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
