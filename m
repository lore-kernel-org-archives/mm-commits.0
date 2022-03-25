Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFC2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357173AbiCYBMO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357165AbiCYBMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D66BD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77080B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339ECC340EC;
        Fri, 25 Mar 2022 01:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170638;
        bh=A/ZduW4o39JSXOEjwlSReORBxRRevXzIxPxnPejV664=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=W8U44mSsZCtKsnV03aftrGyFxWxjsR5wQqNbtj3+h5h81prsb7Cq72R/Bj7uuvK4J
         RexcAtSEJw4HESr+r6XDUM3V+sQaCQ5j6RnTTlI6AWJ8HKAJsGMzh7SgSFfSFQBqdl
         bTlgmaMjDLhCCigbp74CTA8r7+JHw3Stxg/k+OU4=
Date:   Thu, 24 Mar 2022 18:10:37 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 041/114] kasan, page_alloc: move SetPageSkipKASanPoison in post_alloc_hook
Message-Id: <20220325011038.339ECC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: move SetPageSkipKASanPoison in post_alloc_hook

Pull the SetPageSkipKASanPoison() call in post_alloc_hook() out of the big
if clause for better code readability.  This also allows for more
simplifications in the following patches.

Also turn the kasan_has_integrated_init() check into the proper
kasan_hw_tags_enabled() one.  These checks evaluate to the same value, but
logically skipping kasan poisoning has nothing to do with integrated init.

Link: https://lkml.kernel.org/r/7214c1698b754ccfaa44a792113c95cc1f807c48.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook
+++ a/mm/page_alloc.c
@@ -2383,9 +2383,6 @@ inline void post_alloc_hook(struct page
 		init = false;
 	}
 	if (kasan_has_integrated_init()) {
-		if (gfp_flags & __GFP_SKIP_KASAN_POISON)
-			SetPageSkipKASanPoison(page);
-
 		if (!init_tags)
 			kasan_unpoison_pages(page, order, init);
 	} else {
@@ -2394,6 +2391,9 @@ inline void post_alloc_hook(struct page
 		if (init)
 			kernel_init_free_pages(page, 1 << order);
 	}
+	/* Propagate __GFP_SKIP_KASAN_POISON to page flags. */
+	if (kasan_hw_tags_enabled() && (gfp_flags & __GFP_SKIP_KASAN_POISON))
+		SetPageSkipKASanPoison(page);
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
_
