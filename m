Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183AFC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011AD633B6
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhKORtj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238765AbhKORrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE1D6329C;
        Mon, 15 Nov 2021 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997391;
        bh=a9PYanaQxabjacsxkNWFquEqBRv3wrrP3eY8EGYpFTg=;
        h=Date:From:To:Subject:From;
        b=WjyrubjnjOdcHSucnGyievaZrav473doLwrgMRIqjN2XITCmMCp1GezoYwW5r6vtj
         plI167bmsuMiHaWRVwISH6X3w9d74UOl3l/gPdGwfOQz2vkVTRpldmgWW+gqcqMHRx
         bvLZPUCUAG4m3rLUIoBTHA7nYsDmKfJKJR4k8+Ng=
Date:   Mon, 15 Nov 2021 09:29:51 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, dvyukov@google.com,
        glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?kasan-test-consolidate-workarounds-for-unwanted-=5F=5Fall?=
 =?US-ASCII?Q?oc=5Fsize-protection.patch?= removed from -mm tree
Message-ID: <20211115172951.Sitclmchw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: consolidate workarounds for unwanted __alloc_size() protection
has been removed from the -mm tree.  Its filename was
     kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kasan: test: consolidate workarounds for unwanted __alloc_size() protection

This fixes "lib/test_kasan.c: use underlying string helpers" to avoid
needing new helpers.  As done in "kasan: test: bypass __alloc_size
checks", just use OPTIMIZER_HIDE_VAR().  Additionally converts a use of
"volatile", which was trying to work around similar detection.

Link: https://lkml.kernel.org/r/20211020193807.40684-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
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


