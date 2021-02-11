Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988C1C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 682E064E42
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBKXh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhBKXh4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 18:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A2564E3B;
        Thu, 11 Feb 2021 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613086635;
        bh=Y0yMru31UrucsoP1cXrzDL8bhOJ6HvR1dLXj495qjzg=;
        h=Date:From:To:Subject:From;
        b=RZwntBMgLtD3woMkc/GK5pJtUTflKL8aSzb6GOSkSrFtfJDEFHoX+7c/cA+eBQp6o
         LL6Jc8P6p6DcyNlkWCLNaMd+MM4D6sfY3k6pH6vpVehS8edvQxL2ueFH9XAc7XYW1/
         HVqrwVwMdwppvs7V+px/ZLVvq2aDNpM8fzm5eoeI=
Date:   Thu, 11 Feb 2021 15:37:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        vincenzo.frascino@arm.com, pcc@google.com, kevin.brodsky@arm.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, catalin.marinas@arm.com,
        Branislav.Rankov@arm.com, aryabinin@virtuozzo.com,
        andreyknvl@google.com
Subject:  [to-be-updated]
 arm64-kasan-export-mte-symbols-for-kasan-tests.patch removed from -mm tree
Message-ID: <20210211233714.2qSGE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: export MTE symbols for KASAN tests
has been removed from the -mm tree.  Its filename was
     arm64-kasan-export-mte-symbols-for-kasan-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: kasan: export MTE symbols for KASAN tests

Export mte_enable_kernel() and mte_set_report_once() to fix:

ERROR: modpost: "mte_enable_kernel" [lib/test_kasan.ko] undefined!
ERROR: modpost: "mte_set_report_once" [lib/test_kasan.ko] undefined!

Link: https://lkml.kernel.org/r/14da91876a25a6ae5b2096f7c06ebbc6deb3cf6b.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/mte.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/mte.c~arm64-kasan-export-mte-symbols-for-kasan-tests
+++ a/arch/arm64/kernel/mte.c
@@ -113,11 +113,13 @@ void mte_enable_kernel(void)
 	sysreg_clear_set(sctlr_el1, SCTLR_ELx_TCF_MASK, SCTLR_ELx_TCF_SYNC);
 	isb();
 }
+EXPORT_SYMBOL_GPL(mte_enable_kernel);
 
 void mte_set_report_once(bool state)
 {
 	WRITE_ONCE(report_fault_once, state);
 }
+EXPORT_SYMBOL_GPL(mte_set_report_once);
 
 bool mte_report_once(void)
 {
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
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

