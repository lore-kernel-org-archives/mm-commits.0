Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDD4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356075AbiCYAcx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244454AbiCYAcs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CE0BB0A4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17F9BB826E8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F0C340EC;
        Fri, 25 Mar 2022 00:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168272;
        bh=OWl60GIbzVIuuGXE5HtwhVhXsbGB6e36GaAF5IcqmfE=;
        h=Date:To:From:Subject:From;
        b=i1Js9XxdcPC0hA7ZV2SV1tdS2eiL2AVF+mHnHckbDrnqxsXAI7OevmBflSKRKb+U1
         GhJu/UNQavHYzTJaNTJmdowCfRQtyfnlxh0toMzLvwHGK7+ZHlxkAWcp3HcSUUluBo
         btBksGMWIRYBSnNit9gqvFCR10hYbsWUPJA9Rm3I=
Date:   Thu, 24 Mar 2022 17:31:12 -0700
To:     mm-commits@vger.kernel.org, gor@linux.ibm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-vmalloc-only-tag-normal-vmalloc-allocations-fix-3.patch removed from -mm tree
Message-Id: <20220325003112.C17F0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "kasan, vmalloc: only tag normal vmalloc allocations"
has been removed from the -mm tree.  Its filename was
     kasan-vmalloc-only-tag-normal-vmalloc-allocations-fix-3.patch

This patch was dropped because it was folded into kasan-vmalloc-only-tag-normal-vmalloc-allocations.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: fix for "kasan, vmalloc: only tag normal vmalloc allocations"

"kasan, vmalloc: only tag normal vmalloc allocations" unintentionally
disabled poisoning of executable memory for the Generic mode.  Fix it.

Link: https://lkml.kernel.org/r/de4587d6a719232e83c760113e46ed2d4d8da61e.1646757322.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-vmalloc-only-tag-normal-vmalloc-allocations-fix-3
+++ a/mm/kasan/shadow.c
@@ -489,10 +489,11 @@ void *__kasan_unpoison_vmalloc(const voi
 		return (void *)start;
 
 	/*
-	 * Don't tag executable memory.
+	 * Don't tag executable memory with the tag-based mode.
 	 * The kernel doesn't tolerate having the PC register tagged.
 	 */
-	if (!(flags & KASAN_VMALLOC_PROT_NORMAL))
+	if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) &&
+	    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 		return (void *)start;
 
 	start = set_tag(start, kasan_random_tag());
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
kasan-improve-vmalloc-tests-fix-2.patch
kasan-improve-vmalloc-tests-fix-3.patch
kasan-test-support-async-again-and-asymm-modes-for-hw_tags.patch
kasan-print-virtual-mapping-info-in-reports.patch
kasan-drop-addr-check-from-describe_object_addr.patch
kasan-more-line-breaks-in-reports.patch
kasan-rearrange-stack-frame-info-in-reports.patch
kasan-improve-stack-frame-info-in-reports.patch
kasan-print-basic-stack-frame-info-for-sw_tags.patch
kasan-print-basic-stack-frame-info-for-sw_tags-fix.patch
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

