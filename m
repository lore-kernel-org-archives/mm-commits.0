Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA72C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S246220AbiAYDqK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415188AbiAYA7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 19:59:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC5C06B580
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 14:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3883B81255
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 22:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FDEC340E4;
        Mon, 24 Jan 2022 22:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643064216;
        bh=H6W3ytW5mpEtNu9MJh35tGHOzeWkSNckcYMTZPvpIgE=;
        h=Date:From:To:Subject:From;
        b=cnbahSMMNxrjzGihqQksZNa/RKFXChJaqcwf4p4ur+Abn187/M3gQvn65McQB8Asq
         sxwyE6NKWXOSzaBI9Ng3Yc8sOlS9BTUYyvs4LQv4YXhuMYmskY4K+U3mrIYTaFgVSG
         6cq7zYaTDqfjV+7ENv8MaTgat2J6ZsvS8cIpeY+E=
Date:   Mon, 24 Jan 2022 14:43:35 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, catalin.marinas@arm.com, dvyukov@google.com,
        elver@google.com, eugenis@google.com, glider@google.com,
        mark.rutland@arm.com, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, will@kernel.org
Subject:  + kasan-improve-vmalloc-tests.patch added to -mm tree
Message-ID: <20220124224335.ZfgQkLMuw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve vmalloc tests
has been added to the -mm tree.  Its filename is
     kasan-improve-vmalloc-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-vmalloc-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-vmalloc-tests.patch

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
Subject: kasan: improve vmalloc tests

Update the existing vmalloc_oob() test to account for the specifics of the
tag-based modes.  Also add a few new checks and comments.

Add new vmalloc-related tests:

- vmalloc_helpers_tags() to check that exported vmalloc helpers can
  handle tagged pointers.
- vmap_tags() to check that SW_TAGS mode properly tags vmap() mappings.
- vm_map_ram_tags() to check that SW_TAGS mode properly tags
  vm_map_ram() mappings.
