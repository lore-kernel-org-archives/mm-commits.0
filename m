Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9FEC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC37224DE
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbhAQUAO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbhAQUAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E73222510;
        Sun, 17 Jan 2021 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610913563;
        bh=2t+mLjE43BhsHHB/qgoFSk9Uq5F7h0FPeLze8TNbKBw=;
        h=Date:From:To:Subject:From;
        b=Ptz19MSTT0INyxt4gXD6fN+bGL+Mxd14HlwPwM1ou3w48FKX6OnMaCZBXt788DrxB
         c7JWJ7HS4NTU3ldo3rK/zQBWXdFmNdIT9mfcmWbDWbA/uU+LkC5cIf9GI55s/gXpkl
         vaX4M8BGrNK2C+pkPqiL5H23TpYFGFXV/FQE5RLg=
Date:   Sun, 17 Jan 2021 11:59:22 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [to-be-updated]
 kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch removed from
 -mm tree
Message-ID: <20210117195922.TI_YhNLi1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix memory corruption in kasan_bitops_tags test
has been removed from the -mm tree.  Its filename was
     kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix memory corruption in kasan_bitops_tags test

Since the hardware tag-based KASAN mode might not have a redzone that
comes after an allocated object (when kasan.mode=prod is enabled), the
kasan_bitops_tags() test ends up corrupting the next object in memory.

Change the test so it always accesses the redzone that lies within the
allocated object's boundaries.

Link: https://lkml.kernel.org/r/0c51a7266ea851797dc9816405fc40d860a48db1.1609871239.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I67f51d1ee48f0a8d0fe2658c2a39e4879fe0832a
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-memory-corruption-in-kasan_bitops_tags-test
+++ a/lib/test_kasan.c
@@ -771,17 +771,17 @@ static void kasan_bitops_tags(struct kun
 
 	/* This test is specifically crafted for the tag-based mode. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		kunit_info(test, "skipping, CONFIG_KASAN_SW_TAGS required");
+		kunit_info(test, "skipping, CONFIG_KASAN_SW/HW_TAGS required");
 		return;
 	}
 
-	/* Allocation size will be rounded to up granule size, which is 16. */
-	bits = kzalloc(sizeof(*bits), GFP_KERNEL);
+	/* kmalloc-64 cache will be used and the last 16 bytes will be the redzone. */
+	bits = kzalloc(48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bits);
 
-	/* Do the accesses past the 16 allocated bytes. */
-	kasan_bitops_modify(test, BITS_PER_LONG, &bits[1]);
-	kasan_bitops_test_and_modify(test, BITS_PER_LONG + BITS_PER_BYTE, &bits[1]);
+	/* Do the accesses past the 48 allocated bytes, but within the redone. */
+	kasan_bitops_modify(test, BITS_PER_LONG, (void *)bits + 48);
+	kasan_bitops_test_and_modify(test, BITS_PER_LONG + BITS_PER_BYTE, (void *)bits + 48);
 
 	kfree(bits);
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-hw_tags-boot-parameters.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch

