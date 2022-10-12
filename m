Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDDBC43217
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJLW6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJLW6E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA860127BC0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 004D961684
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54916C433C1;
        Wed, 12 Oct 2022 22:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615459;
        bh=xItb4wKF17nrLvAfog2mKQdjwxSoS8q8YmEGqmQA82E=;
        h=Date:To:From:Subject:From;
        b=wxNOS6upVel0NiGfLIO1FD8RzxYnElPO0eq4s5dQ2HnY6gsyExaOl4gDucSH69UaO
         A/8hL/Y7X0mSiZRR4rVYU0D4IRo0w1eW3gSHvpplgvoi5Y71PftjUpvhtuKZ+jR3D4
         eKEhHtR3J2aTUWuwYgYc5oLuyQMJURLApJ0AZV4g=
Date:   Wed, 12 Oct 2022 15:57:38 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-array-bounds-warnings-in-tests.patch removed from -mm tree
Message-Id: <20221012225739.54916C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fix array-bounds warnings in tests
has been removed from the -mm tree.  Its filename was
     kasan-fix-array-bounds-warnings-in-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix array-bounds warnings in tests
Date: Mon, 26 Sep 2022 20:08:47 +0200

GCC's -Warray-bounds option detects out-of-bounds accesses to
statically-sized allocations in krealloc out-of-bounds tests.

Use OPTIMIZER_HIDE_VAR to suppress the warning.

Also change kmalloc_memmove_invalid_size to use OPTIMIZER_HIDE_VAR
instead of a volatile variable.

Link: https://lkml.kernel.org/r/e94399242d32e00bba6fd0d9ec4c897f188128e8.1664215688.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan_test.c~kasan-fix-array-bounds-warnings-in-tests
+++ a/mm/kasan/kasan_test.c
@@ -295,6 +295,9 @@ static void krealloc_more_oob_helper(str
 	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 
+	/* Suppress -Warray-bounds warnings. */
+	OPTIMIZER_HIDE_VAR(ptr2);
+
 	/* All offsets up to size2 must be accessible. */
 	ptr2[size1 - 1] = 'x';
 	ptr2[size1] = 'x';
@@ -327,6 +330,9 @@ static void krealloc_less_oob_helper(str
 	ptr2 = krealloc(ptr1, size2, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 
+	/* Suppress -Warray-bounds warnings. */
+	OPTIMIZER_HIDE_VAR(ptr2);
+
 	/* Must be accessible for all modes. */
 	ptr2[size2 - 1] = 'x';
 
@@ -540,13 +546,14 @@ static void kmalloc_memmove_invalid_size
 {
 	char *ptr;
 	size_t size = 64;
-	volatile size_t invalid_size = size;
+	size_t invalid_size = size;
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
 	OPTIMIZER_HIDE_VAR(ptr);
+	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
_

Patches currently in -mm which might be from andreyknvl@google.com are


