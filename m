Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B673C3526C
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 630DD23B88
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgLRWFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgLRWFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:48 -0500
Date:   Fri, 18 Dec 2020 14:05:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329107;
        bh=9TsHQ6uDKwIEBcEbiKo3oU2d3k0N/gw6C3j6ssode7M=;
        h=From:To:Subject:In-Reply-To:From;
        b=BKlb4Kt3rU4Ltg5MmBjvuVN+vJrGVHIuXOPLY7jo/5yX7CzETvoTLuCmncf4xDsku
         ahhv2euNqTfYYkDM86YK3O0b7ULKqSrDsK/JDDUTpU95e92tzwTnlteIlqLQL50wg3
         LWdnebOVPjqGka72s0Y/y0DCyJxVrTGx81SRUc/0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 67/78] kasan, mm: rename kasan_poison_kfree
Message-ID: <20201218220506.CAXpvj66H%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: rename kasan_poison_kfree

Rename kasan_poison_kfree() to kasan_slab_free_mempool() as it better
reflects what this annotation does. Also add a comment that explains the
PageSlab() check.

No functional changes.

Link: https://lkml.kernel.org/r/141675fb493555e984c5dca555e9d9f768c7bbaa.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I5026f87364e556b506ef1baee725144bb04b8810
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   16 ++++++++--------
 mm/kasan/common.c     |   40 +++++++++++++++++++++++-----------------
 mm/mempool.c          |    2 +-
 3 files changed, 32 insertions(+), 26 deletions(-)

--- a/include/linux/kasan.h~kasan-mm-rename-kasan_poison_kfree
+++ a/include/linux/kasan.h
@@ -176,6 +176,13 @@ static __always_inline bool kasan_slab_f
 	return false;
 }
 
+void __kasan_slab_free_mempool(void *ptr, unsigned long ip);
+static __always_inline void kasan_slab_free_mempool(void *ptr, unsigned long ip)
+{
+	if (kasan_enabled())
+		__kasan_slab_free_mempool(ptr, ip);
+}
+
 void * __must_check __kasan_slab_alloc(struct kmem_cache *s,
 				       void *object, gfp_t flags);
 static __always_inline void * __must_check kasan_slab_alloc(
@@ -216,13 +223,6 @@ static __always_inline void * __must_che
 	return (void *)object;
 }
 
-void __kasan_poison_kfree(void *ptr, unsigned long ip);
-static __always_inline void kasan_poison_kfree(void *ptr, unsigned long ip)
-{
-	if (kasan_enabled())
-		__kasan_poison_kfree(ptr, ip);
-}
-
 void __kasan_kfree_large(void *ptr, unsigned long ip);
 static __always_inline void kasan_kfree_large(void *ptr, unsigned long ip)
 {
@@ -261,6 +261,7 @@ static inline bool kasan_slab_free(struc
 {
 	return false;
 }
+static inline void kasan_slab_free_mempool(void *ptr, unsigned long ip) {}
 static inline void *kasan_slab_alloc(struct kmem_cache *s, void *object,
 				   gfp_t flags)
 {
@@ -280,7 +281,6 @@ static inline void *kasan_krealloc(const
 {
 	return (void *)object;
 }
-static inline void kasan_poison_kfree(void *ptr, unsigned long ip) {}
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
 
 #endif /* CONFIG_KASAN */
--- a/mm/kasan/common.c~kasan-mm-rename-kasan_poison_kfree
+++ a/mm/kasan/common.c
@@ -331,6 +331,29 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
+void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
+{
+	struct page *page;
+
+	page = virt_to_head_page(ptr);
+
+	/*
+	 * Even though this function is only called for kmem_cache_alloc and
+	 * kmalloc backed mempool allocations, those allocations can still be
+	 * !PageSlab() when the size provided to kmalloc is larger than
+	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
+	 */
+	if (unlikely(!PageSlab(page))) {
+		if (ptr != page_address(page)) {
+			kasan_report_invalid_free(ptr, ip);
+			return;
+		}
+		poison_range(ptr, page_size(page), KASAN_FREE_PAGE);
+	} else {
+		____kasan_slab_free(page->slab_cache, ptr, ip, false);
+	}
+}
+
 static void set_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	kasan_set_track(&kasan_get_alloc_meta(cache, object)->alloc_track, flags);
@@ -422,23 +445,6 @@ void * __must_check __kasan_krealloc(con
 						flags, true);
 }
 
-void __kasan_poison_kfree(void *ptr, unsigned long ip)
-{
-	struct page *page;
-
-	page = virt_to_head_page(ptr);
-
-	if (unlikely(!PageSlab(page))) {
-		if (ptr != page_address(page)) {
-			kasan_report_invalid_free(ptr, ip);
-			return;
-		}
-		poison_range(ptr, page_size(page), KASAN_FREE_PAGE);
-	} else {
-		____kasan_slab_free(page->slab_cache, ptr, ip, false);
-	}
-}
-
 void __kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr)))
--- a/mm/mempool.c~kasan-mm-rename-kasan_poison_kfree
+++ a/mm/mempool.c
@@ -104,7 +104,7 @@ static inline void poison_element(mempoo
 static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_poison_kfree(element, _RET_IP_);
+		kasan_slab_free_mempool(element, _RET_IP_);
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
_
