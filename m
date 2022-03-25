Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AACC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiCYWoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8C20A39B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FAC4614DE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB21FC340ED;
        Fri, 25 Mar 2022 22:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248115;
        bh=8CTFFAsEXvf2BNH4f2u9NoClv9BIRYfUHS54vwPq0vE=;
        h=Date:To:From:Subject:From;
        b=q6jgjFQj1N47TYCTNLFvAhTfViHL+CWJZuB7E5SHuXx5eFPV4a2DBP09w/YWqnzcb
         FehaxTZEaUsJdXwcLRtz0+qwJUdnguwrs6kKYhcbXWYhkHkXYMI/F4hdRD9vbKpdDN
         RVlEKV41XF6KCof+cPTZ1GFn9fLibgFHC3Z/eRi8=
Date:   Fri, 25 Mar 2022 15:41:55 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch removed from -mm tree
Message-Id: <20220325224155.CB21FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: move tag_clear_highpage out of kernel_init_free_pages
has been removed from the -mm tree.  Its filename was
     kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: move tag_clear_highpage out of kernel_init_free_pages

Currently, kernel_init_free_pages() serves two purposes: it either only
zeroes memory or zeroes both memory and memory tags via a different code
path.  As this function has only two callers, each using only one code
path, this behaviour is confusing.

Pull the code that zeroes both memory and tags out of
kernel_init_free_pages().

As a result of this change, the code in free_pages_prepare() starts to
look complicated, but this is improved in the few following patches. 
Those improvements are not integrated into this patch to make diffs easier
to read.

This patch does no functional changes.

Link: https://lkml.kernel.org/r/7719874e68b23902629c7cf19f966c4fd5f57979.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-move-tag_clear_highpage-out-of-kernel_init_free_pages
+++ a/mm/page_alloc.c
@@ -1278,16 +1278,10 @@ static inline bool should_skip_kasan_poi
 	       PageSkipKASanPoison(page);
 }
 
-static void kernel_init_free_pages(struct page *page, int numpages, bool zero_tags)
+static void kernel_init_free_pages(struct page *page, int numpages)
 {
 	int i;
 
-	if (zero_tags) {
-		for (i = 0; i < numpages; i++)
-			tag_clear_highpage(page + i);
-		return;
-	}
-
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
 	for (i = 0; i < numpages; i++) {
@@ -1383,7 +1377,7 @@ static __always_inline bool free_pages_p
 		bool init = want_init_on_free();
 
 		if (init)
-			kernel_init_free_pages(page, 1 << order, false);
+			kernel_init_free_pages(page, 1 << order);
 		if (!skip_kasan_poison)
 			kasan_poison_pages(page, order, init);
 	}
@@ -2378,9 +2372,17 @@ inline void post_alloc_hook(struct page
 		bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags);
 
 		kasan_unpoison_pages(page, order, init);
-		if (init)
-			kernel_init_free_pages(page, 1 << order,
-					       gfp_flags & __GFP_ZEROTAGS);
+
+		if (init) {
+			if (gfp_flags & __GFP_ZEROTAGS) {
+				int i;
+
+				for (i = 0; i < 1 << order; i++)
+					tag_clear_highpage(page + i);
+			} else {
+				kernel_init_free_pages(page, 1 << order);
+			}
+		}
 	}
 
 	set_page_owner(page, order, gfp_flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

