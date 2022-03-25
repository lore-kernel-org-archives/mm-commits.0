Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB25C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiCYUqC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiCYUp6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B741032061
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42AFC61D49
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E308C004DD;
        Fri, 25 Mar 2022 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648241057;
        bh=yXWQ3N+ltYL1F6TcYu0VLVJcZP8POks8Z2YQDiiHHfI=;
        h=Date:To:From:Subject:From;
        b=r+lL875noSCBWUxGdKT7OjpPlG+BsQuOkfpK3XP0rhRqkZQVtACpQKVo3v/HJbQLb
         WDEo+aOSM/DvPrm4l8MIGkjiWKOM9GBshY3MefczvR+FACSLDxZZ0m3cHOFt9o8yOR
         BpmOxpBqjWwyfKK60JTd/ShcJL7q83BNT7FjeOJk=
Date:   Fri, 25 Mar 2022 13:44:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, samitolvanen@google.com,
        ryabinin.a.a@gmail.com, pcc@google.com, mark.rutland@arm.com,
        glider@google.com, fmayer@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-stack_trace_save_shadow.patch added to -mm tree
Message-Id: <20220325204417.9E308C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use stack_trace_save_shadow
has been added to the -mm tree.  Its filename is
     kasan-use-stack_trace_save_shadow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-use-stack_trace_save_shadow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-stack_trace_save_shadow.patch

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
Subject: kasan: use stack_trace_save_shadow

Now that stack_trace_save_shadow() is implemented by arm64, use it
whenever CONFIG_HAVE_SHADOW_STACKTRACE is enabled.  This improves the boot
time of a defconfig build by ~30% for all KASAN modes.

Link: https://lkml.kernel.org/r/7027b9b6b0cae2921ff65739582ae499bf61470c.1648049113.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Florian Mayer <fmayer@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-use-stack_trace_save_shadow
+++ a/mm/kasan/common.c
@@ -33,10 +33,13 @@
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
-	unsigned int nr_entries;
+	unsigned int size;
 
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
+	if (IS_ENABLED(CONFIG_HAVE_SHADOW_STACKTRACE))
+		size = stack_trace_save_shadow(entries, ARRAY_SIZE(entries), 0);
+	else
+		size = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	return __stack_depot_save(entries, size, flags, can_alloc);
 }
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
_

Patches currently in -mm which might be from andreyknvl@google.com are

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
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch
kasan-print-virtual-mapping-info-in-reports.patch
kasan-drop-addr-check-from-describe_object_addr.patch
kasan-more-line-breaks-in-reports.patch
kasan-rearrange-stack-frame-info-in-reports.patch
kasan-improve-stack-frame-info-in-reports.patch
kasan-print-basic-stack-frame-info-for-sw_tags.patch
kasan-simplify-async-check-in-end_report.patch
kasan-simplify-kasan_update_kunit_status-and-call-sites.patch
kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch
kasan-move-update_kunit_status-to-start_report.patch
kasan-move-disable_trace_on_warning-to-start_report.patch
kasan-split-out-print_report-from-__kasan_report.patch
kasan-simplify-kasan_find_first_bad_addr-call-sites.patch
kasan-restructure-kasan_report.patch
kasan-merge-__kasan_report-into-kasan_report.patch
kasan-call-print_report-from-kasan_report_invalid_free.patch
kasan-move-and-simplify-kasan_report_async.patch
kasan-rename-kasan_access_info-to-kasan_report_info.patch
kasan-add-comment-about-uaccess-regions-to-kasan_report.patch
kasan-respect-kasan_bit_reported-in-all-reporting-routines.patch
kasan-reorder-reporting-functions.patch
kasan-move-and-hide-kasan_save_enable-restore_multi_shot.patch
kasan-disable-lockdep-when-printing-reports.patch
stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

