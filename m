Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD6EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357148AbiCYBLs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357162AbiCYBLr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFE265D08
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76245B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144AFC340EC;
        Fri, 25 Mar 2022 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170608;
        bh=VgsYjCRlJjN3M+XYSwbBaWpwmU2njZSGVQaMljhDDh8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=POoXUPdvIpRJRTnnpwybYaV2PVOTzqQw96MJAdvOlIPk8geb0xozKTnKAGqgz3UIz
         q/kS9MRWkIg3h5HBCqWcxu7zrxC4QCuqoGETGp+Hdwx5i+WAWDmAmzSS2zzbtgrQNo
         To81sRs+DtJ2bAlTDFqhdVaXQI9f3t6JcNhafGkI=
Date:   Thu, 24 Mar 2022 18:10:07 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 031/114] kasan, page_alloc: move tag_clear_highpage out of kernel_init_free_pages
Message-Id: <20220325011008.144AFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
