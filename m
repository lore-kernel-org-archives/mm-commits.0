Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22EDC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCCA64F2F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhB0Cc0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhB0Cb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6912964F3B;
        Sat, 27 Feb 2021 02:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393075;
        bh=QKBcLVeUnwvQhoxt8bKr+AfupQzn0cvt/dwsL1J/Ka0=;
        h=Date:From:To:Subject:From;
        b=XJ8u/HJSgxH50KaUjM1gti0878b6AMawDVWSTXXY5kmsn1EgGw1FuySqXWL3ieKrw
         gj99Ogy/fsqUbC9wlks0nyZapINUfzD47EHZLBisx+ArS0ld9OYHYnP/rR87+mjLVv
         BHbNHOP/NOqU45MT02WNJCxOCnM8VVrcP9oa9OZk=
Date:   Fri, 26 Feb 2021 18:31:15 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-optimize-large-kmalloc-poisoning.patch
 removed from -mm tree
Message-ID: <20210227023115.41TTH1nuN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: optimize large kmalloc poisoning
has been removed from the -mm tree.  Its filename was
     kasan-optimize-large-kmalloc-poisoning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: optimize large kmalloc poisoning

Similarly to kasan_kmalloc(), kasan_kmalloc_large() doesn't need to
unpoison the object as it as already unpoisoned by alloc_pages() (or by
ksize() for krealloc()).

This patch changes kasan_kmalloc_large() to only poison the redzone.

Link: https://lkml.kernel.org/r/33dee5aac0e550ad7f8e26f590c9b02c6129b4a3.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 mm/kasan/common.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/kasan/common.c~kasan-optimize-large-kmalloc-poisoning
+++ a/mm/kasan/common.c
@@ -494,7 +494,6 @@ EXPORT_SYMBOL(__kasan_kmalloc);
 void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
 						gfp_t flags)
 {
-	struct page *page;
 	unsigned long redzone_start;
 	unsigned long redzone_end;
 
@@ -504,12 +503,23 @@ void * __must_check __kasan_kmalloc_larg
 	if (unlikely(ptr == NULL))
 		return NULL;
 
-	page = virt_to_page(ptr);
+	/*
+	 * The object has already been unpoisoned by kasan_alloc_pages() for
+	 * alloc_pages() or by ksize() for krealloc().
+	 */
+
+	/*
+	 * The redzone has byte-level precision for the generic mode.
+	 * Partially poison the last object granule to cover the unaligned
+	 * part of the redzone.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+		kasan_poison_last_granule(ptr, size);
+
+	/* Poison the aligned part of the redzone. */
 	redzone_start = round_up((unsigned long)(ptr + size),
 				KASAN_GRANULE_SIZE);
-	redzone_end = (unsigned long)ptr + page_size(page);
-
-	kasan_unpoison(ptr, size);
+	redzone_end = (unsigned long)ptr + page_size(virt_to_page(ptr));
 	kasan_poison((void *)redzone_start, redzone_end - redzone_start,
 		     KASAN_PAGE_REDZONE);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


