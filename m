Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A4DC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1780A610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347619AbhIBV6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhIBV6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF690610A1;
        Thu,  2 Sep 2021 21:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619856;
        bh=Wgx6y7dMTJ4/Z8hqabIorsTQCm0eWFr0nFm1Yr4BNiA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GSUroK60sZ1dV6qYl1py/fe+RpkPKr/Fdpp0bDUwY18vHf8vdCQRV9G38usp1OYcz
         rUlP8qVj/Jr93Nm7DgNeeDJSDF8Zigrpo5FwmpN1osYcDJpAqY7ifLFwG/Hu2Y4f+o
         88H2CYhFwIUYjGBffnm8fR/rx4pUmNH0+UvAzwNU=
Date:   Thu, 02 Sep 2021 14:57:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 143/212] kasan: test: avoid writing invalid memory
Message-ID: <20210902215735.v8iHp51ea%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: avoid writing invalid memory

Multiple KASAN tests do writes past the allocated objects or writes to
freed memory.  Turn these writes into reads to avoid corrupting memory. 
Otherwise, these tests might lead to crashes with the HW_TAGS mode, as it
neither uses quarantine nor redzones.

Link: https://lkml.kernel.org/r/c3cd2a383e757e27dd9131635fc7d09a48a49cf9.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/lib/test_kasan.c~kasan-test-avoid-writing-invalid-memory
+++ a/lib/test_kasan.c
@@ -167,7 +167,7 @@ static void kmalloc_node_oob_right(struc
 	ptr = kmalloc_node(size, GFP_KERNEL, 0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
 	kfree(ptr);
 }
 
@@ -203,7 +203,7 @@ static void kmalloc_pagealloc_uaf(struct
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	kfree(ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
 static void kmalloc_pagealloc_invalid_free(struct kunit *test)
@@ -237,7 +237,7 @@ static void pagealloc_oob_right(struct k
 	ptr = page_address(pages);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
 	free_pages((unsigned long)ptr, order);
 }
 
@@ -252,7 +252,7 @@ static void pagealloc_uaf(struct kunit *
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	free_pages((unsigned long)ptr, order);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
 static void kmalloc_large_oob_right(struct kunit *test)
@@ -514,7 +514,7 @@ static void kmalloc_uaf(struct kunit *te
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	kfree(ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, *(ptr + 8) = 'x');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
 }
 
 static void kmalloc_uaf_memset(struct kunit *test)
@@ -553,7 +553,7 @@ again:
 		goto again;
 	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr1[40] = 'x');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
 	KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
 
 	kfree(ptr2);
@@ -700,7 +700,7 @@ static void ksize_unpoisons_memory(struc
 	ptr[size] = 'x';
 
 	/* This one must. */
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[real_size] = 'y');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
 
 	kfree(ptr);
 }
_