- vmalloc_percpu() to check that SW_TAGS mode tags regions allocated
  for __alloc_percpu(). The tagging of per-cpu mappings is best-effort;
  proper tagging is tracked in [1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=215019

Link: https://lkml.kernel.org/r/bbdc1c0501c5275e7f26fdb8e2a7b14a40a9f36b.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |  189 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 183 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests
+++ a/lib/test_kasan.c
@@ -19,6 +19,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/set_memory.h>
 
 #include <asm/page.h>
 
@@ -1049,21 +1050,181 @@ static void kmalloc_double_kzfree(struct
 	KUNIT_EXPECT_KASAN_FAIL(test, kfree_sensitive(ptr));
 }
 
+static void vmalloc_helpers_tags(struct kunit *test)
+{
+	void *ptr;
+	int rv;
+
+	/* This test is intended for tag-based modes. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
+
+	ptr = vmalloc(PAGE_SIZE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	/* Check that the returned pointer is tagged. */
+	KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+	KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+
+	/* Make sure exported vmalloc helpers handle tagged pointers. */
+	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
+
+	/* Make sure vmalloc'ed memory permissions can be changed. */
+	rv = set_memory_ro((unsigned long)ptr, 1);
+	KUNIT_ASSERT_GE(test, rv, 0);
+	rv = set_memory_rw((unsigned long)ptr, 1);
+	KUNIT_ASSERT_GE(test, rv, 0);
+
+	vfree(ptr);
+}
+
 static void vmalloc_oob(struct kunit *test)
 {
-	void *area;
+	char *v_ptr, *p_ptr;
+	struct page *page;
+	size_t size = PAGE_SIZE / 2 - KASAN_GRANULE_SIZE - 5;
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
 
+	v_ptr = vmalloc(size);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
 	/*
-	 * We have to be careful not to hit the guard page.
+	 * We have to be careful not to hit the guard page in vmalloc tests.
 	 * The MMU will catch that and crash us.
 	 */
-	area = vmalloc(3000);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, area);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)area)[3100]);
-	vfree(area);
+	/* Make sure in-bounds accesses are valid. */
+	v_ptr[0] = 0;
+	v_ptr[size - 1] = 0;
+
+	/*
+	 * An unaligned access past the requested vmalloc size.
+	 * Only generic KASAN can precisely detect these.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
+
+	/* An aligned access into the first out-of-bounds granule. */
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5]);
+
+	/* Check that in-bounds accesses to the physical page are valid. */
+	page = vmalloc_to_page(v_ptr);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, page);
+	p_ptr = page_address(page);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_ptr);
+	p_ptr[0] = 0;
+
+	vfree(v_ptr);
+
+	/*
+	 * We can't check for use-after-unmap bugs in this nor in the following
+	 * vmalloc tests, as the page might be fully unmapped and accessing it
+	 * will crash the kernel.
+	 */
+}
+
+static void vmap_tags(struct kunit *test)
+{
+	char *p_ptr, *v_ptr;
+	struct page *p_page, *v_page;
+	size_t order = 1;
+
+	/*
+	 * This test is specifically crafted for the software tag-based mode,
+	 * the only tag-based mode that poisons vmap mappings.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
+
+	p_page = alloc_pages(GFP_KERNEL, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_page);
+	p_ptr = page_address(p_page);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_ptr);
+
+	v_ptr = vmap(&p_page, 1 << order, VM_MAP, PAGE_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
+	/*
+	 * We can't check for out-of-bounds bugs in this nor in the following
+	 * vmalloc tests, as allocations have page granularity and accessing
+	 * the guard page will crash the kernel.
+	 */
+
+	KUNIT_EXPECT_GE(test, (u8)get_tag(v_ptr), (u8)KASAN_TAG_MIN);
+	KUNIT_EXPECT_LT(test, (u8)get_tag(v_ptr), (u8)KASAN_TAG_KERNEL);
+
+	/* Make sure that in-bounds accesses through both pointers work. */
+	*p_ptr = 0;
+	*v_ptr = 0;
+
+	/* Make sure vmalloc_to_page() correctly recovers the page pointer. */
+	v_page = vmalloc_to_page(v_ptr);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_page);
+	KUNIT_EXPECT_PTR_EQ(test, p_page, v_page);
+
+	vunmap(v_ptr);
+	free_pages((unsigned long)p_ptr, order);
+}
+
+static void vm_map_ram_tags(struct kunit *test)
+{
+	char *p_ptr, *v_ptr;
+	struct page *page;
+	size_t order = 1;
+
+	/*
+	 * This test is specifically crafted for the software tag-based mode,
+	 * the only tag-based mode that poisons vm_map_ram mappings.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
+
+	page = alloc_pages(GFP_KERNEL, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, page);
+	p_ptr = page_address(page);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p_ptr);
+
+	v_ptr = vm_map_ram(&page, 1 << order, -1);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
+
+	KUNIT_EXPECT_GE(test, (u8)get_tag(v_ptr), (u8)KASAN_TAG_MIN);
+	KUNIT_EXPECT_LT(test, (u8)get_tag(v_ptr), (u8)KASAN_TAG_KERNEL);
+
+	/* Make sure that in-bounds accesses through both pointers work. */
+	*p_ptr = 0;
+	*v_ptr = 0;
+
+	vm_unmap_ram(v_ptr, 1 << order);
+	free_pages((unsigned long)p_ptr, order);
+}
+
+static void vmalloc_percpu(struct kunit *test)
+{
+	char __percpu *ptr;
+	int cpu;
+
+	/*
+	 * This test is specifically crafted for the software tag-based mode,
+	 * the only tag-based mode that poisons percpu mappings.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_SW_TAGS);
+
+	ptr = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
+
+	for_each_possible_cpu(cpu) {
+		char *c_ptr = per_cpu_ptr(ptr, cpu);
+
+		KUNIT_EXPECT_GE(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(c_ptr), (u8)KASAN_TAG_KERNEL);
+
+		/* Make sure that in-bounds accesses don't crash the kernel. */
+		*c_ptr = 0;
+	}
+
+	free_percpu(ptr);
 }
 
 /*
@@ -1097,6 +1258,18 @@ static void match_all_not_assigned(struc
 		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
 		free_pages((unsigned long)ptr, order);
 	}
+
+	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+		return;
+
+	for (i = 0; i < 256; i++) {
+		size = (get_random_int() % 1024) + 1;
+		ptr = vmalloc(size);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+		vfree(ptr);
+	}
 }
 
 /* Check that 0xff works as a match-all pointer tag for tag-based modes. */
@@ -1202,7 +1375,11 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
 	KUNIT_CASE(kmalloc_double_kzfree),
+	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
+	KUNIT_CASE(vmap_tags),
+	KUNIT_CASE(vm_map_ram_tags),
+	KUNIT_CASE(vmalloc_percpu),
 	KUNIT_CASE(match_all_not_assigned),
 	KUNIT_CASE(match_all_ptr_tag),
 	KUNIT_CASE(match_all_mem_tag),
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

