Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF50C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353209AbiA2VlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353214AbiA2VlO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C88C061714
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 13:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4376CB82817
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B6EC340E8;
        Sat, 29 Jan 2022 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492471;
        bh=Q3+WJXs6P1o3JAP4kOGsUH2ygzsANEWwx5SaFt9TCkw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P2FlLG0ZYWrzAYCWXn8klkW3dBin5nyxgu0H72rF1VkMk8+H+RhLoHRiSHAo/VrQ2
         ipVJRB+P0YDBR5D6n6Rc4waR/CvUhK4tIzMWA24P4nu3CDXGIkF9lb9Th3TQLX8yPw
         5R3So5vneK+Z5HRcnMLRPvZ4kpSnFLyhxnULcYIQ=
Date:   Sat, 29 Jan 2022 13:41:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        brendanhiggins@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npache@redhat.com,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 07/12] kasan: test: fix compatibility with
 FORTIFY_SOURCE
Message-ID: <20220129214111.2i2Jilwui%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: test: fix compatibility with FORTIFY_SOURCE

With CONFIG_FORTIFY_SOURCE enabled, string functions will also perform
dynamic checks using __builtin_object_size(ptr), which when failed will
panic the kernel.

Because the KASAN test deliberately performs out-of-bounds operations, the
kernel panics with FORTIFY_SOURCE, for example:

 | kernel BUG at lib/string_helpers.c:910!
 | invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
 | CPU: 1 PID: 137 Comm: kunit_try_catch Tainted: G    B             5.16.0-rc3+ #3
 | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 | RIP: 0010:fortify_panic+0x19/0x1b
 | ...
 | Call Trace:
 |  <TASK>
 |  kmalloc_oob_in_memset.cold+0x16/0x16
 |  ...

Fix it by also hiding `ptr` from the optimizer, which will ensure that
__builtin_object_size() does not return a valid size, preventing fortified
string functions from panicking.

Link: https://lkml.kernel.org/r/20220124160744.1244685-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/test_kasan.c~kasan-test-fix-compatibility-with-fortify_source
+++ a/lib/test_kasan.c
@@ -492,6 +492,7 @@ static void kmalloc_oob_in_memset(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 				memset(ptr, 0, size + KASAN_GRANULE_SIZE));
@@ -515,6 +516,7 @@ static void kmalloc_memmove_negative_siz
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
@@ -531,6 +533,7 @@ static void kmalloc_memmove_invalid_size
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(ptr);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
@@ -893,6 +896,7 @@ static void kasan_memchr(struct kunit *t
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_ptr_result = memchr(ptr, '1', size + 1));
@@ -919,6 +923,7 @@ static void kasan_memcmp(struct kunit *t
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	memset(arr, 0, sizeof(arr));
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_int_result = memcmp(ptr, arr, size+1));
_
