Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7B3C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbiCBVhX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245370AbiCBVhS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:37:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A53C7E73
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 125C9618E1
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C5BC004E1;
        Wed,  2 Mar 2022 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256989;
        bh=RV6ZuNSR2uxxc1FCVnucj6XJIq4lTsjtzMAorcLL0yY=;
        h=Date:To:From:Subject:From;
        b=G1XdvhhJW5UGCmY8GyYVLr4iKI7l4W1uGikwwdQeN+4hauoAh74VsEtNUWAbIACs4
         g5cq9vOcJsv3HSLHrUCdlYPG9rsMteCyWs6eRYV1xV/f/xo+niH5S4CPADcDWufJ+7
         KpmsEWhXZiieI31GEOl0+SM6KD5k5Fc+FJpBcmF4=
Date:   Wed, 02 Mar 2022 13:36:28 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-rename-kasan_access_info-to-kasan_report_info.patch added to -mm tree
Message-Id: <20220302213629.63C5BC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename kasan_access_info to kasan_report_info
has been added to the -mm tree.  Its filename is
     kasan-rename-kasan_access_info-to-kasan_report_info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rename-kasan_access_info-to-kasan_report_info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rename-kasan_access_info-to-kasan_report_info.patch

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
Subject: kasan: rename kasan_access_info to kasan_report_info

Rename kasan_access_info to kasan_report_info, as the latter name better
reflects the struct's purpose.

Link: https://lkml.kernel.org/r/158a4219a5d356901d017352558c989533a0782c.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |    4 ++--
 mm/kasan/report.c         |    8 ++++----
 mm/kasan/report_generic.c |    6 +++---
 mm/kasan/report_tags.c    |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/kasan/kasan.h~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/kasan.h
@@ -132,7 +132,7 @@ enum kasan_report_type {
 	KASAN_REPORT_INVALID_FREE,
 };
 
-struct kasan_access_info {
+struct kasan_report_info {
 	enum kasan_report_type type;
 	void *access_addr;
 	void *first_bad_addr;
@@ -276,7 +276,7 @@ static inline void kasan_print_tags(u8 a
 #endif
 
 void *kasan_find_first_bad_addr(void *addr, size_t size);
-const char *kasan_get_bug_type(struct kasan_access_info *info);
+const char *kasan_get_bug_type(struct kasan_report_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
 #if defined(CONFIG_KASAN_STACK)
--- a/mm/kasan/report.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report.c
@@ -84,7 +84,7 @@ static int __init kasan_set_multi_shot(c
 }
 __setup("kasan_multi_shot", kasan_set_multi_shot);
 
-static void print_error_description(struct kasan_access_info *info)
+static void print_error_description(struct kasan_report_info *info)
 {
 	if (info->type == KASAN_REPORT_INVALID_FREE) {
 		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
@@ -392,7 +392,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-static void print_report(struct kasan_access_info *info)
+static void print_report(struct kasan_report_info *info)
 {
 	void *tagged_addr = info->access_addr;
 	void *untagged_addr = kasan_reset_tag(tagged_addr);
@@ -414,7 +414,7 @@ static void print_report(struct kasan_ac
 void kasan_report_invalid_free(void *ptr, unsigned long ip)
 {
 	unsigned long flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	start_report(&flags, true);
 
@@ -437,7 +437,7 @@ bool kasan_report(unsigned long addr, si
 	void *ptr = (void *)addr;
 	unsigned long ua_flags = user_access_save();
 	unsigned long irq_flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	if (unlikely(!report_enabled())) {
 		ret = false;
--- a/mm/kasan/report_generic.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_generic.c
@@ -43,7 +43,7 @@ void *kasan_find_first_bad_addr(void *ad
 	return p;
 }
 
-static const char *get_shadow_bug_type(struct kasan_access_info *info)
+static const char *get_shadow_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 	u8 *shadow_addr;
@@ -95,7 +95,7 @@ static const char *get_shadow_bug_type(s
 	return bug_type;
 }
 
-static const char *get_wild_bug_type(struct kasan_access_info *info)
+static const char *get_wild_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 
@@ -109,7 +109,7 @@ static const char *get_wild_bug_type(str
 	return bug_type;
 }
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
--- a/mm/kasan/report_tags.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_tags.c
@@ -7,7 +7,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 #ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
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

