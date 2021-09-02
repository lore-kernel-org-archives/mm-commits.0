Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBBBC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4D8610CE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347613AbhIBV6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhIBV6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFCB560F12;
        Thu,  2 Sep 2021 21:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619853;
        bh=urNIRzQsooE7aKS9sprnKY3rdBQPdMcEVDU/+C9ioac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1xaawYjgpmwpo2v+y3cSOQxn51SK+jGeUvHdhuQbNUySemqhPlY4dnHlykGeqUgYc
         9NpaOCIJjs8seaAceclTYFcwXsFsfwN7HUrmQLonv0Vimavt9CAsWmDpZzyEFc2cSt
         l4Nvy+s5uk7kDYB5rhII52XSx9k1b1UX1hoq9qko=
Date:   Thu, 02 Sep 2021 14:57:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 142/212] kasan: test: rework kmalloc_oob_right
Message-ID: <20210902215732.NRokHjOhw%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: rework kmalloc_oob_right

Patch series "kasan: test: avoid crashing the kernel with HW_TAGS", v2.

KASAN tests do out-of-bounds and use-after-free accesses.  Running the
tests works fine for the GENERIC mode, as it uses qurantine and redzones. 
But the HW_TAGS mode uses neither, and running the tests might crash the
kernel.

Rework the tests to avoid corrupting kernel memory.


This patch (of 8):

Rework kmalloc_oob_right() to do these bad access checks:

1. An unaligned access one byte past the requested kmalloc size
   (can only be detected by KASAN_GENERIC).
2. An aligned access into the first out-of-bounds granule that falls
   within the aligned kmalloc object.
3. Out-of-bounds access past the aligned kmalloc object.

Test #3 deliberately uses a read access to avoid corrupting memory. 
Otherwise, this test might lead to crashes with the HW_TAGS mode, as it
neither uses quarantine nor redzones.

Link: https://lkml.kernel.org/r/cover.1628779805.git.andreyknvl@gmail.com
Link: https://lkml.kernel.org/r/474aa8b7b538c6737a4c6d0090350af2e1776bef.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/lib/test_kasan.c~kasan-test-rework-kmalloc_oob_right
+++ a/lib/test_kasan.c
@@ -122,12 +122,28 @@ static void kasan_test_exit(struct kunit
 static void kmalloc_oob_right(struct kunit *test)
 {
 	char *ptr;
-	size_t size = 123;
+	size_t size = 128 - KASAN_GRANULE_SIZE - 5;
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + OOB_TAG_OFF] = 'x');
+	/*
+	 * An unaligned access past the requested kmalloc size.
+	 * Only generic KASAN can precisely detect these.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 'x');
+
+	/*
+	 * An aligned access into the first out-of-bounds granule that falls
+	 * within the aligned kmalloc object.
+	 */
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] = 'y');
+
+	/* Out-of-bounds access past the aligned kmalloc object. */
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =
+					ptr[size + KASAN_GRANULE_SIZE + 5]);
+
 	kfree(ptr);
 }
 
_
