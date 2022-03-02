Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620B5C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiCBVgt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245352AbiCBVgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:36:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938AEC7D6C
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0310E619C9
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FB2C004E1;
        Wed,  2 Mar 2022 21:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256961;
        bh=7hvj0duAPlgcEhRgM6MRRQVOb436fNAXilzREjhGgPY=;
        h=Date:To:From:Subject:From;
        b=qB1Fa+Z7Lp+myZbLKBUvHtZ3t0qJYoeoZ0IB1J70SSey1K4vjALIb8hWZW7g/4fnO
         KOg5DiUS9QShX06A1hrddT4QPIj0e2qyn6HJXqrRPKfYoLpZzRvGQpSzWXOKv1ArST
         8DcJRJpnPlgWlQcw18tWZMBBeIyWUYeZQESz/cR8=
Date:   Wed, 02 Mar 2022 13:36:00 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rearrange-stack-frame-info-in-reports.patch added to -mm tree
Message-Id: <20220302213601.58FB2C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rearrange stack frame info in reports
has been added to the -mm tree.  Its filename is
     kasan-rearrange-stack-frame-info-in-reports.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rearrange-stack-frame-info-in-reports.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rearrange-stack-frame-info-in-reports.patch

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
Subject: kasan: rearrange stack frame info in reports

- Move printing stack frame info before printing page info.

- Add object_is_on_stack() check to print_address_description()
  and add a corresponding WARNING to kasan_print_address_stack_frame().
  This looks more in line with the rest of the checks in this function
  and also allows to avoid complicating code logic wrt line breaks.

- Clean up comments related to get_address_stack_frame_info().

Link: https://lkml.kernel.org/r/1ee113a4c111df97d168c820b527cda77a3cac40.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c         |   12 +++++++++---
 mm/kasan/report_generic.c |   15 ++++-----------
 2 files changed, 13 insertions(+), 14 deletions(-)

--- a/mm/kasan/report.c~kasan-rearrange-stack-frame-info-in-reports
+++ a/mm/kasan/report.c
@@ -259,6 +259,15 @@ static void print_address_description(vo
 		pr_err("\n");
 	}
 
+	if (object_is_on_stack(addr)) {
+		/*
+		 * Currently, KASAN supports printing frame information only
+		 * for accesses to the task's own stack.
+		 */
+		kasan_print_address_stack_frame(addr);
+		pr_err("\n");
+	}
+
 	if (is_vmalloc_addr(addr)) {
 		struct vm_struct *va = find_vm_area(addr);
 
@@ -278,9 +287,6 @@ static void print_address_description(vo
 		dump_page(page, "kasan: bad access detected");
 		pr_err("\n");
 	}
-
-	kasan_print_address_stack_frame(addr);
-	pr_err("\n");
 }
 
 static bool meta_row_is_guilty(const void *row, const void *addr)
--- a/mm/kasan/report_generic.c~kasan-rearrange-stack-frame-info-in-reports
+++ a/mm/kasan/report_generic.c
@@ -211,6 +211,7 @@ static void print_decoded_frame_descr(co
 	}
 }
 
+/* Returns true only if the address is on the current task's stack. */
 static bool __must_check get_address_stack_frame_info(const void *addr,
 						      unsigned long *offset,
 						      const char **frame_descr,
@@ -224,13 +225,6 @@ static bool __must_check get_address_sta
 
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_STACK_GROWSUP));
 
-	/*
-	 * NOTE: We currently only support printing frame information for
-	 * accesses to the task's own stack.
-	 */
-	if (!object_is_on_stack(addr))
-		return false;
-
 	aligned_addr = round_down((unsigned long)addr, sizeof(long));
 	mem_ptr = round_down(aligned_addr, KASAN_GRANULE_SIZE);
 	shadow_ptr = kasan_mem_to_shadow((void *)aligned_addr);
@@ -269,14 +263,13 @@ void kasan_print_address_stack_frame(con
 	const char *frame_descr;
 	const void *frame_pc;
 
+	if (WARN_ON(!object_is_on_stack(addr)))
+		return;
+
 	if (!get_address_stack_frame_info(addr, &offset, &frame_descr,
 					  &frame_pc))
 		return;
 
-	/*
-	 * get_address_stack_frame_info only returns true if the given addr is
-	 * on the current task's stack.
-	 */
 	pr_err("\n");
 	pr_err("addr %px is located in stack of task %s/%d at offset %lu in frame:\n",
 	       addr, current->comm, task_pid_nr(current), offset);
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

