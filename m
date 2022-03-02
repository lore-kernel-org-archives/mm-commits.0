Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42E1C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 21:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbiCBVhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiCBVhD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 16:37:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB26FC7E4B
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 13:36:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A3C7619D6
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 21:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAE5C004E1;
        Wed,  2 Mar 2022 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646256973;
        bh=Dtor6MJPpMxZjpCy4mtnxlT7xMUn3U6FdbbS92SLXVQ=;
        h=Date:To:From:Subject:From;
        b=0hOW6/eZCQOfIrOskLhEF88cHfXvHI+TB4OIS+u20XSR8HNYd1F4ANLhfKHqcOc5D
         oxt1N7IX2vgB1CNP4hE6uFjap78kMIK+z7NlucbHV6hiISHgp2AmqYu9JZ8frH2zKY
         ce4nBEGNqV/UAW21LB6M8oIKGz5DalBlUfbFMfjo=
Date:   Wed, 02 Mar 2022 13:36:12 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-update_kunit_status-to-start_report.patch added to -mm tree
Message-Id: <20220302213613.8BAE5C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move update_kunit_status to start_report
has been added to the -mm tree.  Its filename is
     kasan-move-update_kunit_status-to-start_report.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-move-update_kunit_status-to-start_report.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-move-update_kunit_status-to-start_report.patch

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
Subject: kasan: move update_kunit_status to start_report

Instead of duplicating calls to update_kunit_status() in every error
report routine, call it once in start_report().  Pass the sync flag as an
additional argument to start_report().

Link: https://lkml.kernel.org/r/cae5c845a0b6f3c867014e53737cdac56b11edc7.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   75 +++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

--- a/mm/kasan/report.c~kasan-move-update_kunit_status-to-start_report
+++ a/mm/kasan/report.c
@@ -98,13 +98,40 @@ static void print_error_description(stru
 			info->access_addr, current->comm, task_pid_nr(current));
 }
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+static void update_kunit_status(bool sync)
+{
+	struct kunit *test;
+	struct kunit_resource *resource;
+	struct kunit_kasan_status *status;
+
+	test = current->kunit_test;
+	if (!test)
+		return;
+
+	resource = kunit_find_named_resource(test, "kasan_status");
+	if (!resource) {
+		kunit_set_failure(test);
+		return;
+	}
+
+	status = (struct kunit_kasan_status *)resource->data;
+	WRITE_ONCE(status->report_found, true);
+	WRITE_ONCE(status->sync_fault, sync);
+
+	kunit_put_resource(resource);
+}
+#else
+static void update_kunit_status(bool sync) { }
+#endif
+
 static DEFINE_SPINLOCK(report_lock);
 
-static void start_report(unsigned long *flags)
+static void start_report(unsigned long *flags, bool sync)
 {
-	/*
-	 * Make sure we don't end up in loop.
-	 */
+	/* Update status of the currently running KASAN test. */
+	update_kunit_status(sync);
+	/* Make sure we don't end up in loop. */
 	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
@@ -356,33 +383,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
-static void update_kunit_status(bool sync)
-{
-	struct kunit *test;
-	struct kunit_resource *resource;
-	struct kunit_kasan_status *status;
-
-	test = current->kunit_test;
-	if (!test)
-		return;
-
-	resource = kunit_find_named_resource(test, "kasan_status");
-	if (!resource) {
-		kunit_set_failure(test);
-		return;
-	}
-
-	status = (struct kunit_kasan_status *)resource->data;
-	WRITE_ONCE(status->report_found, true);
-	WRITE_ONCE(status->sync_fault, sync);
-
-	kunit_put_resource(resource);
-}
-#else
-static void update_kunit_status(bool sync) { }
-#endif
-
 void kasan_report_invalid_free(void *object, unsigned long ip)
 {
 	unsigned long flags;
@@ -390,9 +390,7 @@ void kasan_report_invalid_free(void *obj
 
 	object = kasan_reset_tag(object);
 
-	update_kunit_status(true);
-
-	start_report(&flags);
+	start_report(&flags, true);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
 	kasan_print_tags(tag, object);
 	pr_err("\n");
@@ -406,9 +404,7 @@ void kasan_report_async(void)
 {
 	unsigned long flags;
 
-	update_kunit_status(false);
-
-	start_report(&flags);
+	start_report(&flags, false);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
@@ -425,9 +421,8 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-	update_kunit_status(true);
-
 	disable_trace_on_warning();
+	start_report(&flags, true);
 
 	tagged_addr = (void *)addr;
 	untagged_addr = kasan_reset_tag(tagged_addr);
@@ -442,8 +437,6 @@ static void __kasan_report(unsigned long
 	info.is_write = is_write;
 	info.ip = ip;
 
-	start_report(&flags);
-
 	print_error_description(&info);
 	if (addr_has_metadata(untagged_addr))
 		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
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

