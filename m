Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AB3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 02:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiBQCtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 21:49:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiBQCtM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 21:49:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7AE2A82C1
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 18:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 650B5B820CC
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 02:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135D2C004E1;
        Thu, 17 Feb 2022 02:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066136;
        bh=ysuczBsMf9uLAGxFUkLC9QvkY6CjpQd74alkgs3EWd0=;
        h=Date:To:From:Subject:From;
        b=wYm0TI8Hl8YCUpdVBG/wWrHUqzYvRQcTYALhLY+smPLZGOf5bGcadRkM9mqSN5kCp
         R3qHBjNEiEVDaZ+K4OXKB7u8VHeiVKVTSSqNNhaiTPWh59XFt/EjrP5/ETWi6DRG7Y
         +Yv0IzTpgDrMgdJQ412G8eW+T15RnPEo7MWYsgwM=
Date:   Wed, 16 Feb 2022 18:48:55 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch added to -mm tree
Message-Id: <20220217024856.135D2C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "kasan, fork: reset pointer tags of vmapped stacks"
has been added to the -mm tree.  Its filename is
     kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch

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
Subject: fix for "kasan, fork: reset pointer tags of vmapped stacks"

That patch didn't update the case when a stack is retrived from
cached_stacks in alloc_thread_stack_node().  As cached_stacks stores
vm_structs and not stack pointers themselves, the pointer tag needs to be
reset there as well.

Link: https://lkml.kernel.org/r/f50c5f96ef896d7936192c888b0c0a7674e33184.1644943792.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix
+++ a/kernel/fork.c
@@ -226,15 +226,17 @@ static unsigned long *alloc_thread_stack
 		if (!s)
 			continue;
 
-		/* Mark stack accessible for KASAN. */
+		/* Reset stack metadata. */
 		kasan_unpoison_range(s->addr, THREAD_SIZE);
 
+		stack = kasan_reset_tag(s->addr);
+
 		/* Clear stale pointers from reused stack. */
-		memset(s->addr, 0, THREAD_SIZE);
+		memset(stack, 0, THREAD_SIZE);
 
 		tsk->stack_vm_area = s;
-		tsk->stack = s->addr;
-		return s->addr;
+		tsk->stack = stack;
+		return stack;
 	}
 
 	/*
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-test-prevent-cache-merging-in-kmem_cache_double_destroy.patch
kasan-page_alloc-deduplicate-should_skip_kasan_poison.patch
kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch
kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch
kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch
kasan-page_alloc-init-memory-of-skipped-pages-on-free.patch
kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch
mm-clarify-__gfp_zerotags-comment.patch
kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch
kasan-page_alloc-refactor-init-checks-in-post_alloc_hook.patch
kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook.patch
kasan-page_alloc-combine-tag_clear_highpage-calls-in-post_alloc_hook.patch
kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch
kasan-page_alloc-move-kernel_init_free_pages-in-post_alloc_hook.patch
kasan-page_alloc-rework-kasan_unpoison_pages-call-site.patch
kasan-clean-up-metadata-byte-definitions.patch
kasan-define-kasan_vmalloc_invalid-for-sw_tags.patch
kasan-x86-arm64-s390-rename-functions-for-modules-shadow.patch
kasan-vmalloc-drop-outdated-vm_kasan-comment.patch
kasan-reorder-vmalloc-hooks.patch
kasan-add-wrappers-for-vmalloc-hooks.patch
kasan-vmalloc-reset-tags-in-vmalloc-functions.patch
kasan-fork-reset-pointer-tags-of-vmapped-stacks.patch
kasan-arm64-reset-pointer-tags-of-vmapped-stacks.patch
kasan-fork-reset-pointer-tags-of-vmapped-stacks-fix.patch
kasan-vmalloc-add-vmalloc-tagging-for-sw_tags.patch
kasan-vmalloc-arm64-mark-vmalloc-mappings-as-pgprot_tagged.patch
kasan-vmalloc-unpoison-vm_alloc-pages-after-mapping.patch
kasan-mm-only-define-___gfp_skip_kasan_poison-with-hw_tags.patch
kasan-page_alloc-allow-skipping-unpoisoning-for-hw_tags.patch
kasan-page_alloc-allow-skipping-memory-init-for-hw_tags.patch
kasan-vmalloc-add-vmalloc-tagging-for-hw_tags.patch
kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch
kasan-arm64-dont-tag-executable-vmalloc-allocations.patch
kasan-mark-kasan_arg_stacktrace-as-__initdata.patch
kasan-clean-up-feature-flags-for-hw_tags-mode.patch
kasan-add-kasanvmalloc-command-line-flag.patch
kasan-allow-enabling-kasan_vmalloc-and-sw-hw_tags.patch
arm64-select-kasan_vmalloc-for-sw-hw_tags-modes.patch
kasan-documentation-updates.patch
kasan-improve-vmalloc-tests.patch
kasan-improve-vmalloc-tests-fix-2.patch
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch

