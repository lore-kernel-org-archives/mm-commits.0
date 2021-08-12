Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CEBC4320A
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C9A6101E
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhHLU4U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLU4U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9695260C41;
        Thu, 12 Aug 2021 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628801754;
        bh=CB1S1vDUUusq0NDe3U6yDGgC0amXZHt6SawZ0kwhcpE=;
        h=Date:From:To:Subject:From;
        b=dFucSb+IXBws1OobU09k1qJ6ZRt+juezQ67gvnuVCHQYanXSYanQARwzxGGVqDuau
         Bvhj2zZtZmqAsc4p+TfAsWJ1YKWXboerSz66tlFTIQZUh9CM5cV6WE5rH3xr3rIXiL
         j6Ka+ol8MYN5U2jiUbE0TGsv/yzNZtuKLRfJq6j4=
Date:   Thu, 12 Aug 2021 13:55:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, aryabinin@virtuozzo.com, andreyknvl@gmail.com
Subject:  + kasan-test-avoid-writing-invalid-memory.patch added to
 -mm tree
Message-ID: <20210812205554.qIg0q%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: avoid writing invalid memory
has been added to the -mm tree.  Its filename is
     kasan-test-avoid-writing-invalid-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-avoid-writing-invalid-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-avoid-writing-invalid-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-test-rework-kmalloc_oob_right.patch
kasan-test-avoid-writing-invalid-memory.patch
kasan-test-avoid-corrupting-memory-via-memset.patch
kasan-test-disable-kmalloc_memmove_invalid_size-for-hw_tags.patch
kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch
kasan-test-clean-up-ksize_uaf.patch
kasan-test-avoid-corrupting-memory-in-copy_user_test.patch
kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

