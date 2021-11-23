Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A2EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 23 Nov 2021 22:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbhKWWtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239023AbhKWWtJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 17:49:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3FA260E08;
        Tue, 23 Nov 2021 22:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707559;
        bh=tA2BjcdzyU/jLSth6oyon1ntgtXrR6m4niWKmMsQn0A=;
        h=Date:From:To:Subject:From;
        b=0t3TygYYBygGIKUwJLISNIa4Atl0YhiBEKMqlHLGIncBkhCddRUDdaT6uHIl39oDt
         oYoeRrjTHnFJUSNtihYrtAGFgX2LQGrh/3GlvfAlWAoNScj68ZcDgqbExY8uxLShR4
         mU6eN7qybCw71RQnelzERp8OaZJvGnlEJs0wPlzY=
Date:   Tue, 23 Nov 2021 14:45:59 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-test-silence-intentional-read-overflow-warnings.patch removed from
 -mm tree
Message-ID: <20211123224559.d2Wz9mdG5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: silence intentional read overflow warnings
has been removed from the -mm tree.  Its filename was
     kasan-test-silence-intentional-read-overflow-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kasan: test: silence intentional read overflow warnings

As done in commit d73dad4eb5ad ("kasan: test: bypass __alloc_size checks")
for __write_overflow warnings, also silence some more cases that trip the
__read_overflow warnings seen in 5.16-rc1[1]:

In file included from /kisskb/src/include/linux/string.h:253,
                 from /kisskb/src/include/linux/bitmap.h:10,
                 from /kisskb/src/include/linux/cpumask.h:12,
                 from /kisskb/src/include/linux/mm_types_task.h:14,
                 from /kisskb/src/include/linux/mm_types.h:5,
                 from /kisskb/src/include/linux/page-flags.h:13,
                 from /kisskb/src/arch/arm64/include/asm/mte.h:14,
                 from /kisskb/src/arch/arm64/include/asm/pgtable.h:12,
                 from /kisskb/src/include/linux/pgtable.h:6,
                 from /kisskb/src/include/linux/kasan.h:29,
                 from /kisskb/src/lib/test_kasan.c:10:
In function 'memcmp',
    inlined from 'kasan_memcmp' at /kisskb/src/lib/test_kasan.c:897:2:
/kisskb/src/include/linux/fortify-string.h:263:25: error: call to '__read_overflow' declared with attribute error: detected read beyond size of object (1st parameter)
  263 |                         __read_overflow();
      |                         ^~~~~~~~~~~~~~~~~
In function 'memchr',
    inlined from 'kasan_memchr' at /kisskb/src/lib/test_kasan.c:872:2:
/kisskb/src/include/linux/fortify-string.h:277:17: error: call to '__read_overflow' declared with attribute error: detected read beyond size of object (1st parameter)
  277 |                 __read_overflow();
      |                 ^~~~~~~~~~~~~~~~~

[1] http://kisskb.ellerman.id.au/kisskb/buildresult/14660585/log/

Link: https://lkml.kernel.org/r/20211116004111.3171781-1-keescook@chromium.org
Fixes: d73dad4eb5ad ("kasan: test: bypass __alloc_size checks")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_kasan.c~kasan-test-silence-intentional-read-overflow-warnings
+++ a/lib/test_kasan.c
@@ -869,6 +869,7 @@ static void kasan_memchr(struct kunit *t
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_ptr_result = memchr(ptr, '1', size + 1));
 
@@ -894,6 +895,7 @@ static void kasan_memcmp(struct kunit *t
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	memset(arr, 0, sizeof(arr));
 
+	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_int_result = memcmp(ptr, arr, size+1));
 	kfree(ptr);
_

Patches currently in -mm which might be from keescook@chromium.org are

hfsplus-use-struct_group_attr-for-memcpy-region.patch

