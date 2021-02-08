Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F41C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 20:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEEE64E6C
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 20:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbhBHUZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 15:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhBHUYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 15:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0332864DD5;
        Mon,  8 Feb 2021 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612815853;
        bh=RLxxXgxHx1ukzUcqYuEkTEiD/Lv8eldB4zTX56+aH8I=;
        h=Date:From:To:Subject:From;
        b=i0AycTkzv7j/U814D0OGR/29k/nmcPjZd1TVEYgH/I4klZwGPGoGa2glJ7+em6R0h
         M1wZCtGv2zcBx5wmYlMm2nkUndPmAuBKavkcKdJO5+Ap6DsySyh+sazJFq005x1DJ+
         BewVujtTSkPcw+uVxQG3kzPlBfy/C+fGKHAlE1N0=
Date:   Mon, 08 Feb 2021 12:24:12 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-fix-stack-traces-dependency-for-hw_tags.patch
 added to -mm tree
Message-ID: <20210208202412.1NQGP-N8b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix stack traces dependency for HW_TAGS
has been added to the -mm tree.  Its filename is
     kasan-fix-stack-traces-dependency-for-hw_tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-stack-traces-dependency-for-hw_tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-stack-traces-dependency-for-hw_tags.patch

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
Subject: kasan: fix stack traces dependency for HW_TAGS

Currently, whether the alloc/free stack traces collection is enabled by
default for hardware tag-based KASAN depends on CONFIG_DEBUG_KERNEL.  The
intention for this dependency was to only enable collection on slow debug
kernels due to a significant perf and memory impact.

As it turns out, CONFIG_DEBUG_KERNEL is not considered a debug option and
is enabled on many productions kernels including Android and Ubuntu.  As
the result, this dependency is pointless and only complicates the code and
documentation.

Having stack traces collection disabled by default would make the hardware
mode work differently to to the software ones, which is confusing.

This change removes the dependency and enables stack traces collection by
default.

Looking into the future, this default might makes sense for production
kernels, assuming we implement a fast stack trace collection approach.

Link: https://lkml.kernel.org/r/6678d77ceffb71f1cff2cf61560e2ffe7bb6bfe9.1612808820.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 +--
 mm/kasan/hw_tags.c                |    8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-fix-stack-traces-dependency-for-hw_tags
+++ a/Documentation/dev-tools/kasan.rst
@@ -163,8 +163,7 @@ particular KASAN features.
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
-  traces collection (default: ``on`` for ``CONFIG_DEBUG_KERNEL=y``, otherwise
-  ``off``).
+  traces collection (default: ``on``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
   report or also panic the kernel (default: ``report``).
--- a/mm/kasan/hw_tags.c~kasan-fix-stack-traces-dependency-for-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -134,12 +134,8 @@ void __init kasan_init_hw_tags(void)
 
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
-		/*
-		 * Default to enabling stack trace collection for
-		 * debug kernels.
-		 */
-		if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
-			static_branch_enable(&kasan_flag_stacktrace);
+		/* Default to enabling stack trace collection. */
+		static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	case KASAN_ARG_STACKTRACE_OFF:
 		/* Do nothing, kasan_flag_stacktrace keeps its default value. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-stack-traces-dependency-for-hw_tags.patch
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
arm64-kasan-export-mte-symbols-for-kasan-tests.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

