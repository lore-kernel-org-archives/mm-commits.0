Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFED8C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243964AbiCYBML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357155AbiCYBMI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC4FBB90E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9207EB82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C5C340ED;
        Fri, 25 Mar 2022 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170632;
        bh=rM6/EsvFBcLf5RzPhHr+/28T4bnQErfpbbS9fsOkNG4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=FZwKVv2ZG6kfBthbEb8qGjiF7CYEohVuhzSABAGU1Ki91LQ4qm9+Ve4/EvzLWPsr6
         IqqXour0sRAAehmDdivYUZF72XGwmDrbckjrC7sjzTopu/iqQQGTty0HOCp98WReE+
         l0LcXbiOBloyexQPF1zkoVqLuZaE53DkTEOXgj4M=
Date:   Thu, 24 Mar 2022 18:10:31 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 039/114] kasan, page_alloc: merge kasan_alloc_pages into post_alloc_hook
Message-Id: <20220325011032.2C8C5C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: merge kasan_alloc_pages into post_alloc_hook

Currently, the code responsible for initializing and poisoning memory in
post_alloc_hook() is scattered across two locations: kasan_alloc_pages()
hook for HW_TAGS KASAN and post_alloc_hook() itself.  This is confusing.

This and a few following patches combine the code from these two
locations.  Along the way, these patches do a step-by-step restructure the
many performed checks to make them easier to follow.

Replace the only caller of kasan_alloc_pages() with its implementation.

As kasan_has_integrated_init() is only true when CONFIG_KASAN_HW_TAGS is
enabled, moving the code does no functional changes.

Also move init and init_tags variables definitions out of
kasan_has_integrated_init() clause in post_alloc_hook(), as they have the
same values regardless of what the if condition evaluates to.

This patch is not useful by itself but makes the simplifications in the
following patches easier to follow.

Link: https://lkml.kernel.org/r/5ac7e0b30f5cbb177ec363ddd7878a3141289592.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 include/linux/kasan.h |    9 ---------
 mm/kasan/common.c     |    2 +-
 mm/kasan/hw_tags.c    |   22 ----------------------
 mm/page_alloc.c       |   20 +++++++++++++++-----
 4 files changed, 16 insertions(+), 37 deletions(-)

--- a/include/linux/kasan.h~kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook
+++ a/include/linux/kasan.h
@@ -84,17 +84,8 @@ static inline void kasan_disable_current
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags);
-
 #else /* CONFIG_KASAN_HW_TAGS */
 
-static __always_inline void kasan_alloc_pages(struct page *page,
-					      unsigned int order, gfp_t flags)
-{
-	/* Only available for integrated init. */
-	BUILD_BUG();
-}
-
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 static inline bool kasan_has_integrated_init(void)
--- a/mm/kasan/common.c~kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook
+++ a/mm/kasan/common.c
@@ -538,7 +538,7 @@ void * __must_check __kasan_kmalloc_larg
 		return NULL;
 
 	/*
-	 * The object has already been unpoisoned by kasan_alloc_pages() for
+	 * The object has already been unpoisoned by kasan_unpoison_pages() for
 	 * alloc_pages() or by kasan_krealloc() for krealloc().
 	 */
 
--- a/mm/kasan/hw_tags.c~kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook
+++ a/mm/kasan/hw_tags.c
@@ -192,28 +192,6 @@ void __init kasan_init_hw_tags(void)
 		kasan_stack_collection_enabled() ? "on" : "off");
 }
 
-void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags)
-{
-	/*
-	 * This condition should match the one in post_alloc_hook() in
-	 * page_alloc.c.
-	 */
-	bool init = !want_init_on_free() && want_init_on_alloc(flags);
-	bool init_tags = init && (flags & __GFP_ZEROTAGS);
-
-	if (flags & __GFP_SKIP_KASAN_POISON)
-		SetPageSkipKASanPoison(page);
-
-	if (init_tags) {
-		int i;
-
-		for (i = 0; i != 1 << order; ++i)
-			tag_clear_highpage(page + i);
-	} else {
-		kasan_unpoison_pages(page, order, init);
-	}
-}
-
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_enable_tagging_sync(void)
--- a/mm/page_alloc.c~kasan-page_alloc-merge-kasan_alloc_pages-into-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2346,6 +2346,9 @@ static inline bool check_new_pcp(struct
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
+	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
+	bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
@@ -2361,15 +2364,22 @@ inline void post_alloc_hook(struct page
 
 	/*
 	 * As memory initialization might be integrated into KASAN,
-	 * kasan_alloc_pages and kernel_init_free_pages must be
+	 * KASAN unpoisoning and memory initializion code must be
 	 * kept together to avoid discrepancies in behavior.
 	 */
 	if (kasan_has_integrated_init()) {
-		kasan_alloc_pages(page, order, gfp_flags);
-	} else {
-		bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
-		bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+		if (gfp_flags & __GFP_SKIP_KASAN_POISON)
+			SetPageSkipKASanPoison(page);
 
+		if (init_tags) {
+			int i;
+
+			for (i = 0; i != 1 << order; ++i)
+				tag_clear_highpage(page + i);
+		} else {
+			kasan_unpoison_pages(page, order, init);
+		}
+	} else {
 		kasan_unpoison_pages(page, order, init);
 
 		if (init_tags) {
_
