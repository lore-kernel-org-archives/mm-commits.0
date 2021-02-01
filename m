Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB84DC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0DFF64DDB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBAWrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhBAWrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 17:47:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DBAA64ECC;
        Mon,  1 Feb 2021 22:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612219600;
        bh=sqGZV9jJecrghB3NdpClZ7W72KWoIZLR818OeqUrzug=;
        h=Date:From:To:Subject:From;
        b=hthQr66pw6dqQFuq2HCzy29SMPGzVEOgZZiskjyZskeKWtU/Zd4C/SXFzmeV2GMtS
         BxH6LMWRrwx+73sLrhAJDxf6kEsMP/BIFp4LJ7pZrSD+RQJYayEDQadeXOtgVvtKlp
         Nny56xnkkDJtKaUqCN06xK6sxFCMgZC6+y0cQQVg=
Date:   Mon, 01 Feb 2021 14:46:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + arm64-kasan-export-mte-symbols-for-kasan-tests.patch
 added to -mm tree
Message-ID: <20210201224639.hsTwVDV5H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: export MTE symbols for KASAN tests
has been added to the -mm tree.  Its filename is
     arm64-kasan-export-mte-symbols-for-kasan-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-export-mte-symbols-for-kasan-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-export-mte-symbols-for-kasan-tests.patch

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
Subject: arm64: kasan: export MTE symbols for KASAN tests

Export mte_enable_kernel() and mte_set_report_once() to fix:

ERROR: modpost: "mte_enable_kernel" [lib/test_kasan.ko] undefined!
ERROR: modpost: "mte_set_report_once" [lib/test_kasan.ko] undefined!

Link: https://lkml.kernel.org/r/d128216d3b0aea0b4178e11978f5dd3e8dbeb590.1612208222.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
@@ -118,6 +118,8 @@ void mte_set_report_once(bool state)
 {
 	WRITE_ONCE(report_fault_once, state);
 }
+EXPORT_SYMBOL(mte_enable_kernel_sync);
+EXPORT_SYMBOL(mte_set_report_once);
 
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
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-remove-krealloc-side-effect.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-always-inline-hw_tags-helper-functions.patch
arm64-kasan-export-mte-symbols-for-kasan-tests.patch

