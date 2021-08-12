Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517F6C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3633B60C41
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhHLU4T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLU4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB33660ED5;
        Thu, 12 Aug 2021 20:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628801753;
        bh=CIj4jFIP1/59DR+8BM7tKlKQLGI8bM+xFzdJmiY/ysA=;
        h=Date:From:To:Subject:From;
        b=byiY9wifrl7XsjDzTafzsitqiMFBpho7J5suGNsth17/s919ec+vq/qW/MA+0hxSQ
         g0QI9cm/DGfSvhV7G7Q94VTVwcv9U4hqfdL68oY7HXX2dS2C2CwJ4oBUbEMZlmDYOu
         semf5OdlCI84F3rGz4Jui59N1Uu9vj7c9C1WTIlY=
Date:   Thu, 12 Aug 2021 13:55:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, aryabinin@virtuozzo.com, andreyknvl@gmail.com
Subject:  + kasan-test-rework-kmalloc_oob_right.patch added to -mm
 tree
Message-ID: <20210812205552.-aUNJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: rework kmalloc_oob_right
has been added to the -mm tree.  Its filename is
     kasan-test-rework-kmalloc_oob_right.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-rework-kmalloc_oob_right.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-rework-kmalloc_oob_right.patch

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

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-test-rework-kmalloc_oob_right.patch
kasan-test-avoid-writing-invalid-memory.patch
kasan-test-avoid-corrupting-memory-via-memset.patch
kasan-test-disable-kmalloc_memmove_invalid_size-for-hw_tags.patch
kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch
kasan-test-clean-up-ksize_uaf.patch
kasan-test-avoid-corrupting-memory-in-copy_user_test.patch
kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

