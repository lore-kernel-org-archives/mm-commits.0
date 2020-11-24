Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E321DC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918CA20757
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f56qAmeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgKXAiK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgKXAiJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:38:09 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8735620758;
        Tue, 24 Nov 2020 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178288;
        bh=hj5rmMmvKqP5vPzg2o+qWaRAPUhfJ6uHKYIt8W/qjPs=;
        h=Date:From:To:Subject:From;
        b=f56qAmePRzcAjoh85sF1YYxpaqXgWZRquE35m4SMdvAQE23L83PgElPS/nBRo+LfU
         HdRYlpKRG1DF1+NQZwZj3wIEftvHegMvn1Pw6GjdLn76UnQz9F4if5FcaNWoiivZWA
         m6d+poLrqUF/YDfb2yhNSwcUsZOWNiZjAs5Pq//8=
Date:   Mon, 23 Nov 2020 16:38:05 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-remove-__kasan_unpoison_stack.patch added to -mm
 tree
Message-ID: <20201124003805.9VYhESzaZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove __kasan_unpoison_stack
has been added to the -mm tree.  Its filename is
     kasan-remove-__kasan_unpoison_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-__kasan_unpoison_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-__kasan_unpoison_stack.patch

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
Subject: kasan: remove __kasan_unpoison_stack

There's no need for __kasan_unpoison_stack() helper, as it's only
currently used in a single place. Removing it also removes unneeded
arithmetic.

No functional changes.

Link: https://lkml.kernel.org/r/93e78948704a42ea92f6248ff8a725613d721161.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ie5ba549d445292fe629b4a96735e4034957bcc50
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-remove-__kasan_unpoison_stack
+++ a/mm/kasan/common.c
@@ -65,18 +65,12 @@ void kasan_unpoison_range(const void *ad
 }
 
 #if CONFIG_KASAN_STACK
-static void __kasan_unpoison_stack(struct task_struct *task, const void *sp)
-{
-	void *base = task_stack_page(task);
-	size_t size = sp - base;
-
-	unpoison_range(base, size);
-}
-
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
-	__kasan_unpoison_stack(task, task_stack_page(task) + THREAD_SIZE);
+	void *base = task_stack_page(task);
+
+	unpoison_range(base, THREAD_SIZE);
 }
 
 /* Unpoison the stack for the current task beyond a watermark sp value. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_range.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_memory_per_shadow_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-open-code-kasan_unpoison_slab.patch
kasan-inline-unpoison_range-and-check_invalid_free.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-sanitize-objects-when-metadata-doesnt-fit.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch

