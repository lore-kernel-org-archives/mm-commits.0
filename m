Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3540C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJCVKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJCVI3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F42C4F3A0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AF81CE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE506C433D6;
        Mon,  3 Oct 2022 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831186;
        bh=dkSP34sP9TEf/d+e2qBZ07CasB2nSFfGhIvJcOF+GAY=;
        h=Date:To:From:Subject:From;
        b=LG6CABo3VIYy8g117L9XP4OE3KdTQbtLGHDsZNaYVz8QM0rFYO0y3fJZ2nVr1/lvW
         dIaRr1q1KzH0GreNlEXWRGUrf5EVU08scq3mOUyBzELfFpuDfNd1D7ZNi6EYoq3Rid
         t2vjYcUrjaS5uVGG2LEP8aMY3yDpsIUDdVUl3/yY=
Date:   Mon, 03 Oct 2022 14:06:26 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-add-another-use-after-free-test.patch removed from -mm tree
Message-Id: <20221003210626.BE506C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: add another use-after-free test
has been removed from the -mm tree.  Its filename was
     kasan-add-another-use-after-free-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add another use-after-free test
Date: Mon, 5 Sep 2022 23:05:49 +0200

Add a new use-after-free test that checks that KASAN detects
use-after-free when another object was allocated in the same slot.

This test is mainly relevant for the tag-based modes, which do not use
quarantine.

Once [1] is resolved, this test can be extended to check that the stack
traces in the report point to the proper kmalloc/kfree calls.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=212203

Link: https://lkml.kernel.org/r/0659cfa15809dd38faa02bc0a59d0b5dbbd81211.1662411800.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/lib/test_kasan.c~kasan-add-another-use-after-free-test
+++ a/lib/test_kasan.c
@@ -612,6 +612,29 @@ again:
 	kfree(ptr2);
 }
 
+/*
+ * Check that KASAN detects use-after-free when another object was allocated in
+ * the same slot. Relevant for the tag-based modes, which do not use quarantine.
+ */
+static void kmalloc_uaf3(struct kunit *test)
+{
+	char *ptr1, *ptr2;
+	size_t size = 100;
+
+	/* This test is specifically crafted for tag-based modes. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	ptr1 = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
+	kfree(ptr1);
+
+	ptr2 = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
+	kfree(ptr2);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
+}
+
 static void kfree_via_page(struct kunit *test)
 {
 	char *ptr;
@@ -1382,6 +1405,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_uaf),
 	KUNIT_CASE(kmalloc_uaf_memset),
 	KUNIT_CASE(kmalloc_uaf2),
+	KUNIT_CASE(kmalloc_uaf3),
 	KUNIT_CASE(kfree_via_page),
 	KUNIT_CASE(kfree_via_phys),
 	KUNIT_CASE(kmem_cache_oob),
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

