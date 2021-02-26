Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6CDC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666AA64EDB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhBZArf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhBZAr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:47:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7E8E64EDB;
        Fri, 26 Feb 2021 00:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300408;
        bh=TZxr5J5ZgC9I7Vuro/4AlWExdsHCYUmxqsC44g8B+Nc=;
        h=Date:From:To:Subject:From;
        b=tYFdiRb+T8gStg5blf8yUr9BXDVU7gyLA2omovvGuFBKpD20PKxQ39o59fPX1hNMv
         8vGmhRs2ZsnkBsAETyLu70As+BPfJTnCPC4ixp0f5v3AcbnkWQzrj+FbkMzU+w/BSh
         KE4l2MQT0FQXhS2iv54k26dz1kAeF1Hu2C5hQdZo=
Date:   Thu, 25 Feb 2021 16:46:47 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch removed from -mm
 tree
Message-ID: <20210226004647.OMWZwTCiT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: untag addresses for KFENCE
has been removed from the -mm tree.  Its filename was
     kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch

This patch was dropped because it was folded into kfence-kasan-make-kfence-compatible-with-kasan.patch

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

kfence-kasan-make-kfence-compatible-with-kasan.patch
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

