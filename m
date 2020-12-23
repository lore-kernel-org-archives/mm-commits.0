Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DD3C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2EC8223DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgLWSaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbgLWSaT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:30:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF3F5223DB;
        Wed, 23 Dec 2020 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748204;
        bh=RpxOj9dZwuJ2t1zms53TnLKdtAkooP53ub1uVxsUufw=;
        h=Date:From:To:Subject:From;
        b=cwSmTqDHwZBxOwiDTh+hmRFgkm79Qosngz4xXn4whZ12rA4wU1CNsJsLDYlBS4xBd
         53U5H1KgSFj3l/jIsk+jOfaLPcsUgzHxwig6ecOGba5n6IeuS4KaPGYseZqDtfdMJC
         7Z9gia6hsa1CpsrCQRvS5O8slD3cKVJDr19S1oEE=
Date:   Wed, 23 Dec 2020 10:30:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged] kasan-mm-rename-kasan_poison_kfree.patch removed
 from -mm tree
Message-ID: <20201223183003.O82RKcj6b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: rename kasan_poison_kfree
has been removed from the -mm tree.  Its filename was
     kasan-mm-rename-kasan_poison_kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are


