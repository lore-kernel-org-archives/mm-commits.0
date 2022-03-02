Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BA7C43219
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbiCBVhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245350AbiCBVhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:37:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE809C7E69
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98361B82264
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A54CC004E1;
        Wed,  2 Mar 2022 21:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256977;
        bh=79x9piyfK2ZEVzzFf49JQsW62JcLwckkA/dyYUxB57Y=;
        h=Date:To:From:Subject:From;
        b=EMsFKOiIQTjOdoe9C0iMHQ897jtBXFJocgZZr/3Aua0LjUqX0exIybFGOwjVw2o15
         xMQcpyMeG/UKpXnE0Z/Xn5Ul17UtyE/OPQ9W5ph1c2PMdI0MtaqexEgTr/0l6wZgFc
         Y+eeiuvMSkEFm7c1X+Ps4KOh8oesywsM+EALDQZA=
Date:   Wed, 02 Mar 2022 13:36:16 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-split-out-print_report-from-__kasan_report.patch added to -mm tree
Message-Id: <20220302213617.3A54CC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: split out print_report from __kasan_report
has been added to the -mm tree.  Its filename is
     kasan-split-out-print_report-from-__kasan_report.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-split-out-print_report-from-__kasan_report.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-split-out-print_report-from-__kasan_report.patch

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
Subject: kasan: split out print_report from __kasan_report

Split out the part of __kasan_report() that prints things into
print_report().  One of the subsequent patches makes another error handler
use print_report() as well.

Includes lower-level changes:

- Allow addr_has_metadata() accepting a tagged address.
- Drop the const qualifier from the fields of kasan_access_info to avoid
  excessive type casts.
- Change the type of the address argument of __kasan_report() and
  end_report() to void * to reduce the number of type casts.

Link: https://lkml.kernel.org/r/9be3ed99dd24b9c4e1c4a848b69a0c6ecefd845e.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    7 +++--
 mm/kasan/report.c |   58 +++++++++++++++++++++++---------------------
 2 files changed, 35 insertions(+), 30 deletions(-)

--- a/mm/kasan/kasan.h~kasan-split-out-print_report-from-__kasan_report
+++ a/mm/kasan/kasan.h
@@ -128,8 +128,8 @@ static inline bool kasan_sync_fault_poss
 #define META_ROWS_AROUND_ADDR 2
 
 struct kasan_access_info {
-	const void *access_addr;
-	const void *first_bad_addr;
+	void *access_addr;
+	void *first_bad_addr;
 	size_t access_size;
 	bool is_write;
 	unsigned long ip;
@@ -239,7 +239,8 @@ static inline const void *kasan_shadow_t
 
 static inline bool addr_has_metadata(const void *addr)
 {
-	return (addr >= kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
+	return (kasan_reset_tag(addr) >=
+		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
 }
 
 /**
--- a/mm/kasan/report.c~kasan-split-out-print_report-from-__kasan_report
+++ a/mm/kasan/report.c
@@ -139,10 +139,11 @@ static void start_report(unsigned long *
 	pr_err("==================================================================\n");
 }
 
-static void end_report(unsigned long *flags, unsigned long addr)
+static void end_report(unsigned long *flags, void *addr)
 {
 	if (addr)
-		trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
+		trace_error_report_end(ERROR_DETECTOR_KASAN,
+				       (unsigned long)addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
@@ -398,7 +399,7 @@ void kasan_report_invalid_free(void *obj
 	pr_err("\n");
 	print_address_description(object, tag);
 	print_memory_metadata(object);
-	end_report(&flags, (unsigned long)object);
+	end_report(&flags, object);
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -411,44 +412,47 @@ void kasan_report_async(void)
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
 	dump_stack_lvl(KERN_ERR);
-	end_report(&flags, 0);
+	end_report(&flags, NULL);
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-static void __kasan_report(unsigned long addr, size_t size, bool is_write,
+static void print_report(struct kasan_access_info *info)
+{
+	void *tagged_addr = info->access_addr;
+	void *untagged_addr = kasan_reset_tag(tagged_addr);
+	u8 tag = get_tag(tagged_addr);
+
+	print_error_description(info);
+	if (addr_has_metadata(untagged_addr))
+		kasan_print_tags(tag, info->first_bad_addr);
+	pr_err("\n");
+
+	if (addr_has_metadata(untagged_addr)) {
+		print_address_description(untagged_addr, tag);
+		print_memory_metadata(info->first_bad_addr);
+	} else {
+		dump_stack_lvl(KERN_ERR);
+	}
+}
+
+static void __kasan_report(void *addr, size_t size, bool is_write,
 				unsigned long ip)
 {
 	struct kasan_access_info info;
-	void *tagged_addr;
-	void *untagged_addr;
 	unsigned long flags;
 
 	start_report(&flags, true);
 
-	tagged_addr = (void *)addr;
-	untagged_addr = kasan_reset_tag(tagged_addr);
-
-	info.access_addr = tagged_addr;
-	if (addr_has_metadata(untagged_addr))
-		info.first_bad_addr =
-			kasan_find_first_bad_addr(tagged_addr, size);
+	info.access_addr = addr;
+	if (addr_has_metadata(addr))
+		info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
 	else
-		info.first_bad_addr = untagged_addr;
+		info.first_bad_addr = addr;
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
 
-	print_error_description(&info);
-	if (addr_has_metadata(untagged_addr))
-		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
-	pr_err("\n");
-
-	if (addr_has_metadata(untagged_addr)) {
-		print_address_description(untagged_addr, get_tag(tagged_addr));
-		print_memory_metadata(info.first_bad_addr);
-	} else {
-		dump_stack_lvl(KERN_ERR);
-	}
+	print_report(&info);
 
 	end_report(&flags, addr);
 }
@@ -460,7 +464,7 @@ bool kasan_report(unsigned long addr, si
 	bool ret = false;
 
 	if (likely(report_enabled())) {
-		__kasan_report(addr, size, is_write, ip);
+		__kasan_report((void *)addr, size, is_write, ip);
 		ret = true;
 	}
 
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

