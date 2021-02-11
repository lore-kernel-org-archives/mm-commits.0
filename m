Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD650C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858CB64E65
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhBKSdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhBKSb1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A104E64E15;
        Thu, 11 Feb 2021 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068246;
        bh=fxGPwC9pWn/7HIXom13vXpUL6HkUvAn1d6fbnSLbO4I=;
        h=Date:From:To:Subject:From;
        b=l8D4lTKicI11yxFz786ALW0AR+gLfpZDXFTiC2jeqTqGofN5gTUMurnpiCfGNuPYo
         dFXZeEUyQXYSY2yPr6CqBnLtE/vMBNpFXDSAuJrL6siXHPxuv2ttPnJ1igcf01PfTc
         2cT78j/QUzd94HZdCR/tj38ZeiE9CslhuyHwCR0Q=
Date:   Thu, 11 Feb 2021 10:30:45 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-fix-stack-traces-dependency-for-hw_tags.patch removed from -mm tree
Message-ID: <20210211183045.-4UEn42f8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix stack traces dependency for HW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-fix-stack-traces-dependency-for-hw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

