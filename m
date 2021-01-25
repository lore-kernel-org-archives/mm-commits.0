Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCD7C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CC62242A
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbhAYWd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732940AbhAYVgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:36:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D1222597;
        Mon, 25 Jan 2021 21:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610513;
        bh=3adTPiE0RX0mTmg30+b5248k21iXBd+Crd4tQPvlzLU=;
        h=Date:From:To:Subject:From;
        b=lQfccSppnbuNKJ77i4HWjmBLHns1LyShg72dwJLnz76urZgShMTpvjsnSkmKZo5Ws
         mBlUe15a4uqzlgfQw4Ph0LKRGMJ+Rp7M+cXBQE/kRy0HbL8OG7en6tjltn7NE5lO09
         LJIcP8COglFYJK8obi3XZMCUVQerZMXTCiO9J5Xs=
Date:   Mon, 25 Jan 2021 13:35:13 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch removed from -mm
 tree
Message-ID: <20210125213513.fhbRI1WpD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix resetting page_alloc tags for HW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix resetting page_alloc tags for HW_TAGS

A previous commit added resetting KASAN page tags to
kernel_init_free_pages() to avoid false-positives due to accesses to
metadata with the hardware tag-based mode.

That commit did reset page tags before the metadata access, but didn't
restore them after.  As the result, KASAN fails to detect bad accesses to
page_alloc allocations on some configurations.

Fix this by recovering the tag after the metadata access.

Link: https://lkml.kernel.org/r/02b5bcd692e912c27d484030f666b350ad7e4ae4.1611074450.git.andreyknvl@google.com
Fixes: aa1ef4d7b3f6 ("kasan, mm: reset tags when accessing metadata")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags
+++ a/mm/page_alloc.c
@@ -1207,8 +1207,10 @@ static void kernel_init_free_pages(struc
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
 	for (i = 0; i < numpages; i++) {
+		u8 tag = page_kasan_tag(page + i);
 		page_kasan_tag_reset(page + i);
 		clear_highpage(page + i);
+		page_kasan_tag_set(page + i, tag);
 	}
 	kasan_enable_current();
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch

