Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59E6C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4CD64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhBYT33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233866AbhBYT1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C739764F89;
        Thu, 25 Feb 2021 19:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280546;
        bh=jgwyTHZGbgJY2jprOF1usgT9ahvxyPfpONOCbZGoGus=;
        h=Date:From:To:Subject:From;
        b=qXKFYlLltvXKYODrcJVuaQ2ByrhN4ujhRSKgAhCXkFxiUcJ5UeeOrOc0Xk03OmgDA
         uKNpimRmgPwsFwS8xr42Y8J6qzEJmEbYVFcoqee92yJMSM5IC32KdbJTfPdL1Eqxs3
         l9E8ypUFVnxWrIuqiZWBo3PAORjZN+BbY94AlW/w=
Date:   Thu, 25 Feb 2021 11:15:45 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch removed from
 -mm tree
Message-ID: <20210225191545.Rho14hBd0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix memory corruption in kasan_bitops_tags test
has been removed from the -mm tree.  Its filename was
     kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix memory corruption in kasan_bitops_tags test

Since the hardware tag-based KASAN mode might not have a redzone that
comes after an allocated object (when kasan.mode=prod is enabled), the
kasan_bitops_tags() test ends up corrupting the next object in memory.

Change the test so it always accesses the redzone that lies within the
allocated object's boundaries.

Link: https://linux-review.googlesource.com/id/I67f51d1ee48f0a8d0fe2658c2a39e4879fe0832a
Link: https://lkml.kernel.org/r/7d452ce4ae35bb1988d2c9244dfea56cf2cc9315.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-memory-corruption-in-kasan_bitops_tags-test
+++ a/lib/test_kasan.c
@@ -749,13 +749,13 @@ static void kasan_bitops_tags(struct kun
 	/* This test is specifically crafted for tag-based modes. */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
 
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

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

