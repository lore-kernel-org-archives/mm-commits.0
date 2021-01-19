Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841C5C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3379123104
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbhASTbw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbhAST2Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01C5B216FD;
        Tue, 19 Jan 2021 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611084414;
        bh=kk+ZHqPLeKL7yNQw1JVunOvFp41P3iYLn+/RQNG8o7s=;
        h=Date:From:To:Subject:From;
        b=j6BUZn3Jm64nq5CS4m+WYDY1DwGlrS8tc3U/JFHPmPhV6xJ2cinaKhOtKC+oG2qZy
         8SF0WSzglMIk+6nAt1wYGfmlyA6BmzVipGc+2upEpuU5k3KdLS8604qi6YYThtPDLB
         Ukl/eBc32rNXTXILgdUlMj3Bwr+CLsGgOWBdNs8g=
Date:   Tue, 19 Jan 2021 11:26:53 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch added to -mm tree
Message-ID: <20210119192653.hoHV66y3P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix resetting page_alloc tags for HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-fix-hw_tags-boot-parameters.patch
kasan-mm-fix-conflicts-with-init_on_alloc-free.patch
kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags.patch
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

