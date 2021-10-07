Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE06C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 00:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A200610C7
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 00:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhJGAz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhJGAzz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 20:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07FF610CE;
        Thu,  7 Oct 2021 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633568042;
        bh=LQu3eLCspcUOQTSCZcoBhLz2DilcvwYbOkTc1xnhCwQ=;
        h=Date:From:To:Subject:From;
        b=sSmsPybOL4tFTTvaWMM6djNL2wXA2VKmrWf7iTNlEtu5UaRPB2b0VHKdIQKr8hDNh
         VJ2ZS/Gsi4ku2v6IeBc75n8ZESYuylrtkN3lg8f6dFc00lDKXM3aUpHB686QfuEyFt
         uyyT1DaEWjTBHSdxa01IduVRLSefSzkBf9/Z8PP4=
Date:   Wed, 06 Oct 2021 17:54:02 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com
Subject:  + kasan-test-bypass-__alloc_size-checks.patch added to
 -mm tree
Message-ID: <20211007005402.giWu4Wjge%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: bypass __alloc_size checks
has been added to the -mm tree.  Its filename is
     kasan-test-bypass-__alloc_size-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-bypass-__alloc_size-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-bypass-__alloc_size-checks.patch

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
Subject: kasan: test: bypass __alloc_size checks

Intentional overflows, as performed by the KASAN tests, are detected at
compile time[1] (instead of only at run-time) with the addition of
__alloc_size.  Fix this by forcing the compiler into not being able to
trust the size used following the kmalloc()s.

[1] https://lore.kernel.org/lkml/20211005184717.65c6d8eb39350395e387b71f@linux-foundation.org

Link: https://lkml.kernel.org/r/20211006181544.1670992-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c        |    8 +++++++-
 lib/test_kasan_module.c |    2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-test-bypass-__alloc_size-checks
+++ a/lib/test_kasan.c
@@ -440,6 +440,7 @@ static void kmalloc_oob_memset_2(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 1, 0, 2));
 	kfree(ptr);
 }
@@ -452,6 +453,7 @@ static void kmalloc_oob_memset_4(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 3, 0, 4));
 	kfree(ptr);
 }
@@ -464,6 +466,7 @@ static void kmalloc_oob_memset_8(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 7, 0, 8));
 	kfree(ptr);
 }
@@ -476,6 +479,7 @@ static void kmalloc_oob_memset_16(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test, memset(ptr + size - 15, 0, 16));
 	kfree(ptr);
 }
@@ -488,6 +492,7 @@ static void kmalloc_oob_in_memset(struct
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 				memset(ptr, 0, size + KASAN_GRANULE_SIZE));
 	kfree(ptr);
@@ -497,7 +502,7 @@ static void kmalloc_memmove_invalid_size
 {
 	char *ptr;
 	size_t size = 64;
-	volatile size_t invalid_size = -2;
+	size_t invalid_size = -2;
 
 	/*
 	 * Hardware tag-based mode doesn't check memmove for negative size.
@@ -510,6 +515,7 @@ static void kmalloc_memmove_invalid_size
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
--- a/lib/test_kasan_module.c~kasan-test-bypass-__alloc_size-checks
+++ a/lib/test_kasan_module.c
@@ -35,6 +35,8 @@ static noinline void __init copy_user_te
 		return;
 	}
 
+	OPTIMIZER_HIDE_VAR(size);
+
 	pr_info("out-of-bounds in copy_from_user()\n");
 	unused = copy_from_user(kmem, usermem, size + 1);
 
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
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

