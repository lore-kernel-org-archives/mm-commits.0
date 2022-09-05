Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56FFECAAA1
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiIEWtn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiIEWtC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:49:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4503E696D1
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9EA60C94
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CD1C433C1;
        Mon,  5 Sep 2022 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418139;
        bh=Jfl/XfbtmuenpXDyeMwq38Gwn5sLg5v7Z7U6YyyXEWU=;
        h=Date:To:From:Subject:From;
        b=nqLriZa7Wznh4MYG19oTGOHyl9RaNzSrAmQe5BluIhQ3Y76ptnH01SXh0Vo2QlxqK
         cTuwusdUqQcpXoaA/XDUDGl8e5mM94ie1XATZzRESSJi0BTVnjSxDSPKelqsK6r/Io
         Xtsg8DNfB8GAv72sZTgLq9lgR1O6m/VzONPTt/wg=
Date:   Mon, 05 Sep 2022 15:48:58 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-another-use-after-free-test.patch added to mm-unstable branch
Message-Id: <20220905224859.81CD1C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add another use-after-free test
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-another-use-after-free-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-another-use-after-free-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add another use-after-free test
Date: Mon, 5 Sep 2022 23:05:49 +0200

Add a new use-after-free test that checks that KASAN detects
use-after-free when another object was allocated in the same slot.

This test is mainly relevant for the tag-based modes, which do not use
quarantine.

Once [1] is resolved, this test can be extended to check that the stack
traces in the report point to the proper kmalloc/kfree calls.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=212203

Link: https://lkml.kernel.org/r/0659cfa15809dd38faa02bc0a59d0b5dbbd81211.1662411800.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/lib/test_kasan.c~kasan-add-another-use-after-free-test
+++ a/lib/test_kasan.c
@@ -612,6 +612,29 @@ again:
 	kfree(ptr2);
 }
 
+/*
+ * Check that KASAN detects use-after-free when another object was allocated in
+ * the same slot. Relevant for the tag-based modes, which do not use quarantine.
+ */
+static void kmalloc_uaf3(struct kunit *test)
+{
+	char *ptr1, *ptr2;
+	size_t size = 100;
+
+	/* This test is specifically crafted for tag-based modes. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	ptr1 = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
+	kfree(ptr1);
+
+	ptr2 = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
+	kfree(ptr2);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
+}
+
 static void kfree_via_page(struct kunit *test)
 {
 	char *ptr;
@@ -1382,6 +1405,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_uaf),
 	KUNIT_CASE(kmalloc_uaf_memset),
 	KUNIT_CASE(kmalloc_uaf2),
+	KUNIT_CASE(kmalloc_uaf3),
 	KUNIT_CASE(kfree_via_page),
 	KUNIT_CASE(kfree_via_phys),
 	KUNIT_CASE(kmem_cache_oob),
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

