Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E9C4332B
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6385964EE3
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhCDA6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353204AbhCDADn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD2A64E6C;
        Wed,  3 Mar 2021 23:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813844;
        bh=rUmij+jrJv3bxmkEAuMPJLB5oLaSJ6nMw041oaTUrII=;
        h=Date:From:To:Subject:From;
        b=cgV7ohMfcjVGPhvdO2zSpxyltd7xsAp6z6eQJFuKi4mFRqvghznQ/8ByKYK+VPsfv
         lccI6OiP52+wg0N4RePzmlpftL1zf2XUMx6KzPv4OK+3yBUKYKDr6ehZScGMpivotk
         H3uVe5skPmWRVu2YzOd3ofIWIPLDHHJFI6R2gvWU=
Date:   Wed, 03 Mar 2021 15:24:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, hch@infradead.org, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  +
 kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch added to -mm tree
Message-ID: <20210303232403.xYwtNUmFi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
has been added to the -mm tree.  Its filename is
     kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC

Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
after debug_pagealloc_unmap_pages().  This causes a crash when
debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an unmapped
page.

This patch puts kasan_free_nondeferred_pages() before
debug_pagealloc_unmap_pages().

Besides fixing the crash, this also makes the annotation order consistent
with debug_pagealloc_map_pages() preceding kasan_alloc_pages().

Link: https://lkml.kernel.org/r/1aa83e48627978de8068d5e3314185f3a0d7a849.1614302398.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc
+++ a/mm/page_alloc.c
@@ -1288,10 +1288,14 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
-
+	/*
+	 * With hardware tag-based KASAN, memory tags must be set
+	 * before unmapping the page with debug_pagealloc.
+	 */
 	kasan_free_nondeferred_pages(page, order);
 
+	debug_pagealloc_unmap_pages(page, 1 << order);
+
 	return true;
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

