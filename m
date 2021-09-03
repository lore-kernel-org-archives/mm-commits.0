Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B6BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4536113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbhICVAP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350130AbhICVAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7872A6113C;
        Fri,  3 Sep 2021 20:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702752;
        bh=m0mFxtlOuYjIW5o5ntx0Wi/hINfZIsYR3fW53Xn9F5o=;
        h=Date:From:To:Subject:From;
        b=wUaebNg9lcjObD5uNIQRh9fKQ4Xdxi6zDnr+mHlzPRavPk0bPruKqjjpW3Kd8UXva
         vLdkhTno8kedit86SIFsC+6VZRqaJJTzHdv1Xm7aQWuKC1QnL7DDtJU4c4lyTyFETJ
         /4RmMg0PPC1Mj8J98jP3qbb2+1IF2PkgN+QSdGVQ=
Date:   Fri, 03 Sep 2021 13:59:12 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-test-rework-kmalloc_oob_right.patch
 removed from -mm tree
Message-ID: <20210903205912.DDlgnw4vu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: rework kmalloc_oob_right
has been removed from the -mm tree.  Its filename was
     kasan-test-rework-kmalloc_oob_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


