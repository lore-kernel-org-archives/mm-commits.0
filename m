Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B01C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiGDBJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiGDBJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673C6274
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3892B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B44AC341C6;
        Mon,  4 Jul 2022 01:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896975;
        bh=FZdvslyGAGBHWNRsAuFI5ONXM3OW3rselr610+JcQDU=;
        h=Date:To:From:Subject:From;
        b=m6Qx6u3qwcqq4GceLUW/Ls6iFRf7rQ2vvs3Uq95dUP2ExcMbMWZGaVtypSIwmrM+C
         z9lPSrdVxaEAjMpfiDJYr1/tpZ+JZCh36dCE/xQ8tuLdlPf6o6B2iv4KV2c+wgAu4e
         e7pa/0ilKneT8fJmngUeu9VhaXzT4mliLTMgayjc=
Date:   Sun, 03 Jul 2022 18:09:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch removed from -mm tree
Message-Id: <20220704010935.7B44AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rename kernel_init_free_pages to kernel_init_pages
has been removed from the -mm tree.  Its filename was
     mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm: rename kernel_init_free_pages to kernel_init_pages
Date: Thu, 9 Jun 2022 20:18:45 +0200

Rename kernel_init_free_pages() to kernel_init_pages().  This function is
not only used for free pages but also for pages that were just allocated.

Link: https://lkml.kernel.org/r/1ecaffc0a9c1404d4d7cf52efe0b2dc8a0c681d8.1654798516.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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
@@ -1296,7 +1296,7 @@ static inline bool should_skip_kasan_poi
 	       PageSkipKASanPoison(page);
 }
 
-static void kernel_init_free_pages(struct page *page, int numpages)
+static void kernel_init_pages(struct page *page, int numpages)
 {
 	int i;
 
@@ -1396,7 +1396,7 @@ static __always_inline bool free_pages_p
 			init = false;
 	}
 	if (init)
-		kernel_init_free_pages(page, 1 << order);
+		kernel_init_pages(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -2441,7 +2441,7 @@ inline void post_alloc_hook(struct page
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

mm-introduce-clear_highpage_kasan_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

