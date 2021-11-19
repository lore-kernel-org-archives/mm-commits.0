Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347B6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 19 Nov 2021 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhKSWqG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 17:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKSWqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF7BF61ACE;
        Fri, 19 Nov 2021 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637361784;
        bh=EfjBT2RXzWfzpqkgPQ1qctkW8wQFoMnwIS7OW96A2t8=;
        h=Date:From:To:Subject:From;
        b=JVp9TOi818e+pP3n8owJs6SgSgtPK/di08K72t1QwE7ByZYTUE8iLLW9ldLzLCGIS
         rqzNgmMM6sKq/xUHRvC8WXNY9HavFZDGOU2vGrYcHG5ZQrRhXXGX1FvOK6yRQKV5X1
         xo3Lz5II1TVL7rbxvLXq8lsWEcf5JoLJEXW3u8fs=
Date:   Fri, 19 Nov 2021 14:43:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com, vbabka@suse.cz
Subject:  +
 kasan-test-add-test-case-for-double-kmem_cache_destroy.patch added to -mm
 tree
Message-ID: <20211119224303.ZLw7AMbXA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: add test case for double-kmem_cache_destroy()
has been added to the -mm tree.  Its filename is
     kasan-test-add-test-case-for-double-kmem_cache_destroy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-add-test-case-for-double-kmem_cache_destroy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-add-test-case-for-double-kmem_cache_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: test: add test case for double-kmem_cache_destroy()

Add a test case for double-kmem_cache_destroy() detection.

Link: https://lkml.kernel.org/r/20211119142219.1519617-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/test_kasan.c~kasan-test-add-test-case-for-double-kmem_cache_destroy
+++ a/lib/test_kasan.c
@@ -866,6 +866,16 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+static void kmem_cache_double_destroy(struct kunit *test)
+{
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", 200, 0, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+	kmem_cache_destroy(cache);
+	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
+}
+
 static void kasan_memchr(struct kunit *test)
 {
 	char *ptr;
@@ -1185,6 +1195,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(ksize_uaf),
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
+	KUNIT_CASE(kmem_cache_double_destroy),
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
 	KUNIT_CASE(kasan_strings),
_

Patches currently in -mm which might be from elver@google.com are

mm-slab_common-use-warn-if-cache-still-has-objects-on-destroy.patch
kasan-test-add-globals-left-out-of-bounds-test.patch
kasan-add-ability-to-detect-double-kmem_cache_destroy.patch
kasan-test-add-test-case-for-double-kmem_cache_destroy.patch
panic-use-error_report_end-tracepoint-on-warnings.patch

