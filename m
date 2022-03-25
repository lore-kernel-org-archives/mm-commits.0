Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF9CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiCYWoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B651920A955
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 542F4614DE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCD8C004DD;
        Fri, 25 Mar 2022 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248126;
        bh=RPMtU9d2ACfVw56rzsRFZr7rLskq3GC3GQDsCgCiBJo=;
        h=Date:To:From:Subject:From;
        b=lWYxyMzFDhdD+T2ahqlWqUpXIaD9xgONl2G9OnbY5xOIZ8FMHDbuJdb9nuu3OTyta
         YyeC9jzLI31NBK2ONNFUIa1NBed3PBMKyE9A16oLENEUOHCsYzkRxizTU3n/9WQhLP
         d41jUbaaxBhvgsFV/n8YerjlHYHTP2TkW6B00TBw=
Date:   Fri, 25 Mar 2022 15:42:06 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch removed from -mm tree
Message-Id: <20220325224206.AFCD8C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: move SetPageSkipKASanPoison in post_alloc_hook
has been removed from the -mm tree.  Its filename was
     kasan-page_alloc-move-setpageskipkasanpoison-in-post_alloc_hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

