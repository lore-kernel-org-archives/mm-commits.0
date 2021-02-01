Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83964C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA1664ED2
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhBAXy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhBAXy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:54:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E284764ECC;
        Mon,  1 Feb 2021 23:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223658;
        bh=3Tbw5NVvdpkAUDonHJvR6vwDw55XHNmIjCBVcdHFtvU=;
        h=Date:From:To:Subject:From;
        b=uDvgtSQTLOyViyhAhtMMgLO2h50qrPEO1p3fefkr5TkDbC61ISExxiA3N0yVn+m/x
         jV+tWU+S6dZ4LxFQIBIzETcQfSG159Oavn43iADtt0wRcMqOh0JFaBRM41z5EB+z1N
         8KDVUTUtrBgzT9rnAc/AbqJpQxRT61QbaqQcqEWE=
Date:   Mon, 01 Feb 2021 15:54:17 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  +
 kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch added to -mm
 tree
Message-ID: <20210201235417.bAo--Vqz1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: untag addresses for KFENCE
has been added to the -mm tree.  Its filename is
     kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch

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
Subject: kasan: untag addresses for KFENCE

KFENCE annotations operate on untagged addresses.

Untag addresses in KASAN runtime where they might be tagged.

Link: https://lkml.kernel.org/r/9dc196006921b191d25d10f6e611316db7da2efc.1611946152.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 mm/kasan/kasan.h  |   12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/mm/kasan/common.c~kfence-kasan-make-kfence-compatible-with-kasan-fix-2
+++ a/mm/kasan/common.c
@@ -416,7 +416,7 @@ static void *____kasan_kmalloc(struct km
 	if (unlikely(object == NULL))
 		return NULL;
 
-	if (is_kfence_address(object))
+	if (is_kfence_address(kasan_reset_tag(object)))
 		return (void *)object;
 
 	redzone_start = round_up((unsigned long)(object + size),
--- a/mm/kasan/kasan.h~kfence-kasan-make-kfence-compatible-with-kasan-fix-2
+++ a/mm/kasan/kasan.h
@@ -320,22 +320,28 @@ static inline u8 kasan_random_tag(void)
 
 static inline void kasan_poison(const void *address, size_t size, u8 value)
 {
+	address = kasan_reset_tag(address);
+
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
 	if (is_kfence_address(address))
 		return;
 
-	hw_set_mem_tag_range(kasan_reset_tag(address),
+	hw_set_mem_tag_range((void *)address,
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 static inline void kasan_unpoison(const void *address, size_t size)
 {
+	u8 tag = get_tag(address);
+
+	address = kasan_reset_tag(address);
+
 	/* Skip KFENCE memory if called explicitly outside of sl*b. */
 	if (is_kfence_address(address))
 		return;
 
-	hw_set_mem_tag_range(kasan_reset_tag(address),
-			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
+	hw_set_mem_tag_range((void *)address,
+			round_up(size, KASAN_GRANULE_SIZE), tag);
 }
 
 static inline bool kasan_byte_accessible(const void *addr)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-remove-krealloc-side-effect.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-always-inline-hw_tags-helper-functions.patch
arm64-kasan-export-mte-symbols-for-kasan-tests.patch

