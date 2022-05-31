Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636BDC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346689AbiEaRwQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346683AbiEaRwP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6BF6212E
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:52:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14A59B8116B
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE90C385A9;
        Tue, 31 May 2022 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654019531;
        bh=IMXI9q1mJiJf2tfuG7rvE+SbL3IZVq5gSnCKc+pFdWU=;
        h=Date:To:From:Subject:From;
        b=UCHWXymHwUP29LlI5O4dm5+5ti+y0aBfwycR+LmF3DB4iQFqeVCSCg3PKBD3zYe+U
         cMn+fHIbYzLWvXRZfhbqUqWPRJ3KVm5zAKbY7YDXMATdq7rXbOWBG3ePqcgLP165Nr
         5jR4E51pz+udtDFwoIJVyGwJLhbSI6IDUbO9Xb2Y=
Date:   Tue, 31 May 2022 10:52:11 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch added to mm-unstable branch
Message-Id: <20220531175211.BCE90C385A9@smtp.kernel.org>
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
Date: Tue, 31 May 2022 17:43:48 +0200

Rename kernel_init_free_pages() to kernel_init_pages().  This function is
not only used for free pages but also for pages that were just allocated.

Link: https://lkml.kernel.org/r/4c76a95aff79723de76df146a10888a5a9196faf.1654011120.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
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
mm-introduce-clear_highpage_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

