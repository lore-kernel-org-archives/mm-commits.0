Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F5BC43331
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9567D64E90
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhBYT1O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:27:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhBYTZ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B886864F83;
        Thu, 25 Feb 2021 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280531;
        bh=5c9xI5faQeyqDDUyJhifQNj7kV1bCokihtih+Oubscs=;
        h=Date:From:To:Subject:From;
        b=o48cZtJIgleVLXt5L161s52win/ctsYcVGWBA70Ub2S1RRMMlwF9Z8K9NztHnjTSE
         49vwrck7T5JfAflaz+ioIJ1R7ZXfhkECV9HumyaF1BH+1uNIeFrfgo+9qE5dTprcic
         MKHlD0SHFGx0VTIQlg1s+I408QQ4DnCIGeSMMslU=
Date:   Thu, 25 Feb 2021 11:15:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-add-match-all-tag-tests.patch removed from
 -mm tree
Message-ID: <20210225191530.GR4FqXGBX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add match-all tag tests
has been removed from the -mm tree.  Its filename was
     kasan-add-match-all-tag-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add match-all tag tests

Add 3 new tests for tag-based KASAN modes:

1. Check that match-all pointer tag is not assigned randomly.
2. Check that 0xff works as a match-all pointer tag.
3. Check that there are no match-all memory tags.

Note, that test #3 causes a significant number (255) of KASAN reports
to be printed during execution for the SW_TAGS mode.

[arnd@arndb.de: export kasan_poison]
  Link: https://lkml.kernel.org/r/20210125112831.2156212-1-arnd@kernel.org
[akpm@linux-foundation.org: s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/, per Andrey]
Link: https://linux-review.googlesource.com/id/I78f1375efafa162b37f3abcb2c5bc2f3955dfd8e
Link: https://lkml.kernel.org/r/da841a5408e2204bf25f3b23f70540a65844e8a4.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c  |   92 ++++++++++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h  |    6 ++
 mm/kasan/shadow.c |    1 
 3 files changed, 99 insertions(+)

--- a/lib/test_kasan.c~kasan-add-match-all-tag-tests
+++ a/lib/test_kasan.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
@@ -754,6 +755,94 @@ static void vmalloc_oob(struct kunit *te
 	vfree(area);
 }
 
+/*
+ * Check that the assigned pointer tag falls within the [KASAN_TAG_MIN,
+ * KASAN_TAG_KERNEL) range (note: excluding the match-all tag) for tag-based
+ * modes.
+ */
+static void match_all_not_assigned(struct kunit *test)
+{
+	char *ptr;
+	struct page *pages;
+	int i, size, order;
+
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	for (i = 0; i < 256; i++) {
+		size = (get_random_int() % 1024) + 1;
+		ptr = kmalloc(size, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+		kfree(ptr);
+	}
+
+	for (i = 0; i < 256; i++) {
+		order = (get_random_int() % 4) + 1;
+		pages = alloc_pages(GFP_KERNEL, order);
+		ptr = page_address(pages);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+		free_pages((unsigned long)ptr, order);
+	}
+}
+
+/* Check that 0xff works as a match-all pointer tag for tag-based modes. */
+static void match_all_ptr_tag(struct kunit *test)
+{
+	char *ptr;
+	u8 tag;
+
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	ptr = kmalloc(128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	/* Backup the assigned tag. */
+	tag = get_tag(ptr);
+	KUNIT_EXPECT_NE(test, tag, (u8)KASAN_TAG_KERNEL);
+
+	/* Reset the tag to 0xff.*/
+	ptr = set_tag(ptr, KASAN_TAG_KERNEL);
+
+	/* This access shouldn't trigger a KASAN report. */
+	*ptr = 0;
+
+	/* Recover the pointer tag and free. */
+	ptr = set_tag(ptr, tag);
+	kfree(ptr);
+}
+
+/* Check that there are no match-all memory tags for tag-based modes. */
+static void match_all_mem_tag(struct kunit *test)
+{
+	char *ptr;
+	int tag;
+
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	ptr = kmalloc(128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	KUNIT_EXPECT_NE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+
+	/* For each possible tag value not matching the pointer tag. */
+	for (tag = KASAN_TAG_MIN; tag <= KASAN_TAG_KERNEL; tag++) {
+		if (tag == get_tag(ptr))
+			continue;
+
+		/* Mark the first memory granule with the chosen memory tag. */
+		kasan_poison(ptr, KASAN_GRANULE_SIZE, (u8)tag);
+
+		/* This access must cause a KASAN report. */
+		KUNIT_EXPECT_KASAN_FAIL(test, *ptr = 0);
+	}
+
+	/* Recover the memory tag and free. */
+	kasan_poison(ptr, KASAN_GRANULE_SIZE, get_tag(ptr));
+	kfree(ptr);
+}
+
 static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
@@ -793,6 +882,9 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_bitops_tags),
 	KUNIT_CASE(kmalloc_double_kzfree),
 	KUNIT_CASE(vmalloc_oob),
+	KUNIT_CASE(match_all_not_assigned),
+	KUNIT_CASE(match_all_ptr_tag),
+	KUNIT_CASE(match_all_mem_tag),
 	{}
 };
 
--- a/mm/kasan/kasan.h~kasan-add-match-all-tag-tests
+++ a/mm/kasan/kasan.h
@@ -36,6 +36,12 @@ extern bool kasan_flag_panic __ro_after_
 #define KASAN_TAG_INVALID	0xFE /* inaccessible memory tag */
 #define KASAN_TAG_MAX		0xFD /* maximum value for random tags */
 
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN		0xF0 /* mimimum value for random tags */
+#else
+#define KASAN_TAG_MIN		0x00 /* mimimum value for random tags */
+#endif
+
 #ifdef CONFIG_KASAN_GENERIC
 #define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
--- a/mm/kasan/shadow.c~kasan-add-match-all-tag-tests
+++ a/mm/kasan/shadow.c
@@ -89,6 +89,7 @@ void kasan_poison(const void *address, s
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
+EXPORT_SYMBOL(kasan_poison);
 
 void kasan_unpoison(const void *address, size_t size)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

