Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC9EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiCYWoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30D120A39F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79D6461581
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6791C004DD;
        Fri, 25 Mar 2022 22:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248116;
        bh=6GXwL3VINALi9A58l+Hznnc6Pxd2OVqXu9rIJ0f1zrY=;
        h=Date:To:From:Subject:From;
        b=wWr7v+ZSzHpjRPe7fLfYg979/uZY2nE7Kr0cvDmFg4QbNCh2Ovs0fbbkWS+s8Iezs
         dMyChtbH17AHEw3GYuLovtq3MEP9C7Lcc+U0zhmZ0SX2y8MpEk+Cdzf243bH/o2T3o
         DuZSnGMeCsf7R3kFvRd4RojPKRlZFYKG2FB57+JI=
Date:   Fri, 25 Mar 2022 15:41:56 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch removed from -mm tree
Message-Id: <20220325224156.D6791C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: merge kasan_free_pages into free_pages_prepare
has been removed from the -mm tree.  Its filename was
     kasan-page_alloc-merge-kasan_free_pages-into-free_pages_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

