Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38005C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245347AbiCBVhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245364AbiCBVhD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:37:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806D2C7E58
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF0C619D0
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B429C004E1;
        Wed,  2 Mar 2022 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256975;
        bh=5mCCWqjygsyDSg5gvHQdg224qWq8qBj+6PsksQTG20Y=;
        h=Date:To:From:Subject:From;
        b=1Ese+uqU9z1IshLI6hgemDj0lJgw9XXyQK7zAh5xdFO2/8Tnfqj0Lcv5jDMAARINF
         GUORDaXNkDfngs2al3e45DQdLxIBbE3zn0FE4zcZzl+DbGEeuKX5bv+hqeIoahbyYD
         3YdShh0RoYUY8rqxzu78QVkNjQjjHjVJOrUE/Q5E=
Date:   Wed, 02 Mar 2022 13:36:14 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-disable_trace_on_warning-to-start_report.patch added to -mm tree
Message-Id: <20220302213615.6B429C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move disable_trace_on_warning to start_report
has been added to the -mm tree.  Its filename is
     kasan-move-disable_trace_on_warning-to-start_report.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-move-disable_trace_on_warning-to-start_report.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-move-disable_trace_on_warning-to-start_report.patch

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
Subject: kasan: move disable_trace_on_warning to start_report

Move the disable_trace_on_warning() call, which enables the
/proc/sys/kernel/traceoff_on_warning interface for KASAN bugs, to
start_report(), so that it functions for all types of KASAN reports.

Link: https://lkml.kernel.org/r/7c066c5de26234ad2cebdd931adfe437f8a95d58.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-move-disable_trace_on_warning-to-start_report
+++ a/mm/kasan/report.c
@@ -129,6 +129,8 @@ static DEFINE_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
+	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
+	disable_trace_on_warning();
 	/* Update status of the currently running KASAN test. */
 	update_kunit_status(sync);
 	/* Make sure we don't end up in loop. */
@@ -421,7 +423,6 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-	disable_trace_on_warning();
 	start_report(&flags, true);
 
 	tagged_addr = (void *)addr;
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
kasan-improve-vmalloc-tests-fix-3.patch
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

