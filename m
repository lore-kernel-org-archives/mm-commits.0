Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA43C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 18:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiFISpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 14:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbiFISpw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 14:45:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9606122654D
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 11:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 421A1B82F73
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 18:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9777C34114;
        Thu,  9 Jun 2022 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654800349;
        bh=RH8EX/0H0x4Qu9c7Xu9MuxxfRIqi5+Bw0LaCOTAAMEg=;
        h=Date:To:From:Subject:From;
        b=Qo775ByhT28729j+gRhODyLuSQkPCVqwBLK3TvPmBynlwkTGb6k4NhRFoai1mMx/N
         qtrg2fGJuCPG7P/ZQTZkgaEb7y4Tg3CLEC+FLBsUXrJ+p9uT0tfLrwssWwH3eCzDMz
         f4IthUud6gQN7MrO0METdPxJN2Lho7d/r3UBtTBk=
Date:   Thu, 09 Jun 2022 11:45:48 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch added to mm-unstable branch
Message-Id: <20220609184548.E9777C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename kernel_init_free_pages to kernel_init_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm: rename kernel_init_free_pages to kernel_init_pages
Date: Thu, 9 Jun 2022 20:18:45 +0200

Rename kernel_init_free_pages() to kernel_init_pages().  This function is
not only used for free pages but also for pages that were just allocated.

Link: https://lkml.kernel.org/r/1ecaffc0a9c1404d4d7cf52efe0b2dc8a0c681d8.1654798516.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-rename-kernel_init_free_pages-to-kernel_init_pages
+++ a/mm/page_alloc.c
@@ -1304,7 +1304,7 @@ static inline bool should_skip_kasan_poi
 	       PageSkipKASanPoison(page);
 }
 
-static void kernel_init_free_pages(struct page *page, int numpages)
+static void kernel_init_pages(struct page *page, int numpages)
 {
 	int i;
 
@@ -1404,7 +1404,7 @@ static __always_inline bool free_pages_p
 			init = false;
 	}
 	if (init)
-		kernel_init_free_pages(page, 1 << order);
+		kernel_init_pages(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -2449,7 +2449,7 @@ inline void post_alloc_hook(struct page
 	}
 	/* If memory is still not initialized, do it now. */
 	if (init)
-		kernel_init_free_pages(page, 1 << order);
+		kernel_init_pages(page, 1 << order);
 	/* Propagate __GFP_SKIP_KASAN_POISON to page flags. */
 	if (kasan_hw_tags_enabled() && (gfp_flags & __GFP_SKIP_KASAN_POISON))
 		SetPageSkipKASanPoison(page);
_

Patches currently in -mm which might be from andreyknvl@google.com are

mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch
mm-introduce-clear_highpage_kasan_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

