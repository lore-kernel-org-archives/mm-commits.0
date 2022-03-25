Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49272C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353645AbiCYAes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiCYAer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508A2AE1A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB606178F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41529C340ED;
        Fri, 25 Mar 2022 00:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168391;
        bh=EMtXU3L1KWta2f+kt63xLMyFaTy7Fak0/Nlxg7xpsqs=;
        h=Date:To:From:Subject:From;
        b=AHilE4XApdUeVwbxG+f87pLdhLuFhqdjMnqYvYuSE86j96y0MLLL/cm6kBwKeGYRS
         GZ71nMq0C1+IIBVm5lbsazkb/xsT41eoKjXFfkNQ6Uyl63/VBBZa4JBgFVzheGHfOt
         Bgzr2+AYP3gDCMCtsjrdlJ+fM72hmJ7GI9McJuPo=
Date:   Thu, 24 Mar 2022 17:33:10 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-improve-vmalloc-tests-fix-2.patch removed from -mm tree
Message-Id: <20220325003311.41529C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "kasan: improve vmalloc tests"
has been removed from the -mm tree.  Its filename was
     kasan-improve-vmalloc-tests-fix-2.patch

This patch was dropped because it was folded into kasan-improve-vmalloc-tests.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: fix for "kasan: improve vmalloc tests"

vmap_tags() and vm_map_ram_tags() pass invalid page array size to
vm_map_ram() and vm_unmap_ram().  It's supposed to be 1, but it's 1 <<
order == 2 currently.

Remove order variable (it can only be 0 with the current code) and
hardcode the number of pages in these tests.

Link: https://lkml.kernel.org/r/865c91ba49b90623ab50c7526b79ccb955f544f0.1644950160.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix-2
+++ a/lib/test_kasan.c
@@ -1145,7 +1145,6 @@ static void vmap_tags(struct kunit *test
 {
 	char *p_ptr, *v_ptr;
 	struct page *p_page, *v_page;
-	size_t order = 1;
 
 	/*
 	 * This test is specifically crafted for the software tag-based mode,
@@ -1155,12 +1154,12 @@ static void vmap_tags(struct kunit *test
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
-	p_page = alloc_pages(GFP_KERNEL, order);
+	p_page = alloc_pages(GFP_KERNEL, 1);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_page);
 	p_ptr = page_address(p_page);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_ptr);
 
-	v_ptr = vmap(&p_page, 1 << order, VM_MAP, PAGE_KERNEL);
+	v_ptr = vmap(&p_page, 1, VM_MAP, PAGE_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
 	/*
@@ -1182,14 +1181,13 @@ static void vmap_tags(struct kunit *test
 	KUNIT_EXPECT_PTR_EQ(test, p_page, v_page);
 
 	vunmap(v_ptr);
-	free_pages((unsigned long)p_ptr, order);
+	free_pages((unsigned long)p_ptr, 1);
 }
 
 static void vm_map_ram_tags(struct kunit *test)
 {
 	char *p_ptr, *v_ptr;
 	struct page *page;
-	size_t order = 1;
 
 	/*
 	 * This test is specifically crafted for the software tag-based mode,
@@ -1197,12 +1195,12 @@ static void vm_map_ram_tags(struct kunit
 	 */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
 
-	page = alloc_pages(GFP_KERNEL, order);
+	page = alloc_pages(GFP_KERNEL, 1);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, page);
 	p_ptr = page_address(page);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_ptr);
 
-	v_ptr = vm_map_ram(&page, 1 << order, -1);
+	v_ptr = vm_map_ram(&page, 1, -1);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
 	KUNIT_EXPECT_GE(test, (u8)get_tag(v_ptr), (u8)KASAN_TAG_MIN);
@@ -1212,8 +1210,8 @@ static void vm_map_ram_tags(struct kunit
 	*p_ptr = 0;
 	*v_ptr = 0;
 
-	vm_unmap_ram(v_ptr, 1 << order);
-	free_pages((unsigned long)p_ptr, order);
+	vm_unmap_ram(v_ptr, 1);
+	free_pages((unsigned long)p_ptr, 1);
 }
 
 static void vmalloc_percpu(struct kunit *test)
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

