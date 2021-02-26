Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26BAC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F22A64F47
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBZBWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhBZBUy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA83364F26;
        Fri, 26 Feb 2021 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302412;
        bh=wce53Xwwu9lKx3GmC4ec2EKIUUqHbhyBfKHLHqVMRbA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bWED7WbFR9P83v/ZjKKHDjlFrzaMYti4mj4n+w78IS/6cVme7j+BnTLjUiLzzvKot
         4PQZDIomXBKBGdiVWLzIygbb9c8ctgXdl/5lNwGSerTKcGY2gE6E94BXdBtcjDcwmO
         QAFTy2dsGmiHGcFHJRu2WYF1HmV9KcXBSAFBgtzc=
Date:   Thu, 25 Feb 2021 17:20:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 074/118] kasan: unify large kfree checks
Message-ID: <20210226012011.dU6In8D5z%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: unify large kfree checks

Unify checks in kasan_kfree_large() and in kasan_slab_free_mempool() for
large allocations as it's done for small kfree() allocations.

With this change, kasan_slab_free_mempool() starts checking that the first
byte of the memory that's being freed is accessible.

Link: https://lkml.kernel.org/r/14ffc4cd867e0b1ed58f7527e3b748a1b4ad08aa.1612546384.git.andreyknvl@google.com
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

 include/linux/kasan.h |   16 ++++++++--------
 mm/kasan/common.c     |   36 ++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 18 deletions(-)

--- a/include/linux/kasan.h~kasan-unify-large-kfree-checks
+++ a/include/linux/kasan.h
@@ -200,6 +200,13 @@ static __always_inline bool kasan_slab_f
 	return false;
 }
 
+void __kasan_kfree_large(void *ptr, unsigned long ip);
+static __always_inline void kasan_kfree_large(void *ptr)
+{
+	if (kasan_enabled())
+		__kasan_kfree_large(ptr, _RET_IP_);
+}
+
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip);
 static __always_inline void kasan_slab_free_mempool(void *ptr)
 {
@@ -247,13 +254,6 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
-void __kasan_kfree_large(void *ptr, unsigned long ip);
-static __always_inline void kasan_kfree_large(void *ptr)
-{
-	if (kasan_enabled())
-		__kasan_kfree_large(ptr, _RET_IP_);
-}
-
 /*
  * Unlike kasan_check_read/write(), kasan_check_byte() is performed even for
  * the hardware tag-based mode that doesn't rely on compiler instrumentation.
@@ -302,6 +302,7 @@ static inline bool kasan_slab_free(struc
 {
 	return false;
 }
+static inline void kasan_kfree_large(void *ptr) {}
 static inline void kasan_slab_free_mempool(void *ptr) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags)
@@ -322,7 +323,6 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
-static inline void kasan_kfree_large(void *ptr) {}
 static inline bool kasan_check_byte(const void *address)
 {
 	return true;
--- a/mm/kasan/common.c~kasan-unify-large-kfree-checks
+++ a/mm/kasan/common.c
@@ -364,6 +364,31 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
+static bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+{
+	if (ptr != page_address(virt_to_head_page(ptr))) {
+		kasan_report_invalid_free(ptr, ip);
+		return true;
+	}
+
+	if (!kasan_byte_accessible(ptr)) {
+		kasan_report_invalid_free(ptr, ip);
+		return true;
+	}
+
+	/*
+	 * The object will be poisoned by kasan_free_pages() or
+	 * kasan_slab_free_mempool().
+	 */
+
+	return false;
+}
+
+void __kasan_kfree_large(void *ptr, unsigned long ip)
+{
+	____kasan_kfree_large(ptr, ip);
+}
+
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
 {
 	struct page *page;
@@ -377,10 +402,8 @@ void __kasan_slab_free_mempool(void *ptr
 	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
 	 */
 	if (unlikely(!PageSlab(page))) {
-		if (ptr != page_address(page)) {
-			kasan_report_invalid_free(ptr, ip);
+		if (____kasan_kfree_large(ptr, ip))
 			return;
-		}
 		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE);
 	} else {
 		____kasan_slab_free(page->slab_cache, ptr, ip, false);
@@ -539,13 +562,6 @@ void * __must_check __kasan_krealloc(con
 		return ____kasan_kmalloc(page->slab_cache, object, size, flags);
 }
 
-void __kasan_kfree_large(void *ptr, unsigned long ip)
-{
-	if (ptr != page_address(virt_to_head_page(ptr)))
-		kasan_report_invalid_free(ptr, ip);
-	/* The object will be poisoned by kasan_free_pages(). */
-}
-
 bool __kasan_check_byte(const void *address, unsigned long ip)
 {
 	if (!kasan_byte_accessible(address)) {
_
