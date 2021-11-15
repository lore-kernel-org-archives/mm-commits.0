Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDE9C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E36633B8
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhKORtb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238723AbhKORrL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1DDF6104F;
        Mon, 15 Nov 2021 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997386;
        bh=Z7rSqKW1pNkUDltDASsWeqfCTwr3w3kmBTHaq29PclM=;
        h=Date:From:To:Subject:From;
        b=axbjW6UhGbL0IIjAGUArqILc7bx5pXrfoKVSnldgMj2uDMCU+sE6dR1/nQt4pmoZl
         H3Y+MRTFEBet1yDS8SpmEQMBgNakuAjTi5/J3mlUGPs/CljITEOFxLKkOpyFBCoihO
         zdafEh55hBz+BOQVaf1bgD4OnWKi7fTdwtJ0Meik=
Date:   Mon, 15 Nov 2021 09:29:45 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        keescook@chomium.org, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, trishalfonso@google.com,
        vincenzo.frascino@arm.com
Subject:  [merged] kasan-test-use-underlying-string-helpers.patch
 removed from -mm tree
Message-ID: <20211115172945.-tdtgZbPQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: use underlying string helpers
has been removed from the -mm tree.  Its filename was
     kasan-test-use-underlying-string-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib/test_kasan.c: use underlying string helpers

Calling memcmp() and memchr() with an intentional buffer overflow is now
caught at compile time:

In function 'memcmp',
    inlined from 'kasan_memcmp' at lib/test_kasan.c:897:2:
include/linux/fortify-string.h:263:25: error: call to '__read_overflow' declared with attribute error: detected read beyond size of object (1st parameter)
  263 |                         __read_overflow();
      |                         ^~~~~~~~~~~~~~~~~
In function 'memchr',
    inlined from 'kasan_memchr' at lib/test_kasan.c:872:2:
include/linux/fortify-string.h:277:17: error: call to '__read_overflow' declared with attribute error: detected read beyond size of object (1st parameter)
  277 |                 __read_overflow();
      |                 ^~~~~~~~~~~~~~~~~

Change the kasan tests to wrap those inside of a noinline function
to prevent the compiler from noticing the bug and let kasan find
it at runtime.

Link: https://lkml.kernel.org/r/20211013150025.2875883-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Kees Cook <keescook@chomium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Patricia Alfonso <trishalfonso@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/lib/test_kasan.c~kasan-test-use-underlying-string-helpers
+++ a/lib/test_kasan.c
@@ -831,6 +831,21 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+/*
+ * noinline wrappers to prevent the compiler from noticing the overflow
+ * at compile time rather than having kasan catch it.
+ * */
+static noinline void *__kasan_memchr(const void *s, int c, size_t n)
+{
+	return memchr(s, c, n);
+}
+
+static noinline int __kasan_memcmp(const void *s1, const void *s2, size_t n)
+{
+	return memcmp(s1, s2, n);
+}
+
+
 static void kasan_memchr(struct kunit *test)
 {
 	char *ptr;
@@ -849,7 +864,7 @@ static void kasan_memchr(struct kunit *t
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_ptr_result = memchr(ptr, '1', size + 1));
+		kasan_ptr_result = __kasan_memchr(ptr, '1', size + 1));
 
 	kfree(ptr);
 }
@@ -874,7 +889,7 @@ static void kasan_memcmp(struct kunit *t
 	memset(arr, 0, sizeof(arr));
 
 	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_int_result = memcmp(ptr, arr, size+1));
+		kasan_int_result = __kasan_memcmp(ptr, arr, size+1));
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are


