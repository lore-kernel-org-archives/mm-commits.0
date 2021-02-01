Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29687C433E9
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7AF64EAA
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 22:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBAWrF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhBAWq4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 17:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE7C64ED2;
        Mon,  1 Feb 2021 22:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612219574;
        bh=LK/I/oa8prx0ZB3JNPseDa7Y/CLkeYueGARr71NROMM=;
        h=Date:From:To:Subject:From;
        b=lAZ1uI4tf3Uf8MP7LpyK6TsZuaTtUYctRBaYUotqAo4aFqPiNKBqSmIGReftGPNIg
         fvvq01dz5wbQYw8vNFdLdVYI5fl8y5SBA4fqzBjDF2gGRc8zFHv6S0kEIkFBvKtfol
         Rg9/poBmagrkmzqFSa10W9q+LPVQoDHglrROIUJw=
Date:   Mon, 01 Feb 2021 14:46:13 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-clean-up-setting-free-info-in-kasan_slab_free.patch added to -mm tree
Message-ID: <20210201224613.CIRUcZNUY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clean up setting free info in kasan_slab_free
has been added to the -mm tree.  Its filename is
     kasan-clean-up-setting-free-info-in-kasan_slab_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-clean-up-setting-free-info-in-kasan_slab_free.patch

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
Subject: kasan: clean up setting free info in kasan_slab_free

Put kasan_stack_collection_enabled() check and kasan_set_free_info() calls
next to each other.

The way this was previously implemented was a minor optimization that
relied of the the fact that kasan_stack_collection_enabled() is always
true for generic KASAN.  The confusion that this brings outweights saving
a few instructions.

Link: https://lkml.kernel.org/r/e762958db74587308514341a18622ff350a75d8a.1612208222.git.andreyknvl@google.com
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

 mm/kasan/common.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-setting-free-info-in-kasan_slab_free
+++ a/mm/kasan/common.c
@@ -350,13 +350,11 @@ static bool ____kasan_slab_free(struct k
 
 	kasan_poison(object, cache->object_size, KASAN_KMALLOC_FREE);
 
-	if (!kasan_stack_collection_enabled())
-		return false;
-
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
 
-	kasan_set_free_info(cache, object, tag);
+	if (kasan_stack_collection_enabled())
+		kasan_set_free_info(cache, object, tag);
 
 	return kasan_quarantine_put(cache, object);
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

