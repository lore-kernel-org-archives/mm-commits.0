Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA36C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357174AbiCYBMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354193AbiCYBMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2481BD2D2
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DC35B82708
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30642C340EE;
        Fri, 25 Mar 2022 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170644;
        bh=F3/yFJ7raynTdLtU41lsWpEJSkEvMmD97MF6IDu3z9I=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=vQcJIH3R5fOxiAnDvc0RYX60GJrHHoY/rRvtC02x1Td6zGqsGrvKPsmC9cUvGXcEq
         uxLVBv3f8CSIUhcqa73GU82XkBS7OoQBojj8H+fu2vVqpnAWpHNXqVMjmIFUJ06amK
         eu2rHCmzLqkZHNYUK1e8yJpDHOn9q8l45Yf1qeEY=
Date:   Thu, 24 Mar 2022 18:10:43 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 043/114] kasan, page_alloc: rework kasan_unpoison_pages call site
Message-Id: <20220325011044.30642C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: rework kasan_unpoison_pages call site

Rework the checks around kasan_unpoison_pages() call in post_alloc_hook().

The logical condition for calling this function is:

- If a software KASAN mode is enabled, we need to mark shadow memory.
- Otherwise, HW_TAGS KASAN is enabled, and it only makes sense to
  set tags if they haven't already been cleared by tag_clear_highpage(),
  which is indicated by init_tags.

This patch concludes the changes for post_alloc_hook().

Link: https://lkml.kernel.org/r/0ecebd0d7ccd79150e3620ea4185a32d3dfe912f.1643047180.git.andreyknvl@google.com
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

 mm/page_alloc.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-rework-kasan_unpoison_pages-call-site
+++ a/mm/page_alloc.c
@@ -2382,15 +2382,20 @@ inline void post_alloc_hook(struct page
 		/* Note that memory is already initialized by the loop above. */
 		init = false;
 	}
-	if (kasan_has_integrated_init()) {
-		if (!init_tags) {
-			kasan_unpoison_pages(page, order, init);
+	/*
+	 * If either a software KASAN mode is enabled, or,
+	 * in the case of hardware tag-based KASAN,
+	 * if memory tags have not been cleared via tag_clear_highpage().
+	 */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
+	    IS_ENABLED(CONFIG_KASAN_SW_TAGS) ||
+	    kasan_hw_tags_enabled() && !init_tags) {
+		/* Mark shadow memory or set memory tags. */
+		kasan_unpoison_pages(page, order, init);
 
-			/* Note that memory is already initialized by KASAN. */
+		/* Note that memory is already initialized by KASAN. */
+		if (kasan_has_integrated_init())
 			init = false;
-		}
-	} else {
-		kasan_unpoison_pages(page, order, init);
 	}
 	/* If memory is still not initialized, do it now. */
 	if (init)
_
