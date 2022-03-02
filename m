Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AEEC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbiCBVgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbiCBVgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912455EBE8
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C1A6619CB
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F85BC004E1;
        Wed,  2 Mar 2022 21:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256959;
        bh=OuQlpq46S21ujckTHkTzJHWb42zigghrFeVqQ2OObTY=;
        h=Date:To:From:Subject:From;
        b=H1i1WWxsj//mUIiQVORsstJE4lacWDDqNDU8eDgkK7NMFaUbDFz34CymyelXn58h5
         tjYT+U2j0AlQgzmEiKJ0r3GWvaHoUNdHp0zxRM4cvfNzFVFAitAdX4d6NDB+/c4Xm3
         5hYUlhevRnfGSV2fyhaXKLYphwo98PZh5HsY77Xw=
Date:   Wed, 02 Mar 2022 13:35:57 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-more-line-breaks-in-reports.patch added to -mm tree
Message-Id: <20220302213559.7F85BC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: more line breaks in reports
has been added to the -mm tree.  Its filename is
     kasan-more-line-breaks-in-reports.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-more-line-breaks-in-reports.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-more-line-breaks-in-reports.patch

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
Subject: kasan: more line breaks in reports

Add a line break after each part that describes the buggy address. 
Improves readability of reports.

Link: https://lkml.kernel.org/r/8682c4558e533cd0f99bdb964ce2fe741f2a9212.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kasan/report.c~kasan-more-line-breaks-in-reports
+++ a/mm/kasan/report.c
@@ -250,11 +250,13 @@ static void print_address_description(vo
 		void *object = nearest_obj(cache, slab,	addr);
 
 		describe_object(cache, object, addr, tag);
+		pr_err("\n");
 	}
 
 	if (kernel_or_module_addr(addr) && !init_task_stack_addr(addr)) {
 		pr_err("The buggy address belongs to the variable:\n");
 		pr_err(" %pS\n", addr);
+		pr_err("\n");
 	}
 
 	if (is_vmalloc_addr(addr)) {
@@ -265,6 +267,7 @@ static void print_address_description(vo
 			       " [%px, %px) created by:\n"
 			       " %pS\n",
 			       va->addr, va->addr + va->size, va->caller);
+			pr_err("\n");
 
 			page = vmalloc_to_page(page);
 		}
@@ -273,9 +276,11 @@ static void print_address_description(vo
 	if (page) {
 		pr_err("The buggy address belongs to the physical page:\n");
 		dump_page(page, "kasan: bad access detected");
+		pr_err("\n");
 	}
 
 	kasan_print_address_stack_frame(addr);
+	pr_err("\n");
 }
 
 static bool meta_row_is_guilty(const void *row, const void *addr)
@@ -382,7 +387,6 @@ void kasan_report_invalid_free(void *obj
 	kasan_print_tags(tag, object);
 	pr_err("\n");
 	print_address_description(object, tag);
-	pr_err("\n");
 	print_memory_metadata(object);
 	end_report(&flags, (unsigned long)object);
 }
@@ -443,7 +447,6 @@ static void __kasan_report(unsigned long
 
 	if (addr_has_metadata(untagged_addr)) {
 		print_address_description(untagged_addr, get_tag(tagged_addr));
-		pr_err("\n");
 		print_memory_metadata(info.first_bad_addr);
 	} else {
 		dump_stack_lvl(KERN_ERR);
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

