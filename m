Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECADDC4167D
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357155AbiCYBMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357171AbiCYBMI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BA9673C3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C504E6177D
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B035C340EC;
        Fri, 25 Mar 2022 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170635;
        bh=03ssD2oDVYq3aYa6nAqrqD/sSjXum6w+GSmNj+fRUNY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ihH5v3E8wlPDKA2TxzM1YBbQLH1+jRUCiL8F3BScZKxbw1XEuSgClYM+b76v9CuNN
         DqCWdX++FW/YTqyYBU9R/nKGW1Fn2VTa7po/UuCIDVEJWuyhgylkVrMKm3gz/KUhW5
         GOOv6G1AffwYKBEeMUPBeMouIPD+N9GEeHfdOxmY=
Date:   Thu, 24 Mar 2022 18:10:34 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 040/114] kasan, page_alloc: combine tag_clear_highpage calls in post_alloc_hook
Message-Id: <20220325011035.2B035C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: combine tag_clear_highpage calls in post_alloc_hook

Move tag_clear_highpage() loops out of the kasan_has_integrated_init()
clause as a code simplification.

This patch does no functional changes.

Link: https://lkml.kernel.org/r/587e3fc36358b88049320a89cc8dc6deaecb0cda.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-combine-tag_clear_highpage-calls-in-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2367,30 +2367,30 @@ inline void post_alloc_hook(struct page
 	 * KASAN unpoisoning and memory initializion code must be
 	 * kept together to avoid discrepancies in behavior.
 	 */
+
+	/*
+	 * If memory tags should be zeroed (which happens only when memory
+	 * should be initialized as well).
+	 */
+	if (init_tags) {
+		int i;
+
+		/* Initialize both memory and tags. */
+		for (i = 0; i != 1 << order; ++i)
+			tag_clear_highpage(page + i);
+
+		/* Note that memory is already initialized by the loop above. */
+		init = false;
+	}
 	if (kasan_has_integrated_init()) {
 		if (gfp_flags & __GFP_SKIP_KASAN_POISON)
 			SetPageSkipKASanPoison(page);
 
-		if (init_tags) {
-			int i;
-
-			for (i = 0; i != 1 << order; ++i)
-				tag_clear_highpage(page + i);
-		} else {
+		if (!init_tags)
 			kasan_unpoison_pages(page, order, init);
-		}
 	} else {
 		kasan_unpoison_pages(page, order, init);
 
-		if (init_tags) {
-			int i;
-
-			for (i = 0; i < 1 << order; i++)
-				tag_clear_highpage(page + i);
-
-			init = false;
-		}
-
 		if (init)
 			kernel_init_free_pages(page, 1 << order);
 	}
_
