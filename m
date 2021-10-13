Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACD6C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B35F611C5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhJMVkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhJMVkG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:40:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EC861186;
        Wed, 13 Oct 2021 21:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634161083;
        bh=y8CdFPyytqDUpMiuPRboERU5zckKCt5PIEITpfNXyU0=;
        h=Date:From:To:Subject:From;
        b=GciT+2xiiy42G1PDBWJOpeoyuHP2P6etSzJ/iVqkKS1m3qSrl8tFERyqt9RK77599
         bWAp4275LcjDWxU0YWOZDtZuykBu8V4SJ4vM3bYVANbkhqax0He/ExFGeKYU/9VbC1
         vYhb07KRM6tRO1fgfIqEt5SH2FUKfNs0AKKlOrMQ=
Date:   Wed, 13 Oct 2021 14:38:02 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        keescook@chomium.org, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, trishalfonso@google.com,
        vincenzo.frascino@arm.com
Subject:  + kasan-test-use-underlying-string-helpers.patch added to
 -mm tree
Message-ID: <20211013213802.r4sjDf4jV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: use underlying string helpers
has been added to the -mm tree.  Its filename is
     kasan-test-use-underlying-string-helpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-use-underlying-string-helpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-use-underlying-string-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Kees Cook <keescook@chomium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Patricia Alfonso <trishalfonso@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
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

kasan-test-use-underlying-string-helpers.patch
posix-acl-avoid-wempty-body-warning.patch
hfs-hfsplus-use-warn_on-for-sanity-check.patch

