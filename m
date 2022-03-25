Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194DEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357153AbiCYBLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357165AbiCYBLr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE5665D34
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3266185C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D97CC340EE;
        Fri, 25 Mar 2022 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170611;
        bh=Ndv6k7BnDMrkT2jWLbGKzC4FbVYDQt1vXc2M9TuA9+8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=A4Ofr9JICUKBRobEhTrYyyYtifLwgHEALtZn5qZYD1vHdPWgGyr6VsGttNa2qjbbs
         8dFutjqQdJCNWNEXKkfFc5io4OJN4OP0hy7Cb0QNvqrfkRMUl2b7e61tu2O0N9U61b
         DM25qoVLZFV6qYW0Mxs8woq5oB2KqL8iwqI21ZVU=
Date:   Thu, 24 Mar 2022 18:10:10 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 032/114] kasan, page_alloc: merge kasan_free_pages into free_pages_prepare
Message-Id: <20220325011011.1D97CC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: merge kasan_free_pages into free_pages_prepare

Currently, the code responsible for initializing and poisoning memory in
free_pages_prepare() is scattered across two locations: kasan_free_pages()
for HW_TAGS KASAN and free_pages_prepare() itself.  This is confusing.

This and a few following patches combine the code from these two
locations.  Along the way, these patches also simplify the performed
checks to make them easier to follow.

Replaces the only caller of kasan_free_pages() with its implementation.

As kasan_has_integrated_init() is only true when CONFIG_KASAN_HW_TAGS is
enabled, moving the code does no functional changes.

This patch is not useful by itself but makes the simplifications in the
following patches easier to follow.

Link: https://lkml.kernel.org/r/303498d15840bb71905852955c6e2390ecc87139.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
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

 include/linux/kasan.h |    8 --------
 mm/kasan/common.c     |    2 +-
 mm/kasan/hw_tags.c    |   11 -----------
 mm/page_alloc.c       |    6 ++++--
 4 files changed, 5 insertions(+), 22 deletions(-)

--- a/include/linux/kasan.h~kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare
+++ a/include/linux/kasan.h
@@ -85,7 +85,6 @@ static inline void kasan_disable_current
 #ifdef CONFIG_KASAN_HW_TAGS
 
 void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags);
-void kasan_free_pages(struct page *page, unsigned int order);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
@@ -94,13 +93,6 @@ static __always_inline void kasan_alloc_
 {
 	/* Only available for integrated init. */
 	BUILD_BUG();
-}
-
-static __always_inline void kasan_free_pages(struct page *page,
-					     unsigned int order)
-{
-	/* Only available for integrated init. */
-	BUILD_BUG();
 }
 
 #endif /* CONFIG_KASAN_HW_TAGS */
--- a/mm/kasan/common.c~kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare
+++ a/mm/kasan/common.c
@@ -387,7 +387,7 @@ static inline bool ____kasan_kfree_large
 	}
 
 	/*
-	 * The object will be poisoned by kasan_free_pages() or
+	 * The object will be poisoned by kasan_poison_pages() or
 	 * kasan_slab_free_mempool().
 	 */
 
--- a/mm/kasan/hw_tags.c~kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare
+++ a/mm/kasan/hw_tags.c
@@ -213,17 +213,6 @@ void kasan_alloc_pages(struct page *page
 	}
 }
 
-void kasan_free_pages(struct page *page, unsigned int order)
-{
-	/*
-	 * This condition should match the one in free_pages_prepare() in
-	 * page_alloc.c.
-	 */
-	bool init = want_init_on_free();
-
-	kasan_poison_pages(page, order, init);
-}
-
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_enable_tagging_sync(void)
--- a/mm/page_alloc.c~kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -1364,15 +1364,17 @@ static __always_inline bool free_pages_p
 
 	/*
 	 * As memory initialization might be integrated into KASAN,
-	 * kasan_free_pages and kernel_init_free_pages must be
+	 * KASAN poisoning and memory initialization code must be
 	 * kept together to avoid discrepancies in behavior.
 	 *
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
 	if (kasan_has_integrated_init()) {
+		bool init = want_init_on_free();
+
 		if (!skip_kasan_poison)
-			kasan_free_pages(page, order);
+			kasan_poison_pages(page, order, init);
 	} else {
 		bool init = want_init_on_free();
 
_
