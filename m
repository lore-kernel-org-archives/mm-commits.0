Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D637AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B823561215
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhJTVRP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhJTVRN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 17:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D02F161215;
        Wed, 20 Oct 2021 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634764498;
        bh=Z/f40TpDEX8R9Top8kG7+WIkxwfZnUA6ljpjQQ54zxg=;
        h=Date:From:To:Subject:From;
        b=Um8tKDRLNho6LaS6gLTyFWMS6jHzRZmNct1rExQl0qTkimeFV9D4vS7xgC/OHath5
         HUCBnDueni7eTf9rtN0fnjZMUzvRSoLHH55vBDFVZGLEnjJQU6UHM2Fc3n1Gy6k1DK
         BxzNTlagOs77zw+AySEER0/JwYRy9CPN+Qdb3iAc=
Date:   Wed, 20 Oct 2021 14:14:57 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, dvyukov@google.com,
        glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  +
 =?US-ASCII?Q?kasan-test-consolidate-workarounds-for-unwanted-=5F=5Fall?=
 =?US-ASCII?Q?oc=5Fsize-protection.patch?= added to -mm tree
Message-ID: <20211020211457.1W0bQ4vYV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: consolidate workarounds for unwanted __alloc_size() protection
has been added to the -mm tree.  Its filename is
     kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kasan: test: consolidate workarounds for unwanted __alloc_size() protection

This fixes "lib/test_kasan.c: use underlying string helpers" to avoid
needing new helpers.  As done in "kasan: test: bypass __alloc_size
checks", just use OPTIMIZER_HIDE_VAR().  Additionally converts a use of
"volatile", which was trying to work around similar detection.

Link: https://lkml.kernel.org/r/20211020193807.40684-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/lib/test_kasan.c~kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection
+++ a/lib/test_kasan.c
@@ -525,12 +525,13 @@ static void kmalloc_memmove_invalid_size
 {
 	char *ptr;
 	size_t size = 64;
-	volatile size_t invalid_size = size;
+	size_t invalid_size = size;
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
@@ -852,21 +853,6 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
-/*
- * noinline wrappers to prevent the compiler from noticing the overflow
- * at compile time rather than having kasan catch it.
- */
-static noinline void *__kasan_memchr(const void *s, int c, size_t n)
-{
-	return memchr(s, c, n);
-}
-
-static noinline int __kasan_memcmp(const void *s1, const void *s2, size_t n)
-{
-	return memcmp(s1, s2, n);
-}
-
-
 static void kasan_memchr(struct kunit *test)
 {
 	char *ptr;
@@ -884,8 +870,9 @@ static void kasan_memchr(struct kunit *t
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_ptr_result = __kasan_memchr(ptr, '1', size + 1));
+		kasan_ptr_result = memchr(ptr, '1', size + 1));
 
 	kfree(ptr);
 }
@@ -909,8 +896,9 @@ static void kasan_memcmp(struct kunit *t
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	memset(arr, 0, sizeof(arr));
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_int_result = __kasan_memcmp(ptr, arr, size+1));
+		kasan_int_result = memcmp(ptr, arr, size+1));
 	kfree(ptr);
 }
 
_

Patches currently in -mm which might be from keescook@chromium.org are

kasan-test-bypass-__alloc_size-checks.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

