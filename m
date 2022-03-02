Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13234C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbiCBVhW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiCBVhS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:37:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48435C7E5D
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E44B82259
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8278EC004E1;
        Wed,  2 Mar 2022 21:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256985;
        bh=96A5JRNnyywLiun41iva+AOp29tbQ+4m9cmMS4vOqdw=;
        h=Date:To:From:Subject:From;
        b=IBDdCAdCN5tM9IbylXLqmLXwTnw/vY9Vo/IWh1uE8D0xUfQLmJf0NZJue/F2tH5bn
         qDESd9fd5ciOOdrZS8CC+VItU6ppq0VAuQSmjcDWdzU2FrlIzMsFBxskak4Ah2Lgcu
         LzEAa4Vtm+R3EolBOsilLAdoz0o0a4DnrwklQy8Y=
Date:   Wed, 02 Mar 2022 13:36:24 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-call-print_report-from-kasan_report_invalid_free.patch added to -mm tree
Message-Id: <20220302213625.8278EC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: call print_report from kasan_report_invalid_free
has been added to the -mm tree.  Its filename is
     kasan-call-print_report-from-kasan_report_invalid_free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-call-print_report-from-kasan_report_invalid_free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-call-print_report-from-kasan_report_invalid_free.patch

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
Subject: kasan: call print_report from kasan_report_invalid_free

Call print_report() in kasan_report_invalid_free() instead of calling
printing functions directly.  Compared to the existing implementation of
kasan_report_invalid_free(), print_report() makes sure that the buggy
address has metadata before printing it.

The change requires adding a report type field into kasan_access_info and
using it accordingly.

kasan_report_async() is left as is, as using print_report() will only
complicate the code.

Link: https://lkml.kernel.org/r/9ea6f0604c5d2e1fb28d93dc6c44232c1f8017fe.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    6 ++++++
 mm/kasan/report.c |   42 ++++++++++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 16 deletions(-)

--- a/mm/kasan/kasan.h~kasan-call-print_report-from-kasan_report_invalid_free
+++ a/mm/kasan/kasan.h
@@ -127,7 +127,13 @@ static inline bool kasan_sync_fault_poss
 #define META_MEM_BYTES_PER_ROW (META_BYTES_PER_ROW * KASAN_GRANULE_SIZE)
 #define META_ROWS_AROUND_ADDR 2
 
+enum kasan_report_type {
+	KASAN_REPORT_ACCESS,
+	KASAN_REPORT_INVALID_FREE,
+};
+
 struct kasan_access_info {
+	enum kasan_report_type type;
 	void *access_addr;
 	void *first_bad_addr;
 	size_t access_size;
--- a/mm/kasan/report.c~kasan-call-print_report-from-kasan_report_invalid_free
+++ a/mm/kasan/report.c
@@ -86,6 +86,12 @@ __setup("kasan_multi_shot", kasan_set_mu
 
 static void print_error_description(struct kasan_access_info *info)
 {
+	if (info->type == KASAN_REPORT_INVALID_FREE) {
+		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
+		       (void *)info->ip);
+		return;
+	}
+
 	pr_err("BUG: KASAN: %s in %pS\n",
 		kasan_get_bug_type(info), (void *)info->ip);
 	if (info->access_size)
@@ -386,22 +392,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-void kasan_report_invalid_free(void *object, unsigned long ip)
-{
-	unsigned long flags;
-	u8 tag = get_tag(object);
-
-	object = kasan_reset_tag(object);
-
-	start_report(&flags, true);
-	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
-	kasan_print_tags(tag, object);
-	pr_err("\n");
-	print_address_description(object, tag);
-	print_memory_metadata(object);
-	end_report(&flags, object);
-}
-
 #ifdef CONFIG_KASAN_HW_TAGS
 void kasan_report_async(void)
 {
@@ -435,6 +425,25 @@ static void print_report(struct kasan_ac
 	}
 }
 
+void kasan_report_invalid_free(void *ptr, unsigned long ip)
+{
+	unsigned long flags;
+	struct kasan_access_info info;
+
+	start_report(&flags, true);
+
+	info.type = KASAN_REPORT_INVALID_FREE;
+	info.access_addr = ptr;
+	info.first_bad_addr = kasan_reset_tag(ptr);
+	info.access_size = 0;
+	info.is_write = false;
+	info.ip = ip;
+
+	print_report(&info);
+
+	end_report(&flags, ptr);
+}
+
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
@@ -451,6 +460,7 @@ bool kasan_report(unsigned long addr, si
 
 	start_report(&irq_flags, true);
 
+	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = ptr;
 	info.first_bad_addr = kasan_find_first_bad_addr(ptr, size);
 	info.access_size = size;
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

